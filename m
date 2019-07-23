Return-Path: <SRS0=UGeq=VU=lists.openwall.com=kernel-hardening-return-16560-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE15AC7618B
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 15:41:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 144F6223BA
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 15:41:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 144F6223BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16560-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27700 invoked by uid 550); 23 Jul 2019 15:41:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27658 invoked from network); 23 Jul 2019 15:41:41 -0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Rasmus Villemoes' <linux@rasmusvillemoes.dk>, Joe Perches
	<joe@perches.com>, Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jonathan Corbet <corbet@lwn.net>, Stephen Kitt <steve@sk2.org>, Kees Cook
	<keescook@chromium.org>, Nitin Gote <nitin.r.gote@intel.com>,
	"jannh@google.com" <jannh@google.com>, "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, Andrew Morton
	<akpm@linux-foundation.org>
Subject: RE: [PATCH 1/2] string: Add stracpy and stracpy_pad mechanisms
Thread-Topic: [PATCH 1/2] string: Add stracpy and stracpy_pad mechanisms
Thread-Index: AQHVQSOiPIn99bSetkamp+/6YQTlwKbYVhaA
Date: Tue, 23 Jul 2019 15:41:27 +0000
Message-ID: <5ffdbf4f87054b47a2daf23a6afabecf@AcuMS.aculab.com>
References: <cover.1563841972.git.joe@perches.com>
 <7ab8957eaf9b0931a59eff6e2bd8c5169f2f6c41.1563841972.git.joe@perches.com>
 <eec901c6-ca51-89e4-1887-1ccab0288bee@rasmusvillemoes.dk>
In-Reply-To: <eec901c6-ca51-89e4-1887-1ccab0288bee@rasmusvillemoes.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 32j5YcqrN5ShbLouelXgfQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Rasmus Villemoes
> Sent: 23 July 2019 07:56
...
> > +/**
> > + * stracpy - Copy a C-string into an array of char
> > + * @to: Where to copy the string, must be an array of char and not a p=
ointer
> > + * @from: String to copy, may be a pointer or const char array
> > + *
> > + * Helper for strscpy.
> > + * Copies a maximum of sizeof(@to) bytes of @from with %NUL terminatio=
n.
> > + *
> > + * Returns:
> > + * * The number of characters copied (not including the trailing %NUL)
> > + * * -E2BIG if @to is a zero size array.
>=20
> Well, yes, but more importantly and generally: -E2BIG if the copy
> including %NUL didn't fit. [The zero size array thing could be made into
> a build bug for these stra* variants if one thinks that might actually
> occur in real code.]

Probably better is to return the size of the destination if the copy didn't=
 fit
(zero if the buffer is zero length).
This allows code to do repeated:
=09offset +=3D str*cpy(buf + offset, src, sizeof buf - offset);
and do a final check for overflow after all the copies.

The same is true for a snprintf()like function

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

