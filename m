Return-Path: <SRS0=tm/r=AE=lists.openwall.com=kernel-hardening-return-19052-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B01C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 06:45:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7774A2072E
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 06:45:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m6U0Skvb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7774A2072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19052-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1594 invoked by uid 550); 23 Jun 2020 06:45:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1554 invoked from network); 23 Jun 2020 06:45:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kqrm6H9MAMConNZ8UsM9qxabxTYbRgGIA2rshZa0MPA=;
        b=m6U0SkvbfCx+aJ15SURzgsyxJCOijpaWE0r9HqByYkH9pHhR+0vnK5q2qgXCGlxySX
         OPTVBuDQ7qz8y4dtxFnR7HCrtqpz3y3WzDy3tavMV2X1oROY9kSCOQm0+rcAfQH6ri2f
         P45Cy8mruOipyzi3AFTGufdNSwYYm0jDUffAm5ZebrlXgXFJC32DoRi2TYFbU9w3xW4N
         e4lqkY3ocPAkuGku4MCsD8M/8OEpZYJUhUc2PqXwmSjPbHZSS3/XuJD5ZZRBbly9LqdX
         p5EDB/hBueouJvSCPFbx41qZCQWwDtcFDD4FUICU6cIBXOodXfir1wGesI1NVABRXE7Z
         lilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kqrm6H9MAMConNZ8UsM9qxabxTYbRgGIA2rshZa0MPA=;
        b=DeHsbMGZQpX+bczkAkcc90xcCOJ+Ujzji7fCFFMKHu3QKEuKzzwvdOgqY+t2hCSHau
         h3cElwEPDdguS8MMLA+8dI/vRp8rTwP1+ykFXnc1pVwueMU0tBlWWHpRV+RvJlLzL/JG
         9N7NBnM7fYAZwuZrb1FrcaEjcDuTh8djYoi08dyAVBhjnzko5HBjpVNzVrFoWQL9ytV8
         QIONA8ic67Owcc6AXTCkByKVJi2WmiSr/8VLDX+HasS99z/Gai/MaICgi8bE5gm8Qy11
         OOvGys/g+C1Tkv6o7/qxImShzQHBFkJmQ/NDjluqTOdxgbGPZX6aZhxRYvcvMPU4UmXh
         lmcg==
X-Gm-Message-State: AOAM532EZ6lsJlsNdPXXv7pNg7dL0MouOllQHsbZBwR0BmK0Y3tbGX9y
	m4Q7f5vh8wFjDs7JUQXufjgSf1Q1vo9DuWRbJmtzQA==
X-Google-Smtp-Source: ABdhPJyz5MHotfH74zsF2cIt/ICAEYZJGfP7l9CZ3yW+Cm9v5MJLb86WWbFplOD8DY6u/uAQ8ctWBtPOwyJ4rEFGuJ0=
X-Received: by 2002:ad4:4868:: with SMTP id u8mr25497586qvy.34.1592894722434;
 Mon, 22 Jun 2020 23:45:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez2OrzBW9Cy13fJ2YHpYvAcn+2SbEmv_0MdrCufot65XUw@mail.gmail.com>
In-Reply-To: <CAG48ez2OrzBW9Cy13fJ2YHpYvAcn+2SbEmv_0MdrCufot65XUw@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 23 Jun 2020 08:45:11 +0200
Message-ID: <CACT4Y+acW32ng++GOfjkX=8Fe73u+DMhN=E0ffs13bHxa+_B5w@mail.gmail.com>
Subject: Re: Kernel hardening project suggestion: Normalizing ->ctor slabs and
 TYPESAFE_BY_RCU slabs
To: Jann Horn <jannh@google.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Christoph Lameter <cl@linux.com>, 
	Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux-MM <linux-mm@kvack.org>, Andrey Konovalov <andreyknvl@google.com>, 
	Will Deacon <will@kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, 
	Kees Cook <keescook@google.com>, Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 23, 2020 at 8:26 AM Jann Horn <jannh@google.com> wrote:
>
> Hi!
>
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
>  - For all constructor slabs, let slab_post_alloc_hook() call the
> ->ctor() function on each allocated object, so that Memory Tagging and
> HWASAN will work on them.

Hi Jann,

Both things sound good to me. I think we considered doing the ctor's
change with KASAN, but we did not get anywhere. The only argument
against it I remember now was "performance", but it's not that
important if this mode is enabled only with KASAN and other debugging
tools. Performance is definitely not as important as missing bugs. The
additional code complexity for ctors change should be minimal.
The rcu change would also be useful, but I would assume it will be larger.
Please add them to [1], that's KASAN laundry list.

+Alex, Marco, will it be useful for KFENCE [2] as well? Do ctors/rcu
affect KFENCE? Will we need any special handling for KFENCE?
I assume it will also be useful for KMSAN b/c we can re-mark objects
as uninitialized only after they have been reallocated.

[1] https://bugzilla.kernel.org/buglist.cgi?bug_status=__open__&component=Sanitizers&list_id=1063981&product=Memory%20Management
[2] https://github.com/google/kasan/commits/kfence
