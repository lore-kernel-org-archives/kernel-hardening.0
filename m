Reply-To: kernel-hardening@lists.openwall.com
From: Jann Horn <jannh@google.com>
Date: Sat, 25 Jun 2016 03:13:12 +0200
Message-Id: <1466817192-9586-2-git-send-email-jannh@google.com>
In-Reply-To: <1466817192-9586-1-git-send-email-jannh@google.com>
References: <1466817192-9586-1-git-send-email-jannh@google.com>
Subject: [kernel-hardening] [RFC] kref: pin objects with dangerously high reference count
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: pageexec@freemail.hu, Kees Cook <keescook@google.com>, jann@thejh.net, Jann Horn <jannh@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Reference counting is a frequent source of (security) trouble in the
kernel. Here are the three main things that can, as far as I know, go wrong
with it, together with examples of specific bugs:

 - reference count overdecrement: If something (e.g. a normally-unused
   error path) decrements a reference counter more than it was previously
   incremented, this can cause the reference counter to end up lower than
   it was before. This will cause the object to be freed before the last
   reference to the object is gone.
   This bug class is hard to mitigate - it isn't very different from a
   generic use-after-free.
   Vulnerability examples:
     commit 8358b02bf67d ("bpf: fix double-fdput [...]")
   Bug examples where I haven't looked at impact:
     commit 75f0b68b75da ("debugfs: [...]: avoid double fops release")
     commit 121323ae668e ("drivers/perf: [...]: Fix reference count[...]")

 - reference count overincrement: If an error path omits a necessary
   reference count decrement, this can cause the reference counter to end
   up higher than it was before even though no new reference to the object
   was created. If such a bug is triggered around 2^32 times, the (32 bits
   wide) reference counter overflows to a small value. After dropping a
   few references so that exactly 2^32 references remain, the object will
   be freed prematurely.
   This kind of bug can easily occur when mistakes are made while writing
   error handling code.
   Vulnerability examples:
     commit 23567fd052a9 ("KEYS: Fix keyring ref leak [...]")
   Bug examples where I haven't looked at impact:
     commit b10e3e90485e ("debugfs: [...]: free proxy on ->open() failure")
     commit 3ea411c56ef5 ("android: fix reference leak in [...]")
     commit 8ed9e0e1b602 ("Input: turbografx - fix reference counting")

 - simple reference count overflow: If there are over 2^32 legitimate
   references to an object, a 32-bit reference counter can overflow. Since
   this can't happen on 32-bit architectures and normal references require
   at least a pointer, the minimum amount of physical memory required to
   hit this bug class is sizeof(void*) * 2^32 = 32 GiB ~= 34.36 GB.
   One example of a reference count overflow that could be triggered in
   some uncommon configurations on systems with 40GB of RAM is
   commit 92117d8443bc ("bpf: fix refcnt overflow").
   The nasty thing about this bug class is that it doesn't require a "real"
   reference counting bug, and with increasing amounts of physical memory,
   the number of reachable instances of this issue increases. (Probably not
   at 64GB or so; but it might get dangerous around 1TB or so.)

This patch is a first step towards addressing overincrements and simple
overflows, but not overdecrements.

My concerns when choosing an appropriate fix implementation are:

 - memory usage: An easy fix would be to increase the size of refcounts to
   64 bits. However, that would both increase memory usage and mess with
   data structures that have been designed carefully to e.g. fit into a
   single cacheline.
   (Note: Because file descriptor tables can contain lots of struct file
   pointers and are relatively dense, struct file already has a 64-bit
   refcount.)
 - CPU usage: Refcounting is a central, relatively hot piece of kernel
   code, so a fix must not use a lot of CPU time. In particular, additional
   or less deterministic atomic operations should be avoided.
 - complexity: A fix shouldn't involve significant changes in arch-specific
   code.
 - crashiness: While these kinds of bugs currently cause (potentially
   exploitable) crashes and oopsing would be a big improvement over that,
   ideally the system should just keep going without killing anything.
 - impact on non-refcounting code: atomic_t is a generic atomic type, and
   while a lot of code uses it for reference counting, it also has other
   users for whom reference count hardening might mess up things.

Since 2009 or so, PaX had reference count overflow mitigation code. My main
reasons for reinventing the wheel are:

 - PaX adds arch-specific code, both in the atomic_t operations and in
   exception handlers. I'd like to keep the code as
   architecture-independent as possible, especially without adding
   complexity to assembler code, to make it more maintainable and
   auditable.
 - The refcounting hardening from PaX does not handle the "simple reference
   count overflow" case when just the refcounting hardening code is used as
   a standalone patch. (On a system with the full PaX patch, the active
   response code would probably prevent exploitation of this case.)

I think that the biggest disadvantages of my code are:

 - It increases the size of the inline code for kref_get_unless_zero() and,
   if CONFIG_HARDEN_KREF_BIGMEM is enabled, of kref_sub(). (Also of
   kref_put_mutex(), but that method isn't used often.)
 - If CONFIG_HARDEN_KREF_BIGMEM is enabled, its kref_sub() implementation
   always has to do an additional READ_ONCE() on the reference count, which
   might cause slowdowns.

The inline code in PaX is likely much smaller.

To avoid impact on non-refcounting code, this patch only adds a mitigation
to struct kref, not to atomic_t. The downside of that is that this patch
alone does *not* mitigate issues in most reference counting code in the
current kernel - that will require separate patches that change the various
subsystems to use struct kref instead of atomic_t for reference counting.

The basic way my patch works with REFCOUNT_HARDEN_BIGMEM enabled is that
when a reference counter becomes too big (KREF_MAX_DECREMENTABLE or above),
it is pinned, meaning that all further reference count increments and
decrements on the object have no effect anymore.

When REFCOUNT_HARDEN_BIGMEM is disabled, the code assumes that reference
counts can't legitimately reach KREF_MAX_DECREMENTABLE and only half-pins
the reference counter: It can't be incremented anymore, but it can still be
decremented. If the attacker reached the high reference counter by
exploiting an overincrement / missing decrement, he won't be able to undo
the overincrements, meaning that it's safe to simply limit the reference
counter like this.

The straightforward way to implement reference count hardening would be to
e.g. replace the atomic_inc_return() in kref_get() with an "increment and
return unless equal" operation. However, on x86, atomic "unless equal"
operations are implemented with cmpxchg loops, and I'd like to avoid
replacing normal atomic operations with operations that have somewhat
unpredictable performance. (Also, even in the fast case where the first
cmpxchg succeeds, an extra atomic_read() has to be performed, and the
inline code is a bit big.) Instead, with REFCOUNT_HARDEN_BIGMEM, my patch
divides the positive reference counter values into three ranges:

 - In the first range, from 0 to 0x70000000, refcounters work normally.
 - In the second range, from 0x70000001 to 0x78000000, increments work
   normally, but decrements are blocked. The code is intentionally racy so
   that, if a reference counter goes above 0x70000000 while several
   kref_put() calls are in the middle of execution, it can go back down
   below 0x70000001. However, it shouldn't be possible to still get back
   into the first range from a refcounter near 0x78000000 - doing so would
   require having about 0x8000000 tasks, each of which would have to be
   preempted for quite a while in the middle of kref_dec(). Currently, the
   kernel has a hardcoded limit of 4 million PIDs that can be allocated, so
   even theoretically, this should be safe.
   Because in this range, only decrements are blocked, going into this
   range and back down into the first range can't cause the reference count
   to become too low, it can only cause it to become too high (causing a
   memory leak, harmless compared to a crash).
 - In the third range, from 0x78000001 to 0x7fffffff, both increments and
   decrements are blocked. This means that the reference counter can become
   lower than the number of references to the object, so the counter must
   not be allowed to go back into the "normal refcounting" range ever
   again.
   Again, the code is racy, but it shouldn't be possible to get to the end
   of the third range or back to the start of the second range because
   the range of movement of the reference counter is limited by the number
   of running tasks.

Without REFCOUNT_HARDEN_BIGMEM, the first and second range behave
identically, and in the third range, only increments are blocked under the
assumption that the reference counter must be above the number of
legitimate references, so ignoring increments just reduces the gap between
the number of legitimate references and the reference counter state.


If this patch lands, the next steps will be:

 - Go through the kernel and mechanically replace instances of atomic_t
   that are used for reference counting with struct kref. This will have to
   land in the form of big, ugly patches that touch many subsystems at
   once.
 - Add a checkpatch warning for newly-added atomic_t structure members.


Notes regarding performance and similar stuff:

This is the assembly diff (modulo changed addresses) of kobject_get(),
which calls kref_get(), when compiling with CONFIG_64BIT and CONFIG_BUG on
x86-64:

+ 48 8d 7b 38           lea    rdi,[rbx+0x38]
  b8 01 00 00 00        mov    eax,0x1
  0f c1 43 38           xadd   DWORD PTR [rbx+0x38],eax
- ff c0                 inc    eax
+ 8d 70 01              lea    esi,[rax+0x1]
  ff c8                 dec    eax
- 7f 21                 jg     ffffffff8108947c <kobject_get+0x5f>
- 80 3d 27 17 3a 00 00  cmp    BYTE PTR [rip+0x3a1727],0x0 #<__warned.8073>
- 75 18                 jne    ffffffff8108947c <kobject_get+0x5f>
- be 2e 00 00 00        mov    esi,0x2e
- 48 c7 c7 fe d4 20 81  mov    rdi,0xffffffff8120d4fe
- c6 05 12 17 3a 00 01  mov    BYTE PTR [rip+0x3a1712],0x1 #<__warned.8073>
- e8 49 4e f9 ff        call   ffffffff8101e2c5 <warn_slowpath_null>
+ 3d fe ff ff 77        cmp    eax,0x77fffffe
+ 76 05                 jbe    ffffffff81089477 <kobject_get+0x4d>
+ e8 c6 3b fa ff        call   ffffffff8102d03d <kref_get_slowpath>

As you can see, the compiler optimizes the code so that basically only a
"cmp" and some arithmetic are added, not even an extra conditional branch
or so. For this reason, I believe that putting this part of the hardening
behind a config flag would be more trouble than it's worth. For kref_put(),
if CONFIG_REFCOUNT_HARDEN_BIGMEM is turned on, it's different (here in
kobject_put()) - there are a new read from the counter, a comparison and a
conditional branch:

  e8 72 4d f9 ff          call   ffffffff8101e223 <warn_slowpath_fmt>
+ 8b 43 38                mov    eax,DWORD PTR [rbx+0x38]
+ 3d 00 00 00 70          cmp    eax,0x70000000
+ 7f 0e                   jg     ffffffff810894c9 <kobject_put+0x47>
  83 6b 38 01             sub    DWORD PTR [rbx+0x38],0x1

To be fair: Here I compared the new kref code against the old kref code -
when code is ported from raw atomic_t to kref later, there will be an
additional cost for the change from raw atomic_inc() to kref_get().


Thanks to pipacs for talking to me about refcount hardening.
Thanks to kees for looking at a first version of this patch.

Signed-off-by: Jann Horn <jannh@google.com>
---
 include/linux/kref.h | 39 +++++++++++++++++++++++++++++++++------
 init/Kconfig         | 16 ++++++++++++++++
 kernel/Makefile      |  2 +-
 kernel/kref.c        | 17 +++++++++++++++++
 4 files changed, 67 insertions(+), 7 deletions(-)
 create mode 100644 kernel/kref.c

diff --git a/include/linux/kref.h b/include/linux/kref.h
index e15828f..6c44a0d 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -20,10 +20,19 @@
 #include <linux/kernel.h>
 #include <linux/mutex.h>
 
+/*
+ * Strictly speaking, atomic_t is signed. Avoid undefined behavior by keeping
+ * the reference count below 0x80000000.
+ */
+#define KREF_MAX_DECREMENTABLE 0x70000000
+#define KREF_MAX_INCREMENTABLE 0x78000000
+
 struct kref {
 	atomic_t refcount;
 };
 
+void kref_get_slowpath(struct kref *kref, unsigned int new_refcount);
+
 /**
  * kref_init - initialize object.
  * @kref: object in question.
@@ -39,11 +48,11 @@ static inline void kref_init(struct kref *kref)
  */
 static inline void kref_get(struct kref *kref)
 {
-	/* If refcount was 0 before incrementing then we have a race
-	 * condition when this kref is freeing by some other thread right now.
-	 * In this case one should use kref_get_unless_zero()
-	 */
-	WARN_ON_ONCE(atomic_inc_return(&kref->refcount) < 2);
+	unsigned int new_refcount = atomic_inc_return(&kref->refcount);
+
+	if (unlikely(new_refcount < 2 ||
+	    new_refcount > KREF_MAX_INCREMENTABLE))
+		kref_get_slowpath(kref, new_refcount);
 }
 
 /**
@@ -69,6 +78,12 @@ static inline int kref_sub(struct kref *kref, unsigned int count,
 {
 	WARN_ON(release == NULL);
 
+#ifdef CONFIG_HARDEN_KREF_BIGMEM
+	/* If the object has been pinned, leak the reference. */
+	if (unlikely(atomic_read(&kref->refcount) > KREF_MAX_DECREMENTABLE))
+		return 0;
+#endif
+
 	if (atomic_sub_and_test((int) count, &kref->refcount)) {
 		release(kref);
 		return 1;
@@ -103,6 +118,13 @@ static inline int kref_put_mutex(struct kref *kref,
 				 struct mutex *lock)
 {
 	WARN_ON(release == NULL);
+
+#ifdef CONFIG_HARDEN_KREF_BIGMEM
+	/* If the object has been pinned, leak the reference. */
+	if (unlikely(atomic_read(&kref->refcount) > KREF_MAX_DECREMENTABLE))
+		return 0;
+#endif
+
 	if (unlikely(!atomic_add_unless(&kref->refcount, -1, 1))) {
 		mutex_lock(lock);
 		if (unlikely(!atomic_dec_and_test(&kref->refcount))) {
@@ -133,6 +155,11 @@ static inline int kref_put_mutex(struct kref *kref,
  */
 static inline int __must_check kref_get_unless_zero(struct kref *kref)
 {
-	return atomic_add_unless(&kref->refcount, 1, 0);
+	int old_value = __atomic_add_unless(&kref->refcount, 1, 0);
+
+	if (unlikely(old_value > KREF_MAX_INCREMENTABLE))
+		atomic_dec(&kref->refcount);
+
+	return old_value != 0;
 }
 #endif /* _KREF_H_ */
diff --git a/init/Kconfig b/init/Kconfig
index f755a60..8618353 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1855,6 +1855,22 @@ config PROFILING
 config TRACEPOINTS
 	bool
 
+config HARDEN_KREF_BIGMEM
+	bool "Harden kref against too many references"
+	depends on 64BIT
+	default n
+	help
+	  Prevent memory corruption caused by temporarily having more
+	  references to a kref-managed object than the reference counter can
+	  represent.
+	  This increases security for systems with over 16GB of RAM (swap
+	  doesn't count); if your kernel will only run on systems with <=16GB
+	  of RAM, you can safely leave this disabled to reduce kernel code
+	  size and increase performance. Even on systems with 64GB or so of
+	  RAM, this only protects against worst-case kernel code that probably
+	  doesn't exist; but if your kernel might run on a system with a
+	  terabyte of RAM or so, you'll probably want to enable this.
+
 source "arch/Kconfig"
 
 endmenu		# General setup
diff --git a/kernel/Makefile b/kernel/Makefile
index e2ec54e..e2dcf8d 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    extable.o params.o \
 	    kthread.o sys_ni.o nsproxy.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
-	    async.o range.o smpboot.o
+	    async.o range.o smpboot.o kref.o
 
 obj-$(CONFIG_MULTIUSER) += groups.o
 
diff --git a/kernel/kref.c b/kernel/kref.c
new file mode 100644
index 0000000..2f277cc
--- /dev/null
+++ b/kernel/kref.c
@@ -0,0 +1,17 @@
+#include <linux/bug.h>
+#include <linux/atomic.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/kref.h>
+
+void kref_get_slowpath(struct kref *kref, unsigned int new_refcount)
+{
+	/* If refcount was 0 before incrementing then we have a race
+	 * condition when this kref is freeing by some other thread right now.
+	 * In this case one should use kref_get_unless_zero()
+	 */
+	WARN_ON_ONCE(new_refcount < 2);
+
+	if (new_refcount > KREF_MAX_INCREMENTABLE)
+		atomic_dec(&kref->refcount);
+}
-- 
2.8.0.rc3.226.g39d4020
