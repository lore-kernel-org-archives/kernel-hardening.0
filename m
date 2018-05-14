From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 2/2] powerpc: Check address limit on user-mode return (TIF_FSCHECK)
Date: Mon, 14 May 2018 23:03:16 +1000
Message-Id: <20180514130316.23855-2-mpe@ellerman.id.au>
In-Reply-To: <20180514130316.23855-1-mpe@ellerman.id.au>
References: <20180514130316.23855-1-mpe@ellerman.id.au>
To: linuxppc-dev@ozlabs.org
Cc: kernel-hardening@lists.openwall.com, thgarnie@google.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

set_fs() sets the addr_limit, which is used in access_ok() to
determine if an address is a user or kernel address.

Some code paths use set_fs() to temporarily elevate the addr_limit so
that kernel code can read/write kernel memory as if it were user
memory. That is fine as long as the code can't ever return to
userspace with the addr_limit still elevated.

If that did happen, then userspace can read/write kernel memory as if
it were user memory, eg. just with write(2). In case it's not clear,
that is very bad. It has also happened in the past due to bugs.

Commit 5ea0727b163c ("x86/syscalls: Check address limit on user-mode
return") added a mechanism to check the addr_limit value before
returning to userspace. Any call to set_fs() sets a thread flag,
TIF_FSCHECK, and if we see that on the return to userspace we go out
of line to check that the addr_limit value is not elevated.

For further info see the above commit, as well as:
  https://lwn.net/Articles/722267/
  https://bugs.chromium.org/p/project-zero/issues/detail?id=990

Verified to work on 64-bit Book3S using a POC that objdumps the system
call handler, and a modified lkdtm_CORRUPT_USER_DS() that doesn't kill
the caller.

Before:
  $ sudo ./test-tif-fscheck
  ...
  0000000000000000 <.data>:
         0:       e1 f7 8a 79     rldicl. r10,r12,30,63
         4:       80 03 82 40     bne     0x384
         8:       00 40 8a 71     andi.   r10,r12,16384
         c:       78 0b 2a 7c     mr      r10,r1
        10:       10 fd 21 38     addi    r1,r1,-752
        14:       08 00 c2 41     beq-    0x1c
        18:       58 09 2d e8     ld      r1,2392(r13)
        1c:       00 00 41 f9     std     r10,0(r1)
        20:       70 01 61 f9     std     r11,368(r1)
        24:       78 01 81 f9     std     r12,376(r1)
        28:       70 00 01 f8     std     r0,112(r1)
        2c:       78 00 41 f9     std     r10,120(r1)
        30:       20 00 82 41     beq     0x50
        34:       a6 42 4c 7d     mftb    r10

After:

  $ sudo ./test-tif-fscheck
  Killed

And in dmesg:
  Invalid address limit on user-mode return
  WARNING: CPU: 1 PID: 3689 at ../include/linux/syscalls.h:260 do_notify_resume+0x140/0x170
  ...
  NIP [c00000000001ee50] do_notify_resume+0x140/0x170
  LR [c00000000001ee4c] do_notify_resume+0x13c/0x170
  Call Trace:
    do_notify_resume+0x13c/0x170 (unreliable)
    ret_from_except_lite+0x70/0x74

Performance overhead is essentially zero in the usual case, because
the bit is checked as part of the existing _TIF_USER_WORK_MASK check.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/include/asm/thread_info.h | 8 +++++---
 arch/powerpc/include/asm/uaccess.h     | 8 +++++++-
 arch/powerpc/kernel/signal.c           | 4 ++++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 5964145db03d..f308dfeb2746 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -79,8 +79,7 @@ extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-#define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
-					   TIF_NEED_RESCHED */
+#define TIF_FSCHECK		3	/* Check FS is USER_DS on return */
 #define TIF_32BIT		4	/* 32 bit binary */
 #define TIF_RESTORE_TM		5	/* need to restore TM FP/VEC/VSX */
 #define TIF_PATCH_PENDING	6	/* pending live patching update */
@@ -99,6 +98,7 @@ extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src
 #if defined(CONFIG_PPC64)
 #define TIF_ELF2ABI		18	/* function descriptors must die! */
 #endif
+#define TIF_POLLING_NRFLAG	19	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -118,13 +118,15 @@ extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src
 #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 #define _TIF_EMULATE_STACK_STORE	(1<<TIF_EMULATE_STACK_STORE)
 #define _TIF_NOHZ		(1<<TIF_NOHZ)
+#define _TIF_FSCHECK		(1<<TIF_FSCHECK)
 #define _TIF_SYSCALL_DOTRACE	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
 				 _TIF_SECCOMP | _TIF_SYSCALL_TRACEPOINT | \
 				 _TIF_NOHZ)
 
 #define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
 				 _TIF_NOTIFY_RESUME | _TIF_UPROBE | \
-				 _TIF_RESTORE_TM | _TIF_PATCH_PENDING)
+				 _TIF_RESTORE_TM | _TIF_PATCH_PENDING | \
+				 _TIF_FSCHECK)
 #define _TIF_PERSYSCALL_MASK	(_TIF_RESTOREALL|_TIF_NOERROR)
 
 /* Bits in local_flags */
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index a91cea15187b..abba80f8ff04 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -31,7 +31,13 @@
 
 #define get_ds()	(KERNEL_DS)
 #define get_fs()	(current->thread.addr_limit)
-#define set_fs(val)	(current->thread.addr_limit = (val))
+
+static inline void set_fs(mm_segment_t fs)
+{
+	current->thread.addr_limit = fs;
+	/* On user-mode return check addr_limit (fs) is correct */
+	set_thread_flag(TIF_FSCHECK);
+}
 
 #define segment_eq(a, b)	((a).seg == (b).seg)
 
diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index 61db86ecd318..fb932f1202c7 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -15,6 +15,7 @@
 #include <linux/key.h>
 #include <linux/context_tracking.h>
 #include <linux/livepatch.h>
+#include <linux/syscalls.h>
 #include <asm/hw_breakpoint.h>
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -150,6 +151,9 @@ void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
 {
 	user_exit();
 
+	/* Check valid addr_limit, TIF check is done there */
+	addr_limit_user_check();
+
 	if (thread_info_flags & _TIF_UPROBE)
 		uprobe_notify_resume(regs);
 
-- 
2.14.1
