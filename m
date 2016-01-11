Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 11 Jan 2016 14:19:07 +0100
Message-Id: <1452518355-4606-15-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v3 14/21] arm64: redefine SWAPPER_TABLE_SHIFT for use in asm code
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

The current definition of SWAPPER_TABLE_SHIFT can only be used in
asm code if the configured number of translation levels defines
PUD_SHIFT and/or PMD_SHIFT natively (4KB and 16KB/64KB granule,
respectively). Otherwise, it depends on the nopmd/nopud fixup
headers, which can only be included in C code.

So redefine SWAPPER_TABLE_SHIFT in a way that is independent of the
number of configured translation levels.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/kernel-pgtable.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/asm/kernel-pgtable.h
index dfe4bae463b7..b1c96a29fad7 100644
--- a/arch/arm64/include/asm/kernel-pgtable.h
+++ b/arch/arm64/include/asm/kernel-pgtable.h
@@ -57,13 +57,13 @@
 #if ARM64_SWAPPER_USES_SECTION_MAPS
 #define SWAPPER_BLOCK_SHIFT	SECTION_SHIFT
 #define SWAPPER_BLOCK_SIZE	SECTION_SIZE
-#define SWAPPER_TABLE_SHIFT	PUD_SHIFT
 #else
 #define SWAPPER_BLOCK_SHIFT	PAGE_SHIFT
 #define SWAPPER_BLOCK_SIZE	PAGE_SIZE
-#define SWAPPER_TABLE_SHIFT	PMD_SHIFT
 #endif
 
+#define SWAPPER_TABLE_SHIFT	(SWAPPER_BLOCK_SHIFT + PAGE_SHIFT - 3)
+
 /* The size of the initial kernel direct mapping */
 #define SWAPPER_INIT_MAP_SIZE	(_AC(1, UL) << SWAPPER_TABLE_SHIFT)
 
-- 
2.5.0
