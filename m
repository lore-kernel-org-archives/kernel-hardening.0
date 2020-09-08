Return-Path: <SRS0=dcDD=CR=lists.openwall.com=kernel-hardening-return-19825-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A8CC43461
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 20:56:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 27F9D20732
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 20:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kqiVfXTq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27F9D20732
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19825-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3581 invoked by uid 550); 8 Sep 2020 20:56:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3548 invoked from network); 8 Sep 2020 20:56:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+1kwkhnnjfbD1n3YicFbQyeenHuldLrryzBMnu30RTk=;
        b=kqiVfXTqdvpE+D8HME82Bm/99OYWSZDGK7Oq76UCHFIRCcsokRD7oz4xAQHKlHR74v
         8jFd7Rm7VgphQioMxWqT6sB7WDRfEhiq+5dlPJB+VwsYe0Gws+0LJm6D9zwG/r15KK4j
         cuzPLvDpOo+kNSRVML9vt8TFZj2LIN0dx3+GMt+v/gfQiWWDTGc/5e1sfumXGI2CjeI6
         Wy++ioGxrd4TyZOe6AhKrFK49Dd0klSTZ4EyeBc8yeTCbAl+4UnrnXBHPmJZk+pzkRBq
         MO/Socm9d6L4MR4DbsbQU9qRVnfcNKA/i/3XI/d16ytiFjJKk9h0Y3hAMCxgdwcJ4siN
         gBjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+1kwkhnnjfbD1n3YicFbQyeenHuldLrryzBMnu30RTk=;
        b=Wxj7gtvAHvL07MMlw3A20j5HZJt/OHSOVz2rHJM1F9504ATH8jGb0CPPXORH8hRCri
         +phw8IRik1yGojEnwUB7NeGu0KKDBDMrWlW5VoEWhuRmkRf6swmU3wGavpmdJB8STpWP
         W+CNkr07Tx2I8+8f3heOEgoAA6TL70JKNyBLBG2YMRT94nxnZONIjEumnyOb2iTClpVi
         2EA7UteU4CKJ/b+fqfSap8telP07ukqgEqwn9SxYqXB6vIo/YG0hnbHiGp6rPVnvbNcl
         SKYZ1oOPGNpLKWeTfZg3lToh8NmjKaTfRyPbEayoroQDDzCQNoGt3g3P698upeHW6+/R
         osOQ==
X-Gm-Message-State: AOAM533PH6AlJvW6SRuDSbrihy8z8Egb7LGglJFfGeaUt53kGtuIDjMw
	1QhJJrlJ+BCApnXEqbHjZdavVg==
X-Google-Smtp-Source: ABdhPJwmdCJZLAUsrl/QW5wKuUZMBwlVdVl2VXP+Jk7zMzVi2ljr8t2PHAqCINz0HMBlae3lzorpYw==
X-Received: by 2002:a17:90b:3444:: with SMTP id lj4mr574843pjb.78.1599598579801;
        Tue, 08 Sep 2020 13:56:19 -0700 (PDT)
Date: Tue, 8 Sep 2020 13:56:12 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Kees Cook <keescook@chromium.org>
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
Message-ID: <20200908205612.GA1060586@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-12-samitolvanen@google.com>
 <202009031513.B558594FB9@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009031513.B558594FB9@keescook>

On Thu, Sep 03, 2020 at 03:19:43PM -0700, Kees Cook wrote:
> On Thu, Sep 03, 2020 at 01:30:36PM -0700, Sami Tolvanen wrote:
> > With LTO, LLVM bitcode won't be compiled into native code until
> > modpost_link, or modfinal for modules. This change postpones calls
> > to objtool until after these steps.
> > 
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> 
> For a "fail fast" style of building, it makes sense to have objtool run
> as early as possible, so it makes sense to keep the current behavior in
> non-LTO mode. I do wonder, though, if there is a real benefit to having
> "fail fast" case. I imagine a lot of automated builds are using
> --keep-going with make, and actually waiting until the end to do the
> validation means more code will get build-tested before objtool rejects
> the results. *shrug*
> 
> > ---
> >  arch/Kconfig              |  2 +-
> >  scripts/Makefile.build    |  2 ++
> >  scripts/Makefile.modfinal | 24 ++++++++++++++++++++++--
> >  scripts/link-vmlinux.sh   | 23 ++++++++++++++++++++++-
> >  4 files changed, 47 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index 71392e4a8900..7a418907e686 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -599,7 +599,7 @@ config LTO_CLANG
> >  	depends on $(success,$(NM) --help | head -n 1 | grep -qi llvm)
> >  	depends on $(success,$(AR) --help | head -n 1 | grep -qi llvm)
> >  	depends on ARCH_SUPPORTS_LTO_CLANG
> > -	depends on !FTRACE_MCOUNT_RECORD
> > +	depends on HAVE_OBJTOOL_MCOUNT || !(X86_64 && DYNAMIC_FTRACE)
> >  	depends on !KASAN
> >  	depends on !GCOV_KERNEL
> >  	select LTO
> > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > index c348e6d6b436..b8f1f0d65a73 100644
> > --- a/scripts/Makefile.build
> > +++ b/scripts/Makefile.build
> > @@ -218,6 +218,7 @@ cmd_record_mcount = $(if $(findstring $(strip $(CC_FLAGS_FTRACE)),$(_c_flags)),
> >  endif # USE_RECORDMCOUNT
> >  
> >  ifdef CONFIG_STACK_VALIDATION
> > +ifndef CONFIG_LTO_CLANG
> >  ifneq ($(SKIP_STACK_VALIDATION),1)
> >  
> >  __objtool_obj := $(objtree)/tools/objtool/objtool
> > @@ -253,6 +254,7 @@ objtool_obj = $(if $(patsubst y%,, \
> >  	$(__objtool_obj))
> >  
> >  endif # SKIP_STACK_VALIDATION
> > +endif # CONFIG_LTO_CLANG
> >  endif # CONFIG_STACK_VALIDATION
> >  
> >  # Rebuild all objects when objtool changes, or is enabled/disabled.
> > diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
> > index 1005b147abd0..909bd509edb4 100644
> > --- a/scripts/Makefile.modfinal
> > +++ b/scripts/Makefile.modfinal
> > @@ -34,10 +34,30 @@ ifdef CONFIG_LTO_CLANG
> >  # With CONFIG_LTO_CLANG, reuse the object file we compiled for modpost to
> >  # avoid a second slow LTO link
> >  prelink-ext := .lto
> > -endif
> > +
> > +# ELF processing was skipped earlier because we didn't have native code,
> > +# so let's now process the prelinked binary before we link the module.
> > +
> > +ifdef CONFIG_STACK_VALIDATION
> > +ifneq ($(SKIP_STACK_VALIDATION),1)
> > +cmd_ld_ko_o +=								\
> > +	$(objtree)/tools/objtool/objtool				\
> > +		$(if $(CONFIG_UNWINDER_ORC),orc generate,check)		\
> > +		--module						\
> > +		$(if $(CONFIG_FRAME_POINTER),,--no-fp)			\
> > +		$(if $(CONFIG_GCOV_KERNEL),--no-unreachable,)		\
> > +		$(if $(CONFIG_RETPOLINE),--retpoline,)			\
> > +		$(if $(CONFIG_X86_SMAP),--uaccess,)			\
> > +		$(if $(USE_OBJTOOL_MCOUNT),--mcount,)			\
> > +		$(@:.ko=$(prelink-ext).o);
> > +
> > +endif # SKIP_STACK_VALIDATION
> > +endif # CONFIG_STACK_VALIDATION
> 
> I wonder if objtool_args could be reused here instead of having two
> places to keep in sync? It looks like that might mean moving things
> around a bit before this patch, since I can't quite see if
> Makefile.build's variables are visible to Makefile.modfinal?

It doesn't look like they are. I suppose we could move objtool_args to
Makefile.lib. Masahiro, any thoughts?

Sami
