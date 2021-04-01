Return-Path: <SRS0=J1lb=I6=lists.openwall.com=kernel-hardening-return-21113-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAFBC433ED
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 11:16:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 00A3761057
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 11:16:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00A3761057
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21113-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3444 invoked by uid 550); 1 Apr 2021 11:16:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3415 invoked from network); 1 Apr 2021 11:15:59 -0000
X-MC-Unique: 55FOPC1yNrCSB69XR94FFw-1
From: David Laight <David.Laight@ACULAB.COM>
To: 'Will Deacon' <will@kernel.org>, Kees Cook <keescook@chromium.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova
	<elena.reshetova@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Andy
 Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Catalin Marinas" <catalin.marinas@arm.com>, Mark Rutland
	<mark.rutland@arm.com>, Alexander Potapenko <glider@google.com>, Alexander
 Popov <alex.popov@linux.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>, David
 Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, Andrew
 Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Randy
 Dunlap <rdunlap@infradead.org>, "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 3/6] stack: Optionally randomize kernel stack offset
 each syscall
Thread-Topic: [PATCH v8 3/6] stack: Optionally randomize kernel stack offset
 each syscall
Thread-Index: AQHXJtFkunedSLxfaUq504kizLaNqaqfgZOw
Date: Thu, 1 Apr 2021 11:15:43 +0000
Message-ID: <61ae9398a03d4fe7868b68c9026d5998@AcuMS.aculab.com>
References: <20210330205750.428816-1-keescook@chromium.org>
 <20210330205750.428816-4-keescook@chromium.org>
 <20210401083034.GA8554@willie-the-truck>
In-Reply-To: <20210401083034.GA8554@willie-the-truck>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Will Deacon
> Sent: 01 April 2021 09:31
...
> > +/*
> > + * These macros must be used during syscall entry when interrupts and
> > + * preempt are disabled, and after user registers have been stored to
> > + * the stack.
> > + */
> > +#define add_random_kstack_offset() do {=09=09=09=09=09\
> > +=09if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,=09\
> > +=09=09=09=09&randomize_kstack_offset)) {=09=09\
> > +=09=09u32 offset =3D __this_cpu_read(kstack_offset);=09=09\
> > +=09=09u8 *ptr =3D __builtin_alloca(KSTACK_OFFSET_MAX(offset));=09\
> > +=09=09asm volatile("" : "=3Dm"(*ptr) :: "memory");=09=09\
>=20
> Using the "m" constraint here is dangerous if you don't actually evaluate=
 it
> inside the asm. For example, if the compiler decides to generate an
> addressing mode relative to the stack but with writeback (autodecrement),=
 then
> the stack pointer will be off by 8 bytes. Can you use "o" instead?

Is it allowed to use such a mode?
It would have to know that the "m" was substituted exactly once.
I think there are quite a few examples with 'strange' uses of memory
asm arguments.

However, in this case, isn't it enough to ensure the address is 'saved'?
So:
=09asm volatile("" : "=3Dr"(ptr) );
should be enough.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

