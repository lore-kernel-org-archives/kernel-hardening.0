Return-Path: <SRS0=165/=AM=lists.openwall.com=kernel-hardening-return-19198-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE549C433E1
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Jul 2020 14:20:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 59271206B6
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Jul 2020 14:20:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59271206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19198-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19975 invoked by uid 550); 1 Jul 2020 14:20:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19938 invoked from network); 1 Jul 2020 14:20:27 -0000
X-MC-Unique: BVV8QEx9N7etV0JoaSvqjg-1
From: David Laight <David.Laight@ACULAB.COM>
To: 'Peter Zijlstra' <peterz@infradead.org>, "Paul E. McKenney"
	<paulmck@kernel.org>
CC: Marco Elver <elver@google.com>, Nick Desaulniers
	<ndesaulniers@google.com>, Sami Tolvanen <samitolvanen@google.com>, "Masahiro
 Yamada" <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Kees Cook
	<keescook@chromium.org>, clang-built-linux
	<clang-built-linux@googlegroups.com>, Kernel Hardening
	<kernel-hardening@lists.openwall.com>, linux-arch
	<linux-arch@vger.kernel.org>, Linux ARM
	<linux-arm-kernel@lists.infradead.org>, Linux Kbuild mailing list
	<linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "maintainer:X86
 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: RE: [PATCH 00/22] add support for Clang LTO
Thread-Topic: [PATCH 00/22] add support for Clang LTO
Thread-Index: AQHWT4eVR3DE4y9c50++UkzL75GurajywsMg
Date: Wed, 1 Jul 2020 14:20:13 +0000
Message-ID: <4427b0f825324da4b1640e32265b04bd@AcuMS.aculab.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624211540.GS4817@hirez.programming.kicks-ass.net>
 <CAKwvOdmxz91c-M8egR9GdR1uOjeZv7-qoTP=pQ55nU8TCpkK6g@mail.gmail.com>
 <20200625080313.GY4817@hirez.programming.kicks-ass.net>
 <20200625082433.GC117543@hirez.programming.kicks-ass.net>
 <20200625085745.GD117543@hirez.programming.kicks-ass.net>
 <20200630191931.GA884155@elver.google.com>
 <20200630201243.GD4817@hirez.programming.kicks-ass.net>
 <20200630203016.GI9247@paulmck-ThinkPad-P72>
 <20200701091054.GW4781@hirez.programming.kicks-ass.net>
In-Reply-To: <20200701091054.GW4781@hirez.programming.kicks-ass.net>
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

From: Peter Zijlstra
> Sent: 01 July 2020 10:11
> On Tue, Jun 30, 2020 at 01:30:16PM -0700, Paul E. McKenney wrote:
> > On Tue, Jun 30, 2020 at 10:12:43PM +0200, Peter Zijlstra wrote:
>=20
> > > I'm not convinced C11 memory_order_consume would actually work for us=
,
> > > even if it would work. That is, given:
> > >
> > >   https://lore.kernel.org/lkml/20150520005510.GA23559@linux.vnet.ibm.=
com/
> > >
> > > only pointers can have consume, but like I pointed out, we have code
> > > that relies on dependent loads from integers.
> >
> > I agree that C11 memory_order_consume is not normally what we want,
> > given that it is universally promoted to memory_order_acquire.
> >
> > However, dependent loads from integers are, if anything, more difficult
> > to defend from the compiler than are control dependencies.  This applie=
s
> > doubly to integers that are used to index two-element arrays, in which
> > case you are just asking the compiler to destroy your dependent loads
> > by converting them into control dependencies.
>=20
> Yes, I'm aware. However, as you might know, I'm firmly in the 'C is a
> glorified assembler' camp (as I expect most actual OS people are, out of
> necessity if nothing else) and if I wanted a control dependency I
> would've bloody well written one.

I write in C because doing register tracking is hard :-)
I've got an hdlc implementation in C that is carefully adjusted
so that the worst case path is bounded.
I probably know every one of the 1000 instructions in it.

Would an asm statement that uses the same 'register' for input and
output but doesn't actually do anything help?
It won't generate any code, but the compiler ought to assume that
it might change the value - so can't do optimisations that track
the value across the call.

> I think an optimizing compiler is awesome, but only in so far as that
> optimization is actually helpful -- and yes, I just stepped into a giant
> twilight zone there. That is, any optimization that has _any_
> controversy should be controllable (like -fno-strict-overflow
> -fno-strict-aliasing) and I'd very much like the same here.

I'm fed up of gcc generating the code that uses SIMD instructions
for the 'tail' loop at the end of a function that is already doing
SIMD operations for the main part of the loop.
And compilers that convert a byte copy loop to 'rep movsb'.
If I'm copying 3 or 4 bytes I don't want a 40 clock overhead.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

