Return-Path: <SRS0=Eimt=FM=lists.openwall.com=kernel-hardening-return-20547-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5855CC433FE
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Dec 2020 21:10:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8E7B423B1A
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Dec 2020 21:10:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E7B423B1A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20547-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1211 invoked by uid 550); 8 Dec 2020 21:10:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1184 invoked from network); 8 Dec 2020 21:10:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JlsOI1fRDP5hh5RRN78La/q8WBPdxUn50gvC+PZHts8=;
        b=P0U7Ogd8zoiY2n175d1X/g+/fJdAmGtiw6Ed5UHTXp8ErBagDDkxCwMTGBF9BCIOjy
         pbq/5qwvvmMeWHqUKqTbcNu+xhFsava13TOOa+wLsx8wIArkRm1a9Ar0K9/Kvv8AKw8K
         wAIbNzDXN/ALgxyANFROrjx2Duw9tqQCdjAO5s/bky5fQ31eeRIzwiwPCCeJ9G21PMfp
         0uSk9B6jy06FghAAJqiXpgYoIS0I+PnwdJ8bmYhf7TSY4IKWk8Dfbpn8T2PQYftvQb0G
         TqVBRNnLA45BlEuMp1qEk5rIQLxsS4U1OGfqsttmRzHkFoLCsLcFH/cjS3FxF+XpxVrk
         VA1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JlsOI1fRDP5hh5RRN78La/q8WBPdxUn50gvC+PZHts8=;
        b=XkmmqPKiTlehVZ95c6fDRem/ha1YNxZDih/l8tr3fXUq4xrpo234aUwAAiFotbbdju
         XiV4+39oymWrmaM50FsrmiqFq8d2q3NP2bxDAiJMzNizu3La3oY8WGLV9zDffhaAs36+
         MGE+GfsZ+o/+Z5XBCLrz0+x35qGVkk+rzhCWzM4MmvSqIHLTeRL+GtY1F3jyQWGpZxi6
         Wggi62kTJMHcWdi14tuFbr1G+N+GcxxXp2rL157tHmvt9/GB7Ij4UPvdLarn27XRcJ2a
         8oVzrWZlOvnwuLxy6+XXt5Xs1j8kRrHqMOMg9JOuybFYdHwJeZx2zi55+HtSBypeNVod
         6caQ==
X-Gm-Message-State: AOAM530C5JaXL5izwpQdnbNtk9fOUwd0On51/xNZQ/CxcDgUFvAHNpIk
	DW6+3reApvq7N9tHrJu41IIS6BOYw9tx0r6byn0krg==
X-Google-Smtp-Source: ABdhPJyLnu/bEkr1l2p2adVzNhFUDAMWuxSKY6xfqwbS1B4vhRKyNpYWWFzDSp2GEeJ76KAN+nCTPZuawZcHYARPCnA=
X-Received: by 2002:a63:3247:: with SMTP id y68mr4840pgy.10.1607461806350;
 Tue, 08 Dec 2020 13:10:06 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
 <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com>
 <CABCJKueCHo2RYfx_A21m+=d1gQLR9QsOOxCsHFeicCqyHkb-Kg@mail.gmail.com> <CAK8P3a1Xfpt7QLkvxjtXKcgzcWkS8g9bmxD687+rqjTafTzKrg@mail.gmail.com>
In-Reply-To: <CAK8P3a1Xfpt7QLkvxjtXKcgzcWkS8g9bmxD687+rqjTafTzKrg@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 8 Dec 2020 13:09:54 -0800
Message-ID: <CAKwvOd=hL=Vt1ATYqky9jmv+tM5hpTnLRuZudG-7ki0EYoFGJQ@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
To: Arnd Bergmann <arnd@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 8, 2020 at 1:00 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Tue, Dec 8, 2020 at 5:43 PM 'Sami Tolvanen' via Clang Built Linux
> <clang-built-linux@googlegroups.com> wrote:
> >
> > On Tue, Dec 8, 2020 at 4:15 AM Arnd Bergmann <arnd@kernel.org> wrote:
> > >
> > > - one build seems to take even longer to link. It's currently at 35GB RAM
> > >   usage and 40 minutes into the final link, but I'm worried it might
> > > not complete
> > >   before it runs out of memory.  I only have 128GB installed, and google-chrome
> > >   uses another 30GB of that, and I'm also doing some other builds in parallel.
> > >   Is there a minimum recommended amount of memory for doing LTO builds?
> >
> > When building arm64 defconfig, the maximum memory usage I measured
> > with ThinLTO was 3.5 GB, and with full LTO 20.3 GB. I haven't measured
> > larger configurations, but I believe LLD can easily consume 3-4x that
> > much with full LTO allyesconfig.
>
> Ok, that's not too bad then. Is there actually a reason to still
> support full-lto
> in your series? As I understand it, full LTO was the initial approach and
> used to work better, but thin LTO is actually what we want to use in the
> long run. Perhaps dropping the full LTO option from your series now
> that thin LTO works well enough and uses less resources would help
> avoid some of the problems.

While all developers agree that ThinLTO is a much more palatable
experience than full LTO; our product teams prefer the excessive build
time and memory high water mark (at build time) costs in exchange for
slightly better performance than ThinLTO in <benchmarks that I've been
told are important>.  Keeping support for full LTO in tree would help
our product teams reduce the amount of out of tree code they have.  As
long as <benchmarks that I've been told are important> help
sell/differentiate phones, I suspect our product teams will continue
to ship full LTO in production.
-- 
Thanks,
~Nick Desaulniers
