Return-Path: <SRS0=gabU=WE=lists.openwall.com=kernel-hardening-return-16755-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D66C0650F
	for <kernel-hardening@archiver.kernel.org>; Thu,  8 Aug 2019 06:20:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AD4CB2186A
	for <kernel-hardening@archiver.kernel.org>; Thu,  8 Aug 2019 06:20:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD4CB2186A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16755-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28035 invoked by uid 550); 8 Aug 2019 06:20:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27954 invoked from network); 8 Aug 2019 06:20:22 -0000
Subject: Re: [PATCH v5 06/10] powerpc/fsl_booke/32: implement KASLR
 infrastructure
To: Michael Ellerman <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>,
	<zhaohongjiang@huawei.com>
References: <20190807065706.11411-1-yanaijie@huawei.com>
 <20190807065706.11411-7-yanaijie@huawei.com>
 <87wofpt9dm.fsf@concordia.ellerman.id.au>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <9a47e042-8994-273f-0622-bdb4d7661668@huawei.com>
Date: Thu, 8 Aug 2019 14:19:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <87wofpt9dm.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected



On 2019/8/7 21:04, Michael Ellerman wrote:
> Jason Yan <yanaijie@huawei.com> writes:
>> This patch add support to boot kernel from places other than KERNELBASE.
>> Since CONFIG_RELOCATABLE has already supported, what we need to do is
>> map or copy kernel to a proper place and relocate. Freescale Book-E
>> parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1
>> entries are not suitable to map the kernel directly in a randomized
>> region, so we chose to copy the kernel to a proper place and restart to
>> relocate.
> 
> So to be 100% clear you are randomising the location of the kernel in
> virtual and physical space, by the same amount, and retaining the 1:1
> linear mapping.
> 

100% right :)

>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> index 77f6ebf97113..755378887912 100644
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>> @@ -548,6 +548,17 @@ config RELOCATABLE
>>   	  setting can still be useful to bootwrappers that need to know the
>>   	  load address of the kernel (eg. u-boot/mkimage).
>>   
>> +config RANDOMIZE_BASE
>> +	bool "Randomize the address of the kernel image"
>> +	depends on (FSL_BOOKE && FLATMEM && PPC32)
>> +	select RELOCATABLE
> 
> I think this should depend on RELOCATABLE, rather than selecting it.
> 
>> diff --git a/arch/powerpc/kernel/kaslr_booke.c b/arch/powerpc/kernel/kaslr_booke.c
>> new file mode 100644
>> index 000000000000..30f84c0321b2
>> --- /dev/null
>> +++ b/arch/powerpc/kernel/kaslr_booke.c
>> @@ -0,0 +1,84 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2019 Jason Yan <yanaijie@huawei.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
> 
> You don't need that paragraph now that you have the SPDX tag.
> 
> Rather than using a '//' comment followed by a single line block comment
> you can format it as:
> 
> // SPDX-License-Identifier: GPL-2.0-only
> //
> // Copyright (C) 2019 Jason Yan <yanaijie@huawei.com>
> >
>> +#include <linux/signal.h>
>> +#include <linux/sched.h>
>> +#include <linux/kernel.h>
>> +#include <linux/errno.h>
>> +#include <linux/string.h>
>> +#include <linux/types.h>
>> +#include <linux/ptrace.h>
>> +#include <linux/mman.h>
>> +#include <linux/mm.h>
>> +#include <linux/swap.h>
>> +#include <linux/stddef.h>
>> +#include <linux/vmalloc.h>
>> +#include <linux/init.h>
>> +#include <linux/delay.h>
>> +#include <linux/highmem.h>
>> +#include <linux/memblock.h>
>> +#include <asm/pgalloc.h>
>> +#include <asm/prom.h>
>> +#include <asm/io.h>
>> +#include <asm/mmu_context.h>
>> +#include <asm/pgtable.h>
>> +#include <asm/mmu.h>
>> +#include <linux/uaccess.h>
>> +#include <asm/smp.h>
>> +#include <asm/machdep.h>
>> +#include <asm/setup.h>
>> +#include <asm/paca.h>
>> +#include <mm/mmu_decl.h>
> 
> Do you really need all those headers?
> 

I will remove useless headers.

>> +extern int is_second_reloc;
> 
> That should be in a header.
> 
> Any reason why it isn't a bool?
> 

Oh yes, it should be in a header. This variable is already defined 
before and also used in assembly code. I think it was not defined as a 
bool just because there is no 'bool' in assembly code.

> cheers
> 
> 
> .
> 

