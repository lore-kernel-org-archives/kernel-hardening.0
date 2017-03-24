From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 24 Mar 2017 13:24:08 +0000
Message-Id: <20170324132410.16628-3-ard.biesheuvel@linaro.org>
In-Reply-To: <20170324132410.16628-1-ard.biesheuvel@linaro.org>
References: <20170324132410.16628-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 2/4] efi/libstub: unify command line param parsing
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, matt@codeblueprint.co.uk, leif.lindholm@linaro.org, rfranz@cavium.com, mingo@kernel.org, bp@alien8.de, mark.rutland@arm.com, kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Merge the parsing of the command line carried out in arm-stub.c with
the handling in efi_parse_options. Note that this also fixes the
missing handling of CONFIG_CMDLINE_FORCE=y, in which case the builtin
command line should supersede the one passed by the firmware.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/arm-stub.c        | 14 ------------
 drivers/firmware/efi/libstub/arm64-stub.c      |  4 +---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 23 +++++++++++++-------
 drivers/firmware/efi/libstub/efistub.h         |  2 ++
 include/linux/efi.h                            |  2 +-
 5 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 02049ff25c6b..fcd34057dc1c 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -18,8 +18,6 @@
 
 #include "efistub.h"
 
-bool __nokaslr;
-
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
 			     void *__image, void **__fh)
 {
@@ -153,18 +151,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail;
 	}
 
-	/* check whether 'nokaslr' was passed on the command line */
-	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
-		static const u8 default_cmdline[] = CONFIG_CMDLINE;
-		const u8 *str, *cmdline = cmdline_ptr;
-
-		if (IS_ENABLED(CONFIG_CMDLINE_FORCE))
-			cmdline = default_cmdline;
-		str = strstr(cmdline, "nokaslr");
-		if (str == cmdline || (str > cmdline && *(str - 1) == ' '))
-			__nokaslr = true;
-	}
-
 	si = setup_graphics(sys_table);
 
 	status = handle_kernel_image(sys_table, image_addr, &image_size,
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index eae693eb3e91..b4c2589d7c91 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -16,8 +16,6 @@
 
 #include "efistub.h"
 
-extern bool __nokaslr;
-
 efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
 {
 	u64 tg;
@@ -52,7 +50,7 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
 	u64 phys_seed = 0;
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
-		if (!__nokaslr) {
+		if (!nokaslr()) {
 			status = efi_get_random_bytes(sys_table_arg,
 						      sizeof(phys_seed),
 						      (u8 *)&phys_seed);
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 3290fae0b38f..1575b566cd4a 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -32,6 +32,13 @@
 
 static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
 
+static int __section(.data) __nokaslr;
+
+int __pure nokaslr(void)
+{
+	return __nokaslr;
+}
+
 #define EFI_MMAP_NR_SLACK_SLOTS	8
 
 struct file_info {
@@ -409,17 +416,17 @@ static efi_status_t efi_file_close(void *handle)
  * environments, first in the early boot environment of the EFI boot
  * stub, and subsequently during the kernel boot.
  */
-efi_status_t efi_parse_options(char *cmdline)
+efi_status_t efi_parse_options(char const *cmdline)
 {
+	static const char default_cmdline[] = CONFIG_CMDLINE;
 	char *str;
 
-	/*
-	 * Currently, the only efi= option we look for is 'nochunk', which
-	 * is intended to work around known issues on certain x86 UEFI
-	 * versions. So ignore for now on other architectures.
-	 */
-	if (!IS_ENABLED(CONFIG_X86))
-		return EFI_SUCCESS;
+	if (IS_ENABLED(CONFIG_CMDLINE_FORCE))
+		cmdline = default_cmdline;
+
+	str = strstr(cmdline, "nokaslr");
+	if (str == cmdline || (str && str > cmdline && *(str - 1) == ' '))
+		__nokaslr = 1;
 
 	/*
 	 * If no EFI parameters were specified on the cmdline we've got
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 71c4d0e3c4ed..a7a2a2c3f199 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -24,6 +24,8 @@
 #define EFI_ALLOC_ALIGN		EFI_PAGE_SIZE
 #endif
 
+extern int __pure nokaslr(void);
+
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 94d34e0be24f..e485e87615d1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1471,7 +1471,7 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 				  unsigned long *load_addr,
 				  unsigned long *load_size);
 
-efi_status_t efi_parse_options(char *cmdline);
+efi_status_t efi_parse_options(char const *cmdline);
 
 efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
 			   struct screen_info *si, efi_guid_t *proto,
-- 
2.9.3
