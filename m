Subject: Patch "x86/entry/64: Push extra regs right away" has been added to the 4.9-stable tree
From: <gregkh@linuxfoundation.org>
Date: Thu, 08 Feb 2018 03:38:19 +0100
Message-ID: <15180574993042@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
To: luto@kernel.org, bp@alien8.de, dwmw@amazon.co.uk, gregkh@linuxfoundation.org, kernel-hardening@lists.openwall.com, mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org
Cc: stable@vger.kernel.org, stable-commits@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


This is a note to let you know that I've just added the patch titled

    x86/entry/64: Push extra regs right away

to the 4.9-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     x86-entry-64-push-extra-regs-right-away.patch
and it can be found in the queue-4.9 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From foo@baz Thu Feb  8 03:30:27 CET 2018
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 28 Jan 2018 10:38:49 -0800
Subject: x86/entry/64: Push extra regs right away

From: Andy Lutomirski <luto@kernel.org>

(cherry picked from commit d1f7732009e0549eedf8ea1db948dc37be77fd46)

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
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -177,10 +177,14 @@ GLOBAL(entry_SYSCALL_64_after_swapgs)
 	pushq	%r9				/* pt_regs->r9 */
 	pushq	%r10				/* pt_regs->r10 */
 	pushq	%r11				/* pt_regs->r11 */
-	sub	$(6*8), %rsp			/* pt_regs->bp, bx, r12-15 not saved */
+	pushq	%rbx				/* pt_regs->rbx */
+	pushq	%rbp				/* pt_regs->rbp */
+	pushq	%r12				/* pt_regs->r12 */
+	pushq	%r13				/* pt_regs->r13 */
+	pushq	%r14				/* pt_regs->r14 */
+	pushq	%r15				/* pt_regs->r15 */
 
 	/* IRQs are off. */
-	SAVE_EXTRA_REGS
 	movq	%rsp, %rdi
 	call	do_syscall_64		/* returns with IRQs disabled */
 


Patches currently in stable-queue which might be from luto@kernel.org are

queue-4.9/x86-entry-64-push-extra-regs-right-away.patch
queue-4.9/kvm-vmx-allow-direct-access-to-msr_ia32_spec_ctrl.patch
queue-4.9/kvm-x86-add-ibpb-support.patch
queue-4.9/kvm-svm-allow-direct-access-to-msr_ia32_spec_ctrl.patch
queue-4.9/x86-paravirt-remove-noreplace-paravirt-cmdline-option.patch
queue-4.9/x86-asm-move-status-from-thread_struct-to-thread_info.patch
queue-4.9/kvm-x86-make-indirect-calls-in-emulator-speculation-safe.patch
queue-4.9/x86-entry-64-remove-the-syscall64-fast-path.patch
queue-4.9/x86-asm-fix-inline-asm-call-constraints-for-gcc-4.4.patch
queue-4.9/kvm-vmx-make-indirect-call-speculation-safe.patch
queue-4.9/x86-spectre-fix-spelling-mistake-vunerable-vulnerable.patch
queue-4.9/x86-get_user-use-pointer-masking-to-limit-speculation.patch
queue-4.9/x86-syscall-sanitize-syscall-table-de-references-under-speculation.patch
queue-4.9/x86-pti-make-unpoison-of-pgd-for-trusted-boot-work-for-real.patch
queue-4.9/x86-pti-mark-constant-arrays-as-__initconst.patch
queue-4.9/kvm-vmx-emulate-msr_ia32_arch_capabilities.patch
