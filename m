Return-Path: <SRS0=ZEvh=ZH=lists.openwall.com=kernel-hardening-return-17378-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B62C7C432C3
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 09:12:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 13C8620723
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 09:12:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13C8620723
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17378-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21635 invoked by uid 550); 15 Nov 2019 09:11:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20347 invoked from network); 15 Nov 2019 09:11:15 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <oss@buserror.net>, Jason Yan
	<yanaijie@huawei.com>
Subject: [PATCH 3/6] powerpc/fsl_booke/64: implement KASLR for fsl_booke64
Date: Fri, 15 Nov 2019 17:32:06 +0800
Message-ID: <20191115093209.26434-4-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191115093209.26434-1-yanaijie@huawei.com>
References: <20191115093209.26434-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

The implementation for Freescale BookE64 is similar as BookE32. One
difference is that Freescale BookE64 set up a TLB mapping of 1G during
booting. Another difference is that ppc64 needs the kernel to be
64K-aligned. So we can randomize the kernel in this 1G mapping and make
it 64K-aligned. This can save some code to creat another TLB map at
early boot. The disadvantage is that we only have about 1G/64K = 16384
slots to put the kernel in.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Cc: Scott Wood <oss@buserror.net>
Cc: Diana Craciun <diana.craciun@nxp.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
---
 arch/powerpc/Kconfig                 |  2 +-
 arch/powerpc/kernel/setup_64.c       |  4 +++-
 arch/powerpc/mm/nohash/kaslr_booke.c | 29 ++++++++++++++++++++++++++--
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 4c4a0fcd1674..3e563a07cb67 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -553,7 +553,7 @@ config RELOCATABLE
 
 config RANDOMIZE_BASE
 	bool "Randomize the address of the kernel image"
-	depends on (FSL_BOOKE && FLATMEM && PPC32)
+	depends on (PPC_FSL_BOOK3E && FLATMEM)
 	depends on RELOCATABLE
 	help
 	  Randomizes the virtual address at which the kernel image is
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index d2af4c228970..b7e4f1e92c7e 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -65,7 +65,7 @@
 #include <asm/hw_irq.h>
 #include <asm/feature-fixups.h>
 #include <asm/kup.h>
-
+#include <mm/mmu_decl.h>
 #include "setup.h"
 
 int spinning_secondaries;
@@ -299,6 +299,8 @@ void __init early_setup(unsigned long dt_ptr)
 	/* Enable early debugging if any specified (see udbg.h) */
 	udbg_early_init();
 
+	kaslr_early_init(__va(dt_ptr), 0);
+
 	udbg_printf(" -> %s(), dt_ptr: 0x%lx\n", __func__, dt_ptr);
 
 	/*
diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
index 07b036e98353..513f4616e92a 100644
--- a/arch/powerpc/mm/nohash/kaslr_booke.c
+++ b/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -265,14 +265,14 @@ static unsigned long __init kaslr_legal_offset(void *dt_ptr, unsigned long rando
 {
 	unsigned long koffset = 0;
 	unsigned long start;
-	unsigned long index;
 	unsigned long offset;
 
+#ifdef CONFIG_PPC32
 	/*
 	 * Decide which 64M we want to start
 	 * Only use the low 8 bits of the random seed
 	 */
-	index = random & 0xFF;
+	unsigned long index = random & 0xFF;
 	index %= regions.linear_sz / SZ_64M;
 
 	/* Decide offset inside 64M */
@@ -287,6 +287,15 @@ static unsigned long __init kaslr_legal_offset(void *dt_ptr, unsigned long rando
 			break;
 		index--;
 	}
+#else
+	/* Decide kernel offset inside 1G */
+	offset = random % (SZ_1G - regions.kernel_size);
+	offset = round_down(offset, SZ_64K);
+
+	start = memstart_addr;
+	offset = memstart_addr + offset;
+	koffset = get_usable_address(dt_ptr, start, offset);
+#endif
 
 	if (koffset != 0)
 		koffset -= memstart_addr;
@@ -325,6 +334,7 @@ static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size
 	else
 		pr_warn("KASLR: No safe seed for randomizing the kernel base.\n");
 
+#ifdef CONFIG_PPC32
 	ram = min_t(phys_addr_t, __max_low_memory, size);
 	ram = map_mem_in_cams(ram, CONFIG_LOWMEM_CAM_NUM, true);
 	linear_sz = min_t(unsigned long, ram, SZ_512M);
@@ -332,6 +342,7 @@ static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size
 	/* If the linear size is smaller than 64M, do not randmize */
 	if (linear_sz < SZ_64M)
 		return 0;
+#endif
 
 	/* check for a reserved-memory node and record its cell sizes */
 	regions.reserved_mem = fdt_path_offset(dt_ptr, "/reserved-memory");
@@ -363,6 +374,18 @@ notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
 	unsigned long offset;
 	unsigned long kernel_sz;
 
+#ifdef CONFIG_PPC64
+	unsigned int *__run_at_load = (unsigned int *)(KERNELBASE + 0x5c);
+
+	if (*__run_at_load == 1)
+		return;
+
+	*__run_at_load = 1;
+
+	/* Setup flat device-tree pointer */
+	initial_boot_params = dt_ptr;
+#endif
+
 	kernel_sz = (unsigned long)_end - (unsigned long)_stext;
 
 	offset = kaslr_choose_location(dt_ptr, size, kernel_sz);
@@ -372,6 +395,7 @@ notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
 	kernstart_virt_addr += offset;
 	kernstart_addr += offset;
 
+#ifdef CONFIG_PPC32
 	is_second_reloc = 1;
 
 	if (offset >= SZ_64M) {
@@ -381,6 +405,7 @@ notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
 		/* Create kernel map to relocate in */
 		create_kaslr_tlb_entry(1, tlb_virt, tlb_phys);
 	}
+#endif
 
 	/* Copy the kernel to it's new location and run */
 	memcpy((void *)kernstart_virt_addr, (void *)_stext, kernel_sz);
-- 
2.17.2

