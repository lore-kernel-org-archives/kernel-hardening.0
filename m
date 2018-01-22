From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 22 Jan 2018 10:04:29 -0800
Message-Id: <503224b776b9513885453756e44bab235221124e.1516644136.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast path with retpolines on
To: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Cox <alan@linux.intel.com>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

The existing retpoline code carefully and awkwardly retpolinifies
the SYSCALL64 slow path.  This stops the fast path from being
particularly fast, and it's IMO rather messy.

Instead, just bypass the fast path entirely if retpolines are on.
This seems to be a speedup on a "minimal" retpoline kernel, mainly
because do_syscall_64() ends up calling the syscall handler without
using a slow retpoline thunk.

As an added benefit, we won't need to apply further Spectre
mitigations to the fast path.  The current fast path spectre
mitigations may have a hole: if the syscall nr is out of bounds, it
is plausible that the CPU would mispredict the bounds check and,
load a bogus function pointer, and speculatively execute it right
though the retpoline.  If this is indeed a problem, we need to fix
it in the slow paths anyway, but with this patch applied, we can at
least leave the fast path alone.

Cleans-up: 2641f08bb7fc ("x86/retpoline/entry: Convert entry assembler indirect jumps")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/entry/entry_64.S | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 4f8e1d35a97c..b915bad58754 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -245,6 +245,9 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 	 * If we need to do entry work or if we guess we'll need to do
 	 * exit work, go straight to the slow path.
 	 */
+#ifdef CONFIG_RETPOLINE
+	ALTERNATIVE "", "jmp entry_SYSCALL64_slow_path", X86_FEATURE_RETPOLINE
+#endif
 	movq	PER_CPU_VAR(current_task), %r11
 	testl	$_TIF_WORK_SYSCALL_ENTRY|_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
 	jnz	entry_SYSCALL64_slow_path
@@ -270,13 +273,11 @@ entry_SYSCALL_64_fastpath:
 	 * This call instruction is handled specially in stub_ptregs_64.
 	 * It might end up jumping to the slow path.  If it jumps, RAX
 	 * and all argument registers are clobbered.
+	 *
+	 * NB: no retpoline needed -- we don't execute this code with
+	 * retpolines enabled.
 	 */
-#ifdef CONFIG_RETPOLINE
-	movq	sys_call_table(, %rax, 8), %rax
-	call	__x86_indirect_thunk_rax
-#else
 	call	*sys_call_table(, %rax, 8)
-#endif
 .Lentry_SYSCALL_64_after_fastpath_call:
 
 	movq	%rax, RAX(%rsp)
@@ -431,6 +432,9 @@ ENTRY(stub_ptregs_64)
 	 * which we achieve by trying again on the slow path.  If we are on
 	 * the slow path, the extra regs are already saved.
 	 *
+	 * This code is unreachable (even via mispredicted conditional branches)
+	 * if we're using retpolines.
+	 *
 	 * RAX stores a pointer to the C function implementing the syscall.
 	 * IRQs are on.
 	 */
@@ -448,12 +452,19 @@ ENTRY(stub_ptregs_64)
 	jmp	entry_SYSCALL64_slow_path
 
 1:
-	JMP_NOSPEC %rax				/* Called from C */
+	jmp	*%rax				/* Called from C */
 END(stub_ptregs_64)
 
 .macro ptregs_stub func
 ENTRY(ptregs_\func)
 	UNWIND_HINT_FUNC
+#ifdef CONFIG_RETPOLINE
+	/*
+	 * If retpolines are enabled, we don't use the syscall fast path,
+	 * so just jump straight to the syscall body.
+	 */
+	ALTERNATIVE "", __stringify(jmp \func), X86_FEATURE_RETPOLINE
+#endif
 	leaq	\func(%rip), %rax
 	jmp	stub_ptregs_64
 END(ptregs_\func)
-- 
2.13.6
