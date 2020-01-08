Return-Path: <SRS0=lBPR=25=lists.openwall.com=kernel-hardening-return-17554-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F3EC282DD
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jan 2020 18:04:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 613522067D
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jan 2020 18:04:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UJhDdgds"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 613522067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17554-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16024 invoked by uid 550); 8 Jan 2020 18:04:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11511 invoked from network); 8 Jan 2020 17:51:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aSdZ3aFnA3oyaNn1PxZQVkM/xC6wM/NzLRYNPjDKtGk=;
        b=UJhDdgdsjUO4ywVeJCCVBEmXe8zl1IVqpO8NefBS2jzudGUW4Ae1UiSDzymlFkIjwi
         npZKTirPA9lIsiJKG3hqeOv+ke6PPLyf+Io8IIMEuw69PfOiPlK9UnqHHwGos51O83Xj
         ZEkv0zTlRoT+k3SZtoh6xRRyyA/Jn9S2LetiBTUNeYN6CduaKdEs6zOC81C0sLdtneJL
         7uD2jnziR0kXpdYo6IkvIIJJkELJjM+VSh4aiKMzcukzjGS7adDJtTEflxGBdTdAl548
         asURoyc2sTGOOzwgqlv7EuE0tu9xuIs7jS3XmN/ysLbLU+Spq1yWM+/wxYjuSSv0BPWq
         kuRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aSdZ3aFnA3oyaNn1PxZQVkM/xC6wM/NzLRYNPjDKtGk=;
        b=sD7IIOj/nFcmXtOSPMJAy3/DNx4ruNHpJQnDgNSmgLo65CoLka8uXqFbIk5NaN/6/T
         SxGGHaxSreVi8PlIbRQDJC5cqebwE1digYT1xSEAdAbg3KBj9ssfnwoGCEtm6kMJlUVQ
         GSVKx0aIJVIVbxtNseXKnc6Z/vd6mgX5LNzvpbqtPh7R0cd5MGhL1B0KJjxPuxgB8ZQ9
         2Y5GJij+Im5WE35v2vGzk8Z6YBEUTBGEl1RfWax4mrE4g/z+AwsWqexHS+US2cnEK/uZ
         qpI08p3SeeQ7cpk4f8AR5zuJy9LSGHm6Si4CUArYwGoP4J8o++9OKbv9EbiDe3ksc0F3
         OBkg==
X-Gm-Message-State: APjAAAVNgQosyBzs1P6i9rtZEFc2SGV8oE1yssjy+yIqnyGiwJy+8wz4
	hyd2lPLCnZ8sJtDMqsRwhc58cvB3pnHBlX/+YXA=
X-Google-Smtp-Source: APXvYqxq2sDXTbxb3S/PFtXkOw3vuLm8LBRlfNKToeO7JJ0ai3l9PSPUe8NacQTzdquRiCfMd9pHXIWsiukQguGIiQ4=
X-Received: by 2002:a1c:f30e:: with SMTP id q14mr5231788wmq.65.1578505904939;
 Wed, 08 Jan 2020 09:51:44 -0800 (PST)
MIME-Version: 1.0
References: <20200107192555.20606-1-tli@digitalocean.com> <b5984995-7276-97d3-a604-ddacfb89bd89@amd.com>
 <202001080936.A36005F1@keescook>
In-Reply-To: <202001080936.A36005F1@keescook>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Wed, 8 Jan 2020 12:51:33 -0500
Message-ID: <CADnq5_NLS=CuHD39utCTnTVsY_izuTPXFfsew6TpMjovgFoT5g@mail.gmail.com>
Subject: Re: [PATCH 0/2] drm/radeon: have the callers of set_memory_*() check
 the return value
To: Kees Cook <keescook@chromium.org>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	kernel-hardening@lists.openwall.com, David Airlie <airlied@linux.ie>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, 
	amd-gfx list <amd-gfx@lists.freedesktop.org>, Tianlin Li <tli@digitalocean.com>, 
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>, Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2020 at 12:39 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, Jan 08, 2020 at 01:56:47PM +0100, Christian K=C3=B6nig wrote:
> > Am 07.01.20 um 20:25 schrieb Tianlin Li:
> > > Right now several architectures allow their set_memory_*() family of
> > > functions to fail, but callers may not be checking the return values.
> > > If set_memory_*() returns with an error, call-site assumptions may be
> > > infact wrong to assume that it would either succeed or not succeed at
> > > all. Ideally, the failure of set_memory_*() should be passed up the
> > > call stack, and callers should examine the failure and deal with it.
> > >
> > > Need to fix the callers and add the __must_check attribute. They also
> > > may not provide any level of atomicity, in the sense that the memory
> > > protections may be left incomplete on failure. This issue likely has =
a
> > > few steps on effects architectures:
> > > 1)Have all callers of set_memory_*() helpers check the return value.
> > > 2)Add __must_check to all set_memory_*() helpers so that new uses do
> > > not ignore the return value.
> > > 3)Add atomicity to the calls so that the memory protections aren't le=
ft
> > > in a partial state.
> > >
> > > This series is part of step 1. Make drm/radeon check the return value=
 of
> > > set_memory_*().
> >
> > I'm a little hesitate merge that. This hardware is >15 years old and no=
body
> > of the developers have any system left to test this change on.
>
> If that's true it should be removed from the tree. We need to be able to
> correctly make these kinds of changes in the kernel.

This driver supports about 15 years of hardware generations.  Newer
cards are still prevalent, but the older stuff is less so.  It still
works and people use it based on feedback I've seen, but the older
stuff has no active development at this point.  This change just
happens to target those older chips.

Alex

>
> > Would it be to much of a problem to just add something like: r =3D
> > set_memory_*(); (void)r; /* Intentionally ignored */.
>
> This seems like a bad idea -- we shouldn't be papering over failures
> like this when there is logic available to deal with it.
>
> > Apart from that certainly a good idea to add __must_check to the functi=
ons.
>
> Agreed!
>
> -Kees
>
> --
> Kees Cook
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
