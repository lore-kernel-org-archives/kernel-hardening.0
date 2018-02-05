Subject: Patch "x86/entry/64: Push extra regs right away" has been added to the 4.15-stable tree
From: <gregkh@linuxfoundation.org>
Date: Mon, 05 Feb 2018 09:38:57 -0800
Message-ID: <1517852337168178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
To: luto@kernel.org, bp@alien8.de, gregkh@linuxfoundation.org, kernel-hardening@lists.openwall.com, mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org
Cc: stable@vger.kernel.org, stable-commits@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


This is a note to let you know that I've just added the patch titled

    x86/entry/64: Push extra regs right away

to the 4.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     x86entry64_Push_extra_regs_right_away.patch
and it can be found in the queue-4.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


Subject: x86/entry/64: Push extra regs right away
From: Andy Lutomirski luto@kernel.org
Date: Sun Jan 28 10:38:49 2018 -0800

From: Andy Lutomirski luto@kernel.org

commit d1f7732009e0549eedf8ea1db948dc37be77fd46

With the fast path removed there is no point in splitting the push of the
normal and the extra register set. Just push the extra regs right away.

[ tglx: Split out from 'x86/entry/64: Remove the SYSCALL64 fast path' ]

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Link: https://lkml.kernel.org/r/462dff8d4d64dfbfc851fbf3130641809d980ecd.1517164461.git.luto@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/x86/entry/entry_64.S |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -236,13 +236,17 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 	pushq	%r9				/* pt_regs->r9 */
 	pushq	%r10				/* pt_regs->r10 */
 	pushq	%r11				/* pt_regs->r11 */
-	sub	$(6*8), %rsp			/* pt_regs->bp, bx, r12-15 not saved */
-	UNWIND_HINT_REGS extra=0
+	pushq	%rbx				/* pt_regs->rbx */
+	pushq	%rbp				/* pt_regs->rbp */
+	pushq	%r12				/* pt_regs->r12 */
+	pushq	%r13				/* pt_regs->r13 */
+	pushq	%r14				/* pt_regs->r14 */
+	pushq	%r15				/* pt_regs->r15 */
+	UNWIND_HINT_REGS
 
 	TRACE_IRQS_OFF
 
 	/* IRQs are off. */
-	SAVE_EXTRA_REGS
 	movq	%rsp, %rdi
 	call	do_syscall_64		/* returns with IRQs disabled */
 


Patches currently in stable-queue which might be from luto@kernel.org are

queue-4.15/objtool_Add_support_for_alternatives_at_the_end_of_a_section.patch
queue-4.15/x86pti_Mark_constant_arrays_as___initconst.patch
queue-4.15/x86speculation_Use_Indirect_Branch_Prediction_Barrier_in_context_switch.patch
queue-4.15/x86spectre_Fix_spelling_mistake_vunerable-_vulnerable.patch
queue-4.15/x86get_user_Use_pointer_masking_to_limit_speculation.patch
queue-4.15/x86paravirt_Remove_noreplace-paravirt_cmdline_option.patch
queue-4.15/KVM_VMX_Make_indirect_call_speculation_safe.patch
queue-4.15/KVMVMX_Allow_direct_access_to_MSR_IA32_SPEC_CTRL.patch
queue-4.15/x86entry64_Remove_the_SYSCALL64_fast_path.patch
queue-4.15/KVMSVM_Allow_direct_access_to_MSR_IA32_SPEC_CTRL.patch
queue-4.15/x86asm_Move_status_from_thread_struct_to_thread_info.patch
queue-4.15/KVMx86_Add_IBPB_support.patch
queue-4.15/KVMVMX_Emulate_MSR_IA32_ARCH_CAPABILITIES.patch
queue-4.15/KVM_x86_Make_indirect_calls_in_emulator_speculation_safe.patch
queue-4.15/x86entry64_Push_extra_regs_right_away.patch
queue-4.15/objtool_Warn_on_stripped_section_symbol.patch
queue-4.15/x86syscall_Sanitize_syscall_table_de-references_under_speculation.patch
queue-4.15/objtool_Improve_retpoline_alternative_handling.patch
