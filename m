Return-Path: <SRS0=XZ7O=VI=lists.openwall.com=kernel-hardening-return-16404-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B25C74A42
	for <kernel-hardening@archiver.kernel.org>; Thu, 11 Jul 2019 03:47:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9F10821019
	for <kernel-hardening@archiver.kernel.org>; Thu, 11 Jul 2019 03:47:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F10821019
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16404-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3325 invoked by uid 550); 11 Jul 2019 03:47:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3277 invoked from network); 11 Jul 2019 03:47:13 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,476,1557212400"; 
   d="scan'208";a="177043503"
From: "Gote, Nitin R" <nitin.r.gote@intel.com>
To: 'Joe Perches' <joe@perches.com>, "corbet@lwn.net" <corbet@lwn.net>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"apw@canonical.com" <apw@canonical.com>, "keescook@chromium.org"
	<keescook@chromium.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>
Subject: RE: [PATCH v4] Added warnings in checkpatch.pl script to :
Thread-Topic: [PATCH v4] Added warnings in checkpatch.pl script to :
Thread-Index: AQHVNm3hVzOhL9haf0KMxjtR64B8zqbCGIgAgAFiYNA=
Date: Thu, 11 Jul 2019 03:46:53 +0000
Message-ID: <12356C813DFF6F479B608F81178A5615878BFA@BGSMSX101.gar.corp.intel.com>
References: <20190709154806.26363-1-nitin.r.gote@intel.com>
 <040b50f00501ae131256bb13a5362731ebdd6bfe.camel@perches.com>
In-Reply-To: <040b50f00501ae131256bb13a5362731ebdd6bfe.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOGE2YzA0YmEtOGQ4MC00MTJkLTg5NTgtZDAwYTljOTVlYjYwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTlVmU3pPaTFySlpBV0ZVOEhBekFpcGYzQjJTS2JiZXAweWozOVBFeURlXC9TS3B1RVVtWHlnS21mUXBOQTduQTYifQ==
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0


> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Tuesday, July 9, 2019 9:40 PM
> To: Gote, Nitin R <nitin.r.gote@intel.com>; corbet@lwn.net
> Cc: akpm@linux-foundation.org; apw@canonical.com;
> keescook@chromium.org; linux-doc@vger.kernel.org; linux-
> kernel@vger.kernel.org; kernel-hardening@lists.openwall.com
> Subject: Re: [PATCH v4] Added warnings in checkpatch.pl script to :
>=20
> On Tue, 2019-07-09 at 21:18 +0530, NitinGote wrote:
> > From: Nitin Gote <nitin.r.gote@intel.com>
> >
> > 1. Deprecate strcpy() in favor of strscpy().
> > 2. Deprecate strlcpy() in favor of strscpy().
> > 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> >
> > Updated strncpy() section in Documentation/process/deprecated.rst
> > to cover strscpy_pad() case.
>=20
> Please slow down your patch submission rate for this instance and respond
> appropriately to the comments you've been given.

Sure, I will explore this things more. And sorry, I missed to incorporate o=
ne comment.=20
I will take care of such things.

>=20
> This stuff is not critical bug fixing.
>=20
Noted.

> The subject could be something like:
>=20
> Subject: [PATCH v#] Documentation/checkpatch: Prefer strscpy over
> strcpy/strlcpy
>=20

How about this  :
Subject: [PATCH v#] Doc/checkpatch: Prefer strscpy/strscpy_pad over strcpy/=
strlcpy/strncpy

> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > @@ -605,6 +605,20 @@ foreach my $entry (keys %deprecated_apis) {  }
> > $deprecated_apis_search =3D "(?:${deprecated_apis_search})";
> >
> > +our %deprecated_string_apis =3D (
> > +        "strcpy"				=3D> "strscpy",
> > +        "strlcpy"				=3D> "strscpy",
> > +        "strncpy"				=3D> "strscpy, strscpy_pad or
> for non-NUL-terminated strings, strncpy() can still be used, but destinat=
ions
> should be marked with the __nonstring",
>=20
> 'the' is not necessary.

Noted.

>=20
> There could likely also be a strscat created for strcat, strlcat and strn=
cat.
>

I have not found reference for strscat in kernel.
Could you please give any reference for strscat ?
=20
> btw:
>=20
> There were several defects in the kernel for misuses of strlcpy.
>=20
> Did you or anyone else have an opinion on stracpy to avoid duplicating th=
e
> first argument in a sizeof()?
>=20
> 	strlcpy(foo, bar, sizeof(foo))
> to
> 	stracpy(foo, bar)
>=20
> where foo must be char array compatible ?
>=20
> https://lore.kernel.org/lkml/d1524130f91d7cfd61bc736623409693d2895f57.
> camel@perches.com/
>=20
>

As I understood, your trying to give new interface like stracpy(), to avoid=
 duplication of first=20
argument in a sizeof(), we can also make it more robust for users by adding=
 check or warn in=20
checkpatch.pl to prefer stracpy().

Did you or anyone has opinion on this ?


Thanks,
Nitin Gote
