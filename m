Return-Path: <SRS0=GtYQ=44=lists.openwall.com=kernel-hardening-return-18122-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C6EC10F25
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Mar 2020 06:09:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 30DCA20873
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Mar 2020 06:09:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="G897H7G6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30DCA20873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18122-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3557 invoked by uid 550); 11 Mar 2020 06:09:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3525 invoked from network); 11 Mar 2020 06:09:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=c3Eiiej5Gd50RgJzhEkTBuJdhTagholM7xl6YJq93Wc=;
        b=G897H7G6bgR0g37t/Ahjg9iWtOVLHQ45HUjIMfy5R86tdnfi2m+1gm0dvbZIZN3r34
         lMh6wsG9Vn59M5Axy9XIZfguX7fQQ5ycjwShWBHoC58Bvwny9Ulg6w6stDe213nVm/Hh
         Ue+3KiaQAWNLB0erF0LxuqzHWhUCe/X6DSvCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=c3Eiiej5Gd50RgJzhEkTBuJdhTagholM7xl6YJq93Wc=;
        b=LqywqWLx1qWAi7XPJ8dKfDawL+bkoIWeKxuKxYW86zx4j7c7EBYpxrgSoy3A5eZ7v1
         bhTivcf9iUEMYGtxPH5Nz4gzjYgO/6GDvIGPrlBLx4Q91Hoe2nlTINazDH6VoQwqluNR
         mzctr/oM5mYshaWRuyycsNFN/Nixo/XR6pWL5yyWDSwJkwTq59p/CwCDB+9TyufLgaUN
         MyWRgyyRsplFM+5aU6kyEhBzNfVGaebd6LJLwU8rykJUK2peDjzmmMLOTINZizBMvCEI
         G/6dUbdCqYT8+X+q9gnS8BEYlgfSth3XVNdRaSDGOt2uxz599ur/pOoVeizvNjtTy+/6
         RywQ==
X-Gm-Message-State: ANhLgQ0KcN+igLHd+f7HQG+H6CyosVzNFYCHboOjrfQOMVbvsCV0rtoD
	mPpb2aMCeJ72cfH9tSPEp5QuAA==
X-Google-Smtp-Source: ADFU+vuwePZ+DKPOfje510A10zOjIQNZMI/9v60ebhVo5DxHHMt3CmnKG/pLsVt0bP3YV5NxhSiCpw==
X-Received: by 2002:a17:902:8a88:: with SMTP id p8mr1562296plo.179.1583906951963;
        Tue, 10 Mar 2020 23:09:11 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: Christophe Leroy <christophe.leroy@c-s.fr>, joel@jms.id.au, mpe@ellerman.id.au, ajd@linux.ibm.com, npiggin@gmail.com, kernel-hardening@lists.openwall.com, kbuild test robot <lkp@intel.com>, Russell Currey <ruscur@russell.cc>
Subject: Re: [PATCH v6 6/7] powerpc/mm: implement set_memory_attr()
In-Reply-To: <20200310010338.21205-7-ruscur@russell.cc>
References: <20200310010338.21205-1-ruscur@russell.cc> <20200310010338.21205-7-ruscur@russell.cc>
Date: Wed, 11 Mar 2020 17:09:07 +1100
Message-ID: <87ftefpgn0.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain

Russell Currey <ruscur@russell.cc> writes:

> From: Christophe Leroy <christophe.leroy@c-s.fr>
>
> In addition to the set_memory_xx() functions which allows to change
> the memory attributes of not (yet) used memory regions, implement a
> set_memory_attr() function to:
> - set the final memory protection after init on currently used
> kernel regions.
> - enable/disable kernel memory regions in the scope of DEBUG_PAGEALLOC.
>
> Unlike the set_memory_xx() which can act in three step as the regions
> are unused, this function must modify 'on the fly' as the kernel is
> executing from them. At the moment only PPC32 will use it and changing
> page attributes on the fly is not an issue.
>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> Reported-by: kbuild test robot <lkp@intel.com>
> [ruscur: cast "data" to unsigned long instead of int]
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> ---
>  arch/powerpc/include/asm/set_memory.h |  2 ++
>  arch/powerpc/mm/pageattr.c            | 33 +++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+)
>
> diff --git a/arch/powerpc/include/asm/set_memory.h b/arch/powerpc/include/asm/set_memory.h
> index 64011ea444b4..b040094f7920 100644
> --- a/arch/powerpc/include/asm/set_memory.h
> +++ b/arch/powerpc/include/asm/set_memory.h
> @@ -29,4 +29,6 @@ static inline int set_memory_x(unsigned long addr, int numpages)
>  	return change_memory_attr(addr, numpages, SET_MEMORY_X);
>  }
>  
> +int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot);
> +
>  #endif
> diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
> index 748fa56d9db0..60139fedc6cc 100644
> --- a/arch/powerpc/mm/pageattr.c
> +++ b/arch/powerpc/mm/pageattr.c
> @@ -77,3 +77,36 @@ int change_memory_attr(unsigned long addr, int numpages, long action)
>  
>  	return apply_to_page_range(&init_mm, start, sz, change_page_attr, (void *)action);
>  }
> +
> +/*
> + * Set the attributes of a page:
> + *
> + * This function is used by PPC32 at the end of init to set final kernel memory
> + * protection. It includes changing the maping of the page it is executing from
> + * and data pages it is using.
> + */
> +static int set_page_attr(pte_t *ptep, unsigned long addr, void *data)
> +{
> +	pgprot_t prot = __pgprot((unsigned long)data);
> +
> +	spin_lock(&init_mm.page_table_lock);
> +
> +	set_pte_at(&init_mm, addr, ptep, pte_modify(*ptep, prot));
> +	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
> +
> +	spin_unlock(&init_mm.page_table_lock);
> +
> +	return 0;
> +}
> +
> +int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot)
> +{
> +	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
> +	unsigned long sz = numpages * PAGE_SIZE;
> +
> +	if (!numpages)
> +		return 0;
> +
> +	return apply_to_page_range(&init_mm, start, sz, set_page_attr,
> +				   (void *)pgprot_val(prot));

This should probably use apply_to_existing_page_range as well. 

Regards,
Daniel

> +}
> -- 
> 2.25.1
