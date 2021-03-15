Return-Path: <SRS0=DcXy=IN=lists.openwall.com=kernel-hardening-return-20944-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A14EC433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Mar 2021 22:15:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E488B64F07
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Mar 2021 22:15:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E488B64F07
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20944-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17583 invoked by uid 550); 15 Mar 2021 22:15:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17562 invoked from network); 15 Mar 2021 22:15:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4NJ97PlxHnFzJWJgTtpDT+uKjd7HgYN+0ebu/wLMsHQ=;
        b=GfeWNb1p88yRfbJnymIfERA/ut8kED0Wo7XExiGoNzml+80Z9oey4U0Ro5ATU1yaU2
         HTXnfdZHk6IoQmCWOJmzEb8cMJ+ycjfmtAfwRs9BLtRmg+ZBBxLW7s5f8mLFH9cpacl2
         tnpMFAMPUUJ7b6g/nDRVteP7L4YMejkChexPI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4NJ97PlxHnFzJWJgTtpDT+uKjd7HgYN+0ebu/wLMsHQ=;
        b=OW7FjjoAW2RttfHQ9asKzHG+SgoOYrP5ZGnFybSGHxdyO0FWxgGpcgbmMgCKk/pNDB
         aAds+8fnhRPelm0HJmZY+pLD/YKtKsRf+FT7YWFzRBKEk+v8I9cr19boY74ov9mLfyZc
         S8c4V8/RBRMvqY+UbTiWBze/Z3NU8rTIXIyEyFDCqS6nI3hpyeiRYoy+GWz+lEscoFA9
         r0Qr9D03+1i/72hZGEw6wxF8Y1H20bi7aOxFiffIzULeWJfX/+LHsmifsJ6RYRjo/Xny
         jCuKRMndX3X3331tcIQv8hK0Yt/apZSRD8E441OWR7NHEbRHeyvVLVGupknV4HuU2lFh
         G/Tg==
X-Gm-Message-State: AOAM5311QZkieSQB+igIy9FaZtDDOYMu/Md3ZwwMlIUopVa7i3H21zpF
	1NshK5Pj1E8ig+vNuI11ffMJNg==
X-Google-Smtp-Source: ABdhPJyTjnc9LdJf0dvdcKWL6IHisbEo+ZUejO8pNco1fmFRm1nNRoQe3Sx5RQqz8b9aU1cRR2xiPQ==
X-Received: by 2002:a65:6a0c:: with SMTP id m12mr1019256pgu.161.1615846529292;
        Mon, 15 Mar 2021 15:15:29 -0700 (PDT)
Date: Mon, 15 Mar 2021 15:15:27 -0700
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Potapenko <glider@google.com>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/6] init_on_alloc: Optimize static branches
Message-ID: <202103151514.AE11A69683@keescook>
References: <20210315180229.1224655-1-keescook@chromium.org>
 <20210315180229.1224655-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315180229.1224655-3-keescook@chromium.org>

On Mon, Mar 15, 2021 at 11:02:25AM -0700, Kees Cook wrote:
> diff --git a/mm/slab.h b/mm/slab.h
> index 076582f58f68..b0977d525c06 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -601,7 +601,8 @@ static inline void cache_random_seq_destroy(struct kmem_cache *cachep) { }
>  
>  static inline bool slab_want_init_on_alloc(gfp_t flags, struct kmem_cache *c)
>  {
> -	if (static_branch_unlikely(&init_on_alloc)) {
> +	if (static_branch_maybe(CONFIG_INIT_ON_FREE_DEFAULT_ON,

Gah, this should be CONFIG_INIT_ON_ALLOC_DEFAULT_ON.

I'll see if there are any more comments before sending a v7...

-Kees

> +				&init_on_alloc)) {
>  		if (c->ctor)
>  			return false;
>  		if (c->flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON))
> @@ -613,7 +614,8 @@ static inline bool slab_want_init_on_alloc(gfp_t flags, struct kmem_cache *c)
>  
>  static inline bool slab_want_init_on_free(struct kmem_cache *c)
>  {
> -	if (static_branch_unlikely(&init_on_free))
> +	if (static_branch_maybe(CONFIG_INIT_ON_FREE_DEFAULT_ON,
> +				&init_on_free))
>  		return !(c->ctor ||
>  			 (c->flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON)));
>  	return false;
> -- 
> 2.25.1
> 

-- 
Kees Cook
