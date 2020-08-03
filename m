Return-Path: <SRS0=2QBZ=BN=lists.openwall.com=kernel-hardening-return-19529-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4BBC433E1
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 08:08:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7DCD82065E
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 08:08:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DCD82065E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19529-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11628 invoked by uid 550); 3 Aug 2020 08:08:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11601 invoked from network); 3 Aug 2020 08:08:36 -0000
X-MC-Unique: PHrlPE41MKu5ed8gAMWPYg-1
From: David Laight <David.Laight@ACULAB.COM>
To: 'Pavel Machek' <pavel@ucw.cz>
CC: 'Andy Lutomirski' <luto@kernel.org>, "madvenka@linux.microsoft.com"
	<madvenka@linux.microsoft.com>, Kernel Hardening
	<kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Linux FS Devel
	<linux-fsdevel@vger.kernel.org>, linux-integrity
	<linux-integrity@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "LSM
 List" <linux-security-module@vger.kernel.org>, Oleg Nesterov
	<oleg@redhat.com>, X86 ML <x86@kernel.org>
Subject: RE: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Topic: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Index: AQHWZQT/T+e4gDrzGEmP/30MMvDTCqkgFteggASWI4CAAWJTUA==
Date: Mon, 3 Aug 2020 08:08:21 +0000
Message-ID: <c02fbae7a0754a58884b370657575845@AcuMS.aculab.com>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
 <b9879beef3e740c0aeb1af73485069a8@AcuMS.aculab.com>
 <20200802115600.GB1162@bug>
In-Reply-To: <20200802115600.GB1162@bug>
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

From: Pavel Machek <pavel@ucw.cz>
> Sent: 02 August 2020 12:56
> Hi!
>=20
> > > This is quite clever, but now I???m wondering just how much kernel he=
lp
> > > is really needed. In your series, the trampoline is an non-executable
> > > page.  I can think of at least two alternative approaches, and I'd
> > > like to know the pros and cons.
> > >
> > > 1. Entirely userspace: a return trampoline would be something like:
> > >
> > > 1:
> > > pushq %rax
> > > pushq %rbc
> > > pushq %rcx
> > > ...
> > > pushq %r15
> > > movq %rsp, %rdi # pointer to saved regs
> > > leaq 1b(%rip), %rsi # pointer to the trampoline itself
> > > callq trampoline_handler # see below
> >
> > For nested calls (where the trampoline needs to pass the
> > original stack frame to the nested function) I think you
> > just need a page full of:
> > =09mov=09$0, scratch_reg; jmp trampoline_handler
>=20
> I believe you could do with mov %pc, scratch_reg; jmp ...
>=20
> That has advantage of being able to share single physical
> page across multiple virtual pages...

A lot of architecture don't let you copy %pc that way so you would
have to use 'call' - but that trashes the return address cache.
It also needs the trampoline handler to know the addresses
of the trampolines.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

