Return-Path: <SRS0=Yv08=FH=lists.openwall.com=kernel-hardening-return-20523-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3908BC4361A
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 18:22:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A4A48207A8
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 18:22:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4A48207A8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20523-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20322 invoked by uid 550); 3 Dec 2020 18:22:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20296 invoked from network); 3 Dec 2020 18:22:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jSR8ftEy+ZPymQ2+ANnTCIcrdEyC6rgz8i/C+YFDrrs=;
        b=Ic4QleiYjTsHIMM0On90To1JYUkzfryly4JE00oJVw6xM1knMCPDBhHTFqo48Us3e3
         MF3QjiQL1yjayz+ETueVi50Cn9wqU1xj9ng0fJUbRI+swr7mmTUxDCH4/w/s1H+CN7nV
         OMmtIxG/V/PGVXNAQ6+q7qtZP4eFDcBe5sneK8fRhFRpoA6Nvajm1Z7NHt4ZNxR64L+m
         4StPiEoHrbNTyS5/bdTMBY7TWfxjJGh0p0nIYygOwtneo34JRlkXmRO2GZTSE3KheRhh
         U93GV8FOoYr6XPNft2A1/QvVK5CEPDl6SJRZHBpQO5yh83pv4jtkzUzrLEyURHK7A70P
         Dbgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jSR8ftEy+ZPymQ2+ANnTCIcrdEyC6rgz8i/C+YFDrrs=;
        b=tZ5wYdPClgEP+YpQpXHOfcvEHBwzUHhktqATEeIP2R+ZGBKFLxBGabZ0AhA2W9tL7e
         pRWFLdoNlmgmOpqM0djkNstZw9+x6HTqapFfydBy9noq29jHPlFTh9KxqOiRiMPVwdpU
         raTjf198/fbVkDbU2ji+YMt5bi6ifLSY4Hn79zZi3ln3QdALX9Ky3LpQtJAgIbMZ1RlJ
         Tm3JAOqeJ5607pYvT0vAyMF7q6V+5uCfgwCx7rPdjU2kjLPmSVV9DDG2QE9ZRoDu/K7g
         ORzuitN8k+JoQUx73coV9TfsBO3z0vUDrILIDNGlb6pj77M9zzaz7QgYsqvSNd5GioHG
         4bAw==
X-Gm-Message-State: AOAM531FPEcOa+2SwoUJV/pQlcyNtW+bNgNrfw1nm/SNYaWbqxn2zKwi
	KGCw7lPtDCT5z4dgBOumizs=
X-Google-Smtp-Source: ABdhPJxLBGQRSAEg/JvKkC/BNSVvgOhlpSDC2EIcQCGCOFwysswuak0jbyXtVU7AXdFmRsqK6IIjeA==
X-Received: by 2002:a05:620a:1489:: with SMTP id w9mr4240006qkj.43.1607019722685;
        Thu, 03 Dec 2020 10:22:02 -0800 (PST)
Date: Thu, 3 Dec 2020 11:21:59 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
Message-ID: <20201203182159.GA2104680@ubuntu-m3-large-x86>
References: <20201201213707.541432-1-samitolvanen@google.com>
 <20201203112622.GA31188@willie-the-truck>
 <CABCJKueby8pUoN7f5=6RoyLSt4PgWNx8idUej0sNwAi0F3Xqzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKueby8pUoN7f5=6RoyLSt4PgWNx8idUej0sNwAi0F3Xqzw@mail.gmail.com>

On Thu, Dec 03, 2020 at 09:07:30AM -0800, Sami Tolvanen wrote:
> On Thu, Dec 3, 2020 at 3:26 AM Will Deacon <will@kernel.org> wrote:
> >
> > Hi Sami,
> >
> > On Tue, Dec 01, 2020 at 01:36:51PM -0800, Sami Tolvanen wrote:
> > > This patch series adds support for building the kernel with Clang's
> > > Link Time Optimization (LTO). In addition to performance, the primary
> > > motivation for LTO is to allow Clang's Control-Flow Integrity (CFI)
> > > to be used in the kernel. Google has shipped millions of Pixel
> > > devices running three major kernel versions with LTO+CFI since 2018.
> > >
> > > Most of the patches are build system changes for handling LLVM
> > > bitcode, which Clang produces with LTO instead of ELF object files,
> > > postponing ELF processing until a later stage, and ensuring initcall
> > > ordering.
> > >
> > > Note that arm64 support depends on Will's memory ordering patches
> > > [1]. I will post x86_64 patches separately after we have fixed the
> > > remaining objtool warnings [2][3].
> >
> > I took this series for a spin, with my for-next/lto branch merged in but
> > I see a failure during the LTO stage with clang 11.0.5 because it doesn't
> > understand the '.arch_extension rcpc' directive we throw out in READ_ONCE().
> 
> I just tested this with Clang 11.0.0, which I believe is the latest
> 11.x version, and the current Clang 12 development branch, and both
> work for me. Godbolt confirms that '.arch_extension rcpc' is supported
> by the integrated assembler starting with Clang 11 (the example fails
> with 10.0.1):
> 
> https://godbolt.org/z/1csGcT
> 
> What does running clang --version and ld.lld --version tell you?

11.0.5 is AOSP's clang, which is behind the upstream 11.0.0 release so
it is most likely the case that it is missing the patch that added rcpc.
I think that a version based on the development branch (12.0.0) is in
the works but I am not sure.

> > We actually check that this extension is available before using it in
> > the arm64 Kconfig:
> >
> >         config AS_HAS_LDAPR
> >                 def_bool $(as-instr,.arch_extension rcpc)
> >
> > so this shouldn't happen. I then realised, I wasn't passing LLVM_IAS=1
> > on my Make command line; with that, then the detection works correctly
> > and the LTO step succeeds.
> >
> > Why is it necessary to pass LLVM_IAS=1 if LTO is enabled? I think it
> > would be _much_ better if this was implicit (or if LTO depended on it).
> 
> Without LLVM_IAS=1, Clang uses two different assemblers when LTO is
> enabled: the external GNU assembler for stand-alone assembly, and
> LLVM's integrated assembler for inline assembly. as-instr tests the
> external assembler and makes an admittedly reasonable assumption that
> the test is also valid for inline assembly.
> 
> I agree that it would reduce confusion in future if we just always
> enabled IAS with LTO. Nick, Nathan, any thoughts about this?

I am personally fine with that. As far as I am aware, we are in a fairly
good spot on arm64 and x86_64 when it comes to the integrated assembler.
Should we make it so that the user has to pass LLVM_IAS=1 explicitly or
we just make adding the no integrated assembler flag to CLANG_FLAGS
depend on not LTO (although that will require extra handling because
Kconfig is not available at that stage I think)?

Cheers,
Nathan
