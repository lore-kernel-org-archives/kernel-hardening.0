Return-Path: <SRS0=C3uT=IO=lists.openwall.com=kernel-hardening-return-20957-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD94C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Mar 2021 19:34:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 82D1A64E07
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Mar 2021 19:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82D1A64E07
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20957-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5659 invoked by uid 550); 16 Mar 2021 19:34:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5639 invoked from network); 16 Mar 2021 19:34:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PJ8ESo0xqLlhuMcPL8POiu1QM1DGh9i+Siia5DD90iA=;
        b=PjQAR7jNs9aEbwhkT9krh4CX5Eq0E0nqKvuTh1ox18H2jnLEyvjLF0ogBNQZx70+qE
         w88lKXrGNC0u2RLFwPYEFIJJP7fzVM1wcZzREZLxuIVXkxTvV3Utf4GXsqCDaqxts1Nt
         pQkwtLqPxVJxeYhj4PkZwJA43mxfvW69caxtc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PJ8ESo0xqLlhuMcPL8POiu1QM1DGh9i+Siia5DD90iA=;
        b=f4kIgfOWt2m/HtiXKaVF6B/jv8bV/wGCVpcyA4tJQWjDZ5v9vx3oaS7FeDtlFRz6xH
         YectqC5iEphaEWLm6R3v+qIEpCOSM81h9H2TYFrB/5vTz3E7xLLRAxJlhTlCTsG1TX9O
         mXRu4TWOkOk7fmgUBKCOIjIi5kn28f63D4SwOFGb98TFnMY5Y3HkTn4O5yi4OftNKTyR
         i3kJvylT2L8ZsPUwrRBo9AWER3jZf6t64dg0GJO0ahytL2B1lRwAhafWtySRimF2mPXU
         dygvpToQ+TDzkWB6dfzD8FmgjEcd4o1hZ1txXEPzITNEVk/Gsc05fiSFseqDm6tZegLd
         KysA==
X-Gm-Message-State: AOAM531laXyoaH/T7TIlem+DcrNQL6ZNB3m2NY2L3v1V3OskNeAEj1X9
	ndSEKesuU03seEZ4nB+RIPS3CoF39Ovn7Q==
X-Google-Smtp-Source: ABdhPJwPqcBtTusB8lO8fSeAqm1M092I3AChm0BkSsy9VrtfPHB0zYS3vW4h4eoIpuVpd1qYt5xD9Q==
X-Received: by 2002:a05:6402:14cc:: with SMTP id f12mr39303876edx.19.1615923261014;
        Tue, 16 Mar 2021 12:34:21 -0700 (PDT)
X-Received: by 2002:a2e:9bd0:: with SMTP id w16mr118915ljj.465.1615922781857;
 Tue, 16 Mar 2021 12:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1615372955.git.gladkov.alexey@gmail.com>
 <59ee3289194cd97d70085cce701bc494bfcb4fd2.1615372955.git.gladkov.alexey@gmail.com>
 <202103151426.ED27141@keescook> <CAHk-=wjYOCgM+mKzwTZwkDDg12DdYjFFkmoFKYLim7NFmR9HBg@mail.gmail.com>
 <202103161146.E118DE5@keescook>
In-Reply-To: <202103161146.E118DE5@keescook>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Mar 2021 12:26:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj7k2nCB8Q5kMYsYi1ajb99yZ-EYn_MYFMQ2bw3nWuT5Q@mail.gmail.com>
Message-ID: <CAHk-=wj7k2nCB8Q5kMYsYi1ajb99yZ-EYn_MYFMQ2bw3nWuT5Q@mail.gmail.com>
Subject: Re: [PATCH v8 3/8] Use atomic_t for ucounts reference counting
To: Kees Cook <keescook@chromium.org>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	io-uring <io-uring@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux Containers <containers@lists.linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, 
	Alexey Gladkov <legion@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Christian Brauner <christian.brauner@ubuntu.com>, "Eric W . Biederman" <ebiederm@xmission.com>, 
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 16, 2021 at 11:49 AM Kees Cook <keescook@chromium.org> wrote:
>
> Right -- I saw that when digging through the thread. I'm honestly
> curious, though, why did the 0-day bot find a boot crash? (I can't
> imagine ucounts wrapped in 0.4 seconds.) So it looked like an
> increment-from-zero case, which seems like it would be a bug?

Agreed. It's almost certainly a bug. Possibly a use-after-free, but
more likely just a "this count had never gotten initialized to
anything but zero, but is used by the init process (and kernel
threads) and will be incremented but never be free'd, so we never
noticed"

> Heh, right -- I'm not arguing that refcount_t MUST be used, I just didn't
> see the code path that made them unsuitable: hitting INT_MAX - 128 seems
> very hard to do. Anyway, I'll go study it more to try to understand what
> I'm missing.

So as you may have seen later in the thread, I don't like the "INT_MAX
- 128" as a limit.

I think the page count thing does the right thing: it has separate
"debug checks" and "limit checks", and the way it's done it never
really needs to worry about doing the (often) expensive cmpxchg loop,
because the limit check is _so_ far off the final case that we don't
care, and the debug checks aren't about races, they are about "uhhuh,
yoiu used this wrong".

So what the page code does is:

 - try_get_page() has a limit check _and_ a debug check:

    (a) the limit check is "you've used up half the refcounts, I'm not
giving you any more".
    (b) the debug check is "you can't get a page that has a zero count
or has underflowed".

   it's not obvious that it has both of those checks, because they are
merged into one single WARN_ON_ONCE(), but that's purely for "we
actually want that warning for the limit check, because that looks
like somebody trying an attack" and it just got combined.

   So technically, the code really should do

        page = compound_head(page);
        /* Debug check for mis-use of the count */
        if (WARN_ON_ONCE(page_ref_zero_or_close_to_overflow(page)))
                return false;
        /*
         * Limit check - we're not incrementing the
         * count (much) past the halfway point
         */
        if (page_ref_count(page) <= 0)
                return false;

        /* The actual atomic reference - the above were done "carelessly" */
        page_ref_inc(page);
        return true;

   because the "oh, we're not allowing you this ref" is not
_technically_ wrong, it's just traditionally wrong, if you see what I
mean.

and notice how none of the above really cares about the
"page_ref_inc()" itself being atomic wrt the checks.  It's ok if we
race, and the page ref goes a bit above the half-way point. You can't
race _so_ much that you actually overflow, because our limit check is
_so_ far away from the overflow area that it's not an issue.

And similarly, the debug check with
page_ref_zero_or_close_to_overflow() is one of those things that are
trying to see underflows or bad use-cases, and trying to do that
atomically with the actual ref update doesn't really help. The
underfulow or mis-use will have happened before we increment the page
count.

So the above is very close to what the ucounts code I think really
wants to do: the "zero_or_close_to_overflow" is an error case: it
means something just underflowed, or you were trying to increment a
ref to something you didn't have a reference to in the first place.

And the "<= 0" check is just the cheap test for "I'm giving you at
most half the counter space, because I don't want to have to even
remotely worry about overflow".

Note that the above very intentionally does allow the "we can go over
the limit" case for another reason: we still have that regular
*unconditional* get_page(), that has a "I absolutely need a temporary
ref to this page, but I know it's not some long-term thing that a user
can force". That's not only our traditional model, but it's something
that some kernel code simply does need, so it's a good feature in
itself. That might be less of an issue for ucounts, but for pages, we
somethines do have "I need to take a ref to this page just for my own
use while I then drop the page lock and do something else".

The "put_page()" case then has its own debug check (in
"put_page_testzero()") which says "hey, you can't put a page that has
no refcount.

Thct could could easily use that "zero_or_close_to_overflow(()" rule
too, but if you actually do underflow for real, you'll see the zero
(again - races aren't really important because even if you have some
attack vector that depends on the race, such attack vectors will also
have to depend on doing the thing over and over and over again until
it successfully hits the race, so you'll see the zero case in
practice, and trying to be "atomic" for debug testing is thus
pointless.

So I do think out page counting this is actually pretty good.

And it's possible that "refcount_t" could use that exact same model,
and actually then offer that option that ucounts wants, of a "try to
get a refcount, but if we have too many refcounts, then never mind, I
can just return an error to user space instead".

Hmm? On x86 (and honestly, these days on arm too with the new
atomics), it's generally quite a bit cheaper to do an atomic
increment/decrement than it is to do a cmpxchg loop. That seems to
become even more true as microarchitectures optimize those atomics -
apparently AMD actually does regular locked ops by doing them
optimistically out-of-order, and verifying that the serialization
requirements hold after-the-fact. So plain simple locked ops that
historically used to be quite expensive are getting less so (because
they've obviously gotten much more important over the years).

                Linus
