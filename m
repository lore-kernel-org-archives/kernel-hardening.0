Return-Path: <SRS0=VMD5=FG=lists.openwall.com=kernel-hardening-return-20509-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F1BC64E8A
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Dec 2020 05:47:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7F179221FE
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Dec 2020 05:47:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F179221FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20509-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20391 invoked by uid 550); 2 Dec 2020 05:46:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20367 invoked from network); 2 Dec 2020 05:46:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zIYg3wn3IiOAwIUjN3HHnL/xxZ7BzmV6ArGGQCieAHY=;
        b=bON2yGnfCiyS2deASK7lq7vUUxyZx+TcNqxyx0Y2lzXGXaJk2/GGL6wVTlpf746M17
         ewSfrj7S9dsZKHz9EXsFml/ZRzW3ibKt2hylTzUrhiQailV3BSYLijuRVIlNThE7Ss7H
         KnWN0tGzIrPrfvFAOAvf+8FI8ABAECA3BAv1o2Nf8hdcpJnE2U+4ENVHLDfsMJ2syTzS
         iaGmOfE/X9XwWP/ylcYRN5sQKiXL7/ZHlVEs4e0tCksSkzjQe+RVz9j9FQbs4OUZPc8T
         CR1MgHpyNAn/FzhGrLr7gcE7qYAYqX3l4Q2HISPXD2rjqVZX7wjj378ggI/rHdDvjDb8
         F84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zIYg3wn3IiOAwIUjN3HHnL/xxZ7BzmV6ArGGQCieAHY=;
        b=GgOkz4HRETxotDZSKyQXjpUHaX65XFkzFmH5zYCPLAqSWGXFZXjnA+drbdcRIBSQ5N
         /zFyrJaxA7nzhTvdshFwMVoOhv2OO2l7aPNe1aNDPWnvLybTr3VoMFMMGhcbFfW1XDOm
         h/csY29u6e2vdSe1L1ryKUvbjZl/nBo5p/VbDg1Uu9Ih7M7fFPiVPpuoIT41+ECHywBL
         OhKVcL9opdjBibh6jWdO9EOxr8VEdQ5e+pWksDWIX69neHsGu6Uap/TCcLfJXrlGZLeF
         1bDLpS7s/e3X9jRHSirpJnVO7PA1GjK8uxOMSurJWHIpM6A3FV35p4gMuWNm85ZcuhIU
         VdaQ==
X-Gm-Message-State: AOAM5304RRzPLbfw+XDARDuxaRWlubA4LiC+oazrsQ08Gpht3ZpVS6uI
	U03TWtKwsbACk60mZ3CgTXMXklXaOglfOua5zWMKzQ==
X-Google-Smtp-Source: ABdhPJyfTarblbQWXQ2D0gqGJIM068ljJFblRKN2s+iu0HTYtaH2RdablEmO5KmOvdnbvJUKStvPOuGuLcyF9JZVZE8=
X-Received: by 2002:a1f:36d4:: with SMTP id d203mr580407vka.22.1606888005927;
 Tue, 01 Dec 2020 21:46:45 -0800 (PST)
MIME-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201130120130.GF24563@willie-the-truck> <202012010929.3788AF5@keescook> <CAK7LNASQPOGohtUyzBM6n54pzpLN35kDXC7VbvWzX8QWUmqq9g@mail.gmail.com>
In-Reply-To: <CAK7LNASQPOGohtUyzBM6n54pzpLN35kDXC7VbvWzX8QWUmqq9g@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 1 Dec 2020 21:46:33 -0800
Message-ID: <CABCJKuf6=nqsUFYc5m91x_H44ojBjoE+BqZr81D8T6xRhWTiEg@mail.gmail.com>
Subject: Re: [PATCH v7 00/17] Add support for Clang LTO
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Will Deacon <will@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 1, 2020 at 6:43 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> On Wed, Dec 2, 2020 at 2:31 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Mon, Nov 30, 2020 at 12:01:31PM +0000, Will Deacon wrote:
> > > Hi Sami,
> > >
> > > On Wed, Nov 18, 2020 at 02:07:14PM -0800, Sami Tolvanen wrote:
> > > > This patch series adds support for building the kernel with Clang's
> > > > Link Time Optimization (LTO). In addition to performance, the primary
> > > > motivation for LTO is to allow Clang's Control-Flow Integrity (CFI) to
> > > > be used in the kernel. Google has shipped millions of Pixel devices
> > > > running three major kernel versions with LTO+CFI since 2018.
> > > >
> > > > Most of the patches are build system changes for handling LLVM bitcode,
> > > > which Clang produces with LTO instead of ELF object files, postponing
> > > > ELF processing until a later stage, and ensuring initcall ordering.
> > > >
> > > > Note that v7 brings back arm64 support as Will has now staged the
> > > > prerequisite memory ordering patches [1], and drops x86_64 while we work
> > > > on fixing the remaining objtool warnings [2].
> > >
> > > Sounds like you're going to post a v8, but that's the plan for merging
> > > that? The arm64 parts look pretty good to me now.
> >
> > I haven't seen Masahiro comment on this in a while, so given the review
> > history and its use (for years now) in Android, I will carry v8 (assuming
> > all is fine with it) it in -next unless there are objections.
>
>
> What I dislike about this implementation is
> it cannot drop any unreachable function/data.
> (and it is completely different from GCC LTO)
>
> This is not real LTO.

I'm not sure I understand your concern. LTO cannot drop functions or
data from vmlinux.o that may be referenced externally. However, with
CONFIG_LD_DEAD_CODE_DATA_ELIMINATION, the linker certainly can drop
unused functions and data when linking vmlinux, and there's no reason
this option can't be used together with LTO. In fact, Pixel 3 does
enable this option, but in our experience, there isn't much unused
code or data to remove, so later devices no longer use it.

There's technically no reason why we couldn't postpone LTO until we
link vmlinux instead, and thus allow the linker to possibly remove
more unused code without the help of --gc-sections, but at least with
the current build process, that would involve performing the slow LTO
link step multiple times, which isn't worth it when we can get the
performance benefits (and CFI) already when linking vmlinux.o with
LTO.

Sami
