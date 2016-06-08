Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed,  8 Jun 2016 14:11:39 -0700
Message-Id: <1465420302-23754-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1465420302-23754-1-git-send-email-keescook@chromium.org>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 1/4] mm: Hardened usercopy
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

This is an attempt at porting PAX_USERCOPY into the mainline kernel,
calling it CONFIG_HARDENED_USERCOPY. The work is based on code by Brad
Spengler and PaX Team, and an earlier port from Casey Schaufler.

This patch contains the logic for validating several conditions when
performing copy_to_user() and copy_from_user() on the kernel object
being copied to/from:
- if on the heap:
  - the size of copy must be less than or equal to the size of the object
- if on the stack (and we have architecture/build support for frames):
  - object must be contained by the current stack frame
- object must not be contained in the kernel text

Additional restrictions are in following patches.

This implements the checks on many architectures, but I have only tested
x86_64 so far. I would love to see an arm64 port added as well.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/include/asm/uaccess.h      |   5 +
 arch/ia64/include/asm/uaccess.h     |  18 +++-
 arch/powerpc/include/asm/uaccess.h  |  21 ++++-
 arch/sparc/include/asm/uaccess_32.h |  14 ++-
 arch/sparc/include/asm/uaccess_64.h |  11 ++-
 arch/x86/include/asm/uaccess.h      |  10 +-
 arch/x86/include/asm/uaccess_32.h   |   2 +
 arch/x86/include/asm/uaccess_64.h   |   2 +
 include/linux/slab.h                |   5 +
 include/linux/thread_info.h         |  15 +++
 mm/Makefile                         |   1 +
 mm/slab.c                           |  29 ++++++
 mm/slob.c                           |  51 +++++++++++
 mm/slub.c                           |  17 ++++
 mm/usercopy.c                       | 177 ++++++++++++++++++++++++++++++++++++
 security/Kconfig                    |  11 +++
 16 files changed, 374 insertions(+), 15 deletions(-)
 create mode 100644 mm/usercopy.c

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 35c9db857ebe..7bcdb56ce6fb 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -497,6 +497,8 @@ static inline unsigned long __must_check
 __copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	unsigned int __ua_flags = uaccess_save_and_enable();
+
+	check_object_size(to, n, false);
 	n = arm_copy_from_user(to, from, n);
 	uaccess_restore(__ua_flags);
 	return n;
@@ -512,10 +514,13 @@ __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 #ifndef CONFIG_UACCESS_WITH_MEMCPY
 	unsigned int __ua_flags = uaccess_save_and_enable();
+
+	check_object_size(to, n, false);
 	n = arm_copy_to_user(to, from, n);
 	uaccess_restore(__ua_flags);
 	return n;
 #else
+	check_object_size(to, n, false);
 	return arm_copy_to_user(to, from, n);
 #endif
 }
diff --git a/arch/ia64/include/asm/uaccess.h b/arch/ia64/include/asm/uaccess.h
index 2189d5ddc1ee..465c70982f40 100644
--- a/arch/ia64/include/asm/uaccess.h
+++ b/arch/ia64/include/asm/uaccess.h
@@ -241,12 +241,18 @@ extern unsigned long __must_check __copy_user (void __user *to, const void __use
 static inline unsigned long
 __copy_to_user (void __user *to, const void *from, unsigned long count)
 {
+	if (!__builtin_constant_p(count))
+		check_object_size(from, count, true);
+
 	return __copy_user(to, (__force void __user *) from, count);
 }
 
 static inline unsigned long
 __copy_from_user (void *to, const void __user *from, unsigned long count)
 {
+	if (!__builtin_constant_p(count))
+		check_object_size(to, count, false);
+
 	return __copy_user((__force void __user *) to, from, count);
 }
 
@@ -258,8 +264,11 @@ __copy_from_user (void *to, const void __user *from, unsigned long count)
 	const void *__cu_from = (from);							\
 	long __cu_len = (n);								\
 											\
-	if (__access_ok(__cu_to, __cu_len, get_fs()))					\
-		__cu_len = __copy_user(__cu_to, (__force void __user *) __cu_from, __cu_len);	\
+	if (__access_ok(__cu_to, __cu_len, get_fs())) {					\
+		if (!__builtin_constant_p(n))						\
+			check_object_size(__cu_from, __cu_len, true);			\
+		__cu_len = __copy_user(__cu_to, (__force void __user *)  __cu_from, __cu_len);	\
+	}										\
 	__cu_len;									\
 })
 
@@ -270,8 +279,11 @@ __copy_from_user (void *to, const void __user *from, unsigned long count)
 	long __cu_len = (n);								\
 											\
 	__chk_user_ptr(__cu_from);							\
-	if (__access_ok(__cu_from, __cu_len, get_fs()))					\
+	if (__access_ok(__cu_from, __cu_len, get_fs())) {				\
+		if (!__builtin_constant_p(n))						\
+			check_object_size(__cu_to, __cu_len, false);			\
 		__cu_len = __copy_user((__force void __user *) __cu_to, __cu_from, __cu_len);	\
+	}										\
 	__cu_len;									\
 })
 
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index b7c20f0b8fbe..c1dc6c14deb8 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -310,10 +310,15 @@ static inline unsigned long copy_from_user(void *to,
 {
 	unsigned long over;
 
-	if (access_ok(VERIFY_READ, from, n))
+	if (access_ok(VERIFY_READ, from, n)) {
+		if (!__builtin_constant_p(n))
+			check_object_size(to, n, false);
 		return __copy_tofrom_user((__force void __user *)to, from, n);
+	}
 	if ((unsigned long)from < TASK_SIZE) {
 		over = (unsigned long)from + n - TASK_SIZE;
+		if (!__builtin_constant_p(n - over))
+			check_object_size(to, n - over, false);
 		return __copy_tofrom_user((__force void __user *)to, from,
 				n - over) + over;
 	}
@@ -325,10 +330,15 @@ static inline unsigned long copy_to_user(void __user *to,
 {
 	unsigned long over;
 
-	if (access_ok(VERIFY_WRITE, to, n))
+	if (access_ok(VERIFY_WRITE, to, n)) {
+		if (!__builtin_constant_p(n))
+			check_object_size(from, n, true);
 		return __copy_tofrom_user(to, (__force void __user *)from, n);
+	}
 	if ((unsigned long)to < TASK_SIZE) {
 		over = (unsigned long)to + n - TASK_SIZE;
+		if (!__builtin_constant_p(n))
+			check_object_size(from, n - over, true);
 		return __copy_tofrom_user(to, (__force void __user *)from,
 				n - over) + over;
 	}
@@ -372,6 +382,10 @@ static inline unsigned long __copy_from_user_inatomic(void *to,
 		if (ret == 0)
 			return 0;
 	}
+
+	if (!__builtin_constant_p(n))
+		check_object_size(to, n, false);
+
 	return __copy_tofrom_user((__force void __user *)to, from, n);
 }
 
@@ -398,6 +412,9 @@ static inline unsigned long __copy_to_user_inatomic(void __user *to,
 		if (ret == 0)
 			return 0;
 	}
+	if (!__builtin_constant_p(n))
+		check_object_size(from, n, true);
+
 	return __copy_tofrom_user(to, (__force const void __user *)from, n);
 }
 
diff --git a/arch/sparc/include/asm/uaccess_32.h b/arch/sparc/include/asm/uaccess_32.h
index 57aca2792d29..341a5a133f48 100644
--- a/arch/sparc/include/asm/uaccess_32.h
+++ b/arch/sparc/include/asm/uaccess_32.h
@@ -248,22 +248,28 @@ unsigned long __copy_user(void __user *to, const void __user *from, unsigned lon
 
 static inline unsigned long copy_to_user(void __user *to, const void *from, unsigned long n)
 {
-	if (n && __access_ok((unsigned long) to, n))
+	if (n && __access_ok((unsigned long) to, n)) {
+		if (!__builtin_constant_p(n))
+			check_object_size(from, n, true);
 		return __copy_user(to, (__force void __user *) from, n);
-	else
+	} else
 		return n;
 }
 
 static inline unsigned long __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
+	if (!__builtin_constant_p(n))
+		check_object_size(from, n, true);
 	return __copy_user(to, (__force void __user *) from, n);
 }
 
 static inline unsigned long copy_from_user(void *to, const void __user *from, unsigned long n)
 {
-	if (n && __access_ok((unsigned long) from, n))
+	if (n && __access_ok((unsigned long) from, n)) {
+		if (!__builtin_constant_p(n))
+			check_object_size(to, n, false);
 		return __copy_user((__force void __user *) to, from, n);
-	else
+	} else
 		return n;
 }
 
diff --git a/arch/sparc/include/asm/uaccess_64.h b/arch/sparc/include/asm/uaccess_64.h
index e9a51d64974d..8bda94fab8e8 100644
--- a/arch/sparc/include/asm/uaccess_64.h
+++ b/arch/sparc/include/asm/uaccess_64.h
@@ -210,8 +210,12 @@ unsigned long copy_from_user_fixup(void *to, const void __user *from,
 static inline unsigned long __must_check
 copy_from_user(void *to, const void __user *from, unsigned long size)
 {
-	unsigned long ret = ___copy_from_user(to, from, size);
+	unsigned long ret;
 
+	if (!__builtin_constant_p(size))
+		check_object_size(to, size, false);
+
+	ret = ___copy_from_user(to, from, size);
 	if (unlikely(ret))
 		ret = copy_from_user_fixup(to, from, size);
 
@@ -227,8 +231,11 @@ unsigned long copy_to_user_fixup(void __user *to, const void *from,
 static inline unsigned long __must_check
 copy_to_user(void __user *to, const void *from, unsigned long size)
 {
-	unsigned long ret = ___copy_to_user(to, from, size);
+	unsigned long ret;
 
+	if (!__builtin_constant_p(size))
+		check_object_size(from, size, true);
+	ret = ___copy_to_user(to, from, size);
 	if (unlikely(ret))
 		ret = copy_to_user_fixup(to, from, size);
 	return ret;
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 2982387ba817..aa9cc58409c6 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -742,9 +742,10 @@ copy_from_user(void *to, const void __user *from, unsigned long n)
 	 * case, and do only runtime checking for non-constant sizes.
 	 */
 
-	if (likely(sz < 0 || sz >= n))
+	if (likely(sz < 0 || sz >= n)) {
+		check_object_size(to, n, false);
 		n = _copy_from_user(to, from, n);
-	else if(__builtin_constant_p(n))
+	} else if(__builtin_constant_p(n))
 		copy_from_user_overflow();
 	else
 		__copy_from_user_overflow(sz, n);
@@ -762,9 +763,10 @@ copy_to_user(void __user *to, const void *from, unsigned long n)
 	might_fault();
 
 	/* See the comment in copy_from_user() above. */
-	if (likely(sz < 0 || sz >= n))
+	if (likely(sz < 0 || sz >= n)) {
+		check_object_size(from, n, true);
 		n = _copy_to_user(to, from, n);
-	else if(__builtin_constant_p(n))
+	} else if(__builtin_constant_p(n))
 		copy_to_user_overflow();
 	else
 		__copy_to_user_overflow(sz, n);
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 4b32da24faaf..7d3bdd1ed697 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -37,6 +37,7 @@ unsigned long __must_check __copy_from_user_ll_nocache_nozero
 static __always_inline unsigned long __must_check
 __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
 {
+	check_object_size(from, n, true);
 	return __copy_to_user_ll(to, from, n);
 }
 
@@ -95,6 +96,7 @@ static __always_inline unsigned long
 __copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	might_fault();
+	check_object_size(to, n, false);
 	if (__builtin_constant_p(n)) {
 		unsigned long ret;
 
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 2eac2aa3e37f..673059a109fe 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -54,6 +54,7 @@ int __copy_from_user_nocheck(void *dst, const void __user *src, unsigned size)
 {
 	int ret = 0;
 
+	check_object_size(dst, size, false);
 	if (!__builtin_constant_p(size))
 		return copy_user_generic(dst, (__force void *)src, size);
 	switch (size) {
@@ -119,6 +120,7 @@ int __copy_to_user_nocheck(void __user *dst, const void *src, unsigned size)
 {
 	int ret = 0;
 
+	check_object_size(src, size, true);
 	if (!__builtin_constant_p(size))
 		return copy_user_generic((__force void *)dst, src, size);
 	switch (size) {
diff --git a/include/linux/slab.h b/include/linux/slab.h
index aeb3e6d00a66..5c0cd75b2d07 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -155,6 +155,11 @@ void kfree(const void *);
 void kzfree(const void *);
 size_t ksize(const void *);
 
+#ifdef CONFIG_HARDENED_USERCOPY
+const char *__check_heap_object(const void *ptr, unsigned long n,
+				struct page *page);
+#endif
+
 /*
  * Some archs want to perform DMA into kmalloc caches and need a guaranteed
  * alignment larger than the alignment of a 64-bit integer.
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index b4c2a485b28a..a02200db9c33 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -146,6 +146,21 @@ static inline bool test_and_clear_restore_sigmask(void)
 #error "no set_restore_sigmask() provided and default one won't work"
 #endif
 
+#ifdef CONFIG_HARDENED_USERCOPY
+extern void __check_object_size(const void *ptr, unsigned long n,
+					bool to_user);
+
+static inline void check_object_size(const void *ptr, unsigned long n,
+				     bool to_user)
+{
+	__check_object_size(ptr, n, to_user);
+}
+#else
+static inline void check_object_size(const void *ptr, unsigned long n,
+				     bool to_user)
+{ }
+#endif /* CONFIG_HARDENED_USERCOPY */
+
 #endif	/* __KERNEL__ */
 
 #endif /* _LINUX_THREAD_INFO_H */
diff --git a/mm/Makefile b/mm/Makefile
index 78c6f7dedb83..a359cd9aa759 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -99,3 +99,4 @@ obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
 obj-$(CONFIG_IDLE_PAGE_TRACKING) += page_idle.o
 obj-$(CONFIG_FRAME_VECTOR) += frame_vector.o
 obj-$(CONFIG_DEBUG_PAGE_REF) += debug_page_ref.o
+obj-$(CONFIG_HARDENED_USERCOPY) += usercopy.o
diff --git a/mm/slab.c b/mm/slab.c
index cc8bbc1e6bc9..4cb2e5408625 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4477,6 +4477,35 @@ static int __init slab_proc_init(void)
 module_init(slab_proc_init);
 #endif
 
+#ifdef CONFIG_HARDENED_USERCOPY
+/*
+ * Rejects objects that are:
+ * - NULL or zero-allocated
+ * - incorrectly sized
+ *
+ * Returns NULL if check passes, otherwise const char * to name of cache
+ * to indicate an error.
+ */
+const char *__check_heap_object(const void *ptr, unsigned long n,
+				struct page *page)
+{
+	struct kmem_cache *cachep;
+	unsigned int objnr;
+	unsigned long offset;
+
+	cachep = page->slab_cache;
+
+	objnr = obj_to_index(cachep, page, (void *)ptr);
+	BUG_ON(objnr >= cachep->num);
+	offset = ptr - index_to_obj(cachep, page, objnr) - obj_offset(cachep);
+
+	if (offset <= cachep->object_size && n <= cachep->object_size - offset)
+		return NULL;
+
+	return cachep->name;
+}
+#endif /* CONFIG_HARDENED_USERCOPY */
+
 /**
  * ksize - get the actual amount of memory allocated for a given object
  * @objp: Pointer to the object
diff --git a/mm/slob.c b/mm/slob.c
index 5ec158054ffe..2d54fcd262fa 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -501,6 +501,57 @@ void kfree(const void *block)
 }
 EXPORT_SYMBOL(kfree);
 
+#ifdef CONFIG_HARDENED_USERCOPY
+const char *__check_heap_object(const void *ptr, unsigned long n,
+				struct page *page)
+{
+	const slob_t *free;
+	const void *base;
+	unsigned long flags;
+
+	if (page->private) {
+		base = page;
+		if (base <= ptr && n <= page->private - (ptr - base))
+			return NULL;
+		return "<slob>";
+	}
+
+	/* some tricky double walking to find the chunk */
+	spin_lock_irqsave(&slob_lock, flags);
+	base = (void *)((unsigned long)ptr & PAGE_MASK);
+	free = page->freelist;
+
+	while (!slob_last(free) && (void *)free <= ptr) {
+		base = free + slob_units(free);
+		free = slob_next(free);
+	}
+
+	while (base < (void *)free) {
+		slobidx_t m = ((slob_t *)base)[0].units, align = ((slob_t *)base)[1].units;
+		int size = SLOB_UNIT * SLOB_UNITS(m + align);
+		int offset;
+
+		if (ptr < base + align)
+			break;
+
+		offset = ptr - base - align;
+		if (offset >= m) {
+			base += size;
+			continue;
+		}
+
+		if (n > m - offset)
+			break;
+
+		spin_unlock_irqrestore(&slob_lock, flags);
+		return NULL;
+	}
+
+	spin_unlock_irqrestore(&slob_lock, flags);
+	return "<slob>";
+}
+#endif /* CONFIG_HARDENED_USERCOPY */
+
 /* can't use ksize for kmem_cache_alloc memory, only kmalloc */
 size_t ksize(const void *block)
 {
diff --git a/mm/slub.c b/mm/slub.c
index 825ff4505336..83d3cbc7adf8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3614,6 +3614,23 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
 
+#ifdef CONFIG_HARDENED_USERCOPY
+const char *__check_heap_object(const void *ptr, unsigned long n,
+				struct page *page)
+{
+	struct kmem_cache *s;
+	unsigned long offset;
+
+	s = page->slab_cache;
+
+	offset = (ptr - page_address(page)) % s->size;
+	if (offset <= s->object_size && n <= s->object_size - offset)
+		return NULL;
+
+	return s->name;
+}
+#endif /* CONFIG_HARDENED_USERCOPY */
+
 static size_t __ksize(const void *object)
 {
 	struct page *page;
diff --git a/mm/usercopy.c b/mm/usercopy.c
new file mode 100644
index 000000000000..e09c33070759
--- /dev/null
+++ b/mm/usercopy.c
@@ -0,0 +1,177 @@
+/*
+ * This implements the various checks for CONFIG_HARDENED_USERCOPY*,
+ * which are designed to protect kernel memory from needless exposure
+ * and overwrite under many conditions.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <asm/sections.h>
+
+/*
+ * Checks if a given pointer and length is contained by the current
+ * stack frame (if possible).
+ *
+ *	0: not at all on the stack
+ *	1: fully on the stack (when can't do frame-checking)
+ *	2: fully inside the current stack frame
+ *	-1: error condition (invalid stack position or bad stack frame)
+ */
+static noinline int check_stack_object(const void *obj, unsigned long len)
+{
+	const void * const stack = task_stack_page(current);
+	const void * const stackend = stack + THREAD_SIZE;
+
+#if defined(CONFIG_FRAME_POINTER) && defined(CONFIG_X86)
+	const void *frame = NULL;
+	const void *oldframe;
+#endif
+
+	/* Reject: object wraps past end of memory. */
+	if (obj + len < obj)
+		return -1;
+
+	/* Object is not on the stack at all. */
+	if (obj + len <= stack || stackend <= obj)
+		return 0;
+
+	/*
+	 * Reject: object partially overlaps the stack (passing the
+	 * the check above means at least one end is within the stack,
+	 * so if this check fails, the other end is outside the stack).
+	 */
+	if (obj < stack || stackend < obj + len)
+		return -1;
+
+#if defined(CONFIG_FRAME_POINTER) && defined(CONFIG_X86)
+	oldframe = __builtin_frame_address(1);
+	if (oldframe)
+		frame = __builtin_frame_address(2);
+	/*
+	 * low ----------------------------------------------> high
+	 * [saved bp][saved ip][args][local vars][saved bp][saved ip]
+	 *		     ^----------------^
+	 *             allow copies only within here
+	 */
+	while (stack <= frame && frame < stackend) {
+		/*
+		 * If obj + len extends past the last frame, this
+		 * check won't pass and the next frame will be 0,
+		 * causing us to bail out and correctly report
+		 * the copy as invalid.
+		 */
+		if (obj + len <= frame)
+			return obj >= oldframe + 2 * sizeof(void *) ? 2 : -1;
+		oldframe = frame;
+		frame = *(const void * const *)frame;
+	}
+	return -1;
+#else
+	return 1;
+#endif
+}
+
+static void report_usercopy(const void *ptr, unsigned long len,
+			    bool to_user, const char *type)
+{
+	pr_emerg("kernel memory %s attempt detected %s %p (%s) (%lu bytes)\n",
+		to_user ? "exposure" : "overwrite",
+		to_user ? "from" : "to", ptr, type ? : "unknown", len);
+	dump_stack();
+	do_group_exit(SIGKILL);
+}
+
+/* Is this address range (low, high) in the kernel text area? */
+static inline bool check_kernel_text_object(const void *ptr, unsigned long n)
+{
+	unsigned long low = (unsigned long)ptr;
+	unsigned long high = low + n;
+	unsigned long textlow = (unsigned long)_stext;
+	unsigned long texthigh = (unsigned long)_etext;
+
+#ifdef CONFIG_X86_64
+	/* Check against linear mapping as well. */
+	if (high > (unsigned long)__va(__pa(textlow)) &&
+	    low < (unsigned long)__va(__pa(texthigh)))
+		return true;
+#endif
+
+	/*
+	 * Unless we're entirely below or entirely above the kernel text,
+	 * we've overlapped.
+	 */
+	if (high <= textlow || low >= texthigh)
+		return false;
+	else
+		return true;
+}
+
+static inline const char *check_heap_object(const void *ptr, unsigned long n)
+{
+	struct page *page;
+
+	if (ZERO_OR_NULL_PTR(ptr))
+		return "<null>";
+
+	if (!virt_addr_valid(ptr))
+		return NULL;
+
+	page = virt_to_head_page(ptr);
+	if (!PageSlab(page))
+		return NULL;
+
+	/* Check allocator for flags and size. */
+	return __check_heap_object(ptr, n, page);
+}
+
+/*
+ * Validates that the given object is one of:
+ * - known safe heap object
+ * - known safe stack object
+ * - not in kernel text
+ */
+void __check_object_size(const void *ptr, unsigned long n, bool to_user)
+{
+	const char *err;
+
+#if !defined(CONFIG_STACK_GROWSUP) && !defined(CONFIG_X86_64)
+	unsigned long stackstart = (unsigned long)task_stack_page(current);
+	unsigned long currentsp = (unsigned long)&stackstart;
+	if (unlikely((currentsp < stackstart + 512 ||
+		     currentsp >= stackstart + THREAD_SIZE) && !in_interrupt()))
+		BUG();
+#endif
+	if (!n)
+		return;
+
+	/* Check for bad heap object. */
+	err = check_heap_object(ptr, n);
+	if (!err) {
+		/* Check for bad stack object. */
+		int ret = check_stack_object(ptr, n);
+		if (ret == 1 || ret == 2) {
+			/*
+			 * Object is either in the correct frame (when it
+			 * is possible to check) or just generally on the
+			 * on the process stack (when frame checking not
+			 * available).
+			 */
+			return;
+		}
+		if (ret == 0) {
+			/*
+			 * Object is not on the heap and not on the stack.
+			 * Double-check that it's not in the kernel text.
+			 */
+			if (check_kernel_text_object(ptr, n))
+				err = "<kernel text>";
+			else
+				return;
+		} else
+			err = "<process stack>";
+	}
+
+	report_usercopy(ptr, n, to_user, err);
+}
+EXPORT_SYMBOL(__check_object_size);
diff --git a/security/Kconfig b/security/Kconfig
index 176758cdfa57..081607a5e078 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -118,6 +118,17 @@ config LSM_MMAP_MIN_ADDR
 	  this low address space will need the permission specific to the
 	  systems running LSM.
 
+config HARDENED_USERCOPY
+	bool "Harden memory copies between kernel and userspace"
+	default n
+	help
+	  This option checks for obviously wrong memory regions when
+	  calling copy_to_user() and copy_from_user() by rejecting
+	  copies that are larger than the specified heap object, are
+	  not on the process stack, or are part of the kernel text.
+	  This kills entire classes of heap overflows and similar
+	  kernel memory exposures.
+
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
-- 
2.7.4
