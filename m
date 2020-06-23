Return-Path: <SRS0=ya79=AE=lists.openwall.com=kernel-hardening-return-19060-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A53AC433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 09:14:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AE71920738
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 09:14:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RgLw0dY+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE71920738
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19060-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24146 invoked by uid 550); 23 Jun 2020 09:14:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24111 invoked from network); 23 Jun 2020 09:14:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vtk9OVdWBIKNADV6/am2r3iuDJGvWTfkOXH+NORoJEE=;
        b=RgLw0dY+wWISAydHPK1RYGzh3Bjgq0QwQQs7ehEo8gD0wtFC6bD8909xWC9iubTGU6
         Ot2GJzARHtbNM9kLmcTlJQ0IaxTft/Sv2rp+iuRyXLAIp3ZvRF2qil7WlFTJREO9DIr5
         N3GNbVCjwJcHU2PhTFOqc9+KceSqWuGbCPH5LyLz0eWu6yMTZROfUZkDzTI7CQp2HIUy
         fbwNn7uR2iy8sCamgOMmPsT0oEAjXGZMauAb/COtOG8MbkcgGxjdMdcjRA23073rPE2t
         4XD81PuEK6y3l96QU06CVvFojD0UITYexMMJdZFfwUcBarL9zwSwxcu5BabhmaKA0+4I
         S5Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vtk9OVdWBIKNADV6/am2r3iuDJGvWTfkOXH+NORoJEE=;
        b=mGvhp81PaHz7zyvIs2QMFGxaVjdaY7Y3ytmt+biavO8Ym5pnzICfckATHojAiQRGG5
         hhRAwCu88lRqCD+eGWVVVNor7GaWEhQwLOn8zH74Ec3JTPexWngUYSr6avfyNSXxWKmz
         /+vNWot2Tnjy/sCsaFS8LgD84n/43hOiNNwPdeNry7ZHQwYz7DxU3WIcP5/dY4WaviPe
         q508XWw3BmVclNiCddDvE77AqiADQt+ipCqN9KWPfxfeVSz2xIIbMU2qfwZp6apCkZAy
         Jfnq8c2yydzR1+goewZdvwUlkRyOLJgbpwz0X7o2Xkwwbo0+FZLRGoppgiUA7RqXxr/b
         Xb+Q==
X-Gm-Message-State: AOAM5307i6rcg+ElagslYj3+6ZLKJsRWtbGgcjJ1a4fMOUlInfH4g8ri
	FutJo2H+TDx8q37oxaszxS45wHLNiOw2MBF8/9D1Gg==
X-Google-Smtp-Source: ABdhPJxfyAmn2d6xfjHDJdxmr4+T63Km5W4JYizPwK9Hiwq64yvYr+vS6olV/+jrwG3o8UDH4bxdMNxFAok2munPYi4=
X-Received: by 2002:ac8:41c7:: with SMTP id o7mr110428qtm.257.1592903670569;
 Tue, 23 Jun 2020 02:14:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez2OrzBW9Cy13fJ2YHpYvAcn+2SbEmv_0MdrCufot65XUw@mail.gmail.com>
 <CACT4Y+acW32ng++GOfjkX=8Fe73u+DMhN=E0ffs13bHxa+_B5w@mail.gmail.com>
 <CANpmjNMDHmLDWgR_YYBK-sgp9jHpN0et1X=UkQ4wt2SbtFAjHA@mail.gmail.com>
 <CAG_fn=XDtJuSZ9o6P9LeS4AfSkbP38Mc3AQxEWd+u4wakSG+xQ@mail.gmail.com>
 <CACT4Y+ZfDfMGWn1wk6jq0VdkGdC2H7NifYpVCCXwCmX42m4Thg@mail.gmail.com> <CAG_fn=VEb7XYwi0ZnOXRx-Yss++OhnpKCO-7tFvCOp4pi4MLcA@mail.gmail.com>
In-Reply-To: <CAG_fn=VEb7XYwi0ZnOXRx-Yss++OhnpKCO-7tFvCOp4pi4MLcA@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 23 Jun 2020 11:14:19 +0200
Message-ID: <CACT4Y+ZHoQ5ZPfsvaiQMXrrTxv9-LgP+v_o5Ah2gFBwqQjv-+g@mail.gmail.com>
Subject: Re: Kernel hardening project suggestion: Normalizing ->ctor slabs and
 TYPESAFE_BY_RCU slabs
To: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>, Jann Horn <jannh@google.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Christoph Lameter <cl@linux.com>, 
	Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux-MM <linux-mm@kvack.org>, Andrey Konovalov <andreyknvl@google.com>, 
	Will Deacon <will@kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, 
	Kees Cook <keescook@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2020 at 10:38 AM Alexander Potapenko <glider@google.com> wr=
ote:
> > > KFENCE also has to ignore both TYPESAFE_BY_RCU and ctors.
> > > For ctors it should be pretty straightforward to fix (and won't
> > > require any changes to SL[AU]B). Not sure if your proposal for RCU
> > > will also work for KFENCE.
> >
> > Does it work for objects freed by call_rcu in normal slabs?
> > If yes, then I would assume it will work for TYPESAFE_BY_RCU after
> > this change, or is there a difference?
>
> If my understanding is correct, TYPESAFE_BY_RCU means that the object
> may be used after it has been freed, that's why we cannot further
> reuse or wipe it before ensuring they aren't used anymore.

Yes, but only within an rcu grace period.
And this proposal will take care of this: from the point of view of
slab, the object is freed after an additional rcu grace period. So
when it reaches slab free, it must not be used anymore.

> Objects allocated from normal slabs cannot be used after they've been
> freed, so I don't see how this change applies to them.
>
> > > Another beneficiary of RCU/ctor normalization would be
> > > init_on_alloc/init_on_free, which also ignore such slabs.
> > >
> > > On Tue, Jun 23, 2020 at 9:18 AM Marco Elver <elver@google.com> wrote:
> > > >
> > > > On Tue, 23 Jun 2020 at 08:45, Dmitry Vyukov <dvyukov@google.com> wr=
ote:
> > > > >
> > > > > On Tue, Jun 23, 2020 at 8:26 AM Jann Horn <jannh@google.com> wrot=
e:
> > > > > >
> > > > > > Hi!
> > > > > >
> > > > > > Here's a project idea for the kernel-hardening folks:
> > > > > >
> > > > > > The slab allocator interface has two features that are problema=
tic for
> > > > > > security testing and/or hardening:
> > > > > >
> > > > > >  - constructor slabs: These things come with an object construc=
tor
> > > > > > that doesn't run when an object is allocated, but instead when =
the
> > > > > > slab allocator grabs a new page from the page allocator. This i=
s
> > > > > > problematic for use-after-free detection mechanisms such as HWA=
SAN and
> > > > > > Memory Tagging, which can only do their job properly if the add=
ress of
> > > > > > an object is allowed to change every time the object is
> > > > > > freed/reallocated. (You can't change the address of an object w=
ithout
> > > > > > reinitializing the entire object because e.g. an empty list_hea=
d
> > > > > > points to itself.)
> > > > > >
> > > > > >  - RCU slabs: These things basically permit use-after-frees by =
design,
> > > > > > and stuff like ASAN/HWASAN/Memory Tagging essentially doesn't w=
ork on
> > > > > > them.
> > > > > >
> > > > > >
> > > > > > It would be nice to have a config flag or so that changes the S=
LUB
> > > > > > allocator's behavior such that these slabs can be instrumented
> > > > > > properly. Something like:
> > > > > >
> > > > > >  - Let calculate_sizes() reserve space for an rcu_head on each =
object
> > > > > > in TYPESAFE_BY_RCU slabs, make kmem_cache_free() redirect to
> > > > > > call_rcu() for these slabs, and remove most of the other
> > > > > > special-casing, so that KASAN can instrument these slabs.
> > > > > >  - For all constructor slabs, let slab_post_alloc_hook() call t=
he
> > > > > > ->ctor() function on each allocated object, so that Memory Tagg=
ing and
> > > > > > HWASAN will work on them.
> > > > >
> > > > > Hi Jann,
> > > > >
> > > > > Both things sound good to me. I think we considered doing the cto=
r's
> > > > > change with KASAN, but we did not get anywhere. The only argument
> > > > > against it I remember now was "performance", but it's not that
> > > > > important if this mode is enabled only with KASAN and other debug=
ging
> > > > > tools. Performance is definitely not as important as missing bugs=
. The
> > > > > additional code complexity for ctors change should be minimal.
> > > > > The rcu change would also be useful, but I would assume it will b=
e larger.
> > > > > Please add them to [1], that's KASAN laundry list.
> > > > >
> > > > > +Alex, Marco, will it be useful for KFENCE [2] as well? Do ctors/=
rcu
> > > > > affect KFENCE? Will we need any special handling for KFENCE?
> > > > > I assume it will also be useful for KMSAN b/c we can re-mark obje=
cts
> > > > > as uninitialized only after they have been reallocated.
> > > >
> > > > Yes, we definitely need to handle TYPESAFE_BY_RCU.
> > > >
> > > > > [1] https://bugzilla.kernel.org/buglist.cgi?bug_status=3D__open__=
&component=3DSanitizers&list_id=3D1063981&product=3DMemory%20Management
> > > > > [2] https://github.com/google/kasan/commits/kfence
> > >
> > >
> > >
> > > --
> > > Alexander Potapenko
> > > Software Engineer
> > >
> > > Google Germany GmbH
> > > Erika-Mann-Stra=C3=9Fe, 33
> > > 80636 M=C3=BCnchen
> > >
> > > Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
> > > Registergericht und -nummer: Hamburg, HRB 86891
> > > Sitz der Gesellschaft: Hamburg
>
>
>
> --
> Alexander Potapenko
> Software Engineer
>
> Google Germany GmbH
> Erika-Mann-Stra=C3=9Fe, 33
> 80636 M=C3=BCnchen
>
> Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
> Registergericht und -nummer: Hamburg, HRB 86891
> Sitz der Gesellschaft: Hamburg
