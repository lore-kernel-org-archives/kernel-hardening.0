Return-Path: <SRS0=VPJv=5R=lists.openwall.com=kernel-hardening-return-18350-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAE0C2D0F2
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 07:35:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 397D220772
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 07:35:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CzwRDrj2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 397D220772
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18350-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26273 invoked by uid 550); 1 Apr 2020 07:35:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26235 invoked from network); 1 Apr 2020 07:35:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e9j0gXLS8BiPnG8hg4KhkQMvt4m3nuldxIMCe99NUSM=;
        b=CzwRDrj2h0sa5kX72PUVDeT6L3fY9qudsdi8KkOaBKK9gQI9Rk35RY8a+tf/7T/90X
         Zl5oGkGuBSVb657tgNqL16cqTQjKM3o1b6z/xqQcfhcf5YAqC/8MEoQ6vJl0xnuS4T1p
         bLhOvG+N19w8AdK3xAI90GJXQBJzHg/Idzk0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e9j0gXLS8BiPnG8hg4KhkQMvt4m3nuldxIMCe99NUSM=;
        b=TlrU/AMr2cCa/VaOrm5B7OJ+SQIwAuIVB4spBtet4IB6/GxbUKf+cOBSExvdZ8/t8e
         GLcnMqgQWTI+ITCD8gkFaapC7es9hgdrlY35AAtBxAJ0YbovKXmCOvNfnx6NPGcOaQ+3
         4qjiplLzNbuD0NzYFu3LdRW2qUgvxC+bb40DKgQG+qJ5iREEZmfvZm2yFYCUW/0Yg/ab
         UgIXFRrsq59Axh0LXo60H4vLuAbnoqoCgZhBs+/IRklPJxIWjP7d6bH5AWAZOe1rJGGS
         egPCiu/kmCrUuQuwlZWlUgYcjQDetssDqHlumyl/w1YP/LiQ0oL3wxrKZMqNToBcsp6r
         DjFg==
X-Gm-Message-State: AGi0PubnR8BfrH/UZJZw7TLxPjr7qORH/sgZABP6Rnyn4WXNnRmIqOpQ
	tBEnIZunqdEb2zPQoOpf0CIt0g==
X-Google-Smtp-Source: APiQypJDNRDZ33Sc9rxPUXsp2xFXUXbugulWQqiDDPonuNaxSEsO5TuU3WlX80cycoM1zufaEYn2wA==
X-Received: by 2002:a17:902:6acc:: with SMTP id i12mr7180158plt.61.1585726494195;
        Wed, 01 Apr 2020 00:34:54 -0700 (PDT)
Date: Wed, 1 Apr 2020 00:34:52 -0700
From: Kees Cook <keescook@chromium.org>
To: Slava Bacherikov <slava@bacher09.org>
Cc: andriin@fb.com, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
	jannh@google.com, alexei.starovoitov@gmail.com,
	daniel@iogearbox.net, kernel-hardening@lists.openwall.com,
	Liu Yiding <liuyd.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v2 bpf] kbuild: fix dependencies for DEBUG_INFO_BTF
Message-ID: <202004010033.A1523890@keescook>
References: <20200331215536.34162-1-slava@bacher09.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331215536.34162-1-slava@bacher09.org>

On Wed, Apr 01, 2020 at 12:55:37AM +0300, Slava Bacherikov wrote:
> Currently turning on DEBUG_INFO_SPLIT when DEBUG_INFO_BTF is also
> enabled will produce invalid btf file, since gen_btf function in
> link-vmlinux.sh script doesn't handle *.dwo files.
> 
> Enabling DEBUG_INFO_REDUCED will also produce invalid btf file, and
> using GCC_PLUGIN_RANDSTRUCT with BTF makes no sense.
> 
> Signed-off-by: Slava Bacherikov <slava@bacher09.org>
> Reported-by: Jann Horn <jannh@google.com>
> Reported-by: Liu Yiding <liuyd.fnst@cn.fujitsu.com>
> Fixes: e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")
> ---
>  lib/Kconfig.debug | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index f61d834e02fe..9ae288e2a6c0 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -223,6 +223,7 @@ config DEBUG_INFO_DWARF4
>  config DEBUG_INFO_BTF
>  	bool "Generate BTF typeinfo"
>  	depends on DEBUG_INFO
> +	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED && !GCC_PLUGIN_RANDSTRUCT
>  	help
>  	  Generate deduplicated BTF type information from DWARF debug info.
>  	  Turning this on expects presence of pahole tool, which will convert

Please make this:

depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
depends on COMPILE_TEST || !GCC_PLUGIN_RANDSTRUCT

-Kees

-- 
Kees Cook
