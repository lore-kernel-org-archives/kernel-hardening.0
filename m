Return-Path: <SRS0=22sm=5R=lists.openwall.com=kernel-hardening-return-18356-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4794C43331
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 15:49:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0365E20658
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 15:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fYGIqS4w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0365E20658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18356-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1733 invoked by uid 550); 1 Apr 2020 15:49:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1701 invoked from network); 1 Apr 2020 15:49:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ySKX8LJGChHC8c8x0OQmrTxCx//5fIDMajpHfT6ERsw=;
        b=fYGIqS4w9FpClJWxf/snstu/bTH/DlaBxQ+pEq2Y/GNnZQYhfDgue/9Lz65NoujHM9
         LSxifCvxnIYPKf2GWZY90VOJwTSLJWpwxgDs7Js/2+jdx5gWGXq3ir2iVZK7zD365h/N
         P8618F8gyRMfSa+q7hWsIqDVOexwB7konfVek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ySKX8LJGChHC8c8x0OQmrTxCx//5fIDMajpHfT6ERsw=;
        b=pYvuEFZz0GxfKuK4FfuQb035coKa4Y46WkGCqLott6vl4dr6qFEbAIQ1uDqGtTcOrx
         K3nfNt1RRnjRcLz4lQ5MErCerComy5gRkoLoWmnBzAkNWRNcLm1KiI0iMbFNlxPLuMcg
         ziM1KWv2bFlUlI7zpYtBMshkZAUcS1akQyfI/77zPwaacuK5rw4RpL9w8STdOjNLgRII
         xhMl1TfAnCw+ftNLUkmzfx81arODk4vBlRIlLnqWSAwMrA0LVmAtegobEh0D7K3NN7Ow
         huFSBODeO101x1MWjPlycQdQyUWv26pjN3y6LMN3HbCdJl2aMSfam5gA/twsL/guIkGt
         hxzw==
X-Gm-Message-State: AGi0PuZ7THQbIelblKQVbt3iMsPbKh6RV/zi3cWgftEZdAz+iX0lAJWd
	hcOMshzAB9PgAFi5W6e9k+jdxg==
X-Google-Smtp-Source: APiQypKdrU/NsWejH1n/G3BfA3vTkH3qucG2TO6GKLDMoF3lPyJQdaiJTFZ4/arwCmTtqjxfFpIr1Q==
X-Received: by 2002:a17:90b:110f:: with SMTP id gi15mr5488512pjb.184.1585756165084;
        Wed, 01 Apr 2020 08:49:25 -0700 (PDT)
Date: Wed, 1 Apr 2020 08:49:22 -0700
From: Kees Cook <keescook@chromium.org>
To: Slava Bacherikov <slava@bacher09.org>
Cc: andriin@fb.com, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
	jannh@google.com, alexei.starovoitov@gmail.com,
	daniel@iogearbox.net, kernel-hardening@lists.openwall.com,
	liuyd.fnst@cn.fujitsu.com, KP Singh <kpsingh@google.com>
Subject: Re: [PATCH v3 bpf] kbuild: fix dependencies for DEBUG_INFO_BTF
Message-ID: <202004010849.CC7E9412@keescook>
References: <202004010033.A1523890@keescook>
 <20200401142057.453892-1-slava@bacher09.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401142057.453892-1-slava@bacher09.org>

On Wed, Apr 01, 2020 at 05:20:58PM +0300, Slava Bacherikov wrote:
> Currently turning on DEBUG_INFO_SPLIT when DEBUG_INFO_BTF is also
> enabled will produce invalid btf file, since gen_btf function in
> link-vmlinux.sh script doesn't handle *.dwo files.
> 
> Enabling DEBUG_INFO_REDUCED will also produce invalid btf file, and
> using GCC_PLUGIN_RANDSTRUCT with BTF makes no sense.
> 
> Signed-off-by: Slava Bacherikov <slava@bacher09.org>

Very cool; thanks! :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> Reported-by: Jann Horn <jannh@google.com>
> Reported-by: Liu Yiding <liuyd.fnst@cn.fujitsu.com>
> Acked-by: KP Singh <kpsingh@google.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Fixes: e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")
> ---
>  lib/Kconfig.debug | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index f61d834e02fe..b94227be2d62 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -222,7 +222,9 @@ config DEBUG_INFO_DWARF4
>  
>  config DEBUG_INFO_BTF
>  	bool "Generate BTF typeinfo"
> -	depends on DEBUG_INFO
> +	depends on DEBUG_INFO || COMPILE_TEST
> +	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
> +	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
>  	help
>  	  Generate deduplicated BTF type information from DWARF debug info.
>  	  Turning this on expects presence of pahole tool, which will convert

-- 
Kees Cook
