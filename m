Return-Path: <SRS0=8zbU=4O=lists.openwall.com=kernel-hardening-return-17932-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B1B2C4BA0A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 05:10:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7CAB921556
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 05:10:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="FpYzmR5Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CAB921556
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17932-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18130 invoked by uid 550); 26 Feb 2020 05:10:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18095 invoked from network); 26 Feb 2020 05:10:40 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=FpYzmR5Q; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1582693828; bh=V9G92WeV7I0zyA8d4SzL2Zeetat6pnJ2RUGjU6q3uIg=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=FpYzmR5QNKHUaBBVDRQjMn4m/pOdgoFNEP5tSJGRbUNRZBjex2jvHKjGm8eDBIFBf
	 wnPRdyxZXUFGgKULHnBXKV7iqLyAsW//hePYYh3TciLnTMP9L2FVuHIIo+zvj2DvVw
	 1OgN0jnJw11ZcZaByVat8IoCcG26DQ9EYye4GeBs=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v3 3/6] powerpc/fsl_booke/64: implement KASLR for
 fsl_booke64
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au,
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
 keescook@chromium.org, kernel-hardening@lists.openwall.com, oss@buserror.net
Cc: linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <20200206025825.22934-4-yanaijie@huawei.com>
 <41b9f1ca-c6fd-291a-2c96-2a0e8a754ec4@c-s.fr>
 <dbe0b316-40a2-7da4-c26b-e59efa555400@huawei.com>
 <d3647cce-ece3-d302-f541-b02b1f2b5e9e@huawei.com>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <ceeced29-c6b9-60c9-41b0-3cf537bbf62c@c-s.fr>
Date: Wed, 26 Feb 2020 06:10:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <d3647cce-ece3-d302-f541-b02b1f2b5e9e@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 26/02/2020 à 04:33, Jason Yan a écrit :
> 
> 
> 在 2020/2/26 10:40, Jason Yan 写道:
>>
>>
>> 在 2020/2/20 21:48, Christophe Leroy 写道:
>>>
>>>
>>> Le 06/02/2020 à 03:58, Jason Yan a écrit :
> Hi Christophe,
> 
> When using a standard C if/else, all code compiled for PPC32 and PPC64, 
> but this will bring some build error because not all variables both 
> defined for PPC32 and PPC64.
> 
> [yanaijie@138 linux]$ sh ppc64build.sh
>    CALL    scripts/atomic/check-atomics.sh
>    CALL    scripts/checksyscalls.sh
>    CHK     include/generated/compile.h
>    CC      arch/powerpc/mm/nohash/kaslr_booke.o
> arch/powerpc/mm/nohash/kaslr_booke.c: In function 'kaslr_choose_location':
> arch/powerpc/mm/nohash/kaslr_booke.c:341:30: error: 
> 'CONFIG_LOWMEM_CAM_NUM' undeclared (first use in this function); did you 
> mean 'CONFIG_FLATMEM_MANUAL'?
>     ram = map_mem_in_cams(ram, CONFIG_LOWMEM_CAM_NUM, true);
>                                ^~~~~~~~~~~~~~~~~~~~~
>                                CONFIG_FLATMEM_MANUAL

This one has to remain inside an #ifdef. That's the only one that has to 
remain.

> arch/powerpc/mm/nohash/kaslr_booke.c:341:30: note: each undeclared 
> identifier is reported only once for each function it appears in
> arch/powerpc/mm/nohash/kaslr_booke.c: In function 'kaslr_early_init':
> arch/powerpc/mm/nohash/kaslr_booke.c:404:3: error: 'is_second_reloc' 

In mmu_decl.h, put the declaration outside the #ifdef CONFIG_PPC32

> undeclared (first use in this function); did you mean '__cond_lock'?
>     is_second_reloc = 1;
>     ^~~~~~~~~~~~~~~
>     __cond_lock
> arch/powerpc/mm/nohash/kaslr_booke.c:411:4: error: implicit declaration 
> of function 'create_kaslr_tlb_entry'; did you mean 'reloc_kernel_entry'? 

Same, put the declaration outside of the #ifdef

> [-Werror=implicit-function-declaration]
>      create_kaslr_tlb_entry(1, tlb_virt, tlb_phys);
>      ^~~~~~~~~~~~~~~~~~~~~~
>      reloc_kernel_entry
> cc1: all warnings being treated as errors
> make[3]: *** [scripts/Makefile.build:268: 
> arch/powerpc/mm/nohash/kaslr_booke.o] Error 1
> make[2]: *** [scripts/Makefile.build:505: arch/powerpc/mm/nohash] Error 2
> make[1]: *** [scripts/Makefile.build:505: arch/powerpc/mm] Error 2
> make: *** [Makefile:1681: arch/powerpc] Error 2

See the patch I sent you. It builds ok for me.

Christophe
