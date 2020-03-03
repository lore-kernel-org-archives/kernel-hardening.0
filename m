Return-Path: <SRS0=asha=4U=lists.openwall.com=kernel-hardening-return-18050-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843ECC3F2C6
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Mar 2020 10:55:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D3E482080C
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Mar 2020 10:55:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cHfeDd+4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3E482080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18050-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15419 invoked by uid 550); 3 Mar 2020 10:55:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15387 invoked from network); 3 Mar 2020 10:55:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5jOtb1BhiQGowh0BlpaOUSt5dD3Y3nnseudePnuupsw=;
        b=cHfeDd+442pgG4b/emVO6vf5Em46uyQ+GDRrlICxDJVRD47vglceX82KFDS0Vm8SD9
         oRtBchajRwoRkQB/bedPnFlMocEdFuRUAu90+bbyeU2BB7f8g3tVAzvYqyCL5oFYKZMa
         clf0GPpMGd1Jp2wMFfMqs8v7ZJSas7tD1FJRHLekgKI2Fvx/uo588hi7d2bkQ/2oQnfb
         u9MQj+B+JAUB2+3Jnh5hNxq9VdaQOR2TLuBNomFqMdrbqwJqb/GSpfw1KnGd4Da64tT6
         qQXAW3TQ8xChY33J+pD8+m0/A/FTAwV8F9twKvMkKpiPBeAWKhfEScUw9PPF6vvWW6il
         0Csw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5jOtb1BhiQGowh0BlpaOUSt5dD3Y3nnseudePnuupsw=;
        b=tWYLdnDnqze7cXVcPMEygZNOKFXNqv8gBvOr5l6/pYx+U488YnS43+ech+gYOH50PV
         xqUkd5lOGQ93xtqh1PEr7mC55xBxkUHBUVm0b9T0Nk8ts1dQnIDjcxZPz7/9l6lYJOft
         fRSfaiUps/Lc36qzvcvyTqzuEqL6SCn5ran/FEplY9smCcdeExeB6XOSLY5FDjOpU5YE
         //HrrLPIWLykGmueXstP9msto1S+IGOnr/1V4DxV0KKAXsQ/Qq597fGGDQiORMt0kz/P
         t2gmOiQngJbH8q3HQE+yTl09utuJiD0mkHUP3EDXj7qHHn57Lrtb91ANq/1viTnWcIGc
         3QIw==
X-Gm-Message-State: ANhLgQ3zlyt16ZwuzAfExxYa9OsUf52llLjY/Td79stWfBMRtDxi9LG+
	3R13ysN+REQTQFiEiVVrLT7zkIVBzdZsvXwnP5Yfwg==
X-Google-Smtp-Source: ADFU+vt/0Pkh4xRMSjFYvG0yXIdUv50c98auM9c2ECjtGeoOY5Pb0fIzNq1xj7NtvCkYQoGZ0HC3bO8/F0nNkjluzTA=
X-Received: by 2002:aca:d954:: with SMTP id q81mr2031587oig.157.1583232918470;
 Tue, 03 Mar 2020 02:55:18 -0800 (PST)
MIME-Version: 1.0
References: <20200302195352.226103-1-jannh@google.com> <202003021434.713F5559@keescook>
In-Reply-To: <202003021434.713F5559@keescook>
From: Jann Horn <jannh@google.com>
Date: Tue, 3 Mar 2020 11:54:52 +0100
Message-ID: <CAG48ez12FYHoHY8PB2r7H_JtJ8NatEuRB8Ej0y9pfpp9EnnnsA@mail.gmail.com>
Subject: Re: [PATCH] lib/refcount: Document interaction with PID_MAX_LIMIT
To: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, kernel list <linux-kernel@vger.kernel.org>, 
	Elena Reshetova <elena.reshetova@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Hanjun Guo <guohanjun@huawei.com>, Jan Glauber <jglauber@marvell.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Mar 2, 2020 at 11:37 PM Kees Cook <keescook@chromium.org> wrote:
> On Mon, Mar 02, 2020 at 08:53:52PM +0100, Jann Horn wrote:
> > Document the circumstances under which refcount_t's saturation mechanism
> > works deterministically.
> >
> > Signed-off-by: Jann Horn <jannh@google.com>
>
> Acked-by: Kees Cook <keescook@chromium.org>
>
> With one note below...
>
> > ---
> >  include/linux/refcount.h | 19 ++++++++++++++-----
> >  1 file changed, 14 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/refcount.h b/include/linux/refcount.h
> > index 0ac50cf62d062..cf14db393d89d 100644
> > --- a/include/linux/refcount.h
> > +++ b/include/linux/refcount.h
> > @@ -38,11 +38,20 @@
> >   * atomic operations, then the count will continue to edge closer to 0. If it
> >   * reaches a value of 1 before /any/ of the threads reset it to the saturated
> >   * value, then a concurrent refcount_dec_and_test() may erroneously free the
> > - * underlying object. Given the precise timing details involved with the
> > - * round-robin scheduling of each thread manipulating the refcount and the need
> > - * to hit the race multiple times in succession, there doesn't appear to be a
> > - * practical avenue of attack even if using refcount_add() operations with
> > - * larger increments.
> > + * underlying object.
> > + * Linux limits the maximum number of tasks to PID_MAX_LIMIT, which is currently
> > + * 0x400000 (and can't easily be raised in the future beyond FUTEX_TID_MASK).
>
> Maybe just to clarify and make readers not have to go search the source:
>
>         "... beyond FUTEX_TID_MASK, which is UAPI defined as 0x3fffffff)."

The value of that thing has changed three times in git history, and
there is a comment in threads.h that refers to it as being 0x1fffffff;
so I'm a bit hesitant to copy that around further.

> and is it worth showing the math on this, just to have it clearly
> stated?

Hm, I suppose... I'll send a v2.

> -Kees
>
> > + * With the current PID limit, if no batched refcounting operations are used and
> > + * the attacker can't repeatedly trigger kernel oopses in the middle of refcount
> > + * operations, this makes it impossible for a saturated refcount to leave the
> > + * saturation range, even if it is possible for multiple uses of the same
> > + * refcount to nest in the context of a single task.
> > + * If hundreds of references are added/removed with a single refcounting
> > + * operation, it may potentially be possible to leave the saturation range; but
> > + * given the precise timing details involved with the round-robin scheduling of
> > + * each thread manipulating the refcount and the need to hit the race multiple
> > + * times in succession, there doesn't appear to be a practical avenue of attack
> > + * even if using refcount_add() operations with larger increments.
