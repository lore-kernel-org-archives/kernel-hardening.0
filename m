From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 15 Feb 2017 15:38:01 +0000
Message-Id: <1487173081-13425-4-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1487173081-13425-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1487173081-13425-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 3/3] arm64: efi: use effective text offset when allocating Image
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, keescook@chromium.org, labbott@fedoraproject.org, james.morse@arm.com
Cc: kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Update the image allocation logic in the EFI stub so that the effective
text offset is always honoured on 4 KB pagesize kernels. This ensures
that the __init segment can be mapped without resorting to early RWX
mappings.

Note that this sacrifices 5 bits of KASLR randomization on such kernels.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/efi-entry.S             |  5 +++++
 arch/arm64/kernel/image.h                 |  1 +
 drivers/firmware/efi/libstub/Makefile     |  1 -
 drivers/firmware/efi/libstub/arm64-stub.c | 13 ++++++++-----
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
index 4e6ad355bd05..4e1cbec3c842 100644
--- a/arch/arm64/kernel/efi-entry.S
+++ b/arch/arm64/kernel/efi-entry.S
@@ -120,3 +120,8 @@ efi_load_fail:
 
 entry_end:
 ENDPROC(entry)
+
+	__INITRODATA
+	.align	2
+ENTRY(effective_text_offset)
+	.long	__eff_text_offset
diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
index 98e191cd97b1..f137856f50bf 100644
--- a/arch/arm64/kernel/image.h
+++ b/arch/arm64/kernel/image.h
@@ -132,6 +132,7 @@ __efistub__text			= KALLSYMS_HIDE(_text);
 __efistub__end			= KALLSYMS_HIDE(_end);
 __efistub__edata		= KALLSYMS_HIDE(_edata);
 __efistub_screen_info		= KALLSYMS_HIDE(screen_info);
+__efistub___eff_text_offset	= KALLSYMS_HIDE(__eff_text_offset);
 
 #endif
 
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index d564d25df8ab..c929e787f5b3 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -41,7 +41,6 @@ lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o string.o random.o \
 
 lib-$(CONFIG_ARM)		+= arm32-stub.o
 lib-$(CONFIG_ARM64)		+= arm64-stub.o
-CFLAGS_arm64-stub.o 		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 
 #
 # arm64 puts the stub in the kernel proper, which will unnecessarily retain all
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index eae693eb3e91..b335d0483b65 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -17,6 +17,7 @@
 #include "efistub.h"
 
 extern bool __nokaslr;
+extern const u32 effective_text_offset;
 
 efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
 {
@@ -72,7 +73,8 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
 	 * a 2 MB aligned base, which itself may be lower than dram_base, as
 	 * long as the resulting offset equals or exceeds it.
 	 */
-	preferred_offset = round_down(dram_base, MIN_KIMG_ALIGN) + TEXT_OFFSET;
+	preferred_offset = round_down(dram_base, MIN_KIMG_ALIGN) +
+			   effective_text_offset;
 	if (preferred_offset < dram_base)
 		preferred_offset += MIN_KIMG_ALIGN;
 
@@ -86,8 +88,9 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
 		 * is a multiple of the minimal segment alignment (SZ_64K)
 		 */
 		u32 mask = (MIN_KIMG_ALIGN - 1) & ~(SZ_64K - 1);
-		u32 offset = !IS_ENABLED(CONFIG_DEBUG_ALIGN_RODATA) ?
-			     (phys_seed >> 32) & mask : TEXT_OFFSET;
+		u32 offset = (!IS_ENABLED(CONFIG_DEBUG_ALIGN_RODATA) &&
+			      PAGE_SIZE > SZ_4K) ? (phys_seed >> 32) & mask :
+			      effective_text_offset;
 
 		/*
 		 * If KASLR is enabled, and we have some randomness available,
@@ -124,7 +127,7 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
 	}
 
 	if (status != EFI_SUCCESS) {
-		*reserve_size = kernel_memsize + TEXT_OFFSET;
+		*reserve_size = kernel_memsize + effective_text_offset;
 		status = efi_low_alloc(sys_table_arg, *reserve_size,
 				       MIN_KIMG_ALIGN, reserve_addr);
 
@@ -133,7 +136,7 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
 			*reserve_size = 0;
 			return status;
 		}
-		*image_addr = *reserve_addr + TEXT_OFFSET;
+		*image_addr = *reserve_addr + effective_text_offset;
 	}
 	memcpy((void *)*image_addr, old_image_addr, kernel_size);
 
-- 
2.7.4
