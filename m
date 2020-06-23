Return-Path: <SRS0=Unhy=AE=lists.openwall.com=kernel-hardening-return-19053-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FE3C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 07:18:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 78D33206B7
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 07:18:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GFGAJQQi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78D33206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19053-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11934 invoked by uid 550); 23 Jun 2020 07:18:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11890 invoked from network); 23 Jun 2020 07:18:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/MteRsl9kXDCB4cggamm2Lh5J0tgrSbPos+TELxySHU=;
        b=GFGAJQQi1vlgS574df9wkmnHdutzQejXSmLQL6TuOhZHz6YbMAOJTWzBCXcY59KdvP
         fQhRMrcRfRBrKyNy9fr1lUbZEUNWmeG0bb4Bvmf2Znl/9fkT4uXgv3iyba7n8S5rDxMn
         ZM6ua0HAquw55QT8cERj8zpuUDUKpHpcaHyAK1lm8hp5Y3Gp81evklhU+GiWbsisBz+E
         8paTIfD66ibjOO/n1un/JaDhDU8fAD09sBWHJz3tpxUTARKmqTu+sMPT2JOtIIcOmMe9
         7VFZvn4/fD7BqLOzTcAzc365IA23qsmDECsyMCrd3IO0GtN5NCFJrv+r0q1h/ld3MbTk
         DGTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/MteRsl9kXDCB4cggamm2Lh5J0tgrSbPos+TELxySHU=;
        b=mJ071j1HXzERKnEeEOIyZlwpGZ9ro5XR7kXT7IHX3FVJTSN7pYe9J7QQ6hkCoE/Y5m
         giDQViI/p5LRhZ4b0bHnxNNIFkT4zvEqOw6FgP4rjhoKH74u/qwv/Qq/nXbN298NkOAk
         C4I45eJVJm8PSEf5k9nQAI5Z3nUSCnC03DUtsxg8R2XigM6QnalYogDdlmiG/AZ3s7mm
         xlvdcA9H+NHYP46cOaka0Me4LiKq5ClenXdqH9KgiM1pcfYlyI/uh9mzI4Z/27ExPMzE
         HyDeEa7r7yht/iT8cimHc7MIRUBVDBA4sNmC15CGp4iYpM6+QjhsFC9w41+yOL5PF8pY
         e+/A==
X-Gm-Message-State: AOAM532zEcbUxS0MO32RdOWN3Nl1LYcicxfJV/nP8bw0wwbvVwVaiebZ
	E9kdRVgvY2N3V5GkCoSATV39eBxx810O9pwt6qf73A==
X-Google-Smtp-Source: ABdhPJzBKXUo1WrxeNiIlTCMmGHuyvPThGqyPnmJVDrgKnV893ty/BBXSgNpVvwHEzdELkPKBcmoE6xkBS15DRWd09M=
X-Received: by 2002:a05:6808:34f:: with SMTP id j15mr15871155oie.121.1592896685597;
 Tue, 23 Jun 2020 00:18:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez2OrzBW9Cy13fJ2YHpYvAcn+2SbEmv_0MdrCufot65XUw@mail.gmail.com>
 <CACT4Y+acW32ng++GOfjkX=8Fe73u+DMhN=E0ffs13bHxa+_B5w@mail.gmail.com>
In-Reply-To: <CACT4Y+acW32ng++GOfjkX=8Fe73u+DMhN=E0ffs13bHxa+_B5w@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Tue, 23 Jun 2020 09:17:54 +0200
Message-ID: <CANpmjNMDHmLDWgR_YYBK-sgp9jHpN0et1X=UkQ4wt2SbtFAjHA@mail.gmail.com>
Subject: Re: Kernel hardening project suggestion: Normalizing ->ctor slabs and
 TYPESAFE_BY_RCU slabs
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Christoph Lameter <cl@linux.com>, 
	Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux-MM <linux-mm@kvack.org>, Andrey Konovalov <andreyknvl@google.com>, 
	Will Deacon <will@kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, 
	Kees Cook <keescook@google.com>, Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Jun 2020 at 08:45, Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Tue, Jun 23, 2020 at 8:26 AM Jann Horn <jannh@google.com> wrote:
> >
> > Hi!
> >
> > Here's a project idea for the kernel-hardening folks:
> >
> > The slab allocator interface has two features that are problematic for
> > security testing and/or hardening:
> >
> >  - constructor slabs: These things come with an object constructor
> > that doesn't run when an object is allocated, but instead when the
> > slab allocator grabs a new page from the page allocator. This is
> > problematic for use-after-free detection mechanisms such as HWASAN and
> > Memory Tagging, which can only do their job properly if the address of
> > an object is allowed to change every time the object is
> > freed/reallocated. (You can't change the address of an object without
> > reinitializing the entire object because e.g. an empty list_head
> > points to itself.)
> >
> >  - RCU slabs: These things basically permit use-after-frees by design,
> > and stuff like ASAN/HWASAN/Memory Tagging essentially doesn't work on
> > them.
> >
> >
> > It would be nice to have a config flag or so that changes the SLUB
> > allocator's behavior such that these slabs can be instrumented
> > properly. Something like:
> >
> >  - Let calculate_sizes() reserve space for an rcu_head on each object
> > in TYPESAFE_BY_RCU slabs, make kmem_cache_free() redirect to
> > call_rcu() for these slabs, and remove most of the other
> > special-casing, so that KASAN can instrument these slabs.
> >  - For all constructor slabs, let slab_post_alloc_hook() call the
> > ->ctor() function on each allocated object, so that Memory Tagging and
> > HWASAN will work on them.
>
> Hi Jann,
>
> Both things sound good to me. I think we considered doing the ctor's
> change with KASAN, but we did not get anywhere. The only argument
> against it I remember now was "performance", but it's not that
> important if this mode is enabled only with KASAN and other debugging
> tools. Performance is definitely not as important as missing bugs. The
> additional code complexity for ctors change should be minimal.
> The rcu change would also be useful, but I would assume it will be larger.
> Please add them to [1], that's KASAN laundry list.
>
> +Alex, Marco, will it be useful for KFENCE [2] as well? Do ctors/rcu
> affect KFENCE? Will we need any special handling for KFENCE?
> I assume it will also be useful for KMSAN b/c we can re-mark objects
> as uninitialized only after they have been reallocated.

Yes, we definitely need to handle TYPESAFE_BY_RCU.

> [1] https://bugzilla.kernel.org/buglist.cgi?bug_status=__open__&component=Sanitizers&list_id=1063981&product=Memory%20Management
> [2] https://github.com/google/kasan/commits/kfence
