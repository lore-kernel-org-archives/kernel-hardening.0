From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon,  6 Feb 2017 16:24:32 +0000
Message-Id: <1486398275-3966-5-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1486398275-3966-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1486398275-3966-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 4/7] arm64: efi: ensure that the PE/COFF header pointer appears at offset 0x3c
To: linux-arm-kernel@lists.infradead.org, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com
Cc: labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, leif.lindholm@linaro.org, pjones@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Use a .org directive to ensure that the PE/COFF header pointer appears
at offset 0x3c. Since the EFI header is now emitted using a macro, this
helps ensure that the invocation of the macro remains at the correct
offset.

At the same time, collapse two adjacent #ifdef CONFIG_EFI blocks into one,
and replace .word with .long (which are equivalent, but the former is
never used elsewhere)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/efi-header.S | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
index 8c8cd0a8192b..74a25c09a1b8 100644
--- a/arch/arm64/kernel/efi-header.S
+++ b/arch/arm64/kernel/efi-header.S
@@ -22,14 +22,16 @@
 	.endm
 
 	.macro	__EFI_HEADER
-#ifdef CONFIG_EFI
-	.long	pe_header - _head		// Offset to the PE header.
+#ifndef CONFIG_EFI
+	.long	0				// reserved
 #else
-	.word	0				// reserved
-#endif
+	/*
+	 * PE/COFF requires the offset to the PE header
+	 * to be stored at offset 0x3c into the file.
+	 */
+	.org	_head + 0x3c
+	.long	pe_header - _head		// Offset to the PE header.
 
-#ifdef CONFIG_EFI
-	.align 3
 pe_header:
 	.ascii	"PE"
 	.short 	0
-- 
2.7.4
