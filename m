Return-Path: <SRS0=mHjv=4O=lists.openwall.com=kernel-hardening-return-17955-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15308C4BA0A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 07:29:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 61E7C24650
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 07:29:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="cs0L8wZs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61E7C24650
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17955-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28079 invoked by uid 550); 26 Feb 2020 07:29:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28047 invoked from network); 26 Feb 2020 07:29:31 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=cs0L8wZs; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1582702159; bh=a8SYvzvnlOIBi57mqwe6Lh2gVEDqxoLQIno02IN+QIQ=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=cs0L8wZsiYQVCfe7j0+wjVQwXQAry4k+c6dHNTKJL+uvvVDyNX0TilLfnWlFglYz+
	 lUh13DUEJ68FXEhx65kq3/rUOiK031uQY+4z1FsZ262j6yP8wLJoHoqMkv08Llka8g
	 ZDndOONLrHGyTKh4LqV+DeiQ3BHdzBoOzkIxxxHw=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v5 8/8] powerpc/mm: Disable set_memory() routines when
 strict RWX isn't enabled
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: jniethe5@gmail.com, joel@jms.id.au, mpe@ellerman.id.au,
 ajd@linux.ibm.com, dja@axtens.net, npiggin@gmail.com,
 kernel-hardening@lists.openwall.com
References: <20200226063551.65363-1-ruscur@russell.cc>
 <20200226063551.65363-9-ruscur@russell.cc>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <0c858bb2-9be8-ff77-d5ec-7f74700cdb85@c-s.fr>
Date: Wed, 26 Feb 2020 08:29:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200226063551.65363-9-ruscur@russell.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 26/02/2020 à 07:35, Russell Currey a écrit :
> There are a couple of reasons that the set_memory() functions are
> problematic when STRICT_KERNEL_RWX isn't enabled:
> 
>   - The linear mapping is a different size and apply_to_page_range()
> 	may modify a giant section, breaking everything
>   - patch_instruction() doesn't know to work around a page being marked
>   	RO, and will subsequently crash
> 
> The latter can be replicated by building a kernel with the set_memory()
> patches but with STRICT_KERNEL_RWX off and running ftracetest.

I agree with Andrew, those changes should go into patch 1.

> 
> Reported-by: Jordan Niethe <jniethe5@gmail.com>
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> ---
> v5: Apply to both set_memory_attr() and change_memory_attr()

See my comments of v4, additional comments below

> v4: New
> 
>   arch/powerpc/mm/pageattr.c | 22 ++++++++++++++++------
>   1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
> index ee6b5e3b7604..49b8e2e0581d 100644
> --- a/arch/powerpc/mm/pageattr.c
> +++ b/arch/powerpc/mm/pageattr.c
> @@ -64,13 +64,18 @@ static int change_page_attr(pte_t *ptep, unsigned long addr, void *data)
>   
>   int change_memory_attr(unsigned long addr, int numpages, long action)
>   {
> -	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
> -	unsigned long sz = numpages * PAGE_SIZE;
> +	unsigned long start, size;
> +
> +	if (!IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
> +		return 0;
>   
>   	if (!numpages)
>   		return 0;
>   
> -	return apply_to_page_range(&init_mm, start, sz, change_page_attr, (void *)action);
> +	start = ALIGN_DOWN(addr, PAGE_SIZE);
> +	size = numpages * PAGE_SIZE;
> +
> +	return apply_to_page_range(&init_mm, start, size, change_page_attr, (void *)action);

You don't need to move start and sz initialisation, neither you need to 
change the name of sz to size.

If you want to rename sz to size, do it in the initial patch, but take 
care of the length of the lines. IIRC I used a short name to have the 
line fit on a single line with no more than 90 chars.

Christophe

>   }
>   
>   /*
> @@ -96,12 +101,17 @@ static int set_page_attr(pte_t *ptep, unsigned long addr, void *data)
>   
>   int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot)
>   {
> -	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
> -	unsigned long sz = numpages * PAGE_SIZE;
> +	unsigned long start, size;
> +
> +	if (!IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
> +		return 0;
>   
>   	if (!numpages)
>   		return 0;
>   
> -	return apply_to_page_range(&init_mm, start, sz, set_page_attr,
> +	start = ALIGN_DOWN(addr, PAGE_SIZE);
> +	size = numpages * PAGE_SIZE;
> +
> +	return apply_to_page_range(&init_mm, start, size, set_page_attr,
>   				   (void *)pgprot_val(prot));
>   }
> 
