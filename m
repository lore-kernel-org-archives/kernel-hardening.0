Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 23 Jun 2016 21:23:06 -0700
Message-Id: <2bae70091dd75abc881259747987979156f2f789.1466741835.git.luto@kernel.org>
In-Reply-To: <cover.1466741835.git.luto@kernel.org>
References: <cover.1466741835.git.luto@kernel.org>
In-Reply-To: <cover.1466741835.git.luto@kernel.org>
References: <cover.1466741835.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v4 11/16] x86/dumpstack: When OOPSing, rewind the stack before do_exit
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

If we call do_exit with a clean stack, we greatly reduce the risk of
recursive oopses due to stack overflow in do_exit, and we allow
do_exit to work even if we OOPS from an IST stack.  The latter gives
us a much better chance of surviving long enough after we detect a
stack overflow to write out our logs.

I intentionally separated this from the preceding patch that
disables do_exit-on-OOPS on IST stacks.  This way, if we need to
revert this patch, we still end up in an acceptable state wrt stack
overflow handling.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/entry/entry_32.S   | 11 +++++++++++
 arch/x86/entry/entry_64.S   | 11 +++++++++++
 arch/x86/kernel/dumpstack.c | 13 +++++++++----
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 983e5d3a0d27..0b56666e6039 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1153,3 +1153,14 @@ ENTRY(async_page_fault)
 	jmp	error_code
 END(async_page_fault)
 #endif
+
+ENTRY(rewind_stack_do_exit)
+	/* Prevent any naive code from trying to unwind to our caller. */
+	xorl	%ebp, %ebp
+
+	movl	PER_CPU_VAR(cpu_current_top_of_stack), %esi
+	leal	-TOP_OF_KERNEL_STACK_PADDING-PTREGS_SIZE(%esi), %esp
+
+	call	do_exit
+1:	jmp 1b
+END(rewind_stack_do_exit)
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 9ee0da1807ed..b846875aeea6 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1423,3 +1423,14 @@ ENTRY(ignore_sysret)
 	mov	$-ENOSYS, %eax
 	sysret
 END(ignore_sysret)
+
+ENTRY(rewind_stack_do_exit)
+	/* Prevent any naive code from trying to unwind to our caller. */
+	xorl	%ebp, %ebp
+
+	movq	PER_CPU_VAR(cpu_current_top_of_stack), %rax
+	leaq	-TOP_OF_KERNEL_STACK_PADDING-PTREGS_SIZE(%rax), %rsp
+
+	call	do_exit
+1:	jmp 1b
+END(rewind_stack_do_exit)
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 70d5aae8b8f7..4592bc4ed3e1 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -226,6 +226,8 @@ unsigned long oops_begin(void)
 EXPORT_SYMBOL_GPL(oops_begin);
 NOKPROBE_SYMBOL(oops_begin);
 
+extern void __noreturn rewind_stack_do_exit(int signr);
+
 void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 {
 	if (regs && kexec_should_crash(current))
@@ -245,12 +247,15 @@ void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 		return;
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
-	if (((current_stack_pointer() ^ (current_top_of_stack() - 1))
-	     & ~(THREAD_SIZE - 1)) != 0)
-		panic("Fatal exception on special stack");
 	if (panic_on_oops)
 		panic("Fatal exception");
-	do_exit(signr);
+
+	/*
+	 * We're not going to return, but we might be on an IST stack or
+	 * have very little stack space left.  Rewind the stack and kill
+	 * the task.
+	 */
+	rewind_stack_do_exit(signr);
 }
 NOKPROBE_SYMBOL(oops_end);
 
-- 
2.5.5
