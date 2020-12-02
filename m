Return-Path: <SRS0=qD8f=FG=lists.openwall.com=kernel-hardening-return-20507-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758C7C64E90
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Dec 2020 02:43:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 761DC221E2
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Dec 2020 02:43:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 761DC221E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20507-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3420 invoked by uid 550); 2 Dec 2020 02:43:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3392 invoked from network); 2 Dec 2020 02:43:29 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 0B22gx4Z007045
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1606876979;
	bh=//nWGYyIDtis41/3ZWUbaJfDU17XquHuh1VxESk+fpY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YhmiZCSWdh+h7s2WRTav0INDhIR0rcnW35LlnpIfVUtKyPSMmn+U17B/PK2aeTfa0
	 fTnIGUz3KTJn2M/uiSK20i3edyMDKfviF8pdQau6NsNFuR5b+RtdIG7+HHZ9VW1XBz
	 0GSmvELzZl434j3vtGAy0eAhTaGhMeqCKOAa5PHzgTqSpTWn8ylQtVj1qzI0S88FpS
	 5Qmc1v9gpgH4CSlyu1l3vJez8xoPDRUopIN9fnCrE1/m/NaN6WWHtUaRXetDnkb7Qh
	 ClAnpe17jQ5AWERHhKiobDQLrM8nw0OP1rORNoH9up9fs2A9pm23zlyZViLl2L/fJF
	 iti0WfF94tSpA==
X-Nifty-SrcIP: [209.85.215.180]
X-Gm-Message-State: AOAM5328fykF7J/RqnWLughge1cDEMtBoQFqEzQIMwYnPVs0LBAsokPG
	5JsfAAtRJQSmBHqXIW7l6RXkjVkXhJZmf2jsvYc=
X-Google-Smtp-Source: ABdhPJzi9iDwIta7ZmCbotxfEvvd7Hv2CLzIMvLHO3nRGZI4HCgMqMJzj1Z+ul8DEREU6Yg0tTulHGqnbS5vWd1Hxg8=
X-Received: by 2002:aa7:9606:0:b029:198:14c4:4f44 with SMTP id
 q6-20020aa796060000b029019814c44f44mr748749pfg.80.1606876978646; Tue, 01 Dec
 2020 18:42:58 -0800 (PST)
MIME-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201130120130.GF24563@willie-the-truck> <202012010929.3788AF5@keescook>
In-Reply-To: <202012010929.3788AF5@keescook>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Wed, 2 Dec 2020 11:42:21 +0900
X-Gmail-Original-Message-ID: <CAK7LNASQPOGohtUyzBM6n54pzpLN35kDXC7VbvWzX8QWUmqq9g@mail.gmail.com>
Message-ID: <CAK7LNASQPOGohtUyzBM6n54pzpLN35kDXC7VbvWzX8QWUmqq9g@mail.gmail.com>
Subject: Re: [PATCH v7 00/17] Add support for Clang LTO
To: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 2, 2020 at 2:31 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Nov 30, 2020 at 12:01:31PM +0000, Will Deacon wrote:
> > Hi Sami,
> >
> > On Wed, Nov 18, 2020 at 02:07:14PM -0800, Sami Tolvanen wrote:
> > > This patch series adds support for building the kernel with Clang's
> > > Link Time Optimization (LTO). In addition to performance, the primary
> > > motivation for LTO is to allow Clang's Control-Flow Integrity (CFI) to
> > > be used in the kernel. Google has shipped millions of Pixel devices
> > > running three major kernel versions with LTO+CFI since 2018.
> > >
> > > Most of the patches are build system changes for handling LLVM bitcode,
> > > which Clang produces with LTO instead of ELF object files, postponing
> > > ELF processing until a later stage, and ensuring initcall ordering.
> > >
> > > Note that v7 brings back arm64 support as Will has now staged the
> > > prerequisite memory ordering patches [1], and drops x86_64 while we work
> > > on fixing the remaining objtool warnings [2].
> >
> > Sounds like you're going to post a v8, but that's the plan for merging
> > that? The arm64 parts look pretty good to me now.
>
> I haven't seen Masahiro comment on this in a while, so given the review
> history and its use (for years now) in Android, I will carry v8 (assuming
> all is fine with it) it in -next unless there are objections.


What I dislike about this implementation is
it cannot drop any unreachable function/data.
(and it is completely different from GCC LTO)

This is not real LTO.




> --
> Kees Cook
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/202012010929.3788AF5%40keescook.



-- 
Best Regards
Masahiro Yamada
