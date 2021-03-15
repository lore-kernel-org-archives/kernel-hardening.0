Return-Path: <SRS0=z3BA=IN=lists.openwall.com=kernel-hardening-return-20945-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3924DC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Mar 2021 22:19:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 48A9564F07
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Mar 2021 22:19:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48A9564F07
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20945-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20261 invoked by uid 550); 15 Mar 2021 22:19:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20238 invoked from network); 15 Mar 2021 22:19:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JHuD9L12GwXv9CMjuewy7NJi4UEeZj8gMIMY0fXoMjo=;
        b=S+PBvkiNvoS7h8zAD5cjsSRJz4FVPn0bUbOW1vAx3cSOxv0XYlgWOMD63ht2EW+UvG
         WqRwvdt1hEocnp30SVofJDviTh5NFMlDuAZFdZ0CFQTPQzKAvpCn4FZXTYX5F2Q7x0TA
         w6hkZe/5rBy3BNMBjtwIU8r7P3WUEjnalDrr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JHuD9L12GwXv9CMjuewy7NJi4UEeZj8gMIMY0fXoMjo=;
        b=jRZARi1mkkJk1AKQFvI+flV5iWJO+XwZmEYf779iEa3SK5BRMRSCdVb8VYeJPqjhv6
         apwvD7S3a5jbXbHqD5RP2m1NBfdUOmimr6dKH5dYwI3ueaBvep/NEYEDKOhYUOUqx/P6
         aGnho/DQZ3aXh7eGGEHMq+QycwRUWp2jcNooqZ/Lmppjd4OgiBy75P3gBg2zgQhULiEC
         PjwgkZ9mw2J3cSCbJ/qmbn2UZ2G5XpzjnY4Ar+++wEcJvYjAT0uvp0L1YFwVJKar/zAG
         eBpfldmqaHO73YMrGPEKsMrcIwlAVqJ9n7K0FH3W+TYGXeFCs3It9a9/F8eEcYGYTzUR
         buoA==
X-Gm-Message-State: AOAM532K84polOk/mv7lgg4SsSnBDFyRndYVAUZkfoER7B3Dd4wldlKC
	MFQYqQDe0Y/xpe0XHG9nnTkCtYgv2/6nZw==
X-Google-Smtp-Source: ABdhPJyvVRB9no/0fA6z3VGsQbNLVh+SDzXHLqeKykd0EDlUPH6aLV4Udbfy5DJ1zCBpWvcM8jk3Sg==
X-Received: by 2002:a05:651c:119b:: with SMTP id w27mr682968ljo.237.1615846775177;
        Mon, 15 Mar 2021 15:19:35 -0700 (PDT)
X-Received: by 2002:a2e:a589:: with SMTP id m9mr729361ljp.220.1615846773296;
 Mon, 15 Mar 2021 15:19:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1615372955.git.gladkov.alexey@gmail.com>
 <59ee3289194cd97d70085cce701bc494bfcb4fd2.1615372955.git.gladkov.alexey@gmail.com>
 <202103151426.ED27141@keescook>
In-Reply-To: <202103151426.ED27141@keescook>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 15 Mar 2021 15:19:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjYOCgM+mKzwTZwkDDg12DdYjFFkmoFKYLim7NFmR9HBg@mail.gmail.com>
Message-ID: <CAHk-=wjYOCgM+mKzwTZwkDDg12DdYjFFkmoFKYLim7NFmR9HBg@mail.gmail.com>
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

On Mon, Mar 15, 2021 at 3:03 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, Mar 10, 2021 at 01:01:28PM +0100, Alexey Gladkov wrote:
> > The current implementation of the ucounts reference counter requires the
> > use of spin_lock. We're going to use get_ucounts() in more performance
> > critical areas like a handling of RLIMIT_SIGPENDING.
>
> This really looks like it should be refcount_t.

No.

refcount_t didn't have the capabilities required.

It just saturates, and doesn't have the "don't do this" case, which
the ucounts case *DOES* have.

In other words, refcount_t is entirely misdesigned for this - because
it's literally designed for "people can't handle overflow, so we warn
and saturate".

ucounts can never saturate, because they replace saturation with
"don't do that then".

In other words, ucounts work like the page counts do (which also don't
saturate, they just say "ok, you can't get a reference".

I know you are attached to refcounts, but really: they are not only
more expensive, THEY LITERALLY DO THE WRONG THING.

           Linus
