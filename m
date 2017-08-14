From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:54:10 +0100
Message-Id: <20170814125411.22604-30-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 29/30] efi/libstub: arm: reserve bootloader supplied initrd in memory map
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Under KASLR, the EFI stub may allocate the kernel anywhere in the
physical address space, which could be right on top of an initrd
if it was supplied by the bootloader (i.e., GRUB) in /chosen rather
than passed via the initrd= command line option. So allocate the
pages explicitly, this ensures that the random memory allocation
routine will disregard the region.

Note that this means that we need to defer the handle_kernel_image()
call.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/arm-stub.c | 51 ++++++++++++--------
 drivers/firmware/efi/libstub/efistub.h  |  3 ++
 drivers/firmware/efi/libstub/fdt.c      | 42 ++++++++++++++++
 3 files changed, 75 insertions(+), 21 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 8181ac179d14..f5ef5ccd5f45 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -133,6 +133,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	unsigned long reserve_size = 0;
 	enum efi_secureboot_mode secure_boot;
 	struct screen_info *si;
+	bool have_chosen_initrd;
 
 	/* Check if we were booted by the EFI firmware */
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
@@ -183,15 +184,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 
 	si = setup_graphics(sys_table);
 
-	status = handle_kernel_image(sys_table, image_addr, &image_size,
-				     &reserve_addr,
-				     &reserve_size,
-				     dram_base, image);
-	if (status != EFI_SUCCESS) {
-		pr_efi_err(sys_table, "Failed to relocate kernel\n");
-		goto fail_free_cmdline;
-	}
-
 	secure_boot = efi_get_secureboot(sys_table);
 
 	/*
@@ -209,7 +201,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 
 		if (status != EFI_SUCCESS) {
 			pr_efi_err(sys_table, "Failed to load device tree!\n");
-			goto fail_free_image;
+			goto fail_free_cmdline;
 		}
 	}
 
@@ -222,16 +214,33 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 			pr_efi(sys_table, "Using DTB from configuration table\n");
 	}
 
-	if (!fdt_addr)
+	if (!fdt_addr) {
 		pr_efi(sys_table, "Generating empty DTB\n");
+		have_chosen_initrd = false;
+	} else {
+		status = efi_reserve_dtb_initrd(sys_table, (void *)fdt_addr);
+		have_chosen_initrd = (status != EFI_NOT_FOUND);
+	}
 
-	status = handle_cmdline_files(sys_table, image, cmdline_ptr, "initrd=",
-				      efi_get_max_initrd_addr(dram_base,
-							      *image_addr),
-				      (unsigned long *)&initrd_addr,
-				      (unsigned long *)&initrd_size);
-	if (status != EFI_SUCCESS)
-		pr_efi_err(sys_table, "Failed initrd from command line!\n");
+	status = handle_kernel_image(sys_table, image_addr, &image_size,
+				     &reserve_addr, &reserve_size,
+				     dram_base, image);
+	if (status != EFI_SUCCESS) {
+		pr_efi_err(sys_table, "Failed to relocate kernel\n");
+		goto fail_free_fdt;
+	}
+
+	if (!have_chosen_initrd) {
+		status = handle_cmdline_files(sys_table, image, cmdline_ptr,
+					      "initrd=",
+					      efi_get_max_initrd_addr(dram_base,
+								      *image_addr),
+					      (unsigned long *)&initrd_addr,
+					      (unsigned long *)&initrd_size);
+		if (status != EFI_SUCCESS)
+			pr_efi_err(sys_table,
+				   "Failed initrd from command line!\n");
+	}
 
 	efi_random_get_seed(sys_table);
 
@@ -272,11 +281,11 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	pr_efi_err(sys_table, "Failed to update FDT and exit boot services\n");
 
 	efi_free(sys_table, initrd_size, initrd_addr);
-	efi_free(sys_table, fdt_size, fdt_addr);
-
-fail_free_image:
 	efi_free(sys_table, image_size, *image_addr);
 	efi_free(sys_table, reserve_size, reserve_addr);
+
+fail_free_fdt:
+	efi_free(sys_table, fdt_size, fdt_addr);
 fail_free_cmdline:
 	free_screen_info(sys_table, si);
 	efi_free(sys_table, cmdline_size, (unsigned long)cmdline_ptr);
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index aaf2aeb785ea..35b514d7d962 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -68,4 +68,7 @@ efi_status_t check_platform_features(efi_system_table_t *sys_table_arg);
 
 efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg);
 
+efi_status_t efi_reserve_dtb_initrd(efi_system_table_t *sys_table_arg,
+				    const void *fdt);
+
 #endif
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 8830fa601e45..54408c95e094 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -385,3 +385,45 @@ void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
 
 	return fdt;
 }
+
+efi_status_t efi_reserve_dtb_initrd(efi_system_table_t *sys_table_arg,
+				    const void *fdt)
+{
+	int chosen, len;
+	const void *prop;
+	efi_physical_addr_t start, end;
+	unsigned long num_pages;
+	efi_status_t status;
+
+	chosen = fdt_path_offset(fdt, "/chosen");
+	if (chosen == -FDT_ERR_NOTFOUND)
+		return EFI_NOT_FOUND;
+
+	prop = fdt_getprop(fdt, chosen, "linux,initrd-start", &len);
+	if (!prop)
+		return EFI_NOT_FOUND;
+
+	start = (len == sizeof(fdt32_t)) ? fdt32_to_cpu(*(fdt32_t *)prop)
+					 : fdt64_to_cpu(*(fdt64_t *)prop);
+
+	prop = fdt_getprop(fdt, chosen, "linux,initrd-end", &len);
+	if (!prop)
+		return EFI_NOT_FOUND;
+
+	end = (len == sizeof(fdt32_t)) ? fdt32_to_cpu(*(fdt32_t *)prop)
+				       : fdt64_to_cpu(*(fdt64_t *)prop);
+
+	start = round_down(start, EFI_PAGE_SIZE);
+	num_pages = round_up(end - start, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+
+	status = efi_call_early(allocate_pages, EFI_ALLOCATE_ADDRESS,
+				EFI_LOADER_DATA, num_pages, &start);
+
+	if (status != EFI_SUCCESS)
+		pr_efi_err(sys_table_arg,
+			   "Failed to reserve initrd area found in /chosen\n");
+	else
+		pr_efi(sys_table_arg, "Using initrd found in /chosen\n");
+
+	return status;
+}
-- 
2.11.0
