Return-Path: <SRS0=xH/G=E3=lists.openwall.com=kernel-hardening-return-20453-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C68C9C388F9
	for <kernel-hardening@archiver.kernel.org>; Sat, 21 Nov 2020 20:11:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 03DEC217A0
	for <kernel-hardening@archiver.kernel.org>; Sat, 21 Nov 2020 20:11:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="d6GrwcPv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03DEC217A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20453-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30082 invoked by uid 550); 21 Nov 2020 20:11:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30062 invoked from network); 21 Nov 2020 20:11:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2E/G1+BC++eqc5/VVuVWg3zAaLSLEIJOC7i/xjg7VSs=;
        b=d6GrwcPvUVOPqv9gOqNrM/bSP2HBSSL4qRmWjJIA4m3hlxWzzEj5T+lfuVhxoorPwR
         NB2BxSopAcepiomrLE56aIQhqr6iGtiFG6DXeV6iIvBvUM0uetc94YKKaGPVURg9KuKK
         wPaVmZ+dITTlnTfMDAnpXhgP+pbbnBqLxnBaU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2E/G1+BC++eqc5/VVuVWg3zAaLSLEIJOC7i/xjg7VSs=;
        b=pOYd2GLidavybzLPckEYw14Ofmcq5ZBrLyJyLVWujxQfuCCO5pldcnE4Dz1xXRbR+P
         T5NtBe2POjOtFDPgwOpzyFUMGtbcXC/P4D5N1VwyWdOALKvh8ncIfxfD/0uKM0e163cg
         LnpIyQIWsJSPyozFGl9JMQmXWdtXoD14AZGRhwC6cLHOC05GEOMw2i6mqbf5lD9/me/j
         M8rHRqMJ2qlJR2zaM0pXT24+AystmDwbWEAPKtP8NQ8FX0EdWfnTuIqq56llg3UF8G4A
         /Om5E5Sj2d0cDxmhUKdd27CT93HcssohdxBvdOcqNOQG0zFXrrmP1dkj8vOebaUOgNuj
         tz1Q==
X-Gm-Message-State: AOAM533sgUbTlff6XQlCbEVVBFynNMmFQAiJr3NuglXg1g0E1G91Pc5M
	sKsHdWOFODUNFsat0kIMuJYFFQ==
X-Google-Smtp-Source: ABdhPJxD+jcfx423cWLQ4O6Da2CSyrYt2pnWQlkBVEKwXqI/6a+7t8fMpRLZBlqwuFIT6m30Fbuv4Q==
X-Received: by 2002:a17:90a:f406:: with SMTP id ch6mr15105294pjb.134.1605989487549;
        Sat, 21 Nov 2020 12:11:27 -0800 (PST)
Date: Sat, 21 Nov 2020 12:11:25 -0800
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v7 02/17] kbuild: add support for Clang LTO
Message-ID: <202011211204.211E2B12@keescook>
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201118220731.925424-3-samitolvanen@google.com>
 <CAKwvOdnYTMzaahnBqdNYPz3KMdnkp=jZ4hxiqkTYzM5+BBdezA@mail.gmail.com>
 <CABCJKucj_jUwoiLc35R7qFe+cNKTWgT+gsCa5pPiY66+1--3Lg@mail.gmail.com>
 <202011201144.3F2BB70C@keescook>
 <20201120202935.GA1220359@ubuntu-m3-large-x86>
 <202011201241.B159562D7@keescook>
 <CABCJKucJ87wa73YJkN_dYUyE7foQT+12gdWJZw1PgZ_decFr4w@mail.gmail.com>
 <202011201556.3B910EF@keescook>
 <CABCJKudy5xFfjBFpFPR255-NAb1yOSuVqsL4fFUwJGGWKDnmQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKudy5xFfjBFpFPR255-NAb1yOSuVqsL4fFUwJGGWKDnmQQ@mail.gmail.com>

On Fri, Nov 20, 2020 at 05:46:44PM -0800, Sami Tolvanen wrote:
> Sure, this looks good to me, I'll use this in v8. The only minor
> concern I have is that ThinLTO cannot be set as the default LTO mode,
> but I assume anyone who selects LTO is also capable of deciding which
> mode is better for them.

It could be re-arranged similar to what you had before, but like:

config LTO
	bool "..."
	depends on HAS_LTO
	help
	  ...

choice
	prompt "LTO mode" if LTO
	default LTO_GCC if HAS_LTO_GCC
	default LTO_CLANG_THIN if HAS_LTO_CLANG
	default LTO_CLANG_FULL
	help
	  ...

	config LTO_CLANG_THIN
	...

	config LTO_CLANG_FULL
endchoice

Then the LTO is top-level yes/no, but depends on detected capabilities,
and the mode is visible if LTO is chosen, etc.

I'm not really sure which is better...

> > +config LTO_CLANG_THIN
> > +       bool "Clang ThinLTO (EXPERIMENTAL)"
> > +       depends on ARCH_SUPPORTS_LTO_CLANG_THIN
> > +       select LTO_CLANG
> > +       help
> > +         This option enables Clang's ThinLTO, which allows for parallel
> > +         optimization and faster incremental compiles compared to the
> > +         CONFIG_LTO_CLANG_FULL option. More information can be found
> > +         from Clang's documentation:
> > +
> > +           https://clang.llvm.org/docs/ThinLTO.html
> > +
> > +         If unsure, say Y.
> >  endchoice
> 
> The two LTO_CLANG_* options need to depend on HAS_LTO_CLANG, of course.

Whoops, yes. Thanks for catching that. :)

-- 
Kees Cook
