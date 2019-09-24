Return-Path: <SRS0=tHOM=XT=lists.openwall.com=kernel-hardening-return-16907-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06281C432C1
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Sep 2019 05:53:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2925E20872
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Sep 2019 05:53:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2925E20872
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16907-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32477 invoked by uid 550); 24 Sep 2019 05:53:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32444 invoked from network); 24 Sep 2019 05:53:09 -0000
Subject: Re: [PATCH v7 00/12] implement KASLR for powerpc/fsl_booke/32
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <zhaohongjiang@huawei.com>, <oss@buserror.net>
References: <20190920094546.44948-1-yanaijie@huawei.com>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <9c2dd2a8-83f2-983c-383e-956e19a7803a@huawei.com>
Date: Tue, 24 Sep 2019 13:52:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190920094546.44948-1-yanaijie@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected

Hi Scott,

Can you test v7 to see if it works to load a kernel at a non-zero address?

Thanks,

On 2019/9/20 17:45, Jason Yan wrote:
> This series implements KASLR for powerpc/fsl_booke/32, as a security
> feature that deters exploit attempts relying on knowledge of the location
> of kernel internals.
> 
> Since CONFIG_RELOCATABLE has already supported, what we need to do is
> map or copy kernel to a proper place and relocate. Freescale Book-E
> parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1
> entries are not suitable to map the kernel directly in a randomized
> region, so we chose to copy the kernel to a proper place and restart to
> relocate.
> 
> Entropy is derived from the banner and timer base, which will change every
> build and boot. This not so much safe so additionally the bootloader may
> pass entropy via the /chosen/kaslr-seed node in device tree.
> 
> We will use the first 512M of the low memory to randomize the kernel
> image. The memory will be split in 64M zones. We will use the lower 8
> bit of the entropy to decide the index of the 64M zone. Then we chose a
> 16K aligned offset inside the 64M zone to put the kernel in.
> 
>      KERNELBASE
> 
>          |-->   64M   <--|
>          |               |
>          +---------------+    +----------------+---------------+
>          |               |....|    |kernel|    |               |
>          +---------------+    +----------------+---------------+
>          |                         |
>          |----->   offset    <-----|
> 
>                                kernstart_virt_addr
> 
> We also check if we will overlap with some areas like the dtb area, the
> initrd area or the crashkernel area. If we cannot find a proper area,
> kaslr will be disabled and boot from the original kernel.
> 
> Changes since v6:
>   - Rename create_tlb_entry() to create_kaslr_tlb_entry()
>   - Remove MAS2_VAL since there is no more users.
>   - Move kaslr_booke.c to arch/powerpc/mm/nohash.
>   - Call flush_icache_range() after copying the kernel.
>   - Warning if no kaslr-seed provided by the bootloader
>   - Use the right physical address when checking if the new position will overlap with other regions.
>   - Do not clear bss for the second pass because some global variables will not be initialized again
>   - Use tabs instead of spaces between the mnemonic and the arguments(in fsl_booke_entry_mapping.S).
> 
> Changes since v5:
>   - Rename M_IF_NEEDED to MAS2_M_IF_NEEDED
>   - Define some global variable as __ro_after_init
>   - Replace kimage_vaddr with kernstart_virt_addr
>   - Depend on RELOCATABLE, not select it
>   - Modify the comment block below the SPDX tag
>   - Remove some useless headers in kaslr_booke.c and move is_second_reloc
>     declarationto mmu_decl.h
>   - Remove DBG() and use pr_debug() and rewrite comment above get_boot_seed().
>   - Add a patch to document the KASLR implementation.
>   - Split a patch from patch #10 which exports kaslr offset in VMCOREINFO ELF notes.
>   - Remove extra logic around finding nokaslr string in cmdline.
>   - Make regions static global and __initdata
> 
> Changes since v4:
>   - Add Reviewed-by tag from Christophe
>   - Remove an unnecessary cast
>   - Remove unnecessary parenthesis
>   - Fix checkpatch warning
> 
> Changes since v3:
>   - Add Reviewed-by and Tested-by tag from Diana
>   - Change the comment in fsl_booke_entry_mapping.S to be consistent
>     with the new code.
> 
> Changes since v2:
>   - Remove unnecessary #ifdef
>   - Use SZ_64M instead of0x4000000
>   - Call early_init_dt_scan_chosen() to init boot_command_line
>   - Rename kaslr_second_init() to kaslr_late_init()
> 
> Changes since v1:
>   - Remove some useless 'extern' keyword.
>   - Replace EXPORT_SYMBOL with EXPORT_SYMBOL_GPL
>   - Improve some assembly code
>   - Use memzero_explicit instead of memset
>   - Use boot_command_line and remove early_command_line
>   - Do not print kaslr offset if kaslr is disabled
> 
> Jason Yan (12):
>    powerpc: unify definition of M_IF_NEEDED
>    powerpc: move memstart_addr and kernstart_addr to init-common.c
>    powerpc: introduce kernstart_virt_addr to store the kernel base
>    powerpc/fsl_booke/32: introduce create_kaslr_tlb_entry() helper
>    powerpc/fsl_booke/32: introduce reloc_kernel_entry() helper
>    powerpc/fsl_booke/32: implement KASLR infrastructure
>    powerpc/fsl_booke/32: randomize the kernel image offset
>    powerpc/fsl_booke/kaslr: clear the original kernel if randomized
>    powerpc/fsl_booke/kaslr: support nokaslr cmdline parameter
>    powerpc/fsl_booke/kaslr: dump out kernel offset information on panic
>    powerpc/fsl_booke/kaslr: export offset in VMCOREINFO ELF notes
>    powerpc/fsl_booke/32: Document KASLR implementation
> 
>   Documentation/powerpc/kaslr-booke32.rst       |  42 ++
>   arch/powerpc/Kconfig                          |  11 +
>   arch/powerpc/include/asm/nohash/mmu-book3e.h  |  11 +-
>   arch/powerpc/include/asm/page.h               |   7 +
>   arch/powerpc/kernel/early_32.c                |   5 +-
>   arch/powerpc/kernel/exceptions-64e.S          |  12 +-
>   arch/powerpc/kernel/fsl_booke_entry_mapping.S |  25 +-
>   arch/powerpc/kernel/head_fsl_booke.S          |  61 ++-
>   arch/powerpc/kernel/machine_kexec.c           |   1 +
>   arch/powerpc/kernel/misc_64.S                 |   7 +-
>   arch/powerpc/kernel/setup-common.c            |  20 +
>   arch/powerpc/mm/init-common.c                 |   7 +
>   arch/powerpc/mm/init_32.c                     |   5 -
>   arch/powerpc/mm/init_64.c                     |   5 -
>   arch/powerpc/mm/mmu_decl.h                    |  11 +
>   arch/powerpc/mm/nohash/Makefile               |   1 +
>   arch/powerpc/mm/nohash/fsl_booke.c            |   8 +-
>   arch/powerpc/mm/nohash/kaslr_booke.c          | 401 ++++++++++++++++++
>   18 files changed, 587 insertions(+), 53 deletions(-)
>   create mode 100644 Documentation/powerpc/kaslr-booke32.rst
>   create mode 100644 arch/powerpc/mm/nohash/kaslr_booke.c
> 

