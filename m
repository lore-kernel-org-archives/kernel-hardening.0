Return-Path: <kernel-hardening-return-21680-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 71DCFC3DA66
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Aug 2023 21:23:01 +0000 (UTC)
Received: (qmail 18001 invoked by uid 550); 25 Aug 2023 21:22:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17960 invoked from network); 25 Aug 2023 21:22:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692998560; x=1693603360; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sY4XdT0afbZqJDMtqEzLCUjgr5ro7J2PA8+3Z9sf64I=;
        b=wd30WQbcuM525kBWJUWmnoB/oJwkA/J50Td7KWxSgMA2GRuYGf/x5Qbv/CCiNLEM/A
         TIVS1+HS0oAKeFPr6vfs0ix1rPpn2nKfy4jduYk4/asu5dru9BOjmV9+jEqUMO20sXVF
         WEN0n59BAMmMGKuIAXXgqusNrYmMX47oWRghykcoQTDjwt9x/a15kXSS88rcWp5YOWfx
         FXPjk4FBAB2dPtqot8YjBvCGWEo0424aNeCw8t6vpTrthfuf5HD+eKnMGCKochHkDZRp
         DAdr9xb/37pHFAf7bm94jSRULdkavavngt5O15KCAcnI8XJM2Fp6cAqu+B/u+waEPLzW
         vujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692998560; x=1693603360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sY4XdT0afbZqJDMtqEzLCUjgr5ro7J2PA8+3Z9sf64I=;
        b=R7G8wW5hbW4IvlMwLuORBB5ZHmFc1ywFt6cMIh4p+ZmCKN4E63jCvHIq+kEIA76H34
         Zw9dHz22r18K4B/3Ot78b4gYSEaseAMdXkKB5c5JWsR8bLxGhDQXBFtBH1MYNOYAychf
         YtMhf8jdEv4GTCD0wSqPxaehGS/a0spUWSnKfxj3X4nRe568xXR0XXi583PUTrb9kgvz
         kT7M9ZaFrf3Gu6IUnis27ppLt4BR2j8RR51Z+Dz6Bb5dE3XfejHPpyx8Ll//SFScE44C
         AmvnBdwLh2GvIgVlNcG0WIaUHvpfemiUjWz2iYYFSHusUs0rJVwbd1ppd2IbYTEtiWLx
         gPHA==
X-Gm-Message-State: AOJu0YwjvxJO1n9JvlRpACkXtO4+hKuWOlPRbXvJmiuNXDJwppBCsoxa
	AgfkQgERhS5QCScNG4HP25G3tt10IAeT1TMh1Sk4tJ37Ye1U5pauPRw=
X-Google-Smtp-Source: AGHT+IFJruxQz4dZ8s1YN87YFSZH1HJJv9ClNQAtgrsrR7NPxgGWX8sDMrakERqU/v4Mp0WagK0Cdzy2mUsDVdjLNBw=
X-Received: by 2002:a05:600c:3b8f:b0:400:46db:1bf2 with SMTP id
 n15-20020a05600c3b8f00b0040046db1bf2mr83152wms.2.1692998560041; Fri, 25 Aug
 2023 14:22:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez2OrzBW9Cy13fJ2YHpYvAcn+2SbEmv_0MdrCufot65XUw@mail.gmail.com>
In-Reply-To: <CAG48ez2OrzBW9Cy13fJ2YHpYvAcn+2SbEmv_0MdrCufot65XUw@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Aug 2023 23:22:03 +0200
Message-ID: <CAG48ez1OHWSnsPTg5BnNBiawkVVhuoTCx6Y4ZOE-HYJaRVnhHg@mail.gmail.com>
Subject: Re: Kernel hardening project suggestion: Normalizing ->ctor slabs and
 TYPESAFE_BY_RCU slabs
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, 
	Andrey Konovalov <andreyknvl@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Will Deacon <will@kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, 
	Kees Cook <keescook@google.com>, Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2020 at 8:26=E2=80=AFAM Jann Horn <jannh@google.com> wrote:
> Here's a project idea for the kernel-hardening folks:
>
> The slab allocator interface has two features that are problematic for
> security testing and/or hardening:
>
>  - constructor slabs: These things come with an object constructor
> that doesn't run when an object is allocated, but instead when the
> slab allocator grabs a new page from the page allocator. This is
> problematic for use-after-free detection mechanisms such as HWASAN and
> Memory Tagging, which can only do their job properly if the address of
> an object is allowed to change every time the object is
> freed/reallocated. (You can't change the address of an object without
> reinitializing the entire object because e.g. an empty list_head
> points to itself.)
>
>  - RCU slabs: These things basically permit use-after-frees by design,
> and stuff like ASAN/HWASAN/Memory Tagging essentially doesn't work on
> them.
>
>
> It would be nice to have a config flag or so that changes the SLUB
> allocator's behavior such that these slabs can be instrumented
> properly. Something like:
>
>  - Let calculate_sizes() reserve space for an rcu_head on each object
> in TYPESAFE_BY_RCU slabs, make kmem_cache_free() redirect to
> call_rcu() for these slabs, and remove most of the other
> special-casing, so that KASAN can instrument these slabs.

I've implemented this first part now and sent it out for review:
https://lore.kernel.org/lkml/20230825211426.3798691-1-jannh@google.com/T/


>  - For all constructor slabs, let slab_post_alloc_hook() call the
> ->ctor() function on each allocated object, so that Memory Tagging and
> HWASAN will work on them.
