Return-Path: <SRS0=YlgV=AF=lists.openwall.com=kernel-hardening-return-19136-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7598AC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:14:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C1F4C20768
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:14:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ogyMpgi9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1F4C20768
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19136-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17854 invoked by uid 550); 24 Jun 2020 21:14:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17819 invoked from network); 24 Jun 2020 21:14:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=omCkUcZNHVXP0sWRywzjOwxTXZ4YyisMAxm749WU5GU=;
        b=ogyMpgi9tPFXqD3+b4TskFtzlAE3qRSfSFlhxLkMzfZQl068z8vqJlL5I/k1hQA4j2
         8+KaTuQNKpStTyBjn2ssQsUKa/GWq7f607kaEaeXU2o8/Ft2sUgUsqmcJHltC+KgIKVl
         o3jZ4P3X6AywcFpecW/k8P5ZOrqPI9Z99iVivwkxvFoyUq4G2KcudRcYQ4mOacJiN+sQ
         WfzuwRbr7it+GIQZRqsNndeZ4kbhXyBxzlSPEB5SEo0dkcZcdM6751ifbYi1L0YxNGzl
         zLZYU7QD65uDvjwEcqlKMDaY6jKyUjhUxCFnXE3C+lzv6bRpSkWGLHXOkAgDh/7Se2CC
         j7Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=omCkUcZNHVXP0sWRywzjOwxTXZ4YyisMAxm749WU5GU=;
        b=pXGfC2TgrzURoPQMSgHCrFSwtwAl3arIRro5ajOjcMCR+WBoVieEzj4Kg0HWMhLFFV
         TC7cHjz428TvKPapBLO/9FSUpqqNIANHOFqqtJIYbBCguO+XqbzNCDt27vtGJD9vXiXE
         G2sSek2jhQqfiS7Ida3fu0zWCkzlKH1Ku/qvaY9tRM952MmCgcOIHdqvOcuARnhWMLZX
         ufO4guCVJbaRh5ntJrJZc350sUNY4SCdM6Hdb6b67gqZb8QxA15De413Gi7MucPKdbJx
         qYDp44pEODDbSDkiWy/MpUYNtrUHihtQAqMTkmnU1ZDBkydVM41Zj06QWQBlQz0Ck2+5
         MGIA==
X-Gm-Message-State: AOAM532IU23bySX2kHzcs2nST6NeqgmqceHx/ZyOIzo1gt0JPnFnYL1L
	bM7y9dnX0PGjTLqoRuJz+kOtQ7+FckYQMofOWMzh+Q==
X-Google-Smtp-Source: ABdhPJyvmG5uGb8Lyk5i53Q9bt53kqBtuDjO8DoRXX4pnhndW+Y4vnp4+GK0S4oFxok0KRSkaflUBQ+yOxnxS3G2Ct0=
X-Received: by 2002:a17:902:b698:: with SMTP id c24mr29536869pls.223.1593033238474;
 Wed, 24 Jun 2020 14:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200624203200.78870-9-samitolvanen@google.com>
In-Reply-To: <20200624203200.78870-9-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 24 Jun 2020 14:13:46 -0700
Message-ID: <CAKwvOdmcDxa+h9i6_XQc8ZDQjD9cTrD7s9eNU0fSxZbXciKhDQ@mail.gmail.com>
Subject: Re: [PATCH 08/22] kbuild: lto: remove duplicate dependencies from
 .mod files
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 24, 2020 at 1:33 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
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

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  scripts/Makefile.build | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 82977350f5a6..82b465ce3ca0 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -291,7 +291,7 @@ endef
>
>  # List module undefined symbols (or empty line if not enabled)
>  ifdef CONFIG_TRIM_UNUSED_KSYMS
> -cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | xargs echo
> +cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | sort -u | xargs echo
>  else
>  cmd_undef_syms = echo
>  endif
> --
> 2.27.0.212.ge8ba1cc988-goog
>


-- 
Thanks,
~Nick Desaulniers
