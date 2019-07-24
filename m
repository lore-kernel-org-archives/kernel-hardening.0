Return-Path: <SRS0=Xeaf=VV=lists.openwall.com=kernel-hardening-return-16580-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917D0C76186
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 18:18:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E1C7021926
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 18:18:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1C7021926
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16580-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27970 invoked by uid 550); 24 Jul 2019 18:18:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27919 invoked from network); 24 Jul 2019 18:18:02 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,303,1559545200"; 
   d="scan'208";a="160652656"
From: "Gote, Nitin R" <nitin.r.gote@intel.com>
To: Joe Perches <joe@perches.com>, Kees Cook <keescook@chromium.org>
CC: "corbet@lwn.net" <corbet@lwn.net>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "apw@canonical.com" <apw@canonical.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Subject: RE: [PATCH v5] Documentation/checkpatch: Prefer strscpy/strscpy_pad
 over strcpy/strlcpy/strncpy
Thread-Topic: [PATCH v5] Documentation/checkpatch: Prefer
 strscpy/strscpy_pad over strcpy/strlcpy/strncpy
Thread-Index: AQHVPFiM9cWMTc5Km0imVXiG0lTtQKbWkWuAgAAC7gCAAUjQQIACQMYQ
Date: Wed, 24 Jul 2019 18:17:40 +0000
Message-ID: <12356C813DFF6F479B608F81178A561587AE45@BGSMSX101.gar.corp.intel.com>
References: <20190717043005.19627-1-nitin.r.gote@intel.com>
	 <201907221029.B0CBED4F@keescook>
 <28404b52d58efa0a3e85ce05ce0b210049ed6050.camel@perches.com>
 <12356C813DFF6F479B608F81178A561587ABA9@BGSMSX101.gar.corp.intel.com>
In-Reply-To: <12356C813DFF6F479B608F81178A561587ABA9@BGSMSX101.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjBhMDJiYjQtNTEzYy00MzQ5LTlkYTktNTRlZThhY2JhNjhlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiOW9FcGxDcGpvbTJ1eHdcLzRvWURPVXdVWTZ4MDh4OXVpbkFrd2h1WGFjaDg5aUhRYmhJV1g0WkFaNVFJSUkxVTQifQ==
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

Hi,

> -----Original Message-----
> From: Gote, Nitin R [mailto:nitin.r.gote@intel.com]
> Sent: Tuesday, July 23, 2019 2:56 PM
> To: Joe Perches <joe@perches.com>; Kees Cook <keescook@chromium.org>
> Cc: corbet@lwn.net; akpm@linux-foundation.org; apw@canonical.com;
> linux-doc@vger.kernel.org; kernel-hardening@lists.openwall.com
> Subject: RE: [PATCH v5] Documentation/checkpatch: Prefer
> strscpy/strscpy_pad over strcpy/strlcpy/strncpy
>=20
>=20
> > -----Original Message-----
> > From: Joe Perches [mailto:joe@perches.com]
> > Sent: Monday, July 22, 2019 11:11 PM
> > To: Kees Cook <keescook@chromium.org>; Gote, Nitin R
> > <nitin.r.gote@intel.com>
> > Cc: corbet@lwn.net; akpm@linux-foundation.org; apw@canonical.com;
> > linux-doc@vger.kernel.org; kernel-hardening@lists.openwall.com
> > Subject: Re: [PATCH v5] Documentation/checkpatch: Prefer
> > strscpy/strscpy_pad over strcpy/strlcpy/strncpy
> >
> > On Mon, 2019-07-22 at 10:30 -0700, Kees Cook wrote:
> > > On Wed, Jul 17, 2019 at 10:00:05AM +0530, NitinGote wrote:
> > > > From: Nitin Gote <nitin.r.gote@intel.com>
> > > >
> > > > Added check in checkpatch.pl to
> > > > 1. Deprecate strcpy() in favor of strscpy().
> > > > 2. Deprecate strlcpy() in favor of strscpy().
> > > > 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> > > >
> > > > Updated strncpy() section in Documentation/process/deprecated.rst
> > > > to cover strscpy_pad() case.
> > > >
> > > > Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
> > >
> > > Reviewed-by: Kees Cook <keescook@chromium.org>
> > >
> > > Joe, does this address your checkpatch concerns?
> >
> > Well, kinda.
> >
> > strscpy_pad isn't used anywhere in the kernel.
> >
> > And
> >
> > +        "strncpy"				=3D> "strscpy, strscpy_pad or
> for non-
> > NUL-terminated strings, strncpy() can still be used, but destinations
> > should be marked with __nonstring",
> >
> > is a bit verbose.  This could be simply:
> >
> > +        "strncpy" =3D> "strscpy - for non-NUL-terminated uses,
> > + strncpy() dst
> > should be __nonstring",
> >
>

Could you please give your opinion on below comment.
=20
> But, if the destination buffer needs extra NUL-padding for remaining size=
 of
> destination, then safe replacement is strscpy_pad().  Right?  If yes, the=
n what
> is your opinion on below change :
>=20
>         "strncpy" =3D> "strscpy, strcpy_pad - for non-NUL-terminated uses=
,
> strncpy() dst should be __nonstring",
>=20
>=20

If you agree on this, then I will include this change in next patch version=
.
=20
 > -Nitin
