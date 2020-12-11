Return-Path: <SRS0=cFbk=FP=lists.openwall.com=kernel-hardening-return-20599-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8326EC433FE
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 19:32:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6613624058
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 19:32:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6613624058
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20599-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29824 invoked by uid 550); 11 Dec 2020 19:32:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29802 invoked from network); 11 Dec 2020 19:32:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9QrTgvGnEakPURCqXO9kVzpnI7sAnsn5QLKAoF8jKto=;
        b=YlRVVR0J3SWrOJLo/jmkZifU0GgnWNus/X2mN9j9Dpcm7OnTYCv0w8dDeiXJOhRtKq
         qntCWLVR/OxbTujk2vmdnbE+xvAC7RGanwD7OUpSCuC6myv5NZOsA1/lV5o5GCQIcu3w
         ysXWmzmxZxCXJMR5DqDqZeAn155foWYOHtnKY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9QrTgvGnEakPURCqXO9kVzpnI7sAnsn5QLKAoF8jKto=;
        b=lg+ZQj4SNdPraA/ThwhMJE+o0uazkTELPIFnnIo1de2vuHQUkz1FXgLcYH7euhDa3C
         veySJXhrR+FMiiRAlPYFVfB+SCJB3tUOSfocrRU6EHqaL6FzXKB3zQDLoL0dY7KNLYYb
         TE+D/ohdR0PydZQDA7mzDz5GbHqtl8NWTe9ChSdXUIAywBHgazb8OfSZCIFXy7FIIlPK
         OZRLIukg7wiTLYI7OwmNaG/F384Kj/hAw5xYTsX9ARNtecpUdekTNnpU8XhA9PpeWgfL
         ODYNwA8jnBQMeFQCyzkv1/sF6d6MiHIQJAZUi5Ih9JrFUfJ+lAHWfm0ISDqPXezsW3Zu
         Ac3A==
X-Gm-Message-State: AOAM532Y/rngk9zztpLgCMxdsNlnNylPHURP09Tgz3IIgkGIv2VUgEdn
	Vxz8StMJ702JwiptjiteaTq4DQ==
X-Google-Smtp-Source: ABdhPJxsthqMVhRTxK9zln6OgOykAvCX/6nw+GaT6GPANSQFH6ft5S0zc7PNaBcACeYW35bsdNRUig==
X-Received: by 2002:a17:902:123:b029:da:420e:aab0 with SMTP id 32-20020a1709020123b02900da420eaab0mr12377208plb.30.1607715155648;
        Fri, 11 Dec 2020 11:32:35 -0800 (PST)
Date: Fri, 11 Dec 2020 11:32:33 -0800
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v9 06/16] kbuild: lto: add a default list of used symbols
Message-ID: <202012111131.E41AFFCDB@keescook>
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <20201211184633.3213045-7-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211184633.3213045-7-samitolvanen@google.com>

On Fri, Dec 11, 2020 at 10:46:23AM -0800, Sami Tolvanen wrote:
> With CONFIG_LTO_CLANG, LLVM bitcode has not yet been compiled into a
> binary when the .mod files are generated, which means they don't yet
> contain references to certain symbols that will be present in the final
> binaries. This includes intrinsic functions, such as memcpy, memmove,
> and memset [1], and stack protector symbols [2]. This change adds a
> default symbol list to use with CONFIG_TRIM_UNUSED_KSYMS when Clang's
> LTO is used.
> 
> [1] https://llvm.org/docs/LangRef.html#standard-c-c-library-intrinsics
> [2] https://llvm.org/docs/LangRef.html#llvm-stackprotector-intrinsic
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

> ---
>  init/Kconfig                | 1 +
>  scripts/lto-used-symbollist | 5 +++++
>  2 files changed, 6 insertions(+)
>  create mode 100644 scripts/lto-used-symbollist
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 0872a5a2e759..e88c919c1bf1 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -2297,6 +2297,7 @@ config TRIM_UNUSED_KSYMS
>  config UNUSED_KSYMS_WHITELIST
>  	string "Whitelist of symbols to keep in ksymtab"
>  	depends on TRIM_UNUSED_KSYMS
> +	default "scripts/lto-used-symbollist" if LTO_CLANG
>  	help
>  	  By default, all unused exported symbols will be un-exported from the
>  	  build when TRIM_UNUSED_KSYMS is selected.
> diff --git a/scripts/lto-used-symbollist b/scripts/lto-used-symbollist
> new file mode 100644
> index 000000000000..38e7bb9ebaae
> --- /dev/null
> +++ b/scripts/lto-used-symbollist
> @@ -0,0 +1,5 @@
> +memcpy
> +memmove
> +memset
> +__stack_chk_fail
> +__stack_chk_guard
> -- 
> 2.29.2.576.ga3fc446d84-goog
> 

bikeshed: Should this filename use some kind of extension, like
lto-user-symbols.txt or .list, to make it more human-friendly?

-- 
Kees Cook
