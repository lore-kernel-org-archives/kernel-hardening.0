Return-Path: <SRS0=WMZ2=AE=lists.openwall.com=kernel-hardening-return-19057-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6B1C433E1
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 08:32:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 98B6B2072E
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 08:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pyp7tjOJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98B6B2072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19057-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1782 invoked by uid 550); 23 Jun 2020 08:31:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1745 invoked from network); 23 Jun 2020 08:31:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HCA63Bq1RhuGBZe+uCuPvGnPrsrwVNbQ3GCsOT/wmUM=;
        b=pyp7tjOJLOow1mDmvUgdLzldCixoa3daJpceZRVRHM+OzpQ/SmxfXvKTg7TPGpWZ0h
         w9zNErQ1h+mBD4PNVGUz/jv2MeWWgYVzBvIZqZSCrlI+VjInJq2Ir6Jcvo7TnHXFJQ8d
         qzDCbWX+mu2FFp0hOscTEFGTGc78NhlmkV9spdDRGudKbA+bbF13WHFg7q9Y0f1Pl9uY
         +1unTOYVJLuI1U32TB40WaUyOo6V44vX98oiIlbCIBZnSFy6RQPQd7DxmYQEk0VU1H7I
         a9eDAbXL77lwtq7oMWOD6u3bATYqd2I5ikJUPZt+EaHU+xw8FhqKcZeyP/LvbQm60cbC
         4AZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HCA63Bq1RhuGBZe+uCuPvGnPrsrwVNbQ3GCsOT/wmUM=;
        b=OTvlt/Kkkg/ZMa+R6lUHj8CdoFZvIHBBcXoitCD8sRhYOcFn/UPWP6VsmW5fOtNq+j
         8VJt5D9NZGYbJgRZ2key0vEk8WN/M0Gk7M+7seXReTXIVvttdl48FQHUafjmjftRA+Us
         Z/b6Er45ocghI4psVqbvrHSuSoMpk800yF3QzucOSdcYfrljxYArNtDdgrFkKELLNdpf
         0jJmvvZudV7/gMM8AdGUn6AgRx20PhHSF4b+ayil0+Q9YnQ8QmgogqZatJysD+qU1479
         0taMI3wOmvCaS3BDMSotm84TrnOeYltqf+ho8AzLxjJNGiTHua7occkfiE4S7ykwIn54
         /D/w==
X-Gm-Message-State: AOAM532ug+6BW4S1+BS6ZxRiW7hA7/MAVsKbNJhkN8iNNrm4NTWvaj9e
	I+WBl9GmiN5dHs6deX0qILtas6iGJOzVmL6r4+eouw==
X-Google-Smtp-Source: ABdhPJxJ2f+R+KS7pfQohsYdVddkjHZxwk/0JQR8S7eNdH2ExKuk8ndnjpdBmu09F1/q3NGaVBzOR2OyjOycGTRiof0=
X-Received: by 2002:ac8:7a87:: with SMTP id x7mr20922438qtr.50.1592901104200;
 Tue, 23 Jun 2020 01:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez2OrzBW9Cy13fJ2YHpYvAcn+2SbEmv_0MdrCufot65XUw@mail.gmail.com>
 <CACT4Y+acW32ng++GOfjkX=8Fe73u+DMhN=E0ffs13bHxa+_B5w@mail.gmail.com>
 <CANpmjNMDHmLDWgR_YYBK-sgp9jHpN0et1X=UkQ4wt2SbtFAjHA@mail.gmail.com> <CAG_fn=XDtJuSZ9o6P9LeS4AfSkbP38Mc3AQxEWd+u4wakSG+xQ@mail.gmail.com>
In-Reply-To: <CAG_fn=XDtJuSZ9o6P9LeS4AfSkbP38Mc3AQxEWd+u4wakSG+xQ@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 23 Jun 2020 10:31:32 +0200
Message-ID: <CACT4Y+ZfDfMGWn1wk6jq0VdkGdC2H7NifYpVCCXwCmX42m4Thg@mail.gmail.com>
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

On Tue, Jun 23, 2020 at 9:24 AM Alexander Potapenko <glider@google.com> wro=
te:
>
> KFENCE also has to ignore both TYPESAFE_BY_RCU and ctors.
> For ctors it should be pretty straightforward to fix (and won't
> require any changes to SL[AU]B). Not sure if your proposal for RCU
> will also work for KFENCE.

Does it work for objects freed by call_rcu in normal slabs?
If yes, then I would assume it will work for TYPESAFE_BY_RCU after
this change, or is there a difference?

> Another beneficiary of RCU/ctor normalization would be
> init_on_alloc/init_on_free, which also ignore such slabs.
>
> On Tue, Jun 23, 2020 at 9:18 AM Marco Elver <elver@google.com> wrote:
> >
> > On Tue, 23 Jun 2020 at 08:45, Dmitry Vyukov <dvyukov@google.com> wrote:
> > >
> > > On Tue, Jun 23, 2020 at 8:26 AM Jann Horn <jannh@google.com> wrote:
> > > >
> > > > Hi!
> > > >
> > > > Here's a project idea for the kernel-hardening folks:
> > > >
> > > > The slab allocator interface has two features that are problematic =
for
> > > > security testing and/or hardening:
> > > >
> > > >  - constructor slabs: These things come with an object constructor
> > > > that doesn't run when an object is allocated, but instead when the
> > > > slab allocator grabs a new page from the page allocator. This is
> > > > problematic for use-after-free detection mechanisms such as HWASAN =
and
> > > > Memory Tagging, which can only do their job properly if the address=
 of
> > > > an object is allowed to change every time the object is
> > > > freed/reallocated. (You can't change the address of an object witho=
ut
> > > > reinitializing the entire object because e.g. an empty list_head
> > > > points to itself.)
> > > >
> > > >  - RCU slabs: These things basically permit use-after-frees by desi=
gn,
> > > > and stuff like ASAN/HWASAN/Memory Tagging essentially doesn't work =
on
> > > > them.
> > > >
> > > >
> > > > It would be nice to have a config flag or so that changes the SLUB
> > > > allocator's behavior such that these slabs can be instrumented
> > > > properly. Something like:
> > > >
> > > >  - Let calculate_sizes() reserve space for an rcu_head on each obje=
ct
> > > > in TYPESAFE_BY_RCU slabs, make kmem_cache_free() redirect to
> > > > call_rcu() for these slabs, and remove most of the other
> > > > special-casing, so that KASAN can instrument these slabs.
> > > >  - For all constructor slabs, let slab_post_alloc_hook() call the
> > > > ->ctor() function on each allocated object, so that Memory Tagging =
and
> > > > HWASAN will work on them.
> > >
> > > Hi Jann,
> > >
> > > Both things sound good to me. I think we considered doing the ctor's
> > > change with KASAN, but we did not get anywhere. The only argument
> > > against it I remember now was "performance", but it's not that
> > > important if this mode is enabled only with KASAN and other debugging
> > > tools. Performance is definitely not as important as missing bugs. Th=
e
> > > additional code complexity for ctors change should be minimal.
> > > The rcu change would also be useful, but I would assume it will be la=
rger.
> > > Please add them to [1], that's KASAN laundry list.
> > >
> > > +Alex, Marco, will it be useful for KFENCE [2] as well? Do ctors/rcu
> > > affect KFENCE? Will we need any special handling for KFENCE?
> > > I assume it will also be useful for KMSAN b/c we can re-mark objects
> > > as uninitialized only after they have been reallocated.
> >
> > Yes, we definitely need to handle TYPESAFE_BY_RCU.
> >
> > > [1] https://bugzilla.kernel.org/buglist.cgi?bug_status=3D__open__&com=
ponent=3DSanitizers&list_id=3D1063981&product=3DMemory%20Management
> > > [2] https://github.com/google/kasan/commits/kfence
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
