Return-Path: <SRS0=WW/+=II=lists.openwall.com=kernel-hardening-return-20920-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF95C433DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Mar 2021 21:15:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D11DC64FC9
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Mar 2021 21:15:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D11DC64FC9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20920-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1883 invoked by uid 550); 10 Mar 2021 21:14:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1863 invoked from network); 10 Mar 2021 21:14:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mWjSyj9+MgpkAuhvTxP4EPO0ZRIe4bF8NB224VR5k5Y=;
        b=PIqDJ2U0GSCx4NtqwWKrFE9QHN7qXy5qh2Js/ocQazC6t5gl+kXnW0bxIJE/LFuD2k
         T6xs2xk/6PHqSWp9K4hjRH0M1ASKEW1Ap/K9lX9Q8UAOfl66sg1BvnzXj2ilccmkluus
         iX3LkCYCwJNr7hiSwfQg9Kx4Hg3FIHAwDl0VY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mWjSyj9+MgpkAuhvTxP4EPO0ZRIe4bF8NB224VR5k5Y=;
        b=C4zhQTVqnDOA3xlpI0mvzxONdLa5ZQ4WnmsyI8IuDcv8LpU7y4vkzAms7tg2W5jbU9
         0olQR4VX43vzPBD2VNGM5TQ+QfO0gYBfpE7Msij1TRgeHvfPh452buaUJWqzreidyQCm
         XQkgeL2iJeFsOgk6MlhxaUTp8npUf3gDkOvt37bboYA2krY/6jRB9rIalGobKo7kSlM5
         hvvWQdct399yWZJy6wdB8p/HPqnwdBVvEp7vLoDZu1guXtrt07vMXUgRPXomdPeo1qej
         1ffUhP5w4hV/JxRIiA4qQZRGOE66fH0lwnimypO0kUytsCNVdyspPksRfSSSkh9x2yXb
         z2Xw==
X-Gm-Message-State: AOAM530BM5VUrbzMtRlLQKnUf1oQoJbXWb5ki6u54dIPXrtWLR+6nHD2
	iBCafDhc6mNoMWKfMk2PnJs5zYvauWXU4Q==
X-Google-Smtp-Source: ABdhPJyfeXijo8MyXWu+I5beyEHckxthvTbGD4l9Y3gtWsMPT0NGE+hJ7q1nCCLu5yg9eQPVNuXY7Q==
X-Received: by 2002:a2e:1558:: with SMTP id 24mr2990211ljv.502.1615410882547;
        Wed, 10 Mar 2021 13:14:42 -0800 (PST)
X-Received: by 2002:a2e:5c84:: with SMTP id q126mr2800569ljb.61.1615410880841;
 Wed, 10 Mar 2021 13:14:40 -0800 (PST)
MIME-Version: 1.0
References: <cover.1615372955.git.gladkov.alexey@gmail.com> <59ee3289194cd97d70085cce701bc494bfcb4fd2.1615372955.git.gladkov.alexey@gmail.com>
In-Reply-To: <59ee3289194cd97d70085cce701bc494bfcb4fd2.1615372955.git.gladkov.alexey@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 10 Mar 2021 13:14:24 -0800
X-Gmail-Original-Message-ID: <CAHk-=whg4aVxA7LFAUFCzOn78_7TL1CPo+esPKgN5JTHy8H-Rg@mail.gmail.com>
Message-ID: <CAHk-=whg4aVxA7LFAUFCzOn78_7TL1CPo+esPKgN5JTHy8H-Rg@mail.gmail.com>
Subject: Re: [PATCH v8 3/8] Use atomic_t for ucounts reference counting
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, io-uring <io-uring@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux Containers <containers@lists.linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, 
	Alexey Gladkov <legion@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Christian Brauner <christian.brauner@ubuntu.com>, "Eric W . Biederman" <ebiederm@xmission.com>, 
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@chromium.org>, 
	Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 10, 2021 at 4:01 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
>
> +/* 127: arbitrary random number, small enough to assemble well */
> +#define refcount_zero_or_close_to_overflow(ucounts) \
> +       ((unsigned int) atomic_read(&ucounts->count) + 127u <= 127u)
> +
> +struct ucounts *get_ucounts(struct ucounts *ucounts)
> +{
> +       if (ucounts) {
> +               if (refcount_zero_or_close_to_overflow(ucounts)) {
> +                       WARN_ONCE(1, "ucounts: counter has reached its maximum value");
> +                       return NULL;
> +               }
> +               atomic_inc(&ucounts->count);
> +       }
> +       return ucounts;

Side note: you probably should just make the limit be the "oh, the
count overflows into the sign bit".

The reason the page cache did that tighter thing is that it actually
has _two_ limits:

 - the "try_get_page()" thing uses the sign bit as a "uhhuh, I've now
used up half of the available reference counting bits, and I will
refuse to use any more".

   This is basically your "get_ucounts()" function. It's a "I want a
refcount, but I'm willing to deal with failures".

 - the page cache has a _different_ set of "I need to unconditionally
get a refcount, and I can *not* deal with failures".

   This is basically the traditional "get_page()", which is only used
in fairly controlled places, and should never be something that can
overflow.

    And *that* special code then uses that
"zero_or_close_to_overflow()" case as a "doing a get_page() in this
situation is very very wrong". This is purely a debugging feature used
for a VM_BUG_ON() (that has never triggered, as far as I know).

For your ucounts situation, you don't have that second case at all, so
you have no reason to ever allow the count to even get remotely close
to overflowing.

A reference count being within 128 counts of overflow (when we're
talking a 32-bit count) is basically never a good idea. It means that
you are way too close to the limit, and there's a risk that lots of
concurrent people all first see an ok value, and then *all* decide to
do the increment, and then you're toast.

In contrast, if you use the sign bit as a "ok, let's stop
incrementing", the fact that your "overflow" test and the increment
aren't atomic really isn't a big deal.

(And yes, you could use a cmpxchg to *make* the overflow test atomic,
but it's often much much more expensive, so..)

                    Linus
