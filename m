Return-Path: <SRS0=EKQB=2B=lists.openwall.com=kernel-hardening-return-17495-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A8BC43603
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Dec 2019 13:59:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 952D9214D8
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Dec 2019 13:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H8UZouch"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 952D9214D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17495-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29817 invoked by uid 550); 11 Dec 2019 13:59:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29774 invoked from network); 11 Dec 2019 13:59:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=STaNEtWndnwuAqqhmXVnDhNs+/7QG3rCPR52EQWWaas=;
        b=H8UZouchmiK0Y13YNR0SwBb+PKetsAbTms3YnTspLwes/xLjaIGRijl06ZP9T/cWhL
         eL0jssfAK++uUWsJ+aOMGrdnzq5QH1jQtnzTzB7dj1tfmDziq8+BoZkfyIlaxdyE9CCM
         GhWR+kt0PNgI+E5NjbSENGvL/yWvUasNFalqQGuFTAFdKkC7vMpxIs0RUu9RsRN0lvuu
         uH8cbM+Pt3j+q9QsbwWwSwa/iQB592ABHABHAEDd1WH8FCeLFHyQOdCaCqYOEyAhFTlU
         P/ODSOaB2X7AKgLJo11KL20XSy761EVB73m9jR6fgcPYgmX0mTlkwrTkUagSHh22wNFG
         qEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=STaNEtWndnwuAqqhmXVnDhNs+/7QG3rCPR52EQWWaas=;
        b=fw9uT/5PKGygSi8+QdPvQEJSyerpZQybBWQAmPWZPgD76a07V+A2KJwYBaIc7eZ6FC
         RJZfL4ll5XBpqvm+5qYzJfHlu/kyvCcLy7GN6msqfL6ndGBO/QGIuHV/5v3Yol8LrxAz
         9NX0uFiWpsotNvhNBPGOWDXIhB4CUnL4lhHJnTWFR3eRLZTzuDZ8YQRu4N3Zr63D6qAj
         itNlv+huCiOqZhvKLkUIt45z3tZ6LkDnchKMxJzOqr1GH1MFrJVaTbz6AymFmWSulHfI
         fG7Gc4YcCkTSRIWqqeIjM7FIbLdUE8jwPr8RnXf4sVwcrhEOnpGSJUONP5tqcN4Cqr7F
         RN3g==
X-Gm-Message-State: APjAAAWVusrCFSY8VN+edEiYbV9+zSFlhy3QOzsJTcfrPtqVsJPlB3Ny
	tq/Q1aFKZ4tiyv3rD03xIobh+qNOI8ZsL5NI7hYa8w==
X-Google-Smtp-Source: APXvYqxrnY22qG46E2qM1V+u18BpTO3sW9wSH/3ZXlho4UR4T0gYJ7K7pbXJtIkZxgRF9nLpKcVXc1X1jYSASiOVKoA=
X-Received: by 2002:a5d:46c1:: with SMTP id g1mr3933196wrs.200.1576072774421;
 Wed, 11 Dec 2019 05:59:34 -0800 (PST)
MIME-Version: 1.0
References: <20191211133951.401933-1-arnd@arndb.de>
In-Reply-To: <20191211133951.401933-1-arnd@arndb.de>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 11 Dec 2019 14:59:23 +0100
Message-ID: <CAKv+Gu8yaz8uekq3taUaxWOs95yVB_tRaoKM0N2EBKSzWOhExw@mail.gmail.com>
Subject: Re: [PATCH] gcc-plugins: make it possible to disable
 CONFIG_GCC_PLUGINS again
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	Emese Revfy <re.emese@gmail.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Andrey Ryabinin <aryabinin@virtuozzo.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Dec 2019 at 14:40, Arnd Bergmann <arnd@arndb.de> wrote:
>
> I noticed that randconfig builds with gcc no longer produce a lot of
> ccache hits, unlike with clang, and traced this back to plugins
> now being enabled unconditionally if they are supported.
>
> I am now working around this by adding
>
>    export CCACHE_COMPILERCHECK=/usr/bin/size -A %compiler%
>
> to my top-level Makefile. This changes the heuristic that ccache uses
> to determine whether the plugins are the same after a 'make clean'.
>
> However, it also seems that being able to just turn off the plugins is
> generally useful, at least for build testing it adds noticeable overhead
> but does not find a lot of bugs additional bugs, and may be easier for
> ccache users than my workaround.
>
> Fixes: 9f671e58159a ("security: Create "kernel hardening" config area")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  scripts/gcc-plugins/Kconfig | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
> index d33de0b9f4f5..e3569543bdac 100644
> --- a/scripts/gcc-plugins/Kconfig
> +++ b/scripts/gcc-plugins/Kconfig
> @@ -14,8 +14,8 @@ config HAVE_GCC_PLUGINS
>           An arch should select this symbol if it supports building with
>           GCC plugins.
>
> -config GCC_PLUGINS
> -       bool
> +menuconfig GCC_PLUGINS
> +       bool "GCC plugins"
>         depends on HAVE_GCC_PLUGINS
>         depends on PLUGIN_HOSTCC != ""
>         default y
> @@ -25,8 +25,7 @@ config GCC_PLUGINS
>
>           See Documentation/core-api/gcc-plugins.rst for details.
>
> -menu "GCC plugins"
> -       depends on GCC_PLUGINS
> +if GCC_PLUGINS
>
>  config GCC_PLUGIN_CYC_COMPLEXITY
>         bool "Compute the cyclomatic complexity of a function" if EXPERT
> @@ -113,4 +112,4 @@ config GCC_PLUGIN_ARM_SSP_PER_TASK
>         bool
>         depends on GCC_PLUGINS && ARM
>
> -endmenu
> +endif
> --
> 2.20.0
>
