From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 12 Jul 2017 15:44:14 +0100
Message-Id: <20170712144424.19528-2-ard.biesheuvel@linaro.org>
In-Reply-To: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
References: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 01/10] arm64/lib: copy_page: use consistent prefetch stride
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: mark.rutland@arm.com, labbott@fedoraproject.org, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

The optional prefetch instructions in the copy_page() routine are
inconsistent: at the start of the function, two cachelines are
prefetched beyond the one being loaded in the first iteration, but
in the loop, the prefetch is one more line ahead. This appears to
be unintentional, so let's fix it.

While at it, fix the comment style and white space.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/lib/copy_page.S | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/lib/copy_page.S b/arch/arm64/lib/copy_page.S
index c3cd65e31814..076c43715e64 100644
--- a/arch/arm64/lib/copy_page.S
+++ b/arch/arm64/lib/copy_page.S
@@ -30,9 +30,10 @@
  */
 ENTRY(copy_page)
 alternative_if ARM64_HAS_NO_HW_PREFETCH
-	# Prefetch two cache lines ahead.
-	prfm    pldl1strm, [x1, #128]
-	prfm    pldl1strm, [x1, #256]
+	// Prefetch three cache lines ahead.
+	prfm	pldl1strm, [x1, #128]
+	prfm	pldl1strm, [x1, #256]
+	prfm	pldl1strm, [x1, #384]
 alternative_else_nop_endif
 
 	ldp	x2, x3, [x1]
@@ -50,7 +51,7 @@ alternative_else_nop_endif
 	subs	x18, x18, #128
 
 alternative_if ARM64_HAS_NO_HW_PREFETCH
-	prfm    pldl1strm, [x1, #384]
+	prfm	pldl1strm, [x1, #384]
 alternative_else_nop_endif
 
 	stnp	x2, x3, [x0]
-- 
2.9.3
