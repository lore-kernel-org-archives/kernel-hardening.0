Return-Path: <SRS0=KNP6=AF=lists.openwall.com=kernel-hardening-return-19144-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0987FC433E1
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:32:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5EA45207FC
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:32:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YLhBzo5t"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5EA45207FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19144-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1980 invoked by uid 550); 24 Jun 2020 21:32:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1948 invoked from network); 24 Jun 2020 21:32:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oeZYP2K14l8wy15C+mHJ7IGJGj+bMsdiaVhcvV254wo=;
        b=YLhBzo5tLLnGs0t6TdhnFSz7LC+dIOGSdyR2PzbiJ5sbNeH/OqOlpGPE843RDUqPyB
         xcP72I6Wr3gEeg8vpHpVkU6u63LLrd63P+x1ZZGXfe69+AWJdANZ6EXt2a9Wp3ONoSX+
         IYQFe9nK3k7itVIzd+Ql+LZ3lDH+ctkvhSsUBvpMOUjNf93JbToJ7w7Jl9+ej3WyaGi0
         t64ZoJLPWNph8t4rfm6P3KDNWB+A/4Ny+h52bYBhzjkl8jF/deowywj6kuu84Svv0pXL
         Tt9UDtDNXClNBGQZGornTX62JX0NBkg8bcnSbq3QZ1eCahNDu3bRnftlUijmcZVfck9j
         lPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oeZYP2K14l8wy15C+mHJ7IGJGj+bMsdiaVhcvV254wo=;
        b=mUKSO+4igzoe9prhI9IoSqz3DonYCTh7Mo+KexFMzcZrojz1TagI1sTxenfdjdvzoR
         de55qPL2drsaKcpNzySumfszeM29jS5NU4s1wVNCSfgr0lsR1eNrh/Vg+gfQw+VYAP6E
         20Qymxs94t42iO1H2XaCs9uAoq1Q69dvfZDh3r3nah+f9i5c+yUSSMAh74JQZ9yK42IK
         mg90j2YSdahbj/sPz4oSzyA7rS3eUvEqHGKChZIhhuUHlB9LZjf9g7gESYGnz1dyRFCX
         dhCzZiEE1WlRsylrjpH4SRJ/MTx4kyU0kKjFrnc8TDVabh/d2lXJBo4XKkt2dOB+VkgE
         RpWQ==
X-Gm-Message-State: AOAM533m3afrakKsNNM35Ij/mX2UesnHoII9DQXtqQrUmD3pHYgzEU9t
	o1h4y83W0++EG0N+LJFQLXZJuczAuBJBE3gxBxif5A==
X-Google-Smtp-Source: ABdhPJz+HM0notouaxjjmVfRuFFbkI9iWq5lvgoF8vO75RohUtNuXeLwq0dwZGEXHBIiKBXeihMyXNtyRUAlF/ihVkc=
X-Received: by 2002:a17:90a:1e:: with SMTP id 30mr28248270pja.25.1593034308056;
 Wed, 24 Jun 2020 14:31:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200624211540.GS4817@hirez.programming.kicks-ass.net>
In-Reply-To: <20200624211540.GS4817@hirez.programming.kicks-ass.net>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 24 Jun 2020 14:31:36 -0700
Message-ID: <CAKwvOdmxz91c-M8egR9GdR1uOjeZv7-qoTP=pQ55nU8TCpkK6g@mail.gmail.com>
Subject: Re: [PATCH 00/22] add support for Clang LTO
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Will Deacon <will@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 24, 2020 at 2:15 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Wed, Jun 24, 2020 at 01:31:38PM -0700, Sami Tolvanen wrote:
> > This patch series adds support for building x86_64 and arm64 kernels
> > with Clang's Link Time Optimization (LTO).
> >
> > In addition to performance, the primary motivation for LTO is to allow
> > Clang's Control-Flow Integrity (CFI) to be used in the kernel. Google's
> > Pixel devices have shipped with LTO+CFI kernels since 2018.
> >
> > Most of the patches are build system changes for handling LLVM bitcode,
> > which Clang produces with LTO instead of ELF object files, postponing
> > ELF processing until a later stage, and ensuring initcall ordering.
> >
> > Note that first objtool patch in the series is already in linux-next,
> > but as it's needed with LTO, I'm including it also here to make testing
> > easier.
>
> I'm very sad that yet again, memory ordering isn't addressed. LTO vastly
> increases the range of the optimizer to wreck things.

Hi Peter, could you expand on the issue for the folks on the thread?
I'm happy to try to hack something up in LLVM if we check that X does
or does not happen; maybe we can even come up with some concrete test
cases that can be added to LLVM's codebase?

-- 
Thanks,
~Nick Desaulniers
