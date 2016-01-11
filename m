Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 11 Jan 2016 14:18:54 +0100
Message-Id: <1452518355-4606-2-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v3 01/21] of/fdt: make memblock minimum physical address arch configurable
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

By default, early_init_dt_add_memory_arch() ignores memory below
the base of the kernel image since it won't be addressable via the
linear mapping. However, this is not appropriate anymore once we
decouple the kernel text mapping from the linear mapping, so archs
may want to drop the low limit entirely. So allow the minimum to be
overridden by setting MIN_MEMBLOCK_ADDR.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/of/fdt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index d2430298a309..0455564f8cbc 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -971,13 +971,16 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK
+#ifndef MIN_MEMBLOCK_ADDR
+#define MIN_MEMBLOCK_ADDR	__pa(PAGE_OFFSET)
+#endif
 #ifndef MAX_MEMBLOCK_ADDR
 #define MAX_MEMBLOCK_ADDR	((phys_addr_t)~0)
 #endif
 
 void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
 {
-	const u64 phys_offset = __pa(PAGE_OFFSET);
+	const u64 phys_offset = MIN_MEMBLOCK_ADDR;
 
 	if (!PAGE_ALIGNED(base)) {
 		if (size < PAGE_SIZE - (base & ~PAGE_MASK)) {
-- 
2.5.0
