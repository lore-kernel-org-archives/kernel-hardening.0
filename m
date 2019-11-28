Return-Path: <SRS0=gaP/=ZU=lists.openwall.com=kernel-hardening-return-17445-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F13C432C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 28 Nov 2019 10:39:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AA93821741
	for <kernel-hardening@archiver.kernel.org>; Thu, 28 Nov 2019 10:39:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iVMSh8YU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA93821741
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17445-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5828 invoked by uid 550); 28 Nov 2019 10:39:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5794 invoked from network); 28 Nov 2019 10:39:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p3AKvN/tO+lhaStDPMa1Kw8KDL4h3X77pfKSOUhTuZk=;
        b=iVMSh8YU5Rp7TGU6sFI+b5pYx2FCg1RH4PI5yKv/e0DAGFtdDJU7xyZOze+fhY4a7b
         M8szHIz06gpa0gMY9WnTHFGW9Ulp31hNjyS6GRilC61VmkD171jgXmJllUsRhHzAaDVu
         QmWWGdp+Ow75LwbWbi/lULjghen4RwdfZY7wZEYc7BpHxm+TrrUdPPlrPFF4GLwkVQLS
         P4RXbt2YPrUqWIayplnvk+wQSgl8P+eFWq7PQBboE5kljZ4PVXfNtiHCBJc6gOYSBJJ8
         2pacY4OVFWPUJVUVSxMcHKujLF7pqS0WA2WZ9djFnzyiUgSufQGInPYXwJrOkWw6KsTV
         omaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p3AKvN/tO+lhaStDPMa1Kw8KDL4h3X77pfKSOUhTuZk=;
        b=q0msIuz74/2VwoJh1grB7+h3/8ut2BXxEG65XP47+jloBc8LJVM9kT04rEuypdJmyB
         dm/VQyp2IftGLNWqoTcodd54kJ/1ZVe4pFEfKvNmuiKsvWk7rZH1a4nnoSV+ALMh51hq
         ObBKrVngIVS5vHDjChHYHvJGNoslW/O+mdEGFovhHKN1Kc5SWS7wg0hqhJDKqf+WATyG
         ppOUCioA0hG88A8Eco0TOne9BUjiABM5n79fvYetYVnFfKzM7NyKkZErVnSRbGZ39rQp
         PV/DoABjV3LpLdVc28zQ3/SdHNK6cIa4ZgRiyLP45JVyMXgrJhErJsk9Xkfc3XQNI01A
         M0+Q==
X-Gm-Message-State: APjAAAVD/C5sOU7wPhRBsiTSntOj89D1TIhmqep1z/OUmZBHntkCVYCH
	/sdJkcd8SkMXo1dnp7ylnXfuoF+5ztexnAtQv/5+ZA==
X-Google-Smtp-Source: APXvYqzoJ7fScot5IJtJR3Zs4sgBUozHcvjyasmsIy8iWbtKM78mSml1lJYH+LjB9sLuLiWV6UsObnMM2z0JQot5OFI=
X-Received: by 2002:a37:de12:: with SMTP id h18mr9389184qkj.256.1574937542172;
 Thu, 28 Nov 2019 02:39:02 -0800 (PST)
MIME-Version: 1.0
References: <20191121181519.28637-1-keescook@chromium.org> <CACT4Y+b3JZM=TSvUPZRMiJEPNH69otidRCqq9gmKX53UHxYqLg@mail.gmail.com>
 <201911262134.ED9E60965@keescook> <CACT4Y+bsLJ-wFx_TaXqax3JByUOWB3uk787LsyMVcfW6JzzGvg@mail.gmail.com>
 <CACT4Y+aFiwxT6SO-ABx695Yg3=Zam5saqCo4+FembPwKSV8cug@mail.gmail.com> <201911270952.D66CD15AEC@keescook>
In-Reply-To: <201911270952.D66CD15AEC@keescook>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 28 Nov 2019 11:38:50 +0100
Message-ID: <CACT4Y+a-0ZqGj0hQhOW=aUcjeQpf_487ASnnzdm_M2N7+z17Lg@mail.gmail.com>
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

On Wed, Nov 27, 2019 at 6:59 PM Kees Cook <keescook@chromium.org> wrote:
> > > > > > v2:
> > > > > >     - clarify Kconfig help text (aryabinin)
> > > > > >     - add reviewed-by
> > > > > >     - aim series at akpm, which seems to be where ubsan goes through?
> > > > > > v1: https://lore.kernel.org/lkml/20191120010636.27368-1-keescook@chromium.org
> > > > > >
> > > > > > This splits out the bounds checker so it can be individually used. This
> > > > > > is expected to be enabled in Android and hopefully for syzbot. Includes
> > > > > > LKDTM tests for behavioral corner-cases (beyond just the bounds checker).
> > > > > >
> > > > > > -Kees
> > > > >
> > > > > +syzkaller mailing list
> > > > >
> > > > > This is great!
> > > >
> > > > BTW, can I consider this your Acked-by for these patches? :)
> > > >
> > > > > I wanted to enable UBSAN on syzbot for a long time. And it's
> > > > > _probably_ not lots of work. But it was stuck on somebody actually
> > > > > dedicating some time specifically for it.
> > > >
> > > > Do you have a general mechanism to test that syzkaller will actually
> > > > pick up the kernel log splat of a new check?
> > >
> > > Yes. That's one of the most important and critical parts of syzkaller :)
> > > The tests for different types of bugs are here:
> > > https://github.com/google/syzkaller/tree/master/pkg/report/testdata/linux/report
> > >
> > > But have 3 for UBSAN, but they may be old and it would be useful to
> > > have 1 example crash per bug type:
> > >
> > > syzkaller$ grep UBSAN pkg/report/testdata/linux/report/*
> > > pkg/report/testdata/linux/report/40:TITLE: UBSAN: Undefined behaviour
> > > in drivers/usb/core/devio.c:LINE
> > > pkg/report/testdata/linux/report/40:[    4.556972] UBSAN: Undefined
> > > behaviour in drivers/usb/core/devio.c:1517:25
> > > pkg/report/testdata/linux/report/41:TITLE: UBSAN: Undefined behaviour
> > > in ./arch/x86/include/asm/atomic.h:LINE
> > > pkg/report/testdata/linux/report/41:[    3.805453] UBSAN: Undefined
> > > behaviour in ./arch/x86/include/asm/atomic.h:156:2
> > > pkg/report/testdata/linux/report/42:TITLE: UBSAN: Undefined behaviour
> > > in kernel/time/hrtimer.c:LINE
> > > pkg/report/testdata/linux/report/42:[   50.583499] UBSAN: Undefined
> > > behaviour in kernel/time/hrtimer.c:310:16
> > >
> > > One of them is incomplete and is parsed as "corrupted kernel output"
> > > (won't be reported):
> > > https://github.com/google/syzkaller/blob/master/pkg/report/testdata/linux/report/42
> > >
> > > Also I see that report parsing just takes the first line, which
> > > includes file name, which is suboptimal (too long, can't report 2 bugs
> > > in the same file). We seem to converge on "bug-type in function-name"
> > > format.
> > > The thing about bug titles is that it's harder to change them later.
> > > If syzbot already reported 100 bugs and we change titles, it will
> > > start re-reporting the old one after new names and the old ones will
> > > look stale, yet they still relevant, just detected under different
> > > name.
> > > So we also need to get this part right before enabling.
>
> It Sounds like instead of "UBSAN: Undefined behaviour in $file", UBSAN
> should report something like "UBSAN: $behavior in $file"?
>
> e.g.
> 40: UBSAN: bad shift in drivers/usb/core/devio.c:1517:25"
> 41: UBSAN: signed integer overflow in ./arch/x86/include/asm/atomic.h:156:2

If you mean make them such that kernel testing systems could simply
take the first line as "crash identity", then most likely we need
function name there instead of file:line:column. At least this seems
to be working the best based on our experience.


> I'll add one for the bounds checker.
>
> How are these reports used?

There are test inputs, each also contains expected parsing output
(title at minimum, but can also contain crash type, corrupted mark,
extracted "report") and that's verified against actual parsing result.


> (And is there a way to check a live kernel
> crash? i.e. to tell syzkaller "echo ARRAY_BOUNDS >/.../lkdtm..." and
> generate a report?

Unfortunately all of kernel tooling is completely untested at the
moment. We would very much like to have all sanitizers tested in a
meaningful way, e.g.:
https://github.com/llvm-mirror/compiler-rt/blob/master/test/asan/TestCases/global-overflow.cpp#L15-L18
But also LOCKDEP, KMEMLEAK, ODEBUG, FAULT_INJECTS, etc, all untested
too. Nobody knows what they produce, and if they even still detect
bugs, report false positives, etc.
But that's the kernel testing story...

No, syzbot does not do kernels unit-testing. And there are no such
tests anyways...



> > > > I noticed a few things
> > > > about the ubsan handlers: they don't use any of the common "warn"
> > > > infrastructure (neither does kasan from what I can see), and was missing
> > > > a check for panic_on_warn (kasan has this, but does it incorrectly).
> > >
> > > Yes, panic_on_warn we also need.
> > >
> > > I will look at the patches again for Acked-by.
> >
> >
> > Acked-by: Dmitry Vyukov <dvyukov@google.com>
> > for the series.
>
> Thanks!
>
> >
> > I see you extended the test module, do you have samples of all UBSAN
> > report types that are triggered by these functions? Is so, please add
> > them to:
> > https://github.com/google/syzkaller/tree/master/pkg/report/testdata/linux/report
>
> Okay, cool.
>
> > with whatever titles they are detected now. Improving titles will then
> > be the next step, but much simpler with a good collection of tests.
> >
> > Will you send the panic_on_want patch as well?
>
> Yes; I wanted to make sure it was needed first (which you've confirmed
> now). I'll likely not send it until next week.
>
> --
> Kees Cook
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/201911270952.D66CD15AEC%40keescook.
