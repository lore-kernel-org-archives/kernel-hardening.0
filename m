From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 19 Jul 2017 10:58:59 -0700
Message-Id: <20170719175900.124074-2-thgarnie@google.com>
In-Reply-To: <20170719175900.124074-1-thgarnie@google.com>
References: <20170719175900.124074-1-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH 2/3] arm/syscalls: Optimize work flags assembly check
To: Russell King <linux@armlinux.org.uk>, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dave Martin <Dave.Martin@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, Pratyush Anand <panand@redhat.com>, leonard.crestez@nxp.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Remove the double branch and use tsteq instead.

Suggested-by: Russell King <linux@armlinux.org.uk>
Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/arm/kernel/entry-common.S | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index e33c32d56193..6e094b639d83 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -42,8 +42,7 @@ ret_fast_syscall:
 	disable_irq_notrace			@ disable interrupts
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
 	tst	r1, #_TIF_SYSCALL_WORK
-	bne	fast_work_pending
-	tst	r1, #_TIF_WORK_MASK
+	tsteq   r1, #_TIF_WORK_MASK
 	bne	fast_work_pending
 
 	/* perform architecture specific actions before user return */
@@ -70,14 +69,12 @@ ret_fast_syscall:
 	disable_irq_notrace			@ disable interrupts
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
 	tst	r1, #_TIF_SYSCALL_WORK
-	bne	fast_work_pending
-	tst	r1, #_TIF_WORK_MASK
+	tsteq   r1, #_TIF_WORK_MASK
 	beq	no_work_pending
  UNWIND(.fnend		)
 ENDPROC(ret_fast_syscall)
 
 	/* Slower path - fall through to work_pending */
-fast_work_pending:
 #endif
 
 	tst	r1, #_TIF_SYSCALL_WORK
-- 
2.14.0.rc0.284.gd933b75aa4-goog
