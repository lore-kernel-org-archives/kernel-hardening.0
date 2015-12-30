Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 30 Dec 2015 16:26:01 +0100
Message-Id: <1451489172-17420-3-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 02/13] arm64: introduce KIMAGE_VADDR as the virtual base of the kernel region
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This introduces the preprocessor symbol KIMAGE_VADDR which will serve as
the symbolic virtual base of the kernel region, i.e., the kernel's virtual
offset will be KIMAGE_VADDR + TEXT_OFFSET. For now, we define it as being
equal to PAGE_OFFSET, but in the future, it will be moved below it once
we move the kernel virtual mapping out of the linear mapping.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/memory.h | 10 ++++++++--
 arch/arm64/kernel/head.S        |  2 +-
 arch/arm64/kernel/vmlinux.lds.S |  4 ++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 853953cd1f08..bea9631b34a8 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -51,7 +51,8 @@
 #define VA_BITS			(CONFIG_ARM64_VA_BITS)
 #define VA_START		(UL(0xffffffffffffffff) << VA_BITS)
 #define PAGE_OFFSET		(UL(0xffffffffffffffff) << (VA_BITS - 1))
-#define MODULES_END		(PAGE_OFFSET)
+#define KIMAGE_VADDR		(PAGE_OFFSET)
+#define MODULES_END		(KIMAGE_VADDR)
 #define MODULES_VADDR		(MODULES_END - SZ_64M)
 #define PCI_IO_END		(MODULES_VADDR - SZ_2M)
 #define PCI_IO_START		(PCI_IO_END - PCI_IO_SIZE)
@@ -75,8 +76,13 @@
  * private definitions which should NOT be used outside memory.h
  * files.  Use virt_to_phys/phys_to_virt/__pa/__va instead.
  */
-#define __virt_to_phys(x)	(((phys_addr_t)(x) - PAGE_OFFSET + PHYS_OFFSET))
+#define __virt_to_phys(x) ({						\
+	phys_addr_t __x = (phys_addr_t)(x);				\
+	__x >= PAGE_OFFSET ? (__x - PAGE_OFFSET + PHYS_OFFSET) :	\
+			     (__x - KIMAGE_VADDR + PHYS_OFFSET); })
+
 #define __phys_to_virt(x)	((unsigned long)((x) - PHYS_OFFSET + PAGE_OFFSET))
+#define __phys_to_kimg(x)	((unsigned long)((x) - PHYS_OFFSET + KIMAGE_VADDR))
 
 /*
  * Convert a page to/from a physical address
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 23cfc08fc8ba..6434c844a0e4 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -389,7 +389,7 @@ __create_page_tables:
 	 * Map the kernel image (starting with PHYS_OFFSET).
 	 */
 	mov	x0, x26				// swapper_pg_dir
-	mov	x5, #PAGE_OFFSET
+	ldr	x5, =KIMAGE_VADDR
 	create_pgd_entry x0, x5, x3, x6
 	ldr	x6, =KERNEL_END			// __va(KERNEL_END)
 	mov	x3, x24				// phys offset
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 7de6c39858a5..ced0dedcabcc 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -88,7 +88,7 @@ SECTIONS
 		*(.discard.*)
 	}
 
-	. = PAGE_OFFSET + TEXT_OFFSET;
+	. = KIMAGE_VADDR + TEXT_OFFSET;
 
 	.head.text : {
 		_text = .;
@@ -185,4 +185,4 @@ ASSERT(__idmap_text_end - (__idmap_text_start & ~(SZ_4K - 1)) <= SZ_4K,
 /*
  * If padding is applied before .head.text, virt<->phys conversions will fail.
  */
-ASSERT(_text == (PAGE_OFFSET + TEXT_OFFSET), "HEAD is misaligned")
+ASSERT(_text == (KIMAGE_VADDR + TEXT_OFFSET), "HEAD is misaligned")
-- 
2.5.0
