Subject: Patch "x86/asm: Move 'status' from thread_struct to thread_info" has been added to the 4.14-stable tree
From: <gregkh@linuxfoundation.org>
Date: Mon, 05 Feb 2018 09:38:26 -0800
Message-ID: <1517852306121101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
To: torvalds@linux-foundation.org, bp@alien8.de, gregkh@linuxfoundation.org, kernel-hardening@lists.openwall.com, luto@kernel.org, mingo@kernel.org, tglx@linutronix.de
Cc: stable@vger.kernel.org, stable-commits@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


This is a note to let you know that I've just added the patch titled

    x86/asm: Move 'status' from thread_struct to thread_info

to the 4.14-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     x86asm_Move_status_from_thread_struct_to_thread_info.patch
and it can be found in the queue-4.14 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


Subject: x86/asm: Move 'status' from thread_struct to thread_info
From: Andy Lutomirski luto@kernel.org
Date: Sun Jan 28 10:38:50 2018 -0800

From: Andy Lutomirski luto@kernel.org

commit 37a8f7c38339b22b69876d6f5a0ab851565284e3

The TS_COMPAT bit is very hot and is accessed from code paths that mostly
also touch thread_info::flags.  Move it into struct thread_info to improve
cache locality.

The only reason it was in thread_struct is that there was a brief period
during which arch-specific fields were not allowed in struct thread_info.

Linus suggested further changing:

  ti->status &= ~(TS_COMPAT|TS_I386_REGS_POKED);

to:

  if (unlikely(ti->status & (TS_COMPAT|TS_I386_REGS_POKED)))
          ti->status &= ~(TS_COMPAT|TS_I386_REGS_POKED);

on the theory that frequently dirtying the cacheline even in pure 64-bit
code that never needs to modify status hurts performance.  That could be a
reasonable followup patch, but I suspect it matters less on top of this
patch.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Link: https://lkml.kernel.org/r/03148bcc1b217100e6e8ecf6a5468c45cf4304b6.1517164461.git.luto@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/x86/entry/common.c            |    4 ++--
 arch/x86/include/asm/processor.h   |    2 --
 arch/x86/include/asm/syscall.h     |    6 +++---
 arch/x86/include/asm/thread_info.h |    3 ++-
 arch/x86/kernel/process_64.c       |    4 ++--
 arch/x86/kernel/ptrace.c           |    2 +-
 arch/x86/kernel/signal.c           |    2 +-
 7 files changed, 11 insertions(+), 12 deletions(-)

--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -208,7 +208,7 @@ __visible inline void prepare_exit_to_us
 	 * special case only applies after poking regs and before the
 	 * very next return to user mode.
 	 */
-	current->thread.status &= ~(TS_COMPAT|TS_I386_REGS_POKED);
+	ti->status &= ~(TS_COMPAT|TS_I386_REGS_POKED);
 #endif
 
 	user_enter_irqoff();
@@ -306,7 +306,7 @@ static __always_inline void do_syscall_3
 	unsigned int nr = (unsigned int)regs->orig_ax;
 
 #ifdef CONFIG_IA32_EMULATION
-	current->thread.status |= TS_COMPAT;
+	ti->status |= TS_COMPAT;
 #endif
 
 	if (READ_ONCE(ti->flags) & _TIF_WORK_SYSCALL_ENTRY) {
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -459,8 +459,6 @@ struct thread_struct {
 	unsigned short		gsindex;
 #endif
 
-	u32			status;		/* thread synchronous flags */
-
 #ifdef CONFIG_X86_64
 	unsigned long		fsbase;
 	unsigned long		gsbase;
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -60,7 +60,7 @@ static inline long syscall_get_error(str
 	 * TS_COMPAT is set for 32-bit syscall entries and then
 	 * remains set until we return to user mode.
 	 */
-	if (task->thread.status & (TS_COMPAT|TS_I386_REGS_POKED))
+	if (task->thread_info.status & (TS_COMPAT|TS_I386_REGS_POKED))
 		/*
 		 * Sign-extend the value so (int)-EFOO becomes (long)-EFOO
 		 * and will match correctly in comparisons.
@@ -116,7 +116,7 @@ static inline void syscall_get_arguments
 					 unsigned long *args)
 {
 # ifdef CONFIG_IA32_EMULATION
-	if (task->thread.status & TS_COMPAT)
+	if (task->thread_info.status & TS_COMPAT)
 		switch (i) {
 		case 0:
 			if (!n--) break;
@@ -177,7 +177,7 @@ static inline void syscall_set_arguments
 					 const unsigned long *args)
 {
 # ifdef CONFIG_IA32_EMULATION
-	if (task->thread.status & TS_COMPAT)
+	if (task->thread_info.status & TS_COMPAT)
 		switch (i) {
 		case 0:
 			if (!n--) break;
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -55,6 +55,7 @@ struct task_struct;
 
 struct thread_info {
 	unsigned long		flags;		/* low level flags */
+	u32			status;		/* thread synchronous flags */
 };
 
 #define INIT_THREAD_INFO(tsk)			\
@@ -221,7 +222,7 @@ static inline int arch_within_stack_fram
 #define in_ia32_syscall() true
 #else
 #define in_ia32_syscall() (IS_ENABLED(CONFIG_IA32_EMULATION) && \
-			   current->thread.status & TS_COMPAT)
+			   current_thread_info()->status & TS_COMPAT)
 #endif
 
 /*
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -557,7 +557,7 @@ static void __set_personality_x32(void)
 	 * Pretend to come from a x32 execve.
 	 */
 	task_pt_regs(current)->orig_ax = __NR_x32_execve | __X32_SYSCALL_BIT;
-	current->thread.status &= ~TS_COMPAT;
+	current_thread_info()->status &= ~TS_COMPAT;
 #endif
 }
 
@@ -571,7 +571,7 @@ static void __set_personality_ia32(void)
 	current->personality |= force_personality32;
 	/* Prepare the first "return" to user space */
 	task_pt_regs(current)->orig_ax = __NR_ia32_execve;
-	current->thread.status |= TS_COMPAT;
+	current_thread_info()->status |= TS_COMPAT;
 #endif
 }
 
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -935,7 +935,7 @@ static int putreg32(struct task_struct *
 		 */
 		regs->orig_ax = value;
 		if (syscall_get_nr(child, regs) >= 0)
-			child->thread.status |= TS_I386_REGS_POKED;
+			child->thread_info.status |= TS_I386_REGS_POKED;
 		break;
 
 	case offsetof(struct user32, regs.eflags):
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -787,7 +787,7 @@ static inline unsigned long get_nr_resta
 	 * than the tracee.
 	 */
 #ifdef CONFIG_IA32_EMULATION
-	if (current->thread.status & (TS_COMPAT|TS_I386_REGS_POKED))
+	if (current_thread_info()->status & (TS_COMPAT|TS_I386_REGS_POKED))
 		return __NR_ia32_restart_syscall;
 #endif
 #ifdef CONFIG_X86_X32_ABI


Patches currently in stable-queue which might be from torvalds@linux-foundation.org are

queue-4.14/objtool_Add_support_for_alternatives_at_the_end_of_a_section.patch
queue-4.14/x86pti_Do_not_enable_PTI_on_CPUs_which_are_not_vulnerable_to_Meltdown.patch
queue-4.14/x86_Introduce_barrier_nospec.patch
queue-4.14/x86speculation_Use_Indirect_Branch_Prediction_Barrier_in_context_switch.patch
queue-4.14/x86get_user_Use_pointer_masking_to_limit_speculation.patch
queue-4.14/x86_Introduce___uaccess_begin_nospec()_and_uaccess_try_nospec.patch
queue-4.14/x86cpufeature_Blacklist_SPEC_CTRLPRED_CMD_on_early_Spectre_v2_microcodes.patch
queue-4.14/x86cpufeatures_Add_Intel_feature_bits_for_Speculation_Control.patch
queue-4.14/x86paravirt_Remove_noreplace-paravirt_cmdline_option.patch
queue-4.14/KVM_VMX_Make_indirect_call_speculation_safe.patch
queue-4.14/x86msr_Add_definitions_for_new_speculation_control_MSRs.patch
queue-4.14/x86alternative_Print_unadorned_pointers.patch
queue-4.14/KVMVMX_Allow_direct_access_to_MSR_IA32_SPEC_CTRL.patch
queue-4.14/x86cpufeatures_Add_CPUID_7_EDX_CPUID_leaf.patch
queue-4.14/array_index_nospec_Sanitize_speculative_array_de-references.patch
queue-4.14/Documentation_Document_array_index_nospec.patch
queue-4.14/x86entry64_Remove_the_SYSCALL64_fast_path.patch
queue-4.14/x86retpoline_Remove_the_esprsp_thunk.patch
queue-4.14/x86bugs_Drop_one_mitigation_from_dmesg.patch
queue-4.14/x86cpufeatures_Add_AMD_feature_bits_for_Speculation_Control.patch
queue-4.14/scripts-faddr2line-fix-cross_compile-unset-error.patch
queue-4.14/KVMSVM_Allow_direct_access_to_MSR_IA32_SPEC_CTRL.patch
queue-4.14/x86asm_Move_status_from_thread_struct_to_thread_info.patch
queue-4.14/KVMx86_Add_IBPB_support.patch
queue-4.14/x86_Implement_array_index_mask_nospec.patch
queue-4.14/KVMVMX_Emulate_MSR_IA32_ARCH_CAPABILITIES.patch
queue-4.14/nl80211_Sanitize_array_index_in_parse_txq_params.patch
queue-4.14/moduleretpoline_Warn_about_missing_retpoline_in_module.patch
queue-4.14/x86speculation_Add_basic_IBPB_(Indirect_Branch_Prediction_Barrier)_support.patch
queue-4.14/x86speculation_Simplify_indirect_branch_prediction_barrier().patch
queue-4.14/x86nospec_Fix_header_guards_names.patch
queue-4.14/KVM_x86_Make_indirect_calls_in_emulator_speculation_safe.patch
queue-4.14/x86uaccess_Use___uaccess_begin_nospec()_and_uaccess_try_nospec.patch
queue-4.14/x86entry64_Push_extra_regs_right_away.patch
queue-4.14/x86usercopy_Replace_open_coded_stacclac_with___uaccess_begin_end.patch
queue-4.14/vfs_fdtable_Prevent_bounds-check_bypass_via_speculative_execution.patch
queue-4.14/x86retpoline_Simplify_vmexit_fill_RSB().patch
queue-4.14/objtool_Warn_on_stripped_section_symbol.patch
queue-4.14/x86spectre_Report_get_user_mitigation_for_spectre_v1.patch
queue-4.14/x86cpufeatures_Clean_up_Spectre_v2_related_CPUID_flags.patch
queue-4.14/x86syscall_Sanitize_syscall_table_de-references_under_speculation.patch
queue-4.14/objtool_Improve_retpoline_alternative_handling.patch
