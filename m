From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sun,  3 Sep 2017 13:07:57 +0100
Message-Id: <20170903120757.14968-30-ard.biesheuvel@linaro.org>
In-Reply-To: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 29/29] efi/libstub: arm: implement KASLR
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
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
 arch/arm/boot/compressed/head.S           | 12 ++++-
 drivers/firmware/efi/libstub/arm32-stub.c | 47 +++++++++++++++++++-
 2 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 79b4033b0ed4..68d803dfdf3f 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -203,6 +203,15 @@ not_angel:
 		 */
 		mov	r4, pc
 		and	r4, r4, #0xf8000000
+#if defined(CONFIG_RANDOMIZE_BASE) && defined(CONFIG_EFI_STUB)
+		/*
+		 * The KASLR randomization may have already been performed by
+		 * the UEFI stub, in which case kaslr_offset will already have
+		 * a value.
+		 */
+		ldr	r0, kaslr_offset
+		add	r4, r4, r0
+#endif
 		/* Determine final kernel image address. */
 		add	r4, r4, #TEXT_OFFSET
 #else
@@ -1428,7 +1437,8 @@ ENTRY(__crc16)
 ENDPROC(__crc16)
 
 		.align	2
-kaslr_offset:	.long	0
+ENTRY(kaslr_offset)
+		.long	0
 #ifdef CONFIG_EFI_STUB
 __efi_boot:	.long	0
 #endif
diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index becbda445913..73d3694d2fbb 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -8,9 +8,12 @@
  */
 #include <linux/efi.h>
 #include <asm/efi.h>
+#include <asm/pgtable.h>
 
 #include "efistub.h"
 
+extern u32 kaslr_offset;
+
 efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
 {
 	int block;
@@ -200,6 +203,29 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
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
@@ -210,8 +236,25 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
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
