Return-Path: <SRS0=q49W=VW=lists.openwall.com=kernel-hardening-return-16582-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0875C7618B
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jul 2019 07:16:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 385CE21734
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jul 2019 07:16:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 385CE21734
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16582-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5946 invoked by uid 550); 25 Jul 2019 07:16:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5905 invoked from network); 25 Jul 2019 07:16:50 -0000
Subject: Re: [RFC PATCH 00/10] implement KASLR for powerpc/fsl_booke/32
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>
References: <20190717080621.40424-1-yanaijie@huawei.com>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <e6ad41bc-5d5a-cf3f-b308-e1863b4fef99@huawei.com>
Date: Thu, 25 Jul 2019 15:16:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190717080621.40424-1-yanaijie@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected

Hi all, any comments?


On 2019/7/17 16:06, Jason Yan wrote:
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
>                                kimage_vaddr
> 
> We also check if we will overlap with some areas like the dtb area, the
> initrd area or the crashkernel area. If we cannot find a proper area,
> kaslr will be disabled and boot from the original kernel.
> 
> Jason Yan (10):
>    powerpc: unify definition of M_IF_NEEDED
>    powerpc: move memstart_addr and kernstart_addr to init-common.c
>    powerpc: introduce kimage_vaddr to store the kernel base
>    powerpc/fsl_booke/32: introduce create_tlb_entry() helper
>    powerpc/fsl_booke/32: introduce reloc_kernel_entry() helper
>    powerpc/fsl_booke/32: implement KASLR infrastructure
>    powerpc/fsl_booke/32: randomize the kernel image offset
>    powerpc/fsl_booke/kaslr: clear the original kernel if randomized
>    powerpc/fsl_booke/kaslr: support nokaslr cmdline parameter
>    powerpc/fsl_booke/kaslr: dump out kernel offset information on panic
> 
>   arch/powerpc/Kconfig                          |  11 +
>   arch/powerpc/include/asm/nohash/mmu-book3e.h  |  10 +
>   arch/powerpc/include/asm/page.h               |   7 +
>   arch/powerpc/kernel/Makefile                  |   1 +
>   arch/powerpc/kernel/early_32.c                |   2 +-
>   arch/powerpc/kernel/exceptions-64e.S          |  10 -
>   arch/powerpc/kernel/fsl_booke_entry_mapping.S |  23 +-
>   arch/powerpc/kernel/head_fsl_booke.S          |  61 ++-
>   arch/powerpc/kernel/kaslr_booke.c             | 439 ++++++++++++++++++
>   arch/powerpc/kernel/machine_kexec.c           |   1 +
>   arch/powerpc/kernel/misc_64.S                 |   5 -
>   arch/powerpc/kernel/setup-common.c            |  23 +
>   arch/powerpc/mm/init-common.c                 |   7 +
>   arch/powerpc/mm/init_32.c                     |   5 -
>   arch/powerpc/mm/init_64.c                     |   5 -
>   arch/powerpc/mm/mmu_decl.h                    |  10 +
>   arch/powerpc/mm/nohash/fsl_booke.c            |   8 +-
>   17 files changed, 580 insertions(+), 48 deletions(-)
>   create mode 100644 arch/powerpc/kernel/kaslr_booke.c
> 

