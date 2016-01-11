Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 11 Jan 2016 14:19:15 +0100
Message-Id: <1452518355-4606-23-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v3 21/21] arm64: efi: invoke EFI_RNG_PROTOCOL to supply KASLR randomness
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Since arm64 does not use a decompressor that supplies an execution
environment where it is feasible to some extent to provide a source of
randomness, the arm64 KASLR kernel depends on the bootloader to supply
some random bits in register x1 upon kernel entry.

On UEFI systems, we can use the EFI_RNG_PROTOCOL, if supplied, to obtain
some random bits. At the same time, use it to randomize the offset of the
kernel Image in physical memory.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig                             |  5 ++
 arch/arm64/kernel/efi-entry.S                  |  7 +-
 drivers/firmware/efi/libstub/arm-stub.c        | 17 ++---
 drivers/firmware/efi/libstub/arm64-stub.c      | 67 +++++++++++++++-----
 drivers/firmware/efi/libstub/efi-stub-helper.c | 10 +++
 drivers/firmware/efi/libstub/efistub.h         |  2 +
 6 files changed, 82 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7fa5b74ee80d..ba347302308b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -734,6 +734,11 @@ config RANDOMIZE_BASE
 	  It is the bootloader's job to provide entropy, by passing a
 	  random value in x1 at kernel entry.
 
+	  When booting via the UEFI stub, it will invoke the firmware's
+	  EFI_RNG_PROTOCOL implementation (if available) to supply entropy
+	  to the kernel proper. In addition, it will randomise the physical
+	  location of the kernel Image as well.
+
 	  If unsure, say N.
 
 
diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
index f82036e02485..f41073dde7e0 100644
--- a/arch/arm64/kernel/efi-entry.S
+++ b/arch/arm64/kernel/efi-entry.S
@@ -110,7 +110,7 @@ ENTRY(entry)
 2:
 	/* Jump to kernel entry point */
 	mov	x0, x20
-	mov	x1, xzr
+	ldr	x1, efi_rnd
 	mov	x2, xzr
 	mov	x3, xzr
 	br	x21
@@ -119,6 +119,9 @@ efi_load_fail:
 	mov	x0, #EFI_LOAD_ERROR
 	ldp	x29, x30, [sp], #32
 	ret
+ENDPROC(entry)
+
+ENTRY(efi_rnd)
+	.quad	0, 0
 
 entry_end:
-ENDPROC(entry)
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 950c87f5d279..c39e04a1e8aa 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -207,14 +207,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		pr_efi_err(sys_table, "Failed to find DRAM base\n");
 		goto fail;
 	}
-	status = handle_kernel_image(sys_table, image_addr, &image_size,
-				     &reserve_addr,
-				     &reserve_size,
-				     dram_base, image);
-	if (status != EFI_SUCCESS) {
-		pr_efi_err(sys_table, "Failed to relocate kernel\n");
-		goto fail;
-	}
 
 	/*
 	 * Get the command line from EFI, using the LOADED_IMAGE
@@ -231,6 +223,15 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	if (status != EFI_SUCCESS)
 		pr_efi_err(sys_table, "Failed to parse EFI cmdline options\n");
 
+	status = handle_kernel_image(sys_table, image_addr, &image_size,
+				     &reserve_addr,
+				     &reserve_size,
+				     dram_base, image);
+	if (status != EFI_SUCCESS) {
+		pr_efi_err(sys_table, "Failed to relocate kernel\n");
+		goto fail;
+	}
+
 	/*
 	 * Unauthenticated device tree data is a security hazard, so
 	 * ignore 'dtb=' unless UEFI Secure Boot is disabled.
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 78dfbd34b6bf..96d43bed098f 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -13,6 +13,13 @@
 #include <asm/efi.h>
 #include <asm/sections.h>
 
+#include "efistub.h"
+
+extern struct {
+	u64	virt_seed;
+	u64	phys_seed;
+} efi_rnd;
+
 efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
 					unsigned long *image_addr,
 					unsigned long *image_size,
@@ -27,6 +34,22 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
 	void *old_image_addr = (void *)*image_addr;
 	unsigned long preferred_offset;
 
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
+		if (!__nokaslr) {
+			status = efi_get_random_bytes(sys_table_arg,
+						      sizeof(efi_rnd),
+						      (u8 *)&efi_rnd);
+			if (status == EFI_NOT_FOUND) {
+				pr_efi(sys_table_arg, "EFI_RNG_PROTOCOL unavailable, no randomness supplied\n");
+			} else if (status != EFI_SUCCESS) {
+				pr_efi_err(sys_table_arg, "efi_get_random_bytes() failed\n");
+				return status;
+			}
+		} else {
+			pr_efi(sys_table_arg, "KASLR disabled on kernel command line\n");
+		}
+	}
+
 	/*
 	 * The preferred offset of the kernel Image is TEXT_OFFSET bytes beyond
 	 * a 2 MB aligned base, which itself may be lower than dram_base, as
@@ -36,13 +59,22 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
 	if (preferred_offset < dram_base)
 		preferred_offset += SZ_2M;
 
-	/* Relocate the image, if required. */
 	kernel_size = _edata - _text;
-	if (*image_addr != preferred_offset) {
-		kernel_memsize = kernel_size + (_end - _edata);
+	kernel_memsize = kernel_size + (_end - _edata);
+
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && efi_rnd.phys_seed != 0) {
+		/*
+		 * If KASLR is enabled, and we have some randomness available,
+		 * locate the kernel at a randomized offset in physical memory.
+		 */
+		status = efi_random_alloc(sys_table_arg, kernel_size,
+					  ilog2(MIN_KIMG_ALIGN), reserve_addr,
+					  efi_rnd.phys_seed);
 
+		*image_addr = *reserve_addr + TEXT_OFFSET;
+	} else {
 		/*
-		 * First, try a straight allocation at the preferred offset.
+		 * Else, try a straight allocation at the preferred offset.
 		 * This will work around the issue where, if dram_base == 0x0,
 		 * efi_low_alloc() refuses to allocate at 0x0 (to prevent the
 		 * address of the allocation to be mistaken for a FAIL return
@@ -52,27 +84,30 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
 		 * Mustang), we can still place the kernel at the address
 		 * 'dram_base + TEXT_OFFSET'.
 		 */
+		if (*image_addr == preferred_offset)
+			return EFI_SUCCESS;
+
 		*image_addr = *reserve_addr = preferred_offset;
 		nr_pages = round_up(kernel_memsize, EFI_ALLOC_ALIGN) /
 			   EFI_PAGE_SIZE;
 		status = efi_call_early(allocate_pages, EFI_ALLOCATE_ADDRESS,
 					EFI_LOADER_DATA, nr_pages,
 					(efi_physical_addr_t *)reserve_addr);
-		if (status != EFI_SUCCESS) {
-			kernel_memsize += TEXT_OFFSET;
-			status = efi_low_alloc(sys_table_arg, kernel_memsize,
-					       SZ_2M, reserve_addr);
+	}
 
-			if (status != EFI_SUCCESS) {
-				pr_efi_err(sys_table_arg, "Failed to relocate kernel\n");
-				return status;
-			}
-			*image_addr = *reserve_addr + TEXT_OFFSET;
+	if (status != EFI_SUCCESS) {
+		kernel_memsize += TEXT_OFFSET;
+		status = efi_low_alloc(sys_table_arg, kernel_memsize,
+				       SZ_2M, reserve_addr);
+
+		if (status != EFI_SUCCESS) {
+			pr_efi_err(sys_table_arg, "Failed to relocate kernel\n");
+			return status;
 		}
-		memcpy((void *)*image_addr, old_image_addr, kernel_size);
-		*reserve_size = kernel_memsize;
+		*image_addr = *reserve_addr + TEXT_OFFSET;
 	}
-
+	memcpy((void *)*image_addr, old_image_addr, kernel_size);
+	*reserve_size = kernel_memsize;
 
 	return EFI_SUCCESS;
 }
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 2a7a3015d7e0..e8a3b8cd53cc 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -32,6 +32,10 @@
 
 static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
 
+#ifdef CONFIG_RANDOMIZE_BASE
+bool __nokaslr;
+#endif
+
 /*
  * Allow the platform to override the allocation granularity: this allows
  * systems that have the capability to run with a larger page size to deal
@@ -317,6 +321,12 @@ efi_status_t efi_parse_options(char *cmdline)
 {
 	char *str;
 
+#ifdef CONFIG_RANDOMIZE_BASE
+	str = strstr(cmdline, "nokaslr");
+	if (str && (str == cmdline || *(str - 1) == ' '))
+		__nokaslr = true;
+#endif
+
 	/*
 	 * If no EFI parameters were specified on the cmdline we've got
 	 * nothing to do.
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 7a38e29da53d..250ed4737298 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -5,6 +5,8 @@
 /* error code which can't be mistaken for valid address */
 #define EFI_ERROR	(~0UL)
 
+extern bool __nokaslr;
+
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
-- 
2.5.0
