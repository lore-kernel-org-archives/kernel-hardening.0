Return-Path: <SRS0=z0SL=4O=lists.openwall.com=kernel-hardening-return-17954-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28144C4BA0D
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 07:19:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7AA87222C2
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 07:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="C//uJEes"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AA87222C2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17954-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19947 invoked by uid 550); 26 Feb 2020 07:19:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19912 invoked from network); 26 Feb 2020 07:19:38 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=C//uJEes; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1582701564; bh=TWcuATkJZ00ABnX/nWFwyVvB74ey5GHCEqWBA7CWIfQ=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=C//uJEesIFl3kP4gVOBgARMRL7k7AMSJwKJHqNbJCiXlEWjAvPIoXs42tLwObi23Q
	 3knXXUyu7RmaoVZ8TSBQuFRPXDgTMOAMqzM+qXu0i6qpAuED4gKx/1Fd4pqtoAyWdh
	 nHxMKLYPUEcc06pmeRLN4Cd82sBJU6rpN08thzRA=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v4 8/8] powerpc/mm: Disable set_memory() routines when
 strict RWX isn't enabled
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: joel@jms.id.au, mpe@ellerman.id.au, ajd@linux.ibm.com, dja@axtens.net,
 npiggin@gmail.com, kernel-hardening@lists.openwall.com,
 Jordan Niethe <jniethe5@gmail.com>
References: <20200226062403.63790-1-ruscur@russell.cc>
 <20200226062403.63790-9-ruscur@russell.cc>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <2a9988ec-c115-8fe8-4c68-82eb2fa43d6b@c-s.fr>
Date: Wed, 26 Feb 2020 08:19:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200226062403.63790-9-ruscur@russell.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 26/02/2020 à 07:24, Russell Currey a écrit :
> There are a couple of reasons that the set_memory() functions are
> problematic when STRICT_KERNEL_RWX isn't enabled:
> 
>   - The linear mapping is a different size and apply_to_page_range()
> 	may modify a giant section, breaking everything

I don't understand.

>   - patch_instruction() doesn't know to work around a page being marked
>   	RO, and will subsequently crash

Is patch_instruction() involved at all ?

> 
> The latter can be replicated by building a kernel with the set_memory()
> patches but with STRICT_KERNEL_RWX off and running ftracetest.
> 
> Reported-by: Jordan Niethe <jniethe5@gmail.com>
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> ---
> v4: new
> 
>   arch/powerpc/mm/pageattr.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
> index ee6b5e3b7604..ff111930cf5e 100644
> --- a/arch/powerpc/mm/pageattr.c
> +++ b/arch/powerpc/mm/pageattr.c
> @@ -96,12 +96,17 @@ static int set_page_attr(pte_t *ptep, unsigned long addr, void *data)
>   
>   int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot)

Isn't it change_memory_attr() that is a problem for you ?

>   {
> -	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
> -	unsigned long sz = numpages * PAGE_SIZE;
> +	unsigned long start, size;
> +
> +	if (!IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
> +		return 0;


Doing this you break patch 7:
mark_initmem_nx() is called regardless of CONFIG_STRICT_KERNEL_RWX
__kernel_map_pages() depends on CONFIG_DEBUG_PAGEALLOC which doesn't 
depend on CONFIG_STRICT_KERNEL_RWX


>   
>   	if (!numpages)
>   		return 0;
>   
> -	return apply_to_page_range(&init_mm, start, sz, set_page_attr,
> +	start = ALIGN_DOWN(addr, PAGE_SIZE);
> +	size = numpages * PAGE_SIZE;
> +
> +	return apply_to_page_range(&init_mm, start, size, set_page_attr,

You don't need to move start and size calculation and change the above.

>   				   (void *)pgprot_val(prot));
>   }
> 

Christophe
