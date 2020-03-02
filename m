Return-Path: <SRS0=Qn2T=4T=lists.openwall.com=kernel-hardening-return-18039-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C94DC3F2D1
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 18:40:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 61BAB2465E
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 18:40:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nPCbvNh1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61BAB2465E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18039-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32628 invoked by uid 550); 2 Mar 2020 18:39:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32594 invoked from network); 2 Mar 2020 18:39:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=70PNbjd99jhwaP11CwZH+hyBf72TvQn+KUnto1xAKv4=;
        b=nPCbvNh1ZilYd3+c9woWZLKCkHDNCMs4zM19THJWS1JFKGZS96fPY5ZHZQVhjdwA/V
         xkhGNK7E20uN7WXEdgQdFyA8sPfOalP+Y56a92YVtd7GAymf7tlJPoH5d4/VtkocXtZC
         gDAY3h+7nlI1LyUT3vxrGFUIcVy9miP0sEtJw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=70PNbjd99jhwaP11CwZH+hyBf72TvQn+KUnto1xAKv4=;
        b=nrRg3BwmbIR6VLr64ZHVdx6Z8h/Z5MDHf1BEVYXoO9cDO7U99sjG73rrSNUPpqOgxu
         YMej79wUOVcrEpvGfiM8q/HlWJKlFQ4X/w/fIKPwYYDxRaR4Jcot2i025gNOqEcbIt+E
         dZLkHes6th0FGODIS5556APc8pcj0oGXMZ3aCEolkhdadVtHYpAI2mFusP5P3ljQ7EI7
         3Sb8FDqjoQX4rqlF+V1diYXTAXfIxjq7DFoNqs6maFqDfl09vp0N0F/Yb73kQG8FV2BT
         IuH2Shkd29X5E2bMsqFj1owATVjcmsNt+G99T4QSd3n6xgYiDpDGdM06BcucbxR7AyUZ
         EAbg==
X-Gm-Message-State: ANhLgQ3anNB3GS+LYIwfV8OrSwUCyjc8mmo2u9zzD07eBGEcTS5aOXu1
	afN6DXrvAt3mbHKvV9J6gEIidA==
X-Google-Smtp-Source: ADFU+vuzu2VB845Es4ZS28fsp07dY6EVS7FKBRbOSgalZGRvsU+H2Z/auP14eke/ZoTPHViBUPqJTg==
X-Received: by 2002:a17:902:8d89:: with SMTP id v9mr495019plo.83.1583174386378;
        Mon, 02 Mar 2020 10:39:46 -0800 (PST)
Date: Mon, 2 Mar 2020 10:39:44 -0800
From: Kees Cook <keescook@chromium.org>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: "Tobin C . Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>,
	kernel-hardening@lists.openwall.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/mm/init_32: Stop printing the virtual memory
 layout
Message-ID: <202003021039.257258E1B@keescook>
References: <202002291534.ED372CC@keescook>
 <20200301002209.1304982-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200301002209.1304982-1-nivedita@alum.mit.edu>

On Sat, Feb 29, 2020 at 07:22:09PM -0500, Arvind Sankar wrote:
> For security, don't display the kernel's virtual memory layout.
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

If this needs a v3, I'd just list the commits I mentioned for further
justification. But regardless:

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/x86/mm/init_32.c | 38 --------------------------------------
>  1 file changed, 38 deletions(-)
> 
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 23df4885bbed..8ae0272c1c51 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -788,44 +788,6 @@ void __init mem_init(void)
>  	x86_init.hyper.init_after_bootmem();
>  
>  	mem_init_print_info(NULL);
> -	printk(KERN_INFO "virtual kernel memory layout:\n"
> -		"    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
> -		"  cpu_entry : 0x%08lx - 0x%08lx   (%4ld kB)\n"
> -#ifdef CONFIG_HIGHMEM
> -		"    pkmap   : 0x%08lx - 0x%08lx   (%4ld kB)\n"
> -#endif
> -		"    vmalloc : 0x%08lx - 0x%08lx   (%4ld MB)\n"
> -		"    lowmem  : 0x%08lx - 0x%08lx   (%4ld MB)\n"
> -		"      .init : 0x%08lx - 0x%08lx   (%4ld kB)\n"
> -		"      .data : 0x%08lx - 0x%08lx   (%4ld kB)\n"
> -		"      .text : 0x%08lx - 0x%08lx   (%4ld kB)\n",
> -		FIXADDR_START, FIXADDR_TOP,
> -		(FIXADDR_TOP - FIXADDR_START) >> 10,
> -
> -		CPU_ENTRY_AREA_BASE,
> -		CPU_ENTRY_AREA_BASE + CPU_ENTRY_AREA_MAP_SIZE,
> -		CPU_ENTRY_AREA_MAP_SIZE >> 10,
> -
> -#ifdef CONFIG_HIGHMEM
> -		PKMAP_BASE, PKMAP_BASE+LAST_PKMAP*PAGE_SIZE,
> -		(LAST_PKMAP*PAGE_SIZE) >> 10,
> -#endif
> -
> -		VMALLOC_START, VMALLOC_END,
> -		(VMALLOC_END - VMALLOC_START) >> 20,
> -
> -		(unsigned long)__va(0), (unsigned long)high_memory,
> -		((unsigned long)high_memory - (unsigned long)__va(0)) >> 20,
> -
> -		(unsigned long)&__init_begin, (unsigned long)&__init_end,
> -		((unsigned long)&__init_end -
> -		 (unsigned long)&__init_begin) >> 10,
> -
> -		(unsigned long)&_etext, (unsigned long)&_edata,
> -		((unsigned long)&_edata - (unsigned long)&_etext) >> 10,
> -
> -		(unsigned long)&_text, (unsigned long)&_etext,
> -		((unsigned long)&_etext - (unsigned long)&_text) >> 10);
>  
>  	/*
>  	 * Check boundaries twice: Some fundamental inconsistencies can
> -- 
> 2.24.1
> 

-- 
Kees Cook
