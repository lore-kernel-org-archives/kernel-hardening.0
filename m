Return-Path: <SRS0=g3OS=ZT=lists.openwall.com=kernel-hardening-return-17439-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09302C432C0
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2019 06:54:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2271D206F0
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2019 06:54:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WDJzTUke"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2271D206F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17439-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3558 invoked by uid 550); 27 Nov 2019 06:54:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3524 invoked from network); 27 Nov 2019 06:54:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=legbFrQ1e9U1Xfdcs/id6e/zbRlR7gKK0zBNbirxTnU=;
        b=WDJzTUkeSgLgNEeP9e7raX/DT2pMfosE62r4lrhzZL8yZSNuJIp2rwC8O+8RhK2PFT
         SZlrBthHgB3A62ZHAojQtGHvWiDF+8LtFzlmmCJcqesvWNnZxcNO+a8KHhJZR5UxAbTo
         QW4fxPiDo/LZGo/OJ2wzH9/C6p0EVvPltdHbGbWApRspm80al9xLlEt7+GF+sVm+68zB
         vB31gdGkRK80DwxvhUQDT9Sf40lwKAK5TJscpflHN9SVSqvt6kYFRWCdIlPMYaGPF2EH
         o9EVym+rxe7SRFx6n1vXGOPS8rkygFdDUjBVNK/Jranaic3wiOAN9OzKzBjcSW+CBNzF
         Ro4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=legbFrQ1e9U1Xfdcs/id6e/zbRlR7gKK0zBNbirxTnU=;
        b=bFAVc0Broy2sXZ2C96b3QN5/4aEZxs+vKjA4v+1j68EzuIP01xGuHkSLOBf9GMc2fY
         XoVSosUMcGs68xvdDhkiKNBSiZa/+pUZ1t9oe6p26JJM4h2ADlj5mc9rTDaT/ucQR9tS
         +jgDtVF9LjV/3O4r7lvLUI8Osbseg/r81KL2TWOprgwV7+K3DcBZTQSNL0piVpcp6dIO
         1meBVLpHNETIjWtWhH5lmeB1nHOVqaZEcPwRVMrR8SZokULYIqpHMeMZ5tdu/FoyUqWt
         w2Wqxh36IaM23bSyBJPil+S97Wt1opHgSKsQCAl5tGBrsblbkrzt4Oyg/tObjCZ+7S+a
         2iNQ==
X-Gm-Message-State: APjAAAXHmzp3j26STitL1aSttIaiI39pe2GtPuPSuOcJqSV/arprrLAr
	fvOBzi0zHH+IgmShBP2xfARJCc0k9+9XxlVKCwaEpQ==
X-Google-Smtp-Source: APXvYqyqaLY2PQ25XRUtzLLpRMJQ0P2mn0LzvmT7oCESL+yurKhLCGR4sAyVFfoXoadWt2XqxwCll9QgqncLJvikhUs=
X-Received: by 2002:a0c:c125:: with SMTP id f34mr3174396qvh.22.1574837676626;
 Tue, 26 Nov 2019 22:54:36 -0800 (PST)
MIME-Version: 1.0
References: <20191121181519.28637-1-keescook@chromium.org> <CACT4Y+b3JZM=TSvUPZRMiJEPNH69otidRCqq9gmKX53UHxYqLg@mail.gmail.com>
 <201911262134.ED9E60965@keescook>
In-Reply-To: <201911262134.ED9E60965@keescook>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 27 Nov 2019 07:54:25 +0100
Message-ID: <CACT4Y+bsLJ-wFx_TaXqax3JByUOWB3uk787LsyMVcfW6JzzGvg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ubsan: Split out bounds checker
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, 
	Elena Petrova <lenaptr@google.com>, Alexander Potapenko <glider@google.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Dan Carpenter <dan.carpenter@oracle.com>, 
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>, Arnd Bergmann <arnd@arndb.de>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, kasan-dev <kasan-dev@googlegroups.com>, 
	LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, 
	syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 27, 2019 at 6:42 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Nov 22, 2019 at 10:07:29AM +0100, Dmitry Vyukov wrote:
> > On Thu, Nov 21, 2019 at 7:15 PM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > v2:
> > >     - clarify Kconfig help text (aryabinin)
> > >     - add reviewed-by
> > >     - aim series at akpm, which seems to be where ubsan goes through?
> > > v1: https://lore.kernel.org/lkml/20191120010636.27368-1-keescook@chromium.org
> > >
> > > This splits out the bounds checker so it can be individually used. This
> > > is expected to be enabled in Android and hopefully for syzbot. Includes
> > > LKDTM tests for behavioral corner-cases (beyond just the bounds checker).
> > >
> > > -Kees
> >
> > +syzkaller mailing list
> >
> > This is great!
>
> BTW, can I consider this your Acked-by for these patches? :)
>
> > I wanted to enable UBSAN on syzbot for a long time. And it's
> > _probably_ not lots of work. But it was stuck on somebody actually
> > dedicating some time specifically for it.
>
> Do you have a general mechanism to test that syzkaller will actually
> pick up the kernel log splat of a new check?

Yes. That's one of the most important and critical parts of syzkaller :)
The tests for different types of bugs are here:
https://github.com/google/syzkaller/tree/master/pkg/report/testdata/linux/report

But have 3 for UBSAN, but they may be old and it would be useful to
have 1 example crash per bug type:

syzkaller$ grep UBSAN pkg/report/testdata/linux/report/*
pkg/report/testdata/linux/report/40:TITLE: UBSAN: Undefined behaviour
in drivers/usb/core/devio.c:LINE
pkg/report/testdata/linux/report/40:[    4.556972] UBSAN: Undefined
behaviour in drivers/usb/core/devio.c:1517:25
pkg/report/testdata/linux/report/41:TITLE: UBSAN: Undefined behaviour
in ./arch/x86/include/asm/atomic.h:LINE
pkg/report/testdata/linux/report/41:[    3.805453] UBSAN: Undefined
behaviour in ./arch/x86/include/asm/atomic.h:156:2
pkg/report/testdata/linux/report/42:TITLE: UBSAN: Undefined behaviour
in kernel/time/hrtimer.c:LINE
pkg/report/testdata/linux/report/42:[   50.583499] UBSAN: Undefined
behaviour in kernel/time/hrtimer.c:310:16

One of them is incomplete and is parsed as "corrupted kernel output"
(won't be reported):
https://github.com/google/syzkaller/blob/master/pkg/report/testdata/linux/report/42

Also I see that report parsing just takes the first line, which
includes file name, which is suboptimal (too long, can't report 2 bugs
in the same file). We seem to converge on "bug-type in function-name"
format.
The thing about bug titles is that it's harder to change them later.
If syzbot already reported 100 bugs and we change titles, it will
start re-reporting the old one after new names and the old ones will
look stale, yet they still relevant, just detected under different
name.
So we also need to get this part right before enabling.


> I noticed a few things
> about the ubsan handlers: they don't use any of the common "warn"
> infrastructure (neither does kasan from what I can see), and was missing
> a check for panic_on_warn (kasan has this, but does it incorrectly).

Yes, panic_on_warn we also need.

I will look at the patches again for Acked-by.

> I think kasan and ubsan should be reworked to use the common warn
> infrastructure, and at the very least, ubsan needs this:
>
> diff --git a/lib/ubsan.c b/lib/ubsan.c
> index e7d31735950d..a2535a62c9af 100644
> --- a/lib/ubsan.c
> +++ b/lib/ubsan.c
> @@ -160,6 +160,17 @@ static void ubsan_epilogue(unsigned long *flags)
>                 "========================================\n");
>         spin_unlock_irqrestore(&report_lock, *flags);
>         current->in_ubsan--;
> +
> +       if (panic_on_warn) {
> +               /*
> +                * This thread may hit another WARN() in the panic path.
> +                * Resetting this prevents additional WARN() from panicking the
> +                * system on this thread.  Other threads are blocked by the
> +                * panic_mutex in panic().
> +                */
> +               panic_on_warn = 0;
> +               panic("panic_on_warn set ...\n");
> +       }
>  }
>
>  static void handle_overflow(struct overflow_data *data, void *lhs,
>
> > Kees, or anybody else interested, could you provide relevant configs
> > that (1) useful for kernel,
>
> As mentioned in the other email (but just to keep the note together with
> the other thoughts here) after this series, you'd want:
>
> CONFIG_UBSAN=y
> CONFIG_UBSAN_BOUNDS=y
> # CONFIG_UBSAN_MISC is not set
>
> > (2) we want 100% cleanliness,
>
> What do you mean here by "cleanliness"? It seems different from (3)
> about the test tripping a lot?
>
> > (3) don't
> > fire all the time even without fuzzing?
>
> I ran with the bounds checker enabled (and the above patch) under
> syzkaller for the weekend and saw 0 bounds checker reports.
>
> > Anything else required to
> > enable UBSAN? I don't see anything. syzbot uses gcc 8.something, which
> > I assume should be enough (but we can upgrade if necessary).
>
> As mentioned, gcc 8+ should be fine.
>
> --
> Kees Cook
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/201911262134.ED9E60965%40keescook.
