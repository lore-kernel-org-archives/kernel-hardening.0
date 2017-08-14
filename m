From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:53:51 +0100
Message-Id: <20170814125411.22604-11-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 10/30] ARM: head.S: use PC relative insn sequence to calculate PHYS_OFFSET
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Replace the open coded arithmetic with a simple adr_l/sub pair. This
ensures these quantities are invariant under runtime relocation.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kernel/head.S | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index f607e290ef4b..62c961849035 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -106,10 +106,8 @@ ENTRY(stext)
 #endif
 
 #ifndef CONFIG_XIP_KERNEL
-	adr	r3, 2f
-	ldmia	r3, {r4, r8}
-	sub	r4, r3, r4			@ (PHYS_OFFSET - PAGE_OFFSET)
-	add	r8, r8, r4			@ PHYS_OFFSET
+	adr_l	r8, _text			@ __pa(_text)
+	sub	r8, r8, #TEXT_OFFSET		@ PHYS_OFFSET
 #else
 	ldr	r8, =PLAT_PHYS_OFFSET		@ always constant in this case
 #endif
@@ -161,10 +159,6 @@ ENTRY(stext)
 1:	b	__enable_mmu
 ENDPROC(stext)
 	.ltorg
-#ifndef CONFIG_XIP_KERNEL
-2:	.long	.
-	.long	PAGE_OFFSET
-#endif
 
 /*
  * Setup the initial page tables.  We only setup the barest
-- 
2.11.0
