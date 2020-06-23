Return-Path: <SRS0=EKu2=AE=lists.openwall.com=kernel-hardening-return-19051-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5915CC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 06:26:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A88E220723
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 06:26:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ldl0tBRP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A88E220723
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19051-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11327 invoked by uid 550); 23 Jun 2020 06:26:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11291 invoked from network); 23 Jun 2020 06:26:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=AsNRALeJxIUkEC8oYa+n4aueY7MnLHPOpm0Ghly9IZo=;
        b=ldl0tBRPkMJe4OOLQtpIosTh/6Ob4Jn9s/EVh6LSzff0fP5H31D4yjrRj2ee+sBunO
         0DRBiEW/kyirdT1/pOjcoZ/5qzTm6L0v22Y5yK9cZlfL+GEGIk5t+RBGizPLEwsXPkUB
         VtysDDaCBwi5ORwk70ZWS9YMK8lzCipN4OzMWwkoHCvnL2hwgrPPNFybTMFpEmxMW/JD
         cmDVBapZXHne88gc5JKR3KtAW1OVD7sM1ouCMBaB+gXZ0Z9XQRJAUlg+77fBFKJCBA/Q
         Y0VsC4eVVaf93bb20t6wwRPtFJvkiAP4+GJ6s9xTCYMpsMqgvIrd4FdYeIK6hZau6HMS
         cJZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=AsNRALeJxIUkEC8oYa+n4aueY7MnLHPOpm0Ghly9IZo=;
        b=mP1uJWNNSoyPetgR2xt4kzh8LfxbBOj65YxQOF4h+doLpZy0n+Oigbf+COb60kNY89
         T5trmuLXpgOn5PxdDbi/J/8dSeJ962rsYFAhnINcfwYisfA0RhjPHhVh0sK4lydnkV5X
         7tfJNzqWXzR1IcYGqlhKnPH1GKWnv9W9P5G8m+EA9i9hotpZQSk5UDLuHwm/3GIA5xca
         imqGL3LDJL6vf2Z8TlbOVzIm1OyU92lLVgK20lPhMgTFuktKzIhXA1n/sGRQxPYWwtbz
         8qIdk1MtVe0r4VIoMPOK+M1apB/bpRnO1/l/sOjujCzshC+89DQ51pz9CNfLxJ+q/6ac
         RmNg==
X-Gm-Message-State: AOAM532QTMd8Y/4ohL5mUPc7LpSm22EAYsoNZny3zq+XBvtEMoVWY0/e
	oQKMQwj8V/nlIeBwZZeupGpW7FoYHK1B+s4DFDZy/3fCwXI=
X-Google-Smtp-Source: ABdhPJy24Cl5WiPlliv15Ov+noFUgDy0dvkG5wjtud+Rwrb/FXC8SIewoVl7LLbNYVHEz0ZlTcIHOLflZvN99iQx26g=
X-Received: by 2002:a19:be4b:: with SMTP id o72mr11645822lff.141.1592893591731;
 Mon, 22 Jun 2020 23:26:31 -0700 (PDT)
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Tue, 23 Jun 2020 08:26:05 +0200
Message-ID: <CAG48ez2OrzBW9Cy13fJ2YHpYvAcn+2SbEmv_0MdrCufot65XUw@mail.gmail.com>
Subject: Kernel hardening project suggestion: Normalizing ->ctor slabs and
 TYPESAFE_BY_RCU slabs
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, 
	Andrey Konovalov <andreyknvl@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi!

Here's a project idea for the kernel-hardening folks:

The slab allocator interface has two features that are problematic for
security testing and/or hardening:

 - constructor slabs: These things come with an object constructor
that doesn't run when an object is allocated, but instead when the
slab allocator grabs a new page from the page allocator. This is
problematic for use-after-free detection mechanisms such as HWASAN and
Memory Tagging, which can only do their job properly if the address of
an object is allowed to change every time the object is
freed/reallocated. (You can't change the address of an object without
reinitializing the entire object because e.g. an empty list_head
points to itself.)

 - RCU slabs: These things basically permit use-after-frees by design,
and stuff like ASAN/HWASAN/Memory Tagging essentially doesn't work on
them.


It would be nice to have a config flag or so that changes the SLUB
allocator's behavior such that these slabs can be instrumented
properly. Something like:

 - Let calculate_sizes() reserve space for an rcu_head on each object
in TYPESAFE_BY_RCU slabs, make kmem_cache_free() redirect to
call_rcu() for these slabs, and remove most of the other
special-casing, so that KASAN can instrument these slabs.
 - For all constructor slabs, let slab_post_alloc_hook() call the
->ctor() function on each allocated object, so that Memory Tagging and
HWASAN will work on them.
