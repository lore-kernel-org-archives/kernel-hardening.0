Return-Path: <SRS0=PhSW=4O=lists.openwall.com=kernel-hardening-return-17966-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA02CC4BA21
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 21:52:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 207B424672
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 21:52:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WyBaIgGC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 207B424672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17966-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16258 invoked by uid 550); 26 Feb 2020 21:52:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16226 invoked from network); 26 Feb 2020 21:52:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J0Egg9sFa3mWWC6z1XqltuWj5LdGN/8GpNEWbWGXDQk=;
        b=WyBaIgGCTruemq7rHIeOFFKkSmZFey/y79zq+yX3DPMj/hLTJemZB776zVWmseAoPk
         n4h+kFZSc7lg2ndIlXiXpwOs7NV1fjPDzQ+33L6hQsCrs96NecB9uK4pRd+/ngd7we7v
         EPkCA9TR3YIPZOUKvAryhgjOD+1sVhs7AHBPo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J0Egg9sFa3mWWC6z1XqltuWj5LdGN/8GpNEWbWGXDQk=;
        b=BYV+844LC0hCNUcr0tFXVKfSnpxoMFam0jPTLyyDztl8KUcCY1VpSGVqOn4CsPfopp
         FgNlE/nseyoGJGHz2ioE157pZuiZ/xcZjBDJA5mDenJeo+usoiTa6Stx8WQosTi03CJj
         Ix75VsAW2lJuvzz4Nq/mJnhcxaN3q7Qcvdtk+ZB/woBRW+P4ZtBn3VC89x9TX8yQjVM5
         QZNKyqj61i7g8B4AmKr9t5hnmALBc4nsAMR+De28RtYgKFOU1l+Uw0zrZJpExnfdgHbS
         XS+QigwcutnuQm1eWpuQYR0f8qNctGZd6NEVWs0CmG5SEtc20tajbGRMxpbftZOYQY2B
         jpbg==
X-Gm-Message-State: APjAAAWnkna3OMIcsklem72mKQC8EbTUHQmrJBh6QHXmJoTIw9SEphK+
	0tsuSz+8G+Y28E584o3FMEDkVA==
X-Google-Smtp-Source: APXvYqxEaK1Cv4oaPm0J/tFDjSfHee2s2mNobGOfYf+MXqkoFKyVBxJTTPEDCuSEP1qbuYVtz/v6DA==
X-Received: by 2002:a17:902:b498:: with SMTP id y24mr1280527plr.343.1582753936716;
        Wed, 26 Feb 2020 13:52:16 -0800 (PST)
Date: Wed, 26 Feb 2020 13:52:14 -0800
From: Kees Cook <keescook@chromium.org>
To: Russell Currey <ruscur@russell.cc>
Cc: linuxppc-dev@lists.ozlabs.org, jniethe5@gmail.com,
	christophe.leroy@c-s.fr, joel@jms.id.au, mpe@ellerman.id.au,
	ajd@linux.ibm.com, dja@axtens.net, npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5 3/8] powerpc/mm/ptdump: debugfs handler for W+X checks
 at runtime
Message-ID: <202002261348.8957F0E8D@keescook>
References: <20200226063551.65363-1-ruscur@russell.cc>
 <20200226063551.65363-4-ruscur@russell.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226063551.65363-4-ruscur@russell.cc>

On Wed, Feb 26, 2020 at 05:35:46PM +1100, Russell Currey wrote:
> Very rudimentary, just
> 
> 	echo 1 > [debugfs]/check_wx_pages
> 
> and check the kernel log.  Useful for testing strict module RWX.
> 
> Updated the Kconfig entry to reflect this.

Oh, I like this! This would be handy to have on all architectures.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> 
> Also fixed a typo.
> 
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> ---
>  arch/powerpc/Kconfig.debug      |  6 ++++--
>  arch/powerpc/mm/ptdump/ptdump.c | 21 ++++++++++++++++++++-
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
> index 0b063830eea8..e37960ef68c6 100644
> --- a/arch/powerpc/Kconfig.debug
> +++ b/arch/powerpc/Kconfig.debug
> @@ -370,7 +370,7 @@ config PPC_PTDUMP
>  	  If you are unsure, say N.
>  
>  config PPC_DEBUG_WX
> -	bool "Warn on W+X mappings at boot"
> +	bool "Warn on W+X mappings at boot & enable manual checks at runtime"
>  	depends on PPC_PTDUMP && STRICT_KERNEL_RWX
>  	help
>  	  Generate a warning if any W+X mappings are found at boot.
> @@ -384,7 +384,9 @@ config PPC_DEBUG_WX
>  	  of other unfixed kernel bugs easier.
>  
>  	  There is no runtime or memory usage effect of this option
> -	  once the kernel has booted up - it's a one time check.
> +	  once the kernel has booted up, it only automatically checks once.
> +
> +	  Enables the "check_wx_pages" debugfs entry for checking at runtime.
>  
>  	  If in doubt, say "Y".
>  
> diff --git a/arch/powerpc/mm/ptdump/ptdump.c b/arch/powerpc/mm/ptdump/ptdump.c
> index 206156255247..a15e19a3b14e 100644
> --- a/arch/powerpc/mm/ptdump/ptdump.c
> +++ b/arch/powerpc/mm/ptdump/ptdump.c
> @@ -4,7 +4,7 @@
>   *
>   * This traverses the kernel pagetables and dumps the
>   * information about the used sections of memory to
> - * /sys/kernel/debug/kernel_pagetables.
> + * /sys/kernel/debug/kernel_page_tables.
>   *
>   * Derived from the arm64 implementation:
>   * Copyright (c) 2014, The Linux Foundation, Laura Abbott.
> @@ -413,6 +413,25 @@ void ptdump_check_wx(void)
>  	else
>  		pr_info("Checked W+X mappings: passed, no W+X pages found\n");
>  }
> +
> +static int check_wx_debugfs_set(void *data, u64 val)
> +{
> +	if (val != 1ULL)
> +		return -EINVAL;
> +
> +	ptdump_check_wx();
> +
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(check_wx_fops, NULL, check_wx_debugfs_set, "%llu\n");
> +
> +static int ptdump_check_wx_init(void)
> +{
> +	return debugfs_create_file("check_wx_pages", 0200, NULL,
> +				   NULL, &check_wx_fops) ? 0 : -ENOMEM;
> +}
> +device_initcall(ptdump_check_wx_init);
>  #endif
>  
>  static int ptdump_init(void)
> -- 
> 2.25.1
> 

-- 
Kees Cook
