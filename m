From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 54/92] x86/entry/64: Push extra regs right away
Date: Fri,  9 Feb 2018 14:39:23 +0100
Message-Id: <20180209133935.120035299@linuxfoundation.org>
In-Reply-To: <20180209133931.211869118@linuxfoundation.org>
References: <20180209133931.211869118@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>, Linus Torvalds <torvalds@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, David Woodhouse <dwmw@amazon.co.uk>
List-ID: <kernel-hardening.lists.openwall.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 
