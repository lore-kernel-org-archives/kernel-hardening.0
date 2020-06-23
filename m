Return-Path: <SRS0=z1Tc=AE=lists.openwall.com=kernel-hardening-return-19054-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1621EC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 07:25:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3B4A42072E
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 07:25:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rCYLtS8h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B4A42072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19054-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21915 invoked by uid 550); 23 Jun 2020 07:24:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21878 invoked from network); 23 Jun 2020 07:24:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uWsUrBI2cF3cgBJXHkC6C40URSuY/BmKIvQNeI/0//E=;
        b=rCYLtS8hQyCsH2j0Nnre5UABFgshesNOKJNJupPwo9InI2+Qx8qIWauZHCL7YboqXi
         byvX3aaLcr028Mal3vMOxqm4dL2SNSVbntoDXPgGjDZqrNXNu+ri/nqzRTkfagcJy4TX
         3J7Y/7ev3YMc8cYu9BAjq0a/nGDI6IYPuBytAyMjsY4AFa31U5VUDtDUxr9uUwjsvifx
         6GkrnC+NnReT0xH+GyWOyepSK85gD07y+uHsYDndxmnzWF1f9uZbr2Zsxne8lV0Jlk+M
         IXGaDc6LW4LJ5w/XOVUl5KT7N0EpO819LWMUgvBVrDZ/+kt2VtLMO6Z3Xug5K5E9j8PZ
         df9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uWsUrBI2cF3cgBJXHkC6C40URSuY/BmKIvQNeI/0//E=;
        b=PtbWo9pqLvIBApHZRobHvXBtxN3Fmpci5nmDn+a7ch7R7qLDX3lSg3CbHimGw1V/T0
         aD4QafrzK4nC+xDWuxe3/ASPxnBNcKeUx4OuBL74izckMRtCbrjlspZo8gpNBGIk08q0
         4UsrabHS+y4VN1LsMYxi7MvnEQ9RLE6NKVbpK0YHUNzthqeODxYNZrx93/+lQDCwuLdt
         XPITPVfHp3QvPjCbUalhS8rFExAUJclyBhGihmR1T/XNW8YmWY5K2rs6lMkdk6y8cF98
         u0mFqUAfsMYCmD3bBoGcB1/05edcKDnr+jtEhvVpNO/LrCk67qcjgtj1t7SZutHH7i52
         4sJw==
X-Gm-Message-State: AOAM532YlpZo4hkAcqVOykWd8FfPFKTrP4bY8fNq6o4dmAMUPxyoX5JA
	LEbP0VSmlYDVxR0h4+5ohho1U9iPe5nw50iwstLDkg==
X-Google-Smtp-Source: ABdhPJxR4pb+rI1B2efKebvT8rzSugwN1dVgq95Z2YFFPYruoBaJd4VwYIyYknfr3vHk3e/lpEqVSetFxyVZlYODO6E=
X-Received: by 2002:a1c:4c16:: with SMTP id z22mr22271690wmf.103.1592897086960;
 Tue, 23 Jun 2020 00:24:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez2OrzBW9Cy13fJ2YHpYvAcn+2SbEmv_0MdrCufot65XUw@mail.gmail.com>
 <CACT4Y+acW32ng++GOfjkX=8Fe73u+DMhN=E0ffs13bHxa+_B5w@mail.gmail.com> <CANpmjNMDHmLDWgR_YYBK-sgp9jHpN0et1X=UkQ4wt2SbtFAjHA@mail.gmail.com>
In-Reply-To: <CANpmjNMDHmLDWgR_YYBK-sgp9jHpN0et1X=UkQ4wt2SbtFAjHA@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 23 Jun 2020 09:24:35 +0200
Message-ID: <CAG_fn=XDtJuSZ9o6P9LeS4AfSkbP38Mc3AQxEWd+u4wakSG+xQ@mail.gmail.com>
Subject: Re: Kernel hardening project suggestion: Normalizing ->ctor slabs and
 TYPESAFE_BY_RCU slabs
To: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Christoph Lameter <cl@linux.com>, 
	Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux-MM <linux-mm@kvack.org>, Andrey Konovalov <andreyknvl@google.com>, 
	Will Deacon <will@kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, 
	Kees Cook <keescook@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

KFENCE also has to ignore both TYPESAFE_BY_RCU and ctors.
For ctors it should be pretty straightforward to fix (and won't
require any changes to SL[AU]B). Not sure if your proposal for RCU
will also work for KFENCE.

Another beneficiary of RCU/ctor normalization would be
init_on_alloc/init_on_free, which also ignore such slabs.

On Tue, Jun 23, 2020 at 9:18 AM Marco Elver <elver@google.com> wrote:
>
> On Tue, 23 Jun 2020 at 08:45, Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > On Tue, Jun 23, 2020 at 8:26 AM Jann Horn <jannh@google.com> wrote:
> > >
> > > Hi!
> > >
> > > Here's a project idea for the kernel-hardening folks:
> > >
> > > The slab allocator interface has two features that are problematic fo=
r
> > > security testing and/or hardening:
> > >
> > >  - constructor slabs: These things come with an object constructor
> > > that doesn't run when an object is allocated, but instead when the
> > > slab allocator grabs a new page from the page allocator. This is
> > > problematic for use-after-free detection mechanisms such as HWASAN an=
d
> > > Memory Tagging, which can only do their job properly if the address o=
f
> > > an object is allowed to change every time the object is
> > > freed/reallocated. (You can't change the address of an object without
> > > reinitializing the entire object because e.g. an empty list_head
> > > points to itself.)
> > >
> > >  - RCU slabs: These things basically permit use-after-frees by design=
,
> > > and stuff like ASAN/HWASAN/Memory Tagging essentially doesn't work on
> > > them.
> > >
> > >
> > > It would be nice to have a config flag or so that changes the SLUB
> > > allocator's behavior such that these slabs can be instrumented
> > > properly. Something like:
> > >
> > >  - Let calculate_sizes() reserve space for an rcu_head on each object
> > > in TYPESAFE_BY_RCU slabs, make kmem_cache_free() redirect to
> > > call_rcu() for these slabs, and remove most of the other
> > > special-casing, so that KASAN can instrument these slabs.
> > >  - For all constructor slabs, let slab_post_alloc_hook() call the
> > > ->ctor() function on each allocated object, so that Memory Tagging an=
d
> > > HWASAN will work on them.
> >
> > Hi Jann,
> >
> > Both things sound good to me. I think we considered doing the ctor's
> > change with KASAN, but we did not get anywhere. The only argument
> > against it I remember now was "performance", but it's not that
> > important if this mode is enabled only with KASAN and other debugging
> > tools. Performance is definitely not as important as missing bugs. The
> > additional code complexity for ctors change should be minimal.
> > The rcu change would also be useful, but I would assume it will be larg=
er.
> > Please add them to [1], that's KASAN laundry list.
> >
> > +Alex, Marco, will it be useful for KFENCE [2] as well? Do ctors/rcu
> > affect KFENCE? Will we need any special handling for KFENCE?
> > I assume it will also be useful for KMSAN b/c we can re-mark objects
> > as uninitialized only after they have been reallocated.
>
> Yes, we definitely need to handle TYPESAFE_BY_RCU.
>
> > [1] https://bugzilla.kernel.org/buglist.cgi?bug_status=3D__open__&compo=
nent=3DSanitizers&list_id=3D1063981&product=3DMemory%20Management
> > [2] https://github.com/google/kasan/commits/kfence



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
