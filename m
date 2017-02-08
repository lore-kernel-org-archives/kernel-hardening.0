From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed,  8 Feb 2017 11:55:35 +0000
Message-Id: <1486554947-3964-3-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 02/14] include: pe.h: add some missing definitions
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, leif.lindholm@linaro.org
Cc: catalin.marinas@arm.com, linux@armlinux.org.uk, kernel-hardening@lists.openwall.com, labbott@fedoraproject.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Mark Rutland <mark.rutland@arm.com>

Add the missing IMAGE_FILE_MACHINE_ARM64 and IMAGE_DEBUG_TYPE_CODEVIEW
definitions.

We'll need them for the arm64 EFI stub...

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
[ardb: add IMAGE_DEBUG_TYPE_CODEVIEW as well]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/linux/pe.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/pe.h b/include/linux/pe.h
index a8a594117df3..143ce75be5f0 100644
--- a/include/linux/pe.h
+++ b/include/linux/pe.h
@@ -34,6 +34,7 @@
 #define	IMAGE_FILE_MACHINE_AMD64	0x8664
 #define	IMAGE_FILE_MACHINE_ARM		0x01c0
 #define	IMAGE_FILE_MACHINE_ARMV7	0x01c4
+#define	IMAGE_FILE_MACHINE_ARM64	0xaa64
 #define	IMAGE_FILE_MACHINE_EBC		0x0ebc
 #define	IMAGE_FILE_MACHINE_I386		0x014c
 #define	IMAGE_FILE_MACHINE_IA64		0x0200
@@ -141,6 +142,8 @@
 #define IMAGE_SCN_MEM_READ	0x40000000 /* readable */
 #define IMAGE_SCN_MEM_WRITE	0x80000000 /* writeable */
 
+#define IMAGE_DEBUG_TYPE_CODEVIEW	2
+
 #ifndef __ASSEMBLY__
 
 struct mz_hdr {
-- 
2.7.4
