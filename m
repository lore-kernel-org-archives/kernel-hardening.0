Return-Path: <kernel-hardening-return-21581-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 72D3FC4332F
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Nov 2022 09:26:33 +0000 (UTC)
Received: (qmail 15559 invoked by uid 550); 8 Nov 2022 09:26:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15527 invoked from network); 8 Nov 2022 09:26:21 -0000
X-MC-Unique: iyhD-bNnNIqZzr0HEwK7vA-1
From: David Laight <David.Laight@ACULAB.COM>
To: 'Jann Horn' <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
CC: Greg KH <gregkh@linuxfoundation.org>, Linus Torvalds
	<torvalds@linuxfoundation.org>, Seth Jenkins <sethjenkins@google.com>, "Eric
 W . Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] exit: Put an upper limit on how often we can oops
Thread-Topic: [PATCH] exit: Put an upper limit on how often we can oops
Thread-Index: AQHY8uVtJeqm4QnZJEegjt8nfpQUG640wW1Q
Date: Tue, 8 Nov 2022 09:26:06 +0000
Message-ID: <3e2f7e2cb4f6451a9ef5d0fb9e1f6080@AcuMS.aculab.com>
References: <20221107201317.324457-1-jannh@google.com>
In-Reply-To: <20221107201317.324457-1-jannh@google.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Jann Horn
> Sent: 07 November 2022 20:13
>=20
> Many Linux systems are configured to not panic on oops; but allowing an
> attacker to oops the system **really** often can make even bugs that look
> completely unexploitable exploitable (like NULL dereferences and such) if
> each crash elevates a refcount by one or a lock is taken in read mode, an=
d
> this causes a counter to eventually overflow.
>=20
> The most interesting counters for this are 32 bits wide (like open-coded
> refcounts that don't use refcount_t). (The ldsem reader count on 32-bit
> platforms is just 16 bits, but probably nobody cares about 32-bit platfor=
ms
> that much nowadays.)
>=20
> So let's panic the system if the kernel is constantly oopsing.

I think you are pretty much guaranteed to run out of memory
(or at least KVA) before any 32bit counter wraps.

That is probably even harder to diagnose than a refcount wrap!

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

