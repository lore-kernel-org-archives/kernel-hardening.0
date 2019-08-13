Return-Path: <SRS0=D6P/=WJ=lists.openwall.com=kernel-hardening-return-16786-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EBEC433FF
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Aug 2019 15:01:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2C4B72084D
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Aug 2019 15:01:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HfdlKLK7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C4B72084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16786-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21939 invoked by uid 550); 13 Aug 2019 15:01:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21907 invoked from network); 13 Aug 2019 15:01:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dl4zVREy4GL+zTPrnysS4JlC3AXp76Unucw3J+BxEXY=;
        b=HfdlKLK7w5ckYWTiIAzA/VwjXyExjaFSKoh7zzeDJPrIWm6F5UJ3581EHNU4Zr+p/p
         LKtfzmYDqbq8e9GirSLRDUTaIGLRyk//tHb+E/npw4iLXU48CvIEHVjQdaTYHZKekBiB
         tzmV0Kwef9RmZK+5l0x0sOexOKP018DtqrLJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dl4zVREy4GL+zTPrnysS4JlC3AXp76Unucw3J+BxEXY=;
        b=jZhe6HLD6rfOSc/S6PNzg6FAzvqDovdpVTIJPvfZoZBfs+rD0RLOPdBXpr4vTr5xx6
         Pvqlyht2FUlVmjWRzsU46cQXAogr4RXpwQajDFVigjyT9jJqB+R1ffI2jhqlf+oz17GV
         7jvSKqIia1JHbcT+/myRixXLZ1+JIjYhOHQ2ZMIQ6olfQ1l+JaO3ONk6M5FqN22QrqIx
         ih10jir2/L2XIEEUVV2SJPjTWqz6JQ5PjSd0K+4ar0iEx6XPAMY5wbMHYo1dRSaeyBQZ
         w3qTv3zniI/B8Oa/N/Lak0++HqHXcukQFDVpbx+0yPzZlCkP06cKUgcUQ6SDh1xkZ1JD
         TFaQ==
X-Gm-Message-State: APjAAAVMxuOosbHQQJvtyVtxrk2LREsMe91cN8TjmYQ5nX/7QJOEMgto
	4IqyqNutkveVWv1zkAU2U2b9IA==
X-Google-Smtp-Source: APXvYqxUaIs7z51V78IT1RtONuWfId/F36pH8j+pzIUb1yCPTkEy3q7fsBAIl1Cp3wlvwc3MDZRv/A==
X-Received: by 2002:a17:90a:9f46:: with SMTP id q6mr2558368pjv.110.1565708454954;
        Tue, 13 Aug 2019 08:00:54 -0700 (PDT)
Date: Tue, 13 Aug 2019 08:00:53 -0700
From: Kees Cook <keescook@chromium.org>
To: zhe.he@windriver.com
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] gcc-plugins: Enable error message print
Message-ID: <201908130755.A44C39B46@keescook>
References: <1565689489-309136-1-git-send-email-zhe.he@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565689489-309136-1-git-send-email-zhe.he@windriver.com>

On Tue, Aug 13, 2019 at 05:44:49PM +0800, zhe.he@windriver.com wrote:
> From: He Zhe <zhe.he@windriver.com>
> 
> Instead of sliently emptying CONFIG_PLUGIN_HOSTCC which is the dependency
> of a series of configurations, the following error message would be easier
> for users to find something is wrong and what is happening.
> 
> scripts/gcc-plugins/gcc-common.h:5:22: fatal error: bversion.h:
> No such file or directory
> compilation terminated.
> 
> Now that we have already got the error message switch, let's turn it on.
> 
> Signed-off-by: He Zhe <zhe.he@windriver.com>

Hi!

Yeah, this would be helpful, but unfortunately it would be very noisy
for many people who don't have the GCC plugins installed. It used to
print error messages when it was a selectable Kconfig option but now
that it is autodetected, we can't show the errors unconditionally.

I would love to have some kind of way to answer the question "why isn't
this option available?" in Kconfig. The best place for this might be in
the menuconfig search option, but I'm not sure how to wire up other
things like it.

-Kees

> ---
>  scripts/gcc-plugins/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
> index d33de0b..fe28cb9 100644
> --- a/scripts/gcc-plugins/Kconfig
> +++ b/scripts/gcc-plugins/Kconfig
> @@ -3,7 +3,7 @@ preferred-plugin-hostcc := $(if-success,[ $(gcc-version) -ge 40800 ],$(HOSTCXX),
>  
>  config PLUGIN_HOSTCC
>  	string
> -	default "$(shell,$(srctree)/scripts/gcc-plugin.sh "$(preferred-plugin-hostcc)" "$(HOSTCXX)" "$(CC)")" if CC_IS_GCC
> +	default "$(shell,$(srctree)/scripts/gcc-plugin.sh --show-error "$(preferred-plugin-hostcc)" "$(HOSTCXX)" "$(CC)")" if CC_IS_GCC
>  	help
>  	  Host compiler used to build GCC plugins.  This can be $(HOSTCXX),
>  	  $(HOSTCC), or a null string if GCC plugin is unsupported.
> -- 
> 2.7.4
> 

-- 
Kees Cook
