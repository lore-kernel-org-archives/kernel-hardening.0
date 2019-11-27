Return-Path: <SRS0=0QYB=ZT=lists.openwall.com=kernel-hardening-return-17441-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616C5C432C0
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2019 17:59:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8575020871
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2019 17:59:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="J6979edA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8575020871
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17441-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28668 invoked by uid 550); 27 Nov 2019 17:59:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28629 invoked from network); 27 Nov 2019 17:59:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ezl2J7x0qEbob3yE0P5wX3Ui+Wbk0cG2BwPkP3kEj5Y=;
        b=J6979edAXnvzD+DxpY1Rpdrv2sZQSBrfPzOX0P7q2tW9DBES7k4YGGkRgBBcvZppet
         IHa/DiqfeH6r6w+303x8cyWIHSMaR9QpY4lQhnnJndwgODtWfMdSsDgTt2tT/BUTHZZU
         BnosabZCMvc/C0GZYQyGZSpOvQytI62IR3phE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ezl2J7x0qEbob3yE0P5wX3Ui+Wbk0cG2BwPkP3kEj5Y=;
        b=tShf059pGGUb6pC/j5a/IcZRgKydoILAMOv+M5hbRmDCfYtiKqyGHszhxeisAm7Fum
         NkCOgUHS+HBc2xLnI9SNoQ1N0PZQM339qbgBLRXOIz0vhheg2VZYg7D7LL0NUKO6jbxN
         Uv6o3Y7enHti7VHWgMrjaISBgMk63zayeDOg9+eXCWZh9trip0A/YsnRl7OwGyHpUueF
         YniUW6SKga0rH6nJdHxZgh+4ICig/ZVUmi1cok201cKlcBJLys8mzuF6ZW/Dt7pzI53I
         2QzcA4v/6ldA/h+gjz8H14mqUc53L14f5Tr2znpwELld4NhJdg6pZnvDUr3mH+Zyd2aQ
         ra3w==
X-Gm-Message-State: APjAAAV0NEdmwqBeXC8M6oLe8wK+euRa4jrSI9PBhmoLaedkHBUO08yz
	8lpH/jAAU8BSip9/07zTOgn4cA==
X-Google-Smtp-Source: APXvYqzAsp2FzmJPhEiveHXqNvW+AhAHn0LqoWNyHVLFte5LKXXaOX9hV2I8WqQ5RrQ+7i6xI5V8lw==
X-Received: by 2002:a17:90b:3109:: with SMTP id gc9mr2956841pjb.30.1574877560087;
        Wed, 27 Nov 2019 09:59:20 -0800 (PST)
Date: Wed, 27 Nov 2019 09:59:18 -0800
From: Kees Cook <keescook@chromium.org>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Elena Petrova <lenaptr@google.com>,
	Alexander Potapenko <glider@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	kasan-dev <kasan-dev@googlegroups.com>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-hardening@lists.openwall.com,
	syzkaller <syzkaller@googlegroups.com>
Subject: Re: [PATCH v2 0/3] ubsan: Split out bounds checker
Message-ID: <201911270952.D66CD15AEC@keescook>
References: <20191121181519.28637-1-keescook@chromium.org>
 <CACT4Y+b3JZM=TSvUPZRMiJEPNH69otidRCqq9gmKX53UHxYqLg@mail.gmail.com>
 <201911262134.ED9E60965@keescook>
 <CACT4Y+bsLJ-wFx_TaXqax3JByUOWB3uk787LsyMVcfW6JzzGvg@mail.gmail.com>
 <CACT4Y+aFiwxT6SO-ABx695Yg3=Zam5saqCo4+FembPwKSV8cug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+aFiwxT6SO-ABx695Yg3=Zam5saqCo4+FembPwKSV8cug@mail.gmail.com>

On Wed, Nov 27, 2019 at 10:34:24AM +0100, Dmitry Vyukov wrote:
> On Wed, Nov 27, 2019 at 7:54 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > On Wed, Nov 27, 2019 at 6:42 AM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > On Fri, Nov 22, 2019 at 10:07:29AM +0100, Dmitry Vyukov wrote:
> > > > On Thu, Nov 21, 2019 at 7:15 PM Kees Cook <keescook@chromium.org> wrote:
> > > > >
> > > > > v2:
> > > > >     - clarify Kconfig help text (aryabinin)
> > > > >     - add reviewed-by
> > > > >     - aim series at akpm, which seems to be where ubsan goes through?
> > > > > v1: https://lore.kernel.org/lkml/20191120010636.27368-1-keescook@chromium.org
> > > > >
> > > > > This splits out the bounds checker so it can be individually used. This
> > > > > is expected to be enabled in Android and hopefully for syzbot. Includes
> > > > > LKDTM tests for behavioral corner-cases (beyond just the bounds checker).
> > > > >
> > > > > -Kees
> > > >
> > > > +syzkaller mailing list
> > > >
> > > > This is great!
> > >
> > > BTW, can I consider this your Acked-by for these patches? :)
> > >
> > > > I wanted to enable UBSAN on syzbot for a long time. And it's
> > > > _probably_ not lots of work. But it was stuck on somebody actually
> > > > dedicating some time specifically for it.
> > >
> > > Do you have a general mechanism to test that syzkaller will actually
> > > pick up the kernel log splat of a new check?
> >
> > Yes. That's one of the most important and critical parts of syzkaller :)
> > The tests for different types of bugs are here:
> > https://github.com/google/syzkaller/tree/master/pkg/report/testdata/linux/report
> >
> > But have 3 for UBSAN, but they may be old and it would be useful to
> > have 1 example crash per bug type:
> >
> > syzkaller$ grep UBSAN pkg/report/testdata/linux/report/*
> > pkg/report/testdata/linux/report/40:TITLE: UBSAN: Undefined behaviour
> > in drivers/usb/core/devio.c:LINE
> > pkg/report/testdata/linux/report/40:[    4.556972] UBSAN: Undefined
> > behaviour in drivers/usb/core/devio.c:1517:25
> > pkg/report/testdata/linux/report/41:TITLE: UBSAN: Undefined behaviour
> > in ./arch/x86/include/asm/atomic.h:LINE
> > pkg/report/testdata/linux/report/41:[    3.805453] UBSAN: Undefined
> > behaviour in ./arch/x86/include/asm/atomic.h:156:2
> > pkg/report/testdata/linux/report/42:TITLE: UBSAN: Undefined behaviour
> > in kernel/time/hrtimer.c:LINE
> > pkg/report/testdata/linux/report/42:[   50.583499] UBSAN: Undefined
> > behaviour in kernel/time/hrtimer.c:310:16
> >
> > One of them is incomplete and is parsed as "corrupted kernel output"
> > (won't be reported):
> > https://github.com/google/syzkaller/blob/master/pkg/report/testdata/linux/report/42
> >
> > Also I see that report parsing just takes the first line, which
> > includes file name, which is suboptimal (too long, can't report 2 bugs
> > in the same file). We seem to converge on "bug-type in function-name"
> > format.
> > The thing about bug titles is that it's harder to change them later.
> > If syzbot already reported 100 bugs and we change titles, it will
> > start re-reporting the old one after new names and the old ones will
> > look stale, yet they still relevant, just detected under different
> > name.
> > So we also need to get this part right before enabling.

It Sounds like instead of "UBSAN: Undefined behaviour in $file", UBSAN
should report something like "UBSAN: $behavior in $file"?

e.g.
40: UBSAN: bad shift in drivers/usb/core/devio.c:1517:25"
41: UBSAN: signed integer overflow in ./arch/x86/include/asm/atomic.h:156:2

I'll add one for the bounds checker.

How are these reports used? (And is there a way to check a live kernel
crash? i.e. to tell syzkaller "echo ARRAY_BOUNDS >/.../lkdtm..." and
generate a report?

> > > I noticed a few things
> > > about the ubsan handlers: they don't use any of the common "warn"
> > > infrastructure (neither does kasan from what I can see), and was missing
> > > a check for panic_on_warn (kasan has this, but does it incorrectly).
> >
> > Yes, panic_on_warn we also need.
> >
> > I will look at the patches again for Acked-by.
> 
> 
> Acked-by: Dmitry Vyukov <dvyukov@google.com>
> for the series.

Thanks!

> 
> I see you extended the test module, do you have samples of all UBSAN
> report types that are triggered by these functions? Is so, please add
> them to:
> https://github.com/google/syzkaller/tree/master/pkg/report/testdata/linux/report

Okay, cool.

> with whatever titles they are detected now. Improving titles will then
> be the next step, but much simpler with a good collection of tests.
> 
> Will you send the panic_on_want patch as well?

Yes; I wanted to make sure it was needed first (which you've confirmed
now). I'll likely not send it until next week.

-- 
Kees Cook
