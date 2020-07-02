Return-Path: <SRS0=Eo62=AN=lists.openwall.com=kernel-hardening-return-19203-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89763C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Jul 2020 09:37:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E8D4B20760
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Jul 2020 09:37:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8D4B20760
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19203-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11366 invoked by uid 550); 2 Jul 2020 09:37:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11334 invoked from network); 2 Jul 2020 09:37:40 -0000
X-MC-Unique: _943ttHWM7K-SXNAkBuyNw-1
From: David Laight <David.Laight@ACULAB.COM>
To: "'paulmck@kernel.org'" <paulmck@kernel.org>
CC: 'Peter Zijlstra' <peterz@infradead.org>, Marco Elver <elver@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>, Sami Tolvanen
	<samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, "Will
 Deacon" <will@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>, clang-built-linux
	<clang-built-linux@googlegroups.com>, Kernel Hardening
	<kernel-hardening@lists.openwall.com>, linux-arch
	<linux-arch@vger.kernel.org>, Linux ARM
	<linux-arm-kernel@lists.infradead.org>, Linux Kbuild mailing list
	<linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "maintainer:X86
 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: RE: [PATCH 00/22] add support for Clang LTO
Thread-Topic: [PATCH 00/22] add support for Clang LTO
Thread-Index: AQHWT4eVR3DE4y9c50++UkzL75GurajywsMggAAQjQCAATOsAA==
Date: Thu, 2 Jul 2020 09:37:26 +0000
Message-ID: <aeed740a4d86470d84ae7d5f1cf07951@AcuMS.aculab.com>
References: <20200624211540.GS4817@hirez.programming.kicks-ass.net>
 <CAKwvOdmxz91c-M8egR9GdR1uOjeZv7-qoTP=pQ55nU8TCpkK6g@mail.gmail.com>
 <20200625080313.GY4817@hirez.programming.kicks-ass.net>
 <20200625082433.GC117543@hirez.programming.kicks-ass.net>
 <20200625085745.GD117543@hirez.programming.kicks-ass.net>
 <20200630191931.GA884155@elver.google.com>
 <20200630201243.GD4817@hirez.programming.kicks-ass.net>
 <20200630203016.GI9247@paulmck-ThinkPad-P72>
 <20200701091054.GW4781@hirez.programming.kicks-ass.net>
 <4427b0f825324da4b1640e32265b04bd@AcuMS.aculab.com>
 <20200701160624.GO9247@paulmck-ThinkPad-P72>
In-Reply-To: <20200701160624.GO9247@paulmck-ThinkPad-P72>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Paul E. McKenney
> Sent: 01 July 2020 17:06
...
> > Would an asm statement that uses the same 'register' for input and
> > output but doesn't actually do anything help?
> > It won't generate any code, but the compiler ought to assume that
> > it might change the value - so can't do optimisations that track
> > the value across the call.
>=20
> It might replace the volatile load, but there are optimizations that
> apply to the downstream code as well.
>=20
> Or are you suggesting periodically pushing the dependent variable
> through this asm?  That might work, but it would be easier and
> more maintainable to just mark the variable.

Marking the variable requires compiler support.
Although what 'volatile register int foo;' means might be interesting.

So I was thinking that in the case mentioned earlier you do:
=09ptr +=3D LAUNDER(offset & 1);
to ensure the compiler didn't convert to:
=09if (offset & 1) ptr++;
(Which is probably a pessimisation - the reverse is likely better.)

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

