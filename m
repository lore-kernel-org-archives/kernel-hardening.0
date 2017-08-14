From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:54:00 +0100
Message-Id: <20170814125411.22604-20-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 19/30] ARM: kernel: use PC-relative symbol references in MMU switch code
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

To prepare for adding support for KASLR, which relocates all absolute
symbol references at runtime after the caches have been enabled,
update the MMU switch code to avoid using absolute symbol references
where possible. This ensures these quantities are invariant under
runtime relocation.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kernel/head-common.S | 39 ++++++++------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
index 06035488130c..b74477507a12 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -79,9 +79,10 @@ ENDPROC(__vet_atags)
  */
 	__INIT
 __mmap_switched:
-	adr	r3, __mmap_switched_data
-
-	ldmia	r3!, {r4, r5, r6, r7}
+	adr_l	r4, __data_loc
+	adr_l	r5, _sdata
+	adr_l	r6, __bss_start
+	adr_l	r7, _end
 	cmp	r4, r5				@ Copy data segment if needed
 1:	cmpne	r5, r6
 	ldrne	fp, [r4], #4
@@ -93,9 +94,17 @@ __mmap_switched:
 	strcc	fp, [r6],#4
 	bcc	1b
 
- ARM(	ldmia	r3, {r4, r5, r6, r7, sp})
- THUMB(	ldmia	r3, {r4, r5, r6, r7}	)
- THUMB(	ldr	sp, [r3, #16]		)
+	adr_l	r3, init_thread_union + THREAD_START_SP
+	mov	sp, r3
+	adr_l	r4, processor_id
+	adr_l	r5, __machine_arch_type
+	adr_l	r6, __atags_pointer
+#ifdef CONFIG_CPU_CP15
+	adr_l	r7, cr_alignment
+#else
+	mov	r7, #0
+#endif
+
 	str	r9, [r4]			@ Save processor ID
 	str	r1, [r5]			@ Save machine type
 	str	r2, [r6]			@ Save atags pointer
@@ -104,24 +113,6 @@ __mmap_switched:
 	b	start_kernel
 ENDPROC(__mmap_switched)
 
-	.align	2
-	.type	__mmap_switched_data, %object
-__mmap_switched_data:
-	.long	__data_loc			@ r4
-	.long	_sdata				@ r5
-	.long	__bss_start			@ r6
-	.long	_end				@ r7
-	.long	processor_id			@ r4
-	.long	__machine_arch_type		@ r5
-	.long	__atags_pointer			@ r6
-#ifdef CONFIG_CPU_CP15
-	.long	cr_alignment			@ r7
-#else
-	.long	0				@ r7
-#endif
-	.long	init_thread_union + THREAD_START_SP @ sp
-	.size	__mmap_switched_data, . - __mmap_switched_data
-
 /*
  * This provides a C-API version of __lookup_processor_type
  */
-- 
2.11.0
