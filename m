From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 12 Jul 2017 23:33:01 +0100
Message-Id: <1499898783-25732-5-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1499898783-25732-1-git-send-email-mark.rutland@arm.com>
References: <1499898783-25732-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 4/6] arm64: pass stack base to secondary_start_kernel
To: ard.biesheuvel@linaro.org, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: akashi.takahiro@linaro.org, catalin.marinas@arm.com, dave.martin@arm.com, james.morse@arm.com, labbott@fedoraproject.org, will.deacon@arm.com, keescook@chromium.org, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

In subsequent patches, we'll want the base of the secondary stack in
secondary_start_kernel.

Pass the stack base down, as we do in the primary path, and add the
offset in secondary_start_kernel. Unfortunately, we can't encode
STACK_START_SP in an add immediate, so use a mov immedaite, which has
greater range.

This is far from a hot path, so the overhead shouldn't matter.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/kernel/head.S | 3 ++-
 arch/arm64/kernel/smp.c  | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index a58ecda..db77cac 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -613,7 +613,8 @@ __secondary_switched:
 
 	adr_l	x0, secondary_data
 	ldr	x1, [x0, #CPU_BOOT_STACK]	// get secondary_data.stack
-	mov	sp, x1
+	mov	x3, #THREAD_START_SP
+	add	sp, x1, x3
 	ldr	x2, [x0, #CPU_BOOT_TASK]
 	msr	tpidr_el1, x2
 	mov	x29, #0
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 6e0e16a..269c957 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -154,7 +154,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 	 * page tables.
 	 */
 	secondary_data.task = idle;
-	secondary_data.stack = task_stack_page(idle) + THREAD_START_SP;
+	secondary_data.stack = task_stack_page(idle);
 	update_cpu_boot_status(CPU_MMU_OFF);
 	__flush_dcache_area(&secondary_data, sizeof(secondary_data));
 
-- 
1.9.1
