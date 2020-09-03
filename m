Return-Path: <SRS0=KM3w=CM=lists.openwall.com=kernel-hardening-return-19760-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47090C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:20:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6407120767
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:20:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jxDHCE4P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6407120767
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19760-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13548 invoked by uid 550); 3 Sep 2020 22:19:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13514 invoked from network); 3 Sep 2020 22:19:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MWNxdRC9o4O5cBaQMtBrWZaTyq9NHomAWBLJ5BXZ/Cg=;
        b=jxDHCE4PSws5lQZxdXVDEjhRQTdgtlSfRbx8rYkpCfQICEnOWSuKZ7dWjeNOju7dHs
         JEdGW0U96wxe5VP81V1HIKryHZ+2sUEbGwgPTUa5Or2pgLw9K4kqUUj39f1wAlZHuNJ6
         G7nevfW8wKYTznCuyu42z91ddeu7fJXntaESc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MWNxdRC9o4O5cBaQMtBrWZaTyq9NHomAWBLJ5BXZ/Cg=;
        b=ClFE9IeaKiXraePUBtPMs4srQykI8RYZswjX3+rt1+Ls9FoNrOAj9OLA13FXaTnrqO
         SIGdv7k4Le5k45oONNmjUeh7n3FDLvASVQWYgzFW2mP+r5JQitcTnZvpA9SpPgvOlOrR
         /89YKrhYu3WytAhL6LsdiP0Gp3uWKsvuoeJil2Za9W9+sfQZ9yf57bNQlr3KzGAt2KQ0
         YHJsNHrmiFngRAJFQF9wKO0ftfLe7NueOLAJRBOYm5mJct7bmFUxaifNXaIL7SdQCTMh
         wdbWIIS7jTURfgZy0xb422ljZnlzPrhqQN9f4uUyhaEcSI+XpP6NE4SD6IgR9ohCrXNm
         eJyA==
X-Gm-Message-State: AOAM5314SIm/LcjE/jb81rDGlPgfYjLzOlsoYizsnwIvFZMQ01eItjLQ
	yxLFudHy7GqAU0JlW10tdb6QOA==
X-Google-Smtp-Source: ABdhPJyiQdJtuSv4chDGmJRkFDeKEEXRJWc13sRcliVwROf2KadwLW6WYWrupCYc5UO95rWT0iVSnQ==
X-Received: by 2002:a05:6a00:14ce:: with SMTP id w14mr5536446pfu.119.1599171585674;
        Thu, 03 Sep 2020 15:19:45 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:19:43 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 11/28] kbuild: lto: postpone objtool
Message-ID: <202009031513.B558594FB9@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-12-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-12-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:36PM -0700, Sami Tolvanen wrote:
> With LTO, LLVM bitcode won't be compiled into native code until
> modpost_link, or modfinal for modules. This change postpones calls
> to objtool until after these steps.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

For a "fail fast" style of building, it makes sense to have objtool run
as early as possible, so it makes sense to keep the current behavior in
non-LTO mode. I do wonder, though, if there is a real benefit to having
"fail fast" case. I imagine a lot of automated builds are using
--keep-going with make, and actually waiting until the end to do the
validation means more code will get build-tested before objtool rejects
the results. *shrug*

> ---
>  arch/Kconfig              |  2 +-
>  scripts/Makefile.build    |  2 ++
>  scripts/Makefile.modfinal | 24 ++++++++++++++++++++++--
>  scripts/link-vmlinux.sh   | 23 ++++++++++++++++++++++-
>  4 files changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 71392e4a8900..7a418907e686 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -599,7 +599,7 @@ config LTO_CLANG
>  	depends on $(success,$(NM) --help | head -n 1 | grep -qi llvm)
>  	depends on $(success,$(AR) --help | head -n 1 | grep -qi llvm)
>  	depends on ARCH_SUPPORTS_LTO_CLANG
> -	depends on !FTRACE_MCOUNT_RECORD
> +	depends on HAVE_OBJTOOL_MCOUNT || !(X86_64 && DYNAMIC_FTRACE)
>  	depends on !KASAN
>  	depends on !GCOV_KERNEL
>  	select LTO
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index c348e6d6b436..b8f1f0d65a73 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -218,6 +218,7 @@ cmd_record_mcount = $(if $(findstring $(strip $(CC_FLAGS_FTRACE)),$(_c_flags)),
>  endif # USE_RECORDMCOUNT
>  
>  ifdef CONFIG_STACK_VALIDATION
> +ifndef CONFIG_LTO_CLANG
>  ifneq ($(SKIP_STACK_VALIDATION),1)
>  
>  __objtool_obj := $(objtree)/tools/objtool/objtool
> @@ -253,6 +254,7 @@ objtool_obj = $(if $(patsubst y%,, \
>  	$(__objtool_obj))
>  
>  endif # SKIP_STACK_VALIDATION
> +endif # CONFIG_LTO_CLANG
>  endif # CONFIG_STACK_VALIDATION
>  
>  # Rebuild all objects when objtool changes, or is enabled/disabled.
> diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
> index 1005b147abd0..909bd509edb4 100644
> --- a/scripts/Makefile.modfinal
> +++ b/scripts/Makefile.modfinal
> @@ -34,10 +34,30 @@ ifdef CONFIG_LTO_CLANG
>  # With CONFIG_LTO_CLANG, reuse the object file we compiled for modpost to
>  # avoid a second slow LTO link
>  prelink-ext := .lto
> -endif
> +
> +# ELF processing was skipped earlier because we didn't have native code,
> +# so let's now process the prelinked binary before we link the module.
> +
> +ifdef CONFIG_STACK_VALIDATION
> +ifneq ($(SKIP_STACK_VALIDATION),1)
> +cmd_ld_ko_o +=								\
> +	$(objtree)/tools/objtool/objtool				\
> +		$(if $(CONFIG_UNWINDER_ORC),orc generate,check)		\
> +		--module						\
> +		$(if $(CONFIG_FRAME_POINTER),,--no-fp)			\
> +		$(if $(CONFIG_GCOV_KERNEL),--no-unreachable,)		\
> +		$(if $(CONFIG_RETPOLINE),--retpoline,)			\
> +		$(if $(CONFIG_X86_SMAP),--uaccess,)			\
> +		$(if $(USE_OBJTOOL_MCOUNT),--mcount,)			\
> +		$(@:.ko=$(prelink-ext).o);
> +
> +endif # SKIP_STACK_VALIDATION
> +endif # CONFIG_STACK_VALIDATION

I wonder if objtool_args could be reused here instead of having two
places to keep in sync? It looks like that might mean moving things
around a bit before this patch, since I can't quite see if
Makefile.build's variables are visible to Makefile.modfinal?

> +
> +endif # CONFIG_LTO_CLANG
>  
>  quiet_cmd_ld_ko_o = LD [M]  $@
> -      cmd_ld_ko_o =                                                     \
> +      cmd_ld_ko_o +=                                                     \
>  	$(LD) -r $(KBUILD_LDFLAGS)					\
>  		$(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE)		\
>  		$(addprefix -T , $(KBUILD_LDS_MODULE))			\
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index 3e99a19b9195..a352a5ad9ef7 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -93,8 +93,29 @@ objtool_link()
>  {
>  	local objtoolopt;
>  
> +	if [ "${CONFIG_LTO_CLANG} ${CONFIG_STACK_VALIDATION}" = "y y" ]; then
> +		# Don't perform vmlinux validation unless explicitly requested,
> +		# but run objtool on vmlinux.o now that we have an object file.
> +		if [ -n "${CONFIG_UNWINDER_ORC}" ]; then
> +			objtoolopt="orc generate"
> +		else
> +			objtoolopt="check"
> +		fi
> +
> +		if [ -n ${USE_OBJTOOL_MCOUNT} ]; then
> +			objtoolopt="${objtoolopt} --mcount"
> +		fi
> +	fi
> +
>  	if [ -n "${CONFIG_VMLINUX_VALIDATION}" ]; then
> -		objtoolopt="check --vmlinux"
> +		if [ -z "${objtoolopt}" ]; then
> +			objtoolopt="check --vmlinux"
> +		else
> +			objtoolopt="${objtoolopt} --vmlinux"
> +		fi
> +	fi
> +
> +	if [ -n "${objtoolopt}" ]; then
>  		if [ -z "${CONFIG_FRAME_POINTER}" ]; then
>  			objtoolopt="${objtoolopt} --no-fp"
>  		fi
> -- 
> 2.28.0.402.g5ffc5be6b7-goog
> 

-- 
Kees Cook
