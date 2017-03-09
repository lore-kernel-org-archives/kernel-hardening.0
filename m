From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu,  9 Mar 2017 21:52:06 +0100
Message-Id: <1489092729-16871-9-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1489092729-16871-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1489092729-16871-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v6 08/11] arm64/mmu: add contiguous bit to sanity bug check
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org
Cc: kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

A mapping with the contiguous bit cannot be safely manipulated while
live, regardless of whether the bit changes between the old and new
mapping. So take this into account when deciding whether the change
is safe.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/mmu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index ec23aec6433f..382ebd6ef46f 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -103,7 +103,15 @@ static bool pgattr_change_is_safe(u64 old, u64 new)
 	 */
 	static const pteval_t mask = PTE_PXN | PTE_RDONLY | PTE_WRITE;
 
-	return old  == 0 || new  == 0 || ((old ^ new) & ~mask) == 0;
+	/* creating or taking down mappings is always safe */
+	if (old == 0 || new == 0)
+		return true;
+
+	/* live contiguous mappings may not be manipulated at all */
+	if ((old | new) & PTE_CONT)
+		return false;
+
+	return ((old ^ new) & ~mask) == 0;
 }
 
 static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
-- 
2.7.4
