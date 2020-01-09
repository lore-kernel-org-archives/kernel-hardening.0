Return-Path: <SRS0=N249=27=lists.openwall.com=kernel-hardening-return-17558-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C520AC33CA2
	for <kernel-hardening@archiver.kernel.org>; Fri, 10 Jan 2020 10:35:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EBA5020661
	for <kernel-hardening@archiver.kernel.org>; Fri, 10 Jan 2020 10:35:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="juSyx3fI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBA5020661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17558-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28337 invoked by uid 550); 10 Jan 2020 10:35:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23952 invoked from network); 9 Jan 2020 20:17:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E+lwrXE3aZ94AXYYIKmBRrTAemPYlA5yIdzG6bHrsbM=;
        b=juSyx3fIemNz4CfhuztJJRSl/hZcSdBYYxa82QRPNc5ezugZgpxWIbJe8ZOAo3Y/OG
         Zh/nnA/LwkmeHKVD7+fhrraxUqdbXkIy/yzqfxMcPcER5SXWrAyKbodbiHRcDIH+Ljuw
         jaBKurW4cZD1tlk6qEhW+vkbcwBOHdbuGU5V8qYp+1KFz7/RUTucBBwEzhMSINlLG5X5
         6mNdA+hmav+o0Q3JCRsTmjgEwgDdMmcRrPQZd8Jft6uVqLuSaSZ16wAOs8zaI4+CzvDb
         Xr4BLxh34hH4LHKSqjloscJkcH30Dm0S74Y+WMf0O9hOYJc8+JEZJDiZ/iwgImwD7e0k
         R50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E+lwrXE3aZ94AXYYIKmBRrTAemPYlA5yIdzG6bHrsbM=;
        b=sUKv668+wbh+BAi3evYgdqUAjpXkszO6QTnwC4Kd9oRLcIDnLGtHjkVNGxlerY4Wh7
         0ZzT7ie1jl1vKUl9M0w2dv/G0gdqftEGQnAQZDGGy3bAG7EHUby4Z04O/WHG9EC8IDt8
         /n4S6BrehdW0PEJGU7DM3D74XfSxtO15OXwCM5T8C+XIB2OdniCv8mqDxjiw5Vx/mrEr
         hjbo2Cc9X411+12qMdY0cn+hzJqChPDAp1f7bSGk1ObQ7VXEXKEoXJBQolUoobRZitcA
         GFocuBAup8vc84+1CAt3KhHipH3C4p6D99MjTazeGT5nU8PYPV1i0YN/PQH+veHoZrmX
         BV1A==
X-Gm-Message-State: APjAAAU6jZUq0vDnCuOY3bjarxpAxk1XrXIEeJqRF/uYApZv6VELOMZ6
	VQLoYswOrHu1PzWq7PQw8gp81qguELTl4n/kdw0=
X-Google-Smtp-Source: APXvYqyRBoQWA0EPa3ebhHv8AejJlhOoyhlMvK0QfxIl4zgcvvSGuHQ4BPXGpoSdlb3wsdh6/KtNAXpvrLOLks96BXo=
X-Received: by 2002:a1c:6404:: with SMTP id y4mr6727312wmb.143.1578601016498;
 Thu, 09 Jan 2020 12:16:56 -0800 (PST)
MIME-Version: 1.0
References: <20200107192555.20606-1-tli@digitalocean.com> <b5984995-7276-97d3-a604-ddacfb89bd89@amd.com>
 <202001080936.A36005F1@keescook> <CADnq5_NLS=CuHD39utCTnTVsY_izuTPXFfsew6TpMjovgFoT5g@mail.gmail.com>
 <a2919283-f5aa-43b2-9186-6c41315458c4@amd.com> <505a76a9-6110-3ddb-0f15-059b60922482@suse.de>
In-Reply-To: <505a76a9-6110-3ddb-0f15-059b60922482@suse.de>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Thu, 9 Jan 2020 15:16:44 -0500
Message-ID: <CADnq5_NH0Xwhr3YjT5Ax-45-f8mmCxvfUPb8V6i34TY44BJPOA@mail.gmail.com>
Subject: Re: [PATCH 0/2] drm/radeon: have the callers of set_memory_*() check
 the return value
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, 
	David Airlie <airlied@linux.ie>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	LKML <linux-kernel@vger.kernel.org>, amd-gfx list <amd-gfx@lists.freedesktop.org>, 
	Tianlin Li <tli@digitalocean.com>, 
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>, Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 9, 2020 at 5:49 AM Thomas Zimmermann <tzimmermann@suse.de> wrot=
e:
>
> Hi
>
> Am 09.01.20 um 11:15 schrieb Christian K=C3=B6nig:
> > Am 08.01.20 um 18:51 schrieb Alex Deucher:
> >> On Wed, Jan 8, 2020 at 12:39 PM Kees Cook <keescook@chromium.org> wrot=
e:
> >>> On Wed, Jan 08, 2020 at 01:56:47PM +0100, Christian K=C3=B6nig wrote:
> >>>> Am 07.01.20 um 20:25 schrieb Tianlin Li:
> >>>>> Right now several architectures allow their set_memory_*() family o=
f
> >>>>> functions to fail, but callers may not be checking the return value=
s.
> >>>>> If set_memory_*() returns with an error, call-site assumptions may =
be
> >>>>> infact wrong to assume that it would either succeed or not succeed =
at
> >>>>> all. Ideally, the failure of set_memory_*() should be passed up the
> >>>>> call stack, and callers should examine the failure and deal with it=
.
> >>>>>
> >>>>> Need to fix the callers and add the __must_check attribute. They al=
so
> >>>>> may not provide any level of atomicity, in the sense that the memor=
y
> >>>>> protections may be left incomplete on failure. This issue likely ha=
s a
> >>>>> few steps on effects architectures:
> >>>>> 1)Have all callers of set_memory_*() helpers check the return value=
.
> >>>>> 2)Add __must_check to all set_memory_*() helpers so that new uses d=
o
> >>>>> not ignore the return value.
> >>>>> 3)Add atomicity to the calls so that the memory protections aren't
> >>>>> left
> >>>>> in a partial state.
> >>>>>
> >>>>> This series is part of step 1. Make drm/radeon check the return
> >>>>> value of
> >>>>> set_memory_*().
> >>>> I'm a little hesitate merge that. This hardware is >15 years old and
> >>>> nobody
> >>>> of the developers have any system left to test this change on.
> >>> If that's true it should be removed from the tree. We need to be able=
 to
> >>> correctly make these kinds of changes in the kernel.
> >> This driver supports about 15 years of hardware generations.  Newer
> >> cards are still prevalent, but the older stuff is less so.  It still
> >> works and people use it based on feedback I've seen, but the older
> >> stuff has no active development at this point.  This change just
> >> happens to target those older chips.
> >
> > Just a few weeks back we've got a mail from somebody using an integrate=
d
> > R128 in a laptop.
> >
> > After a few mails back and force we figured out that his nearly 20 year=
s
> > old hardware was finally failing.
> >
> > Up till that he was still successfully updating his kernel from time to
> > time and the driver still worked. I find that pretty impressive.
> >
> >>
> >> Alex
> >>
> >>>> Would it be to much of a problem to just add something like: r =3D
> >>>> set_memory_*(); (void)r; /* Intentionally ignored */.
> >>> This seems like a bad idea -- we shouldn't be papering over failure
> >>> like this when there is logic available to deal with it.
> >
> > Well I certainly agree to that, but we are talking about a call which
> > happens only once during driver load/unload. If necessary we could also
> > print an error when something goes wrong, but please no larger
> > refactoring of return values and call paths.
> >
>
> IMHO radeon should be marked as orphaned or obsolete then.

As I said this covers about 15-17 years of GPUs (~60 asic families).
The older stuff is hard to test these days because it's PCI or AGP
hardware.  So far it works for most people.  The newer stuff is still
tested as used regularly.

Alex

>
> Best regards
> Thomas
>
> > It is perfectly possible that this call actually failed on somebodies
> > hardware, but we never noticed because the driver still works fine. If
> > we now handle the error it is possible that the module never loads and
> > the user gets a black screen instead.
> >
> > Regards,
> > Christian.
> >
> >>>
> >>>> Apart from that certainly a good idea to add __must_check to the
> >>>> functions.
> >>> Agreed!
> >>>
> >>> -Kees
> >>>
> >>> --
> >>> Kees Cook
> >>> _______________________________________________
> >>> dri-devel mailing list
> >>> dri-devel@lists.freedesktop.org
> >>> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fl=
ists.freedesktop.org%2Fmailman%2Flistinfo%2Fdri-devel&amp;data=3D02%7C01%7C=
christian.koenig%40amd.com%7Ca542d384d54040b5b0b708d794636df1%7C3dd8961fe48=
84e608e11a82d994e183d%7C0%7C0%7C637141027080080147&amp;sdata=3DEHFl6YOHmNp7=
gOqWsVmfoeD0jNirBTOGHcCP4efC%2FvE%3D&amp;reserved=3D0
> >>>
> >
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/dri-devel
>
> --
> Thomas Zimmermann
> Graphics Driver Developer
> SUSE Software Solutions Germany GmbH
> Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
> (HRB 36809, AG N=C3=BCrnberg)
> Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer
>
