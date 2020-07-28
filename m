Return-Path: <SRS0=3GRy=BH=lists.openwall.com=kernel-hardening-return-19459-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2010BC433F2
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 08:07:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 77AC920656
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 08:07:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77AC920656
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19459-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21711 invoked by uid 550); 28 Jul 2020 08:07:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21679 invoked from network); 28 Jul 2020 08:07:26 -0000
X-MC-Unique: o5x9Q9SyNzqkeSG6S-qBgw-1
From: David Laight <David.Laight@ACULAB.COM>
To: 'Christoph Hellwig' <hch@lst.de>, "Jason A. Donenfeld" <Jason@zx2c4.com>
CC: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI
	<yoshfuji@linux-ipv6.org>, Eric Dumazet <edumazet@google.com>, "Linux Crypto
 Mailing List" <linux-crypto@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	"linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
	"linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	"bridge@lists.linux-foundation.org" <bridge@lists.linux-foundation.org>,
	"linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
	"dccp@vger.kernel.org" <dccp@vger.kernel.org>,
	"linux-decnet-user@lists.sourceforge.net"
	<linux-decnet-user@lists.sourceforge.net>, "linux-wpan@vger.kernel.org"
	<linux-wpan@vger.kernel.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "mptcp@lists.01.org" <mptcp@lists.01.org>,
	"lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
	"rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
	"linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
	"tipc-discussion@lists.sourceforge.net"
	<tipc-discussion@lists.sourceforge.net>, "linux-x25@vger.kernel.org"
	<linux-x25@vger.kernel.org>, Kernel Hardening
	<kernel-hardening@lists.openwall.com>
Subject: RE: [PATCH 12/26] netfilter: switch nf_setsockopt to sockptr_t
Thread-Topic: [PATCH 12/26] netfilter: switch nf_setsockopt to sockptr_t
Thread-Index: AQHWZDJbUYsuJ1QOc0ujZBN9RDfEqKkcofVA
Date: Tue, 28 Jul 2020 08:07:11 +0000
Message-ID: <908ed73081cc42d58a5b01e0c97dbe47@AcuMS.aculab.com>
References: <20200723060908.50081-1-hch@lst.de>
 <20200723060908.50081-13-hch@lst.de> <20200727150310.GA1632472@zx2c4.com>
 <20200727150601.GA3447@lst.de>
 <CAHmME9ric=chLJayn7Erve7WBa+qCKn-+Gjri=zqydoY6623aA@mail.gmail.com>
 <20200727162357.GA8022@lst.de>
In-Reply-To: <20200727162357.GA8022@lst.de>
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

From: Christoph Hellwig
> Sent: 27 July 2020 17:24
>=20
> On Mon, Jul 27, 2020 at 06:16:32PM +0200, Jason A. Donenfeld wrote:
> > Maybe sockptr_advance should have some safety checks and sometimes
> > return -EFAULT? Or you should always use the implementation where
> > being a kernel address is an explicit bit of sockptr_t, rather than
> > being implicit?
>=20
> I already have a patch to use access_ok to check the whole range in
> init_user_sockptr.

That doesn't make (much) difference to the code paths that ignore
the user-supplied length.
OTOH doing the user/kernel check on the base address (not an
incremented one) means that the correct copy function is always
selected.

Perhaps the functions should all be passed a 'const sockptr_t'.
The typedef could be made 'const' - requiring non-const items
explicitly use the union/struct itself.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

