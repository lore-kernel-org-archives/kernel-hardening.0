Return-Path: <SRS0=mnoF=6N=lists.openwall.com=kernel-hardening-return-18678-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75625C83003
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Apr 2020 08:39:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CA4A420731
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Apr 2020 08:39:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA4A420731
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18678-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5908 invoked by uid 550); 29 Apr 2020 08:39:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5885 invoked from network); 29 Apr 2020 08:39:48 -0000
X-MC-Unique: r75nPERROFeEoEJIwkJHxw-1
From: David Laight <David.Laight@ACULAB.COM>
To: 'Sami Tolvanen' <samitolvanen@google.com>, Ard Biesheuvel
	<ardb@kernel.org>
CC: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, "Ard
 Biesheuvel" <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek
	<michal.lkml@markovi.net>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
	<peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
	<vincent.guittot@linaro.org>, Kees Cook <keescook@chromium.org>, Jann Horn
	<jannh@google.com>, Marc Zyngier <maz@kernel.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	Nick Desaulniers <ndesaulniers@google.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, Miguel Ojeda
	<miguel.ojeda.sandonis@gmail.com>, Masami Hiramatsu <mhiramat@kernel.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>, Laura Abbott
	<labbott@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Linux ARM
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v13 00/12] add support for Clang's Shadow Call Stack
Thread-Topic: [PATCH v13 00/12] add support for Clang's Shadow Call Stack
Thread-Index: AQHWHOCVWHSK1xvpOUef91FgkS/f7KiPxyTg
Date: Wed, 29 Apr 2020 08:39:33 +0000
Message-ID: <6762b8d0974d49de80c3b398d714b3fb@AcuMS.aculab.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200427160018.243569-1-samitolvanen@google.com>
 <CAMj1kXGASSCjTjvXJh=_iPwEPG50_pVRe2QO1hoRW+KHtugFVQ@mail.gmail.com>
 <CAMj1kXFYv6YQJ0KGnFh=d6_K-39PYW+2bUj9TDnutA04czhOjQ@mail.gmail.com>
 <20200427220942.GB80713@google.com>
In-Reply-To: <20200427220942.GB80713@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Sami Tolvanen
> Sent: 27 April 2020 23:10
...
> > > Alternatively, I wonder if there is a way we could let the SCS and
> > > ordinary stack share the [bottom of] the vmap'ed region. That would
> > > give rather nasty results if the ordinary stack overflows into the
> > > SCS, but for cases where we really recurse out of control, we could
> > > catch this occurrence on either stack, whichever one occurs first. An=
d
> > > the nastiness -when it does occur- will not corrupt any state beyond
> > > the stack of the current task.
> >
> > Hmm, I guess that would make it quite hard to keep the SCS address
> > secret though :-(
>=20
> Yes, and the stack potentially overflowing into the SCS sort of defeats
> the purpose. I'm fine with increasing the SCS size to something safer,
> but using a vmapped shadow stack seems like the correct solution to this
> problem, at least on devices where allocating a full page isn't an issue.

Wouldn't you do it the other way around - so shadow stack overflow
corrupts the bottom of the normal stack?
That can be detected 'after the fact' in a few places (eg process
switch and return to user)

Actually you might want to do syscall entry at the base of stack area,
then (effectively) allocate an on-stack buffer for the shadow stack.

I'd have though that kernel code could be the shadow stack address
by just reading r18?
Userspace isn't supposed to be able to get the main kernel stack
address either.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

