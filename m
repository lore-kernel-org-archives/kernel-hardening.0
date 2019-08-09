Return-Path: <SRS0=9GG6=WF=lists.openwall.com=kernel-hardening-return-16762-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0D3C31E40
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Aug 2019 09:52:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 33BF92166E
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Aug 2019 09:52:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33BF92166E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16762-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12123 invoked by uid 550); 9 Aug 2019 09:52:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12001 invoked from network); 9 Aug 2019 09:52:11 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>,
	<zhaohongjiang@huawei.com>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v6 00/12] implement KASLR for powerpc/fsl_booke/32
Date: Fri, 9 Aug 2019 18:07:48 +0800
Message-ID: <20190809100800.5426-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

This series implements KASLR for powerpc/fsl_booke/32, as a security
feature that deters exploit attempts relying on knowledge of the location
of kernel internals.

Since CONFIG_RELOCATABLE has already supported, what we need to do is
map or copy kernel to a proper place and relocate. Freescale Book-E
parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1
entries are not suitable to map the kernel directly in a randomized
region, so we chose to copy the kernel to a proper place and restart to
relocate.

Entropy is derived from the banner and timer base, which will change every
build and boot. This not so much safe so additionally the bootloader may
pass entropy via the /chosen/kaslr-seed node in device tree.

We will use the first 512M of the low memory to randomize the kernel
image. The memory will be split in 64M zones. We will use the lower 8
bit of the entropy to decide the index of the 64M zone. Then we chose a
16K aligned offset inside the 64M zone to put the kernel in.

    KERNELBASE

        |-->   64M   <--|
        |               |
        +---------------+    +----------------+---------------+
        |               |....|    |kernel|    |               |
        +---------------+    +----------------+---------------+
        |                         |
        |----->   offset    <-----|

                              kernstart_virt_addr

We also check if we will overlap with some areas like the dtb area, the
initrd area or the crashkernel area. If we cannot find a proper area,
kaslr will be disabled and boot from the original kernel.

Changes since v5:
 - Rename M_IF_NEEDED to MAS2_M_IF_NEEDED
 - Define some global variable as __ro_after_init
 - Replace kimage_vaddr with kernstart_virt_addr
 - Depend on RELOCATABLE, not select it
 - Modify the comment block below the SPDX tag
 - Remove some useless headers in kaslr_booke.c and move is_second_reloc
   declarationto mmu_decl.h
 - Remove DBG() and use pr_debug() and rewrite comment above get_boot_seed().
 - Add a patch to document the KASLR implementation.
 - Split a patch from patch #10 which exports kaslr offset in VMCOREINFO ELF notes.
 - Remove extra logic around finding nokaslr string in cmdline.
 - Make regions static global and __initdata

Changes since v4:
 - Add Reviewed-by tag from Christophe
 - Remove an unnecessary cast
 - Remove unnecessary parenthesis
 - Fix checkpatch warning

Changes since v3:
 - Add Reviewed-by and Tested-by tag from Diana
 - Change the comment in fsl_booke_entry_mapping.S to be consistent
   with the new code.

Changes since v2:
 - Remove unnecessary #ifdef
 - Use SZ_64M instead of0x4000000
 - Call early_init_dt_scan_chosen() to init boot_command_line
 - Rename kaslr_second_init() to kaslr_late_init()

Changes since v1:
 - Remove some useless 'extern' keyword.
 - Replace EXPORT_SYMBOL with EXPORT_SYMBOL_GPL
 - Improve some assembly code
 - Use memzero_explicit instead of memset
 - Use boot_command_line and remove early_command_line
 - Do not print kaslr offset if kaslr is disabled

Jason Yan (12):
  powerpc: unify definition of M_IF_NEEDED
  powerpc: move memstart_addr and kernstart_addr to init-common.c
  powerpc: introduce kernstart_virt_addr to store the kernel base
  powerpc/fsl_booke/32: introduce create_tlb_entry() helper
  powerpc/fsl_booke/32: introduce reloc_kernel_entry() helper
  powerpc/fsl_booke/32: implement KASLR infrastructure
  powerpc/fsl_booke/32: randomize the kernel image offset
  powerpc/fsl_booke/kaslr: clear the original kernel if randomized
  powerpc/fsl_booke/kaslr: support nokaslr cmdline parameter
  powerpc/fsl_booke/kaslr: dump out kernel offset information on panic
  powerpc/fsl_booke/kaslr: export offset in VMCOREINFO ELF notes
  powerpc/fsl_booke/32: Document KASLR implementation

 Documentation/powerpc/kaslr-booke32.rst       |  42 ++
 arch/powerpc/Kconfig                          |  11 +
 arch/powerpc/include/asm/nohash/mmu-book3e.h  |  10 +
 arch/powerpc/include/asm/page.h               |   7 +
 arch/powerpc/kernel/Makefile                  |   1 +
 arch/powerpc/kernel/early_32.c                |   2 +-
 arch/powerpc/kernel/exceptions-64e.S          |  12 +-
 arch/powerpc/kernel/fsl_booke_entry_mapping.S |  27 +-
 arch/powerpc/kernel/head_fsl_booke.S          |  55 ++-
 arch/powerpc/kernel/kaslr_booke.c             | 393 ++++++++++++++++++
 arch/powerpc/kernel/machine_kexec.c           |   1 +
 arch/powerpc/kernel/misc_64.S                 |   7 +-
 arch/powerpc/kernel/setup-common.c            |  20 +
 arch/powerpc/mm/init-common.c                 |   7 +
 arch/powerpc/mm/init_32.c                     |   5 -
 arch/powerpc/mm/init_64.c                     |   5 -
 arch/powerpc/mm/mmu_decl.h                    |  11 +
 arch/powerpc/mm/nohash/fsl_booke.c            |   8 +-
 18 files changed, 572 insertions(+), 52 deletions(-)
 create mode 100644 Documentation/powerpc/kaslr-booke32.rst
 create mode 100644 arch/powerpc/kernel/kaslr_booke.c

-- 
2.17.2

