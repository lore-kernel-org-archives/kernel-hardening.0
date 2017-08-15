From: Mark Rutland <mark.rutland@arm.com>
Date: Tue, 15 Aug 2017 13:50:43 +0100
Message-Id: <1502801449-29246-9-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
References: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCHv2 08/14] efi/arm64: add EFI_KIMG_ALIGN
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, mark.rutland@arm.com, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

The EFI stub is intimately coupled with the kernel, and takes advantage
of this by relocating the kernel at a weaker alignment than the
documented boot protocol mandates.

However, it does so by assuming it can align the kernel to the segment
alignment, and assumes that this is 64K. In subsequent patches, we'll
have to consider other details to determine this de-facto alignment
constraint.

This patch adds a new EFI_KIMG_ALIGN definition that will track the
kernel's de-facto alignment requirements. Subsequent patches will modify
this as required.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/efi.h              | 3 +++
 drivers/firmware/efi/libstub/arm64-stub.c | 6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 8f3043a..0e8cc3b 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -4,6 +4,7 @@
 #include <asm/boot.h>
 #include <asm/cpufeature.h>
 #include <asm/io.h>
+#include <asm/memory.h>
 #include <asm/mmu_context.h>
 #include <asm/neon.h>
 #include <asm/ptrace.h>
@@ -48,6 +49,8 @@
  */
 #define EFI_FDT_ALIGN	SZ_2M   /* used by allocate_new_fdt_and_exit_boot() */
 
+#define EFI_KIMG_ALIGN	SEGMENT_ALIGN
+
 /* on arm64, the FDT may be located anywhere in system RAM */
 static inline unsigned long efi_get_max_fdt_addr(unsigned long dram_base)
 {
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index b4c2589..af6ae95 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -11,6 +11,7 @@
  */
 #include <linux/efi.h>
 #include <asm/efi.h>
+#include <asm/memory.h>
 #include <asm/sections.h>
 #include <asm/sysreg.h>
 
@@ -81,9 +82,10 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
 		/*
 		 * If CONFIG_DEBUG_ALIGN_RODATA is not set, produce a
 		 * displacement in the interval [0, MIN_KIMG_ALIGN) that
-		 * is a multiple of the minimal segment alignment (SZ_64K)
+		 * doesn't violate this kernel's de-facto alignment
+		 * constraints.
 		 */
-		u32 mask = (MIN_KIMG_ALIGN - 1) & ~(SZ_64K - 1);
+		u32 mask = (MIN_KIMG_ALIGN - 1) & ~(EFI_KIMG_ALIGN - 1);
 		u32 offset = !IS_ENABLED(CONFIG_DEBUG_ALIGN_RODATA) ?
 			     (phys_seed >> 32) & mask : TEXT_OFFSET;
 
-- 
1.9.1
