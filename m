Return-Path: <SRS0=QiFq=DV=lists.openwall.com=kernel-hardening-return-20209-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1474AC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 22:50:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1BB712223F
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 22:50:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hr4N6hwj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BB712223F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20209-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9317 invoked by uid 550); 14 Oct 2020 22:50:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9285 invoked from network); 14 Oct 2020 22:50:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3VrWtG2Nzyu2csFSOGvGre3/3hIZgGNscPNIfDNpl2k=;
        b=hr4N6hwj+08gozMcwrEdmSN1/DHjJ1wV/rjoECw8Rb2Lo+XQgEYgDpitXER6aen3HX
         eXkJa61f3G1/5SOO7jrmjCFOzgysn3m/odJ4K0c9h+p6mhA72fUnwN1sijYXM89+e5/y
         E6EY2141rat0DkfG+cb3u9htDo0fyWs7u+jCA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3VrWtG2Nzyu2csFSOGvGre3/3hIZgGNscPNIfDNpl2k=;
        b=YLPNyCcVSVJqanoApkFeo/MmCTbpNRmce2BBo+vc5kjzmKZJkofV2P3UwBRAsyc8/u
         M/kp4QgpsTNI1b62XCVqBT2D98cki0g26bPsM2FBucxTUod6ZhJzAGG+NBW1g2SbMj4M
         pjcJ/Xxmbvrwo3mMuJTfKxA/0JDO94UKBiOOazoxtVYScSu2sJI9dvrCU6FelIHFDj0e
         7XB246sZ9o1yIcuDzSBGO+HyLXnX9lckBV1lBPqnFw+ozmrILeqNMOb+UnJNInFc10UB
         RRd88HsVaZraQA0jikEC+0s3SnzFFCzK7l2WaDzw2k6+jYrc8LG/l025Mbp7Oq4crjUA
         l01Q==
X-Gm-Message-State: AOAM531O8ASl0V+JyRt3pRhFx6vjDc+x906Egsg/FcTx1G1LY+OMyt93
	VM3JjMtN1Zph9bF+OlRUjQQ5Qw==
X-Google-Smtp-Source: ABdhPJy3mXoDsP85zSkY2lnijaDX4p6o9n8i+9WfyCkbfe3bfD5GCGw8G2jBei5i1UDoglc5TJDPQA==
X-Received: by 2002:a62:1856:0:b029:155:1718:91a3 with SMTP id 83-20020a6218560000b0290155171891a3mr1359345pfy.66.1602715830672;
        Wed, 14 Oct 2020 15:50:30 -0700 (PDT)
Date: Wed, 14 Oct 2020 15:50:28 -0700
From: Kees Cook <keescook@chromium.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v6 14/25] kbuild: lto: remove duplicate dependencies from
 .mod files
Message-ID: <202010141549.412F2BF0@keescook>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-15-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013003203.4168817-15-samitolvanen@google.com>

On Mon, Oct 12, 2020 at 05:31:52PM -0700, Sami Tolvanen wrote:
> With LTO, llvm-nm prints out symbols for each archive member
> separately, which results in a lot of duplicate dependencies in the
> .mod file when CONFIG_TRIM_UNUSED_SYMS is enabled. When a module
> consists of several compilation units, the output can exceed the
> default xargs command size limit and split the dependency list to
> multiple lines, which results in used symbols getting trimmed.
> 
> This change removes duplicate dependencies, which will reduce the
> probability of this happening and makes .mod files smaller and
> easier to read.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Hi Masahiro,

This appears to be a general improvement as well. This looks like it can
land without depending on the rest of the series.

-Kees

> ---
>  scripts/Makefile.build | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index ab0ddf4884fd..96d6c9e18901 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -266,7 +266,7 @@ endef
>  
>  # List module undefined symbols (or empty line if not enabled)
>  ifdef CONFIG_TRIM_UNUSED_KSYMS
> -cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | xargs echo
> +cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | sort -u | xargs echo
>  else
>  cmd_undef_syms = echo
>  endif
> -- 
> 2.28.0.1011.ga647a8990f-goog
> 

-- 
Kees Cook
