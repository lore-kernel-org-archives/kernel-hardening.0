From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:54:11 +0100
Message-Id: <20170814125411.22604-31-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 30/30] efi/libstub: arm: implement KASLR
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

This wires up the new KASLR implementation for ARM to the random number
generator and memory allocation routines in the UEFI stub.

Given how the UEFI stub keeps track of the placement of the DTB and
potentially an initrd via its memory map, we can quite simply use
efi_random_alloc() to carve out a window for the kernel proper, and
inform the decompressor about this by setting the kaslr_offset variable
directly.

Since the presence of a vmalloc= command line option complicates the
calculations involved, let's just disable KASLR for now if a vmalloc=
command line argument was provided.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/arm32-stub.c | 46 +++++++++++++++++++-
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index becbda445913..f812cbca08ee 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -8,6 +8,8 @@
  */
 #include <linux/efi.h>
 #include <asm/efi.h>
+#include <asm/pgtable.h>
+#include <asm/zimage.h>
 
 #include "efistub.h"
 
@@ -200,6 +202,29 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 				 efi_loaded_image_t *image)
 {
 	efi_status_t status;
+	u32 phys_seed = 0;
+
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
+		if (have_vmalloc()) {
+			pr_efi(sys_table,
+			       "vmalloc= command line argument found, disabling KASLR\n");
+		} else if (!nokaslr()) {
+			status = efi_get_random_bytes(sys_table,
+						      sizeof(phys_seed),
+						      (u8 *)&phys_seed);
+			if (status == EFI_NOT_FOUND) {
+				pr_efi(sys_table,
+				       "EFI_RNG_PROTOCOL unavailable, no randomness supplied\n");
+			} else if (status != EFI_SUCCESS) {
+				pr_efi_err(sys_table,
+					   "efi_get_random_bytes() failed\n");
+				return status;
+			}
+		} else {
+			pr_efi(sys_table,
+			       "KASLR disabled on kernel command line\n");
+		}
+	}
 
 	/*
 	 * Verify that the DRAM base address is compatible with the ARM
@@ -210,8 +235,25 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 	 */
 	dram_base = round_up(dram_base, SZ_128M);
 
-	status = reserve_kernel_base(sys_table, dram_base, reserve_addr,
-				     reserve_size);
+	if (!IS_ENABLED(CONFIG_RANDOMIZE_BASE) || phys_seed == 0) {
+		status = reserve_kernel_base(sys_table, dram_base, reserve_addr,
+					     reserve_size);
+	} else {
+		/* the end of the lowmem region */
+		unsigned long max = dram_base + VMALLOC_DEFAULT_BASE
+				    - PAGE_OFFSET - 1;
+		/*
+		 * The DTB and initrd are covered by allocations in the UEFI
+		 * memory map, so we can create a random allocation for the
+		 * uncompressed kernel, and inform the decompressor about the
+		 * offset with respect to the base of memory.
+		 */
+		*reserve_size = MAX_UNCOMP_KERNEL_SIZE;
+		status = efi_random_alloc(sys_table, *reserve_size, SZ_2M,
+					  reserve_addr, phys_seed, max);
+		kaslr_offset = *reserve_addr - dram_base;
+	}
+
 	if (status != EFI_SUCCESS) {
 		pr_efi_err(sys_table, "Unable to allocate memory for uncompressed kernel.\n");
 		return status;
-- 
2.11.0
