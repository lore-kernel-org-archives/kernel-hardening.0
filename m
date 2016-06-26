Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 26 Jun 2016 14:55:39 -0700
Message-Id: <ffb301d6213d3cd9e47f903699084854f61681e1.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v4 17/29] x86: Move uaccess_err and sig_on_uaccess_err to thread_struct
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

thread_info is a legacy mess.  To prepare for its partial removal,
move the uaccess control fields out -- they're straightforward.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/entry/vsyscall/vsyscall_64.c | 6 +++---
 arch/x86/include/asm/processor.h      | 3 +++
 arch/x86/include/asm/thread_info.h    | 2 --
 arch/x86/include/asm/uaccess.h        | 4 ++--
 arch/x86/mm/extable.c                 | 2 +-
 arch/x86/mm/fault.c                   | 2 +-
 6 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
index 174c2549939d..3aba2b043050 100644
--- a/arch/x86/entry/vsyscall/vsyscall_64.c
+++ b/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -221,8 +221,8 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 	 * With a real vsyscall, page faults cause SIGSEGV.  We want to
 	 * preserve that behavior to make writing exploits harder.
 	 */
-	prev_sig_on_uaccess_error = current_thread_info()->sig_on_uaccess_error;
-	current_thread_info()->sig_on_uaccess_error = 1;
+	prev_sig_on_uaccess_error = current->thread.sig_on_uaccess_error;
+	current->thread.sig_on_uaccess_error = 1;
 
 	ret = -EFAULT;
 	switch (vsyscall_nr) {
@@ -243,7 +243,7 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 		break;
 	}
 
-	current_thread_info()->sig_on_uaccess_error = prev_sig_on_uaccess_error;
+	current->thread.sig_on_uaccess_error = prev_sig_on_uaccess_error;
 
 check_fault:
 	if (ret == -EFAULT) {
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 62c6cc3cc5d3..f53ae57bd985 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -419,6 +419,9 @@ struct thread_struct {
 	/* Max allowed port in the bitmap, in bytes: */
 	unsigned		io_bitmap_max;
 
+	unsigned int		sig_on_uaccess_error:1;
+	unsigned int		uaccess_err:1;	/* uaccess failed */
+
 	/* Floating point and extended processor state */
 	struct fpu		fpu;
 	/*
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 30c133ac05cd..7c47bb659ecd 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -58,8 +58,6 @@ struct thread_info {
 	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
 	mm_segment_t		addr_limit;
-	unsigned int		sig_on_uaccess_error:1;
-	unsigned int		uaccess_err:1;	/* uaccess failed */
 };
 
 #define INIT_THREAD_INFO(tsk)			\
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 2982387ba817..4d2a726e8e6d 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -468,13 +468,13 @@ struct __large_struct { unsigned long buf[100]; };
  * uaccess_try and catch
  */
 #define uaccess_try	do {						\
-	current_thread_info()->uaccess_err = 0;				\
+	current->thread.uaccess_err = 0;				\
 	__uaccess_begin();						\
 	barrier();
 
 #define uaccess_catch(err)						\
 	__uaccess_end();						\
-	(err) |= (current_thread_info()->uaccess_err ? -EFAULT : 0);	\
+	(err) |= (current->thread.uaccess_err ? -EFAULT : 0);		\
 } while (0)
 
 /**
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 4bb53b89f3c5..0f90cc218d04 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -37,7 +37,7 @@ bool ex_handler_ext(const struct exception_table_entry *fixup,
 		   struct pt_regs *regs, int trapnr)
 {
 	/* Special hack for uaccess_err */
-	current_thread_info()->uaccess_err = 1;
+	current->thread.uaccess_err = 1;
 	regs->ip = ex_fixup_addr(fixup);
 	return true;
 }
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index c68b81f5659f..d34e21e81b07 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -737,7 +737,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 		 * In this case we need to make sure we're not recursively
 		 * faulting through the emulate_vsyscall() logic.
 		 */
-		if (current_thread_info()->sig_on_uaccess_error && signal) {
+		if (current->thread.sig_on_uaccess_error && signal) {
 			tsk->thread.trap_nr = X86_TRAP_PF;
 			tsk->thread.error_code = error_code | PF_USER;
 			tsk->thread.cr2 = address;
-- 
2.7.4
