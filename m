Return-Path: <SRS0=jTPb=CU=lists.openwall.com=kernel-hardening-return-19882-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DADBC43461
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Sep 2020 18:47:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 34A0722208
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Sep 2020 18:47:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bc90pNkL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 34A0722208
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19882-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7352 invoked by uid 550); 11 Sep 2020 18:47:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26565 invoked from network); 11 Sep 2020 15:15:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ufdcEHy1PC/ezqsDkWS+TD6mTdL2tp2wTQ8CZ+/qEf4=;
        b=Bc90pNkLgX/h4MhEiVG6O4ps43IfI/m7/Zc7dCGFHr18Vx68b8DyKVqeGXSvVPfImY
         p3UbApPC5gPzgFbeD/tTJddfuQtyP2DuUCzY9ldYyi1uN1s3/JPjNz4ncAVRVhWbGs8w
         PMOiLoSSFz84Cck5e/jpWOOp9rKhln9p6EbkwJ6kydDU5QFXDF12jgUuv2sea45R0aiO
         JFrV+VIva6QeigZwcNREL7G5Xb92/fxuQ0uJ3ni5LofpK+I72th9YigCYAnqcdpV9nVp
         9OCa1A7lmyHBBI3ai9XaOMNzh8HDgDFBCi5aIvVos8p7VtWo8DL1t/FpR4KSx17aAv8Z
         ZU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ufdcEHy1PC/ezqsDkWS+TD6mTdL2tp2wTQ8CZ+/qEf4=;
        b=AMWoFcRrCvK+Uqd9ketPYDpQbuc+kBUYpHGcHrk6Gz0179Y5cKebGq9EhzmBjt5F43
         BBU3KuX0JGN+KrKy/H2pWx4hCDIKDiiYzFZdlXes6tmtUjEV92+6x9xtC4f6czecvT+K
         1XKyRVbf1f7y80HAtleAY9MtoCA4CYX9cvYxneV8EAbJU4OlB8W09es9wQ8y4pg2+rat
         Y34ZSpLSmqzafCHZ2VV0Ux4ZLKwgDbWtXd4B7Vgz1sAWFBLumh+tyWCo3qhTShElxX44
         lSmk6c12nLClB4CC4vpTTWKpUc0FHHac8P/0NmlMyiLwdqCuF3Jgz8FhqCsQGYBRYaHf
         KyiQ==
X-Gm-Message-State: AOAM532314wSu34XgeIT5ydD3SHzKramtkPFLaIvcgv2qUug8+W39eWR
	nkHgTATPZ0RcKtU/F46BqGU4WJoZCc2Yd8VEg2e2/A==
X-Google-Smtp-Source: ABdhPJyvZhR8i/gmsNhZsOdEJ+iRUX+LvrerRs093pQQn9n7rb6cL2TL4s+8cWYimF1Ux+s7FkMTaMK3o/zc9ap7hNg=
X-Received: by 2002:a05:6e02:1141:: with SMTP id o1mr2099807ill.275.1599837320632;
 Fri, 11 Sep 2020 08:15:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200910134802.3160311-1-lenaptr@google.com> <CAG48ez3x51kkDt19ONXbi8Se+2swMgwfmaj7AFbBqmss=D38Ug@mail.gmail.com>
In-Reply-To: <CAG48ez3x51kkDt19ONXbi8Se+2swMgwfmaj7AFbBqmss=D38Ug@mail.gmail.com>
From: Elena Petrova <lenaptr@google.com>
Date: Fri, 11 Sep 2020 16:15:09 +0100
Message-ID: <CABvBcwY2FLJxc80Leibv=zZ-e_YbjkE+ZBH2LNoFy8HAeD8m6Q@mail.gmail.com>
Subject: Re: [PATCH] sched.h: drop in_ubsan field when UBSAN is in trap mode
To: Jann Horn <jannh@google.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	kernel list <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

Hi Jann,

On Thu, 10 Sep 2020 at 20:35, Jann Horn <jannh@google.com> wrote:
>
> On Thu, Sep 10, 2020 at 3:48 PM Elena Petrova <lenaptr@google.com> wrote:
> > in_ubsan field of task_struct is only used in lib/ubsan.c, which in its
> > turn is used only `ifneq ($(CONFIG_UBSAN_TRAP),y)`.
> >
> > Removing unnecessary field from a task_struct will help preserve the
> > ABI between vanilla and CONFIG_UBSAN_TRAP'ed kernels. In particular,
> > this will help enabling bounds sanitizer transparently for Android's
> > GKI.
>
> The diff looks reasonable to me, but I'm curious about the
> justification in the commit message:
>
> Is the intent here that you want to be able to build a module without
> CONFIG_UBSAN and load it into a kernel that is built with
> CONFIG_UBSAN? Or the inverse?

The former. But more precisely, with GKI Google gives a promise, that
when certain GKI is released, i.e. at 4.19, its ABI will never ever
change (or, perhaps only change with <next letter> Android release),
so vendor modules could have an independent development lifecycle. And
this patch, when backported, will help enable boundsan on kernels
where ABI has already been frozen.

> Does this mean that in the future, gating new exported functions, or
> new struct fields, on CONFIG_UBSAN (independent of whether
> CONFIG_UBSAN_TRAP is set) will break Android?

I don't understand what you mean here, sorry.

> If you really want to do this, and using alternatives to patch out the
> ubsan instructions is not an option, I wonder whether it would be more
> reasonable to at least add a configuration where CONFIG_UBSAN is
> enabled but the compiler flag is not actually set. Then you could
> unconditionally build that android kernel and its modules with that
> config option, and wouldn't have to worry about structure size issues,
> dependencies on undefined symbols and so on.

Such setup might be confusing for developers. We were considering
something similar: to keep the in_ubsan field regardless of the
CONFIG_UBSAN option. But since non-trap mode is unlikely to be used on
production devices due to size and performance overheads, I think it's
better to just get rid of an unused field, rather than balloon
task_struct.

Cheers,
*lenaptr
