Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 26 Jan 2016 18:10:48 +0100
Message-Id: <1453828249-14467-22-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v4 21/22] efi: stub: use high allocation for converted command line
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, labbott@fedoraproject.org, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Before we can move the command line processing before the allocation
of the kernel, which is required for detecting the 'nokaslr' option
which controls that allocation, move the converted command line higher
up in memory, to prevent it from interfering with the kernel itself.

Since x86 needs the address to fit in 32 bits, use UINT_MAX as the upper
bound there. Otherwise, use ULONG_MAX (i.e., no limit)

Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/include/asm/efi.h                     | 2 ++
 drivers/firmware/efi/libstub/efi-stub-helper.c | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 0010c78c4998..08b1f2f6ea50 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -25,6 +25,8 @@
 #define EFI32_LOADER_SIGNATURE	"EL32"
 #define EFI64_LOADER_SIGNATURE	"EL64"
 
+#define MAX_CMDLINE_ADDRESS	UINT_MAX
+
 #ifdef CONFIG_X86_32
 
 
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index f07d4a67fa76..29ed2f9b218c 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -649,6 +649,10 @@ static u8 *efi_utf16_to_utf8(u8 *dst, const u16 *src, int n)
 	return dst;
 }
 
+#ifndef MAX_CMDLINE_ADDRESS
+#define MAX_CMDLINE_ADDRESS	ULONG_MAX
+#endif
+
 /*
  * Convert the unicode UEFI command line to ASCII to pass to kernel.
  * Size of memory allocated return in *cmd_line_len.
@@ -684,7 +688,8 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
 
 	options_bytes++;	/* NUL termination */
 
-	status = efi_low_alloc(sys_table_arg, options_bytes, 0, &cmdline_addr);
+	status = efi_high_alloc(sys_table_arg, options_bytes, 0,
+				&cmdline_addr, MAX_CMDLINE_ADDRESS);
 	if (status != EFI_SUCCESS)
 		return NULL;
 
-- 
2.5.0
