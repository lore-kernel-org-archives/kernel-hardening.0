Return-Path: <SRS0=DMBW=FN=lists.openwall.com=kernel-hardening-return-20556-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97489C4361B
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 16:12:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5322A23A02
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 16:12:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5322A23A02
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20556-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5471 invoked by uid 550); 9 Dec 2020 16:11:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5412 invoked from network); 9 Dec 2020 16:11:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RAzf84xm2mgxYvHDSz3COzuojd6IcnSxMMVRpqKMx58=;
        b=gIACvSNIaNgfk8yYU6S+oPUv61DEJWlMah84jEakzPWNcyXSQgGfZRUQCmTA2z2H68
         OBzeyFblbpXMDN4KMc97LtU39WqbsHFa8AfAomXUSKTieYHPNM7GEZ6ZC1XAJfkKWHDD
         N/rGmO7I1HBChFKlMvhDUHT+DD0u7soRUGjQ6XTsXx6XX9hNVWvtKbx0EmKVXSx0x63q
         uSx0K2QC6qZIjcT/Vy+GTkse17WcJ35wK97vuG6odXGIYTCqk24f8kQwlYGGa1smU8sB
         zozuG5IW1kXDMdiObqppDeT7967KYlhg+uX66AupNL004gGWmHXS7ElwVjsdgyVqwHeF
         qKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RAzf84xm2mgxYvHDSz3COzuojd6IcnSxMMVRpqKMx58=;
        b=rHv8dB7/+KjClr6CvEciPESTV6QNItIMFHA7J7H2xNUV56ptuhNo5Z8A9MW4CMPSXY
         909R3XlkoPUoss2WRTI+lLsGDl1+Xt/PngF+MIuqTCuTsWfZ/JjYvZVBw1mkWhwTW5GQ
         w7neVIltlyLdg9rzi4bmxaqPqSNOLXCC/SGbAqeaRZrwOfi/TZGiyPU1eCTwXTc90aWE
         b5OVJcxZObijHa90BGeIVNEOH96d9dKtc/4tpWjhOV8Wyo+aWxaLftaQwhLv02R2lmoD
         CZgbmX/71x+iaNxXowImQyzaIJwuLh37392BOyI8Kp4rTh4ClkrjBZGU0BGaL63Udcbk
         m4lQ==
X-Gm-Message-State: AOAM533P9Kn50yBEjQ+prePYmcK1NqnxkNth9JIqCwsRpXnZCa3kuMku
	opvqSSypQG0YsVguA+Wa05H0+r/k0cJ8GBwoG1FK+g==
X-Google-Smtp-Source: ABdhPJxCOtYM6wE6I23ECIs2Qe4RqO9Fsld+KWhukNaUvLqxacy6A4k/Hk6QX5PPXhxx/JBHh4wZPl2Wms4urz4X8pg=
X-Received: by 2002:ab0:1c0a:: with SMTP id a10mr2343531uaj.89.1607530273519;
 Wed, 09 Dec 2020 08:11:13 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
 <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com>
 <CABCJKueCHo2RYfx_A21m+=d1gQLR9QsOOxCsHFeicCqyHkb-Kg@mail.gmail.com>
 <CAK8P3a1Xfpt7QLkvxjtXKcgzcWkS8g9bmxD687+rqjTafTzKrg@mail.gmail.com>
 <CAKwvOd=hL=Vt1ATYqky9jmv+tM5hpTnLRuZudG-7ki0EYoFGJQ@mail.gmail.com> <CAK8P3a1k_cq3NOUeuQC4-uKDBaGq49GSjAMSiS_M9AVMBxv51g@mail.gmail.com>
In-Reply-To: <CAK8P3a1k_cq3NOUeuQC4-uKDBaGq49GSjAMSiS_M9AVMBxv51g@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 9 Dec 2020 08:11:02 -0800
Message-ID: <CABCJKucn6HnOw+oonjGU8q7w3uC0H727JZ30LzTbXx9BVLb0Zg@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
To: Arnd Bergmann <arnd@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
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

On Tue, Dec 8, 2020 at 2:20 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Tue, Dec 8, 2020 at 10:10 PM 'Nick Desaulniers' via Clang Built
> Linux <clang-built-linux@googlegroups.com> wrote:
> >
> > On Tue, Dec 8, 2020 at 1:00 PM Arnd Bergmann <arnd@kernel.org> wrote:
> > >
> > > On Tue, Dec 8, 2020 at 5:43 PM 'Sami Tolvanen' via Clang Built Linux
> > > <clang-built-linux@googlegroups.com> wrote:
> > > >
> > > > On Tue, Dec 8, 2020 at 4:15 AM Arnd Bergmann <arnd@kernel.org> wrote:
> > > > >
> > > > > - one build seems to take even longer to link. It's currently at 35GB RAM
> > > > >   usage and 40 minutes into the final link, but I'm worried it might
> > > > > not complete
> > > > >   before it runs out of memory.  I only have 128GB installed, and google-chrome
> > > > >   uses another 30GB of that, and I'm also doing some other builds in parallel.
> > > > >   Is there a minimum recommended amount of memory for doing LTO builds?
> > > >
> > > > When building arm64 defconfig, the maximum memory usage I measured
> > > > with ThinLTO was 3.5 GB, and with full LTO 20.3 GB. I haven't measured
> > > > larger configurations, but I believe LLD can easily consume 3-4x that
> > > > much with full LTO allyesconfig.
> > >
> > > Ok, that's not too bad then. Is there actually a reason to still
> > > support full-lto
> > > in your series? As I understand it, full LTO was the initial approach and
> > > used to work better, but thin LTO is actually what we want to use in the
> > > long run. Perhaps dropping the full LTO option from your series now
> > > that thin LTO works well enough and uses less resources would help
> > > avoid some of the problems.
> >
> > While all developers agree that ThinLTO is a much more palatable
> > experience than full LTO; our product teams prefer the excessive build
> > time and memory high water mark (at build time) costs in exchange for
> > slightly better performance than ThinLTO in <benchmarks that I've been
> > told are important>.  Keeping support for full LTO in tree would help
> > our product teams reduce the amount of out of tree code they have.  As
> > long as <benchmarks that I've been told are important> help
> > sell/differentiate phones, I suspect our product teams will continue
> > to ship full LTO in production.
>
> Ok, fair enough. How about marking FULL_LTO as 'depends on
> !COMPILE_TEST' then? I'll do that locally for my randconfig tests,
> but it would help the other build bots that also force-enable
> COMPILE_TEST.

Sure, that sounds reasonable to me. I'll add it in v9.

Sami
