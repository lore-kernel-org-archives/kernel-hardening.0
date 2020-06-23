Return-Path: <SRS0=nelv=AE=lists.openwall.com=kernel-hardening-return-19058-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F76C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 08:38:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6E13820771
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 08:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NNOEMG0S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E13820771
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19058-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11320 invoked by uid 550); 23 Jun 2020 08:38:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11285 invoked from network); 23 Jun 2020 08:38:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4WsWkj4zSWAAdD1NjDPTNdEL45zLPcQEEtkDieAodAA=;
        b=NNOEMG0SezXh4fy6WwRTElh1naKV+QBeCN2Gv6nuqCqThcdj2mMbsbkIJ9Ds0rJuuH
         1pxxLC2vMmixv6G7Y3h9Qaj/CoseV3JcpcViOVcPN/izs78yXUmWT4ZMYJKscpQDymsD
         RBh1jzHUuu3t7iTY31x5bcQ9E346q5X0n4w4yfWE+2rrU3f8lChjJahenWpxDePCfgmi
         x8U1tkxrzx7+9cA0vH328VBp6xzPwiv76yV7Iby3pdWhwYbJoyXqHR4cHO4lvhsu2wc7
         k9nxSUMQRxPhY6rtPIJO+7VcNoCspFjyxX19A/PYArretNchQ/y18PdnaCJ6ZWYfbLu3
         6Mmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4WsWkj4zSWAAdD1NjDPTNdEL45zLPcQEEtkDieAodAA=;
        b=ZPWJOOf1NoqsBlh7oWvXIpctQ50ghA2HrieA+bAyl5HY5Q867PkMLHsyge/J74XF5v
         YcMy7orl5HEndURrz9Tzcpk8MXbsqsOoHIQGAd2bunSy9ctTs5ktiqe7Fxko5JTfL3td
         v/iB0Pgu2qkAfbwAdfG6IGm3swsOpifgM6QxJJKjn8kxZAnq5mT5rrBJmRETlUJ8vOw6
         cfhyUQvd9cP5sQ4ivMF64izdMcn0vlfckeSmcJTfodppk3mf877dHwsZbWDc4xthibI0
         OsxpRhWTwXm5DsITUGeE5EgxWsj8dEpSv5qVvZXUC8sqYTTqHWgVWh+d/yLw/jBreH65
         3Kuw==
X-Gm-Message-State: AOAM533FycWHqXiW7PF52tb+edTdq2ALdzj8i3vMtwrV4WdqL4GMkDBQ
	p/N8nvfLubC5LvxDS4TDvALBxYEXCuHGLrS3DmTsng==
X-Google-Smtp-Source: ABdhPJwbeE/LAHcq/Tr0CShbl1Q4H1AzmYNj2HUOkmS3LUteV1vbK4IgYXtLMi+EapNIHca88ijiGfr1lBtRjZ5UVUc=
X-Received: by 2002:adf:97cb:: with SMTP id t11mr23818010wrb.314.1592901492799;
 Tue, 23 Jun 2020 01:38:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez2OrzBW9Cy13fJ2YHpYvAcn+2SbEmv_0MdrCufot65XUw@mail.gmail.com>
 <CACT4Y+acW32ng++GOfjkX=8Fe73u+DMhN=E0ffs13bHxa+_B5w@mail.gmail.com>
 <CANpmjNMDHmLDWgR_YYBK-sgp9jHpN0et1X=UkQ4wt2SbtFAjHA@mail.gmail.com>
 <CAG_fn=XDtJuSZ9o6P9LeS4AfSkbP38Mc3AQxEWd+u4wakSG+xQ@mail.gmail.com> <CACT4Y+ZfDfMGWn1wk6jq0VdkGdC2H7NifYpVCCXwCmX42m4Thg@mail.gmail.com>
In-Reply-To: <CACT4Y+ZfDfMGWn1wk6jq0VdkGdC2H7NifYpVCCXwCmX42m4Thg@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 23 Jun 2020 10:38:01 +0200
Message-ID: <CAG_fn=VEb7XYwi0ZnOXRx-Yss++OhnpKCO-7tFvCOp4pi4MLcA@mail.gmail.com>
Subject: Re: Kernel hardening project suggestion: Normalizing ->ctor slabs and
 TYPESAFE_BY_RCU slabs
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>, Jann Horn <jannh@google.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Christoph Lameter <cl@linux.com>, 
	Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux-MM <linux-mm@kvack.org>, Andrey Konovalov <andreyknvl@google.com>, 
	Will Deacon <will@kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, 
	Kees Cook <keescook@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2020 at 10:31 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Tue, Jun 23, 2020 at 9:24 AM Alexander Potapenko <glider@google.com> w=
rote:
> >
> > KFENCE also has to ignore both TYPESAFE_BY_RCU and ctors.
> > For ctors it should be pretty straightforward to fix (and won't
> > require any changes to SL[AU]B). Not sure if your proposal for RCU
> > will also work for KFENCE.
>
> Does it work for objects freed by call_rcu in normal slabs?
> If yes, then I would assume it will work for TYPESAFE_BY_RCU after
> this change, or is there a difference?

If my understanding is correct, TYPESAFE_BY_RCU means that the object
may be used after it has been freed, that's why we cannot further
reuse or wipe it before ensuring they aren't used anymore.
Objects allocated from normal slabs cannot be used after they've been
freed, so I don't see how this change applies to them.

> > Another beneficiary of RCU/ctor normalization would be
> > init_on_alloc/init_on_free, which also ignore such slabs.
> >
> > On Tue, Jun 23, 2020 at 9:18 AM Marco Elver <elver@google.com> wrote:
> > >
> > > On Tue, 23 Jun 2020 at 08:45, Dmitry Vyukov <dvyukov@google.com> wrot=
e:
> > > >
> > > > On Tue, Jun 23, 2020 at 8:26 AM Jann Horn <jannh@google.com> wrote:
> > > > >
> > > > > Hi!
> > > > >
> > > > > Here's a project idea for the kernel-hardening folks:
> > > > >
> > > > > The slab allocator interface has two features that are problemati=
c for
> > > > > security testing and/or hardening:
> > > > >
> > > > >  - constructor slabs: These things come with an object constructo=
r
> > > > > that doesn't run when an object is allocated, but instead when th=
e
> > > > > slab allocator grabs a new page from the page allocator. This is
> > > > > problematic for use-after-free detection mechanisms such as HWASA=
N and
> > > > > Memory Tagging, which can only do their job properly if the addre=
ss of
> > > > > an object is allowed to change every time the object is
> > > > > freed/reallocated. (You can't change the address of an object wit=
hout
> > > > > reinitializing the entire object because e.g. an empty list_head
> > > > > points to itself.)
> > > > >
> > > > >  - RCU slabs: These things basically permit use-after-frees by de=
sign,
> > > > > and stuff like ASAN/HWASAN/Memory Tagging essentially doesn't wor=
k on
> > > > > them.
> > > > >
> > > > >
> > > > > It would be nice to have a config flag or so that changes the SLU=
B
> > > > > allocator's behavior such that these slabs can be instrumented
> > > > > properly. Something like:
> > > > >
> > > > >  - Let calculate_sizes() reserve space for an rcu_head on each ob=
ject
> > > > > in TYPESAFE_BY_RCU slabs, make kmem_cache_free() redirect to
> > > > > call_rcu() for these slabs, and remove most of the other
> > > > > special-casing, so that KASAN can instrument these slabs.
> > > > >  - For all constructor slabs, let slab_post_alloc_hook() call the
> > > > > ->ctor() function on each allocated object, so that Memory Taggin=
g and
> > > > > HWASAN will work on them.
> > > >
> > > > Hi Jann,
> > > >
> > > > Both things sound good to me. I think we considered doing the ctor'=
s
> > > > change with KASAN, but we did not get anywhere. The only argument
> > > > against it I remember now was "performance", but it's not that
> > > > important if this mode is enabled only with KASAN and other debuggi=
ng
> > > > tools. Performance is definitely not as important as missing bugs. =
The
> > > > additional code complexity for ctors change should be minimal.
> > > > The rcu change would also be useful, but I would assume it will be =
larger.
> > > > Please add them to [1], that's KASAN laundry list.
> > > >
> > > > +Alex, Marco, will it be useful for KFENCE [2] as well? Do ctors/rc=
u
> > > > affect KFENCE? Will we need any special handling for KFENCE?
> > > > I assume it will also be useful for KMSAN b/c we can re-mark object=
s
> > > > as uninitialized only after they have been reallocated.
> > >
> > > Yes, we definitely need to handle TYPESAFE_BY_RCU.
> > >
> > > > [1] https://bugzilla.kernel.org/buglist.cgi?bug_status=3D__open__&c=
omponent=3DSanitizers&list_id=3D1063981&product=3DMemory%20Management
> > > > [2] https://github.com/google/kasan/commits/kfence
> >
> >
> >
> > --
> > Alexander Potapenko
> > Software Engineer
> >
> > Google Germany GmbH
> > Erika-Mann-Stra=C3=9Fe, 33
> > 80636 M=C3=BCnchen
> >
> > Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
> > Registergericht und -nummer: Hamburg, HRB 86891
> > Sitz der Gesellschaft: Hamburg



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
