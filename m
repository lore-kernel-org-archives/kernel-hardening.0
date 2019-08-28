Return-Path: <SRS0=9w8r=WY=lists.openwall.com=kernel-hardening-return-16810-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37124C3A5A1
	for <kernel-hardening@archiver.kernel.org>; Wed, 28 Aug 2019 05:48:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 77E5D22CF8
	for <kernel-hardening@archiver.kernel.org>; Wed, 28 Aug 2019 05:48:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="H7d56jgp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77E5D22CF8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16810-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18072 invoked by uid 550); 28 Aug 2019 05:48:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18040 invoked from network); 28 Aug 2019 05:48:04 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=H7d56jgp; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1566971271; bh=AmYiAtB5pIcz/P08jhfTvi4CrbWmoulSdtRcuEa5sPo=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=H7d56jgpyX5Kf4QbM6cOYjGTtGYEwWLMazu8whUO3pJSpS7PdHbz4EGeBXDBEe9Xg
	 y9UEbe15Q5czkyEHzO6+CdBmqGkICEFK2lKF64ns1NY/fMeiERw4Zg9l5vu7t1geOs
	 +LfAGJuFdSBnpaaHCG3qCgdFe19/Lc9CcmNrX6Mw=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v6 06/12] powerpc/fsl_booke/32: implement KASLR
 infrastructure
To: Scott Wood <oss@buserror.net>, Jason Yan <yanaijie@huawei.com>
Cc: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
 keescook@chromium.org, kernel-hardening@lists.openwall.com,
 wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org,
 jingxiangfeng@huawei.com, zhaohongjiang@huawei.com,
 thunder.leizhen@huawei.com, fanchengyang@huawei.com, yebin10@huawei.com
References: <20190809100800.5426-1-yanaijie@huawei.com>
 <20190809100800.5426-7-yanaijie@huawei.com>
 <20190828045454.GB17757@home.buserror.net>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <2db76c55-df5f-5ca8-f0a6-bcee75b8edaa@c-s.fr>
Date: Wed, 28 Aug 2019 07:47:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828045454.GB17757@home.buserror.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 28/08/2019 à 06:54, Scott Wood a écrit :
> On Fri, Aug 09, 2019 at 06:07:54PM +0800, Jason Yan wrote:
>> This patch add support to boot kernel from places other than KERNELBASE.
>> Since CONFIG_RELOCATABLE has already supported, what we need to do is
>> map or copy kernel to a proper place and relocate. Freescale Book-E
>> parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1
>> entries are not suitable to map the kernel directly in a randomized
>> region, so we chose to copy the kernel to a proper place and restart to
>> relocate.
>>
>> The offset of the kernel was not randomized yet(a fixed 64M is set). We
>> will randomize it in the next patch.
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> Cc: Diana Craciun <diana.craciun@nxp.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Tested-by: Diana Craciun <diana.craciun@nxp.com>
>> Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
>> ---
>>   arch/powerpc/Kconfig                          | 11 ++++
>>   arch/powerpc/kernel/Makefile                  |  1 +
>>   arch/powerpc/kernel/early_32.c                |  2 +-
>>   arch/powerpc/kernel/fsl_booke_entry_mapping.S | 17 +++--
>>   arch/powerpc/kernel/head_fsl_booke.S          | 13 +++-
>>   arch/powerpc/kernel/kaslr_booke.c             | 62 +++++++++++++++++++
>>   arch/powerpc/mm/mmu_decl.h                    |  7 +++
>>   arch/powerpc/mm/nohash/fsl_booke.c            |  7 ++-
>>   8 files changed, 105 insertions(+), 15 deletions(-)
>>   create mode 100644 arch/powerpc/kernel/kaslr_booke.c
>>

[...]

>> diff --git a/arch/powerpc/kernel/kaslr_booke.c b/arch/powerpc/kernel/kaslr_booke.c
>> new file mode 100644
>> index 000000000000..f8dc60534ac1
>> --- /dev/null
>> +++ b/arch/powerpc/kernel/kaslr_booke.c
> 
> Shouldn't this go under arch/powerpc/mm/nohash?
> 
>> +/*
>> + * To see if we need to relocate the kernel to a random offset
>> + * void *dt_ptr - address of the device tree
>> + * phys_addr_t size - size of the first memory block
>> + */
>> +notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
>> +{
>> +	unsigned long tlb_virt;
>> +	phys_addr_t tlb_phys;
>> +	unsigned long offset;
>> +	unsigned long kernel_sz;
>> +
>> +	kernel_sz = (unsigned long)_end - KERNELBASE;
> 
> Why KERNELBASE and not kernstart_addr?
> 
>> +
>> +	offset = kaslr_choose_location(dt_ptr, size, kernel_sz);
>> +
>> +	if (offset == 0)
>> +		return;
>> +
>> +	kernstart_virt_addr += offset;
>> +	kernstart_addr += offset;
>> +
>> +	is_second_reloc = 1;
>> +
>> +	if (offset >= SZ_64M) {
>> +		tlb_virt = round_down(kernstart_virt_addr, SZ_64M);
>> +		tlb_phys = round_down(kernstart_addr, SZ_64M);
> 
> If kernstart_addr wasn't 64M-aligned before adding offset, then "offset
>> = SZ_64M" is not necessarily going to detect when you've crossed a
> mapping boundary.
> 
>> +
>> +		/* Create kernel map to relocate in */
>> +		create_tlb_entry(tlb_phys, tlb_virt, 1);
>> +	}
>> +
>> +	/* Copy the kernel to it's new location and run */
>> +	memcpy((void *)kernstart_virt_addr, (void *)KERNELBASE, kernel_sz);
>> +
>> +	reloc_kernel_entry(dt_ptr, kernstart_virt_addr);
>> +}
> 
> After copying, call flush_icache_range() on the destination.

Function copy_and_flush() does the copy and the flush. I think it should 
be used instead of memcpy() + flush_icache_range()

Christophe
