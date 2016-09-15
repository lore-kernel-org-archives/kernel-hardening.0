Reply-To: kernel-hardening@lists.openwall.com
From: Mark Rutland <mark.rutland@arm.com>
Date: Thu, 15 Sep 2016 14:49:06 +0100
Message-Id: <1473947349-14521-6-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
References: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 5/8] arm64: assembler: introduce ldr_this_cpu
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, keescook@chromium.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, luto@kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, takahiro.akashi@linaro.org, will.deacon@arm.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Shortly we will want to load a percpu variable in the return from
userspace path. We can save an instruction by folding the addition of
the percpu offset into the load instruction, and this patch adds a new
helper to do so.

At the same time, we clean up this_cpu_ptr for consistency. As with
{adr,ldr,str}_l, we change the template to take the destination register
first, and name this dst. Secondly, we rename the macro to adr_this_cpu,
following the scheme of adr_l, and matching the newly added
ldr_this_cpu.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/assembler.h | 19 +++++++++++++++----
 arch/arm64/kernel/entry.S          |  2 +-
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index d5025c6..265fd81 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -193,14 +193,25 @@ lr	.req	x30		// link register
 	.endm
 
 	/*
+	 * @dst: Result of per_cpu(sym, smp_processor_id())
 	 * @sym: The name of the per-cpu variable
-	 * @reg: Result of per_cpu(sym, smp_processor_id())
 	 * @tmp: scratch register
 	 */
-	.macro this_cpu_ptr, sym, reg, tmp
-	adr_l	\reg, \sym
+	.macro adr_this_cpu, dst, sym, tmp
+	adr_l	\dst, \sym
 	mrs	\tmp, tpidr_el1
-	add	\reg, \reg, \tmp
+	add	\dst, \dst, \tmp
+	.endm
+
+	/*
+	 * @dst: Result of READ_ONCE(per_cpu(sym, smp_processor_id()))
+	 * @sym: The name of the per-cpu variable
+	 * @tmp: scratch register
+	 */
+	.macro ldr_this_cpu dst, sym, tmp
+	adr_l	\dst, \sym
+	mrs	\tmp, tpidr_el1
+	ldr	\dst, [\dst, \tmp]
 	.endm
 
 /*
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 441420c..52b4241 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -206,7 +206,7 @@ alternative_endif
 	cmp	x25, tsk
 	b.ne	9998f
 
-	this_cpu_ptr irq_stack, x25, x26
+	adr_this_cpu x25, irq_stack, x26
 	mov	x26, #IRQ_STACK_START_SP
 	add	x26, x25, x26
 
-- 
1.9.1
