Return-Path: <SRS0=eD02=AE=lists.openwall.com=kernel-hardening-return-19066-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9ABCC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 13:42:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3325A2070E
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 13:42:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3325A2070E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19066-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12025 invoked by uid 550); 23 Jun 2020 13:42:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11988 invoked from network); 23 Jun 2020 13:42:44 -0000
X-MC-Unique: tuWEcT22NmmyTjcRjBXV1g-1
From: David Laight <David.Laight@ACULAB.COM>
To: 'Kees Cook' <keescook@chromium.org>, Arvind Sankar <nivedita@alum.mit.edu>
CC: Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova
	<elena.reshetova@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Andy
 Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Catalin Marinas" <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	"Mark Rutland" <mark.rutland@arm.com>, Alexander Potapenko
	<glider@google.com>, Alexander Popov <alex.popov@linux.com>, Ard Biesheuvel
	<ard.biesheuvel@linaro.org>, Jann Horn <jannh@google.com>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 3/5] stack: Optionally randomize kernel stack offset
 each syscall
Thread-Topic: [PATCH v4 3/5] stack: Optionally randomize kernel stack offset
 each syscall
Thread-Index: AQHWSPkh/p0bc5D3iUelrjbiR4wWCajmNFDA
Date: Tue, 23 Jun 2020 13:42:30 +0000
Message-ID: <917458f43d194385a760d75292d4eb47@AcuMS.aculab.com>
References: <20200622193146.2985288-1-keescook@chromium.org>
 <20200622193146.2985288-4-keescook@chromium.org>
 <20200622225615.GA3511702@rani.riverdale.lan>
 <202006221604.871B13DE3@keescook>
 <20200623000510.GA3542245@rani.riverdale.lan>
 <202006221748.DA27A7FFC@keescook>
In-Reply-To: <202006221748.DA27A7FFC@keescook>
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

From: Kees Cook
> Sent: 23 June 2020 01:56
> On Mon, Jun 22, 2020 at 08:05:10PM -0400, Arvind Sankar wrote:
> > But I still don't see anything _stopping_ the compiler from optimizing
> > this better in the future. The "=3Dm" is not a barrier: it just informs
> > the compiler that the asm produces an output value in *ptr (and no othe=
r
> > outputs). If nothing can consume that output, it doesn't stop the
> > compiler from freeing the allocation immediately after the asm instead
> > of at the end of the function.
>=20
> Ah, yeah, I get what you mean.
>=20
> > I'm talking about something like
> > =09asm volatile("" : : "r" (ptr) : "memory");
> > which tells the compiler that the asm may change memory arbitrarily.
>=20
> Yeah, I will adjust it.
>=20
> > Here, we don't use it really as a barrier, but to tell the compiler tha=
t
> > the asm may have stashed the value of ptr somewhere in memory, so it's
> > not free to reuse the space that it pointed to until the function
> > returns (unless it can prove that nothing accesses memory, not just tha=
t
> > nothing accesses ptr).

Do you need another asm volatile("" : : "r" (ptr) : "memory");
(or similar) at the bottom of the function - that the compiler thinks
might access the memory whose address it thought got saved earlier?

I wonder if it would be easier to allocate the stack space
in the asm wrapper? At least as an architecture option.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

