Return-Path: <SRS0=iO7B=3X=lists.openwall.com=kernel-hardening-return-17652-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4F6C33C9E
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Feb 2020 07:07:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A240B20661
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Feb 2020 07:07:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="IqgNPnJz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A240B20661
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17652-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3398 invoked by uid 550); 3 Feb 2020 07:07:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3359 invoked from network); 3 Feb 2020 07:07:11 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=IqgNPnJz; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1580713614; bh=smrKpIHjFvgNU1nY+YX2OWlGMfhRIgdamHvzNUhVLVg=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=IqgNPnJzQokcayKUyec8eVwm/PCXeJ9wuAZ3C027ZMmxzRzPJudSm2cGpYnowyuC2
	 q7/KV4/7w7wzKa4FrQinYFr+MgOysUneExIAp9Jq/VZ5P/g/6VhhgsnR/FI5+hN9h5
	 WsXbN4D7oe/tUwwjQyyoyeRsIAwQEvIUutUOjooE=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v6 1/5] powerpc/mm: Implement set_memory() routines
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: joel@jms.id.au, mpe@ellerman.id.au, ajd@linux.ibm.com, dja@axtens.net,
 npiggin@gmail.com, kernel-hardening@lists.openwall.com
References: <20191224055545.178462-1-ruscur@russell.cc>
 <20191224055545.178462-2-ruscur@russell.cc>
 <8f8940e2-c6ab-fca2-ab8a-61b80b2edd22@c-s.fr>
 <8675c11631ac027a78e00d4fe2c20736496b1e97.camel@russell.cc>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <59c7ce33-b61b-e008-f3fc-730ae1dd2ba7@c-s.fr>
Date: Mon, 3 Feb 2020 08:06:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <8675c11631ac027a78e00d4fe2c20736496b1e97.camel@russell.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 03/02/2020 à 01:46, Russell Currey a écrit :
> On Wed, 2020-01-08 at 13:52 +0100, Christophe Leroy wrote:
>>
>> Le 24/12/2019 à 06:55, Russell Currey a écrit :
>>> diff --git a/arch/powerpc/mm/Makefile b/arch/powerpc/mm/Makefile
>>> index 5e147986400d..d0a0bcbc9289 100644
>>> --- a/arch/powerpc/mm/Makefile
>>> +++ b/arch/powerpc/mm/Makefile
>>> @@ -20,3 +20,4 @@ obj-$(CONFIG_HIGHMEM)		+= highmem.o
>>>    obj-$(CONFIG_PPC_COPRO_BASE)	+= copro_fault.o
>>>    obj-$(CONFIG_PPC_PTDUMP)	+= ptdump/
>>>    obj-$(CONFIG_KASAN)		+= kasan/
>>> +obj-$(CONFIG_ARCH_HAS_SET_MEMORY) += pageattr.o
>>
>> CONFIG_ARCH_HAS_SET_MEMORY is set inconditionnally, I think you
>> should
>> add pageattr.o to obj-y instead. CONFIG_ARCH_HAS_XXX are almost
>> never
>> used in Makefiles
> 
> Fair enough, will keep that in mind

I forgot I commented that. I'll do it in v3.

>>> +	pte_t pte_val;
>>> +
>>> +	// invalidate the PTE so it's safe to modify
>>> +	pte_val = ptep_get_and_clear(&init_mm, addr, ptep);
>>> +	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
>>
>> Why flush a range for a single page ? On most targets this will do a
>> tlbia which is heavy, while a tlbie would suffice.
>>
>> I think flush_tlb_kernel_range() should be replaced by something
>> flushing only a single page.
> 
> You might be able to help me out here, I wanted to do that but the only
> functions I could find that flushed single pages needed a
> vm_area_struct, which I can't get.

I sent out two patches for that, one for book3s/32 and one for nohash:
https://patchwork.ozlabs.org/patch/1231983/
https://patchwork.ozlabs.org/patch/1232223/

Maybe one for book3s/64 would be needed as well ? Can you do it if needed ?


> 
>>
>>> +
>>> +	// modify the PTE bits as desired, then apply
>>> +	switch (action) {
>>> +	case SET_MEMORY_RO:
>>> +		pte_val = pte_wrprotect(pte_val);
>>> +		break;
>>> +	case SET_MEMORY_RW:
>>> +		pte_val = pte_mkwrite(pte_val);
>>> +		break;
>>> +	case SET_MEMORY_NX:
>>> +		pte_val = pte_exprotect(pte_val);
>>> +		break;
>>> +	case SET_MEMORY_X:
>>> +		pte_val = pte_mkexec(pte_val);
>>> +		break;
>>> +	default:
>>> +		WARN_ON(true);
>>> +		return -EINVAL;
>>
>> Is it worth checking that the action is valid for each page ? I
>> think
>> validity of action should be checked in change_memory_attr(). All
>> other
>> functions are static so you know they won't be called from outside.
>>
>> Once done, you can squash __change_page_attr() into
>> change_page_attr(),
>> remove the ret var and return 0 all the time.
> 
> Makes sense to fold things into a single function, but in terms of
> performance it shouldn't make a difference, right?  I still have to
> check the action to determine what to change (unless I replace passing
> SET_MEMORY_RO into apply_to_page_range() with a function pointer to
> pte_wrprotect() for example).

pte_wrprotect() is a static inline.

> 
>>
>>> +	}
>>> +
>>> +	set_pte_at(&init_mm, addr, ptep, pte_val);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int change_page_attr(pte_t *ptep, unsigned long addr, void
>>> *data)
>>> +{
>>> +	int ret;
>>> +
>>> +	spin_lock(&init_mm.page_table_lock);
>>> +	ret = __change_page_attr(ptep, addr, data);
>>> +	spin_unlock(&init_mm.page_table_lock);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +int change_memory_attr(unsigned long addr, int numpages, int
>>> action)
>>> +{
>>> +	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
>>> +	unsigned long size = numpages * PAGE_SIZE;
>>> +
>>> +	if (!numpages)
>>> +		return 0;
>>> +
>>> +	return apply_to_page_range(&init_mm, start, size,
>>> change_page_attr, &action);
>>
>> Use (void*)action instead of &action (see upper comment)
> 
> To get this to work I had to use (void *)(size_t)action to stop the
> compiler from complaining about casting an int to a void*, is there a
> better way to go about it?  Works fine, just looks gross.

Yes, use long instead (see my v3)

Christophe
