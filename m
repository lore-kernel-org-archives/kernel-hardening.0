From: Mark Rutland <mark.rutland@arm.com>
Date: Tue, 15 Aug 2017 13:50:45 +0100
Message-Id: <1502801449-29246-11-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
References: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCHv2 10/14] arm64: assembler: allow adr_this_cpu to use the stack pointer
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, mark.rutland@arm.com, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Given that adr_this_cpu already requires a temp register in addition
to the destination register, tweak the instruction sequence so that sp
may be used as well.

This will simplify switching to per-cpu stacks in subsequent patches. While
this limits the range of adr_this_cpu, to +/-4GiB, we don't currently use
adr_this_cpu in modules, and this is not problematic for the main kernel image.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
[Mark: add more commit text]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/assembler.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 610a420..2f2bd51 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -230,12 +230,18 @@
 	.endm
 
 	/*
-	 * @dst: Result of per_cpu(sym, smp_processor_id())
+	 * @dst: Result of per_cpu(sym, smp_processor_id()), can be SP for
+	 *       non-module code
 	 * @sym: The name of the per-cpu variable
 	 * @tmp: scratch register
 	 */
 	.macro adr_this_cpu, dst, sym, tmp
+#ifndef MODULE
+	adrp	\tmp, \sym
+	add	\dst, \tmp, #:lo12:\sym
+#else
 	adr_l	\dst, \sym
+#endif
 	mrs	\tmp, tpidr_el1
 	add	\dst, \dst, \tmp
 	.endm
-- 
1.9.1
