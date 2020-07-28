Return-Path: <SRS0=bBLk=BH=lists.openwall.com=kernel-hardening-return-19460-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182ABC433E1
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 08:18:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 65E242177B
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 08:18:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nEjdWpcU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65E242177B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zx2c4.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19460-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29795 invoked by uid 550); 28 Jul 2020 08:17:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29760 invoked from network); 28 Jul 2020 08:17:54 -0000
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
	:references:in-reply-to:from:date:message-id:subject:to:cc
	:content-type; s=mail; bh=K4YAt33ilBR3hd1+7JojCPxtvSA=; b=nEjdWp
	cUQVj0KWRd87puFx0fk1HADPVt/5ckkL0vcSiVAoyePGSTncp+KafcroE0itJJAR
	hvCKOHIgNqwby+4I13HG5z9ibnxBmqHfVx+jKtrPfvHTnJrmPNg1WsagEKVyYT8s
	0wLLBcv/NIyWIJ2xwHqa/F7Ekuot/H5qUld6hDSAXP06OIRI6q+V7cdk8Ye2E95N
	oE2iYHJELOZGqN2H10I58K4qjsUNSGzPFklfgHdPIOfnKUBe2eF7SiuhT2DW4gmx
	Zlh/4Lwi80eH4MYYZz1R0kvQtczs/XnszWGNGZW6geww/y9D6tsJ0FqJg7QkrUqh
	r9lHeJJo9aIu1+DA==
X-Gm-Message-State: AOAM5330KUtZBBxWC5LeueETM8gQhT2Pgmp/JWvAugdmh0JO6JG0duJs
	lxNun4/HOKWm4paa9qI5dvSSyBjejRUy48oTNB8=
X-Google-Smtp-Source: ABdhPJwruWEMSl6lI3SS18Iq/8cGmq7nVWSaRamLRaM9jzUJiajMF+UBN6XkUtAb0UlYhZIkk+zlhZ92oa7Pvf4Iz8s=
X-Received: by 2002:a05:6638:250f:: with SMTP id v15mr8210865jat.75.1595924260418;
 Tue, 28 Jul 2020 01:17:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200723060908.50081-1-hch@lst.de> <20200723060908.50081-13-hch@lst.de>
 <20200727150310.GA1632472@zx2c4.com> <20200727150601.GA3447@lst.de>
 <CAHmME9ric=chLJayn7Erve7WBa+qCKn-+Gjri=zqydoY6623aA@mail.gmail.com>
 <20200727162357.GA8022@lst.de> <908ed73081cc42d58a5b01e0c97dbe47@AcuMS.aculab.com>
In-Reply-To: <908ed73081cc42d58a5b01e0c97dbe47@AcuMS.aculab.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 28 Jul 2020 10:17:28 +0200
X-Gmail-Original-Message-ID: <CAHmME9pUbRmJq1Qcj10eENt15cuQHkiXJNKrUDmmC18n2mLKDA@mail.gmail.com>
Message-ID: <CAHmME9pUbRmJq1Qcj10eENt15cuQHkiXJNKrUDmmC18n2mLKDA@mail.gmail.com>
Subject: Re: [PATCH 12/26] netfilter: switch nf_setsockopt to sockptr_t
To: David Laight <David.Laight@aculab.com>
Cc: Christoph Hellwig <hch@lst.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, 
	Eric Dumazet <edumazet@google.com>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Netdev <netdev@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, 
	"coreteam@netfilter.org" <coreteam@netfilter.org>, 
	"linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, 
	"linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>, 
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>, 
	"bridge@lists.linux-foundation.org" <bridge@lists.linux-foundation.org>, 
	"linux-can@vger.kernel.org" <linux-can@vger.kernel.org>, "dccp@vger.kernel.org" <dccp@vger.kernel.org>, 
	"linux-decnet-user@lists.sourceforge.net" <linux-decnet-user@lists.sourceforge.net>, 
	"linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "mptcp@lists.01.org" <mptcp@lists.01.org>, 
	"lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>, 
	"rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>, 
	"linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>, 
	"tipc-discussion@lists.sourceforge.net" <tipc-discussion@lists.sourceforge.net>, 
	"linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 28, 2020 at 10:07 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Christoph Hellwig
> > Sent: 27 July 2020 17:24
> >
> > On Mon, Jul 27, 2020 at 06:16:32PM +0200, Jason A. Donenfeld wrote:
> > > Maybe sockptr_advance should have some safety checks and sometimes
> > > return -EFAULT? Or you should always use the implementation where
> > > being a kernel address is an explicit bit of sockptr_t, rather than
> > > being implicit?
> >
> > I already have a patch to use access_ok to check the whole range in
> > init_user_sockptr.
>
> That doesn't make (much) difference to the code paths that ignore
> the user-supplied length.
> OTOH doing the user/kernel check on the base address (not an
> incremented one) means that the correct copy function is always
> selected.

Right, I had the same reaction in reading this, but actually, his code
gets rid of the sockptr_advance stuff entirely and never mutates, so
even though my point about attacking those pointers was missed, the
code does the better thing now -- checking the base address and never
mutating the pointer. So I think we're good.

>
> Perhaps the functions should all be passed a 'const sockptr_t'.
> The typedef could be made 'const' - requiring non-const items
> explicitly use the union/struct itself.

I was thinking the same, but just by making the pointers inside the
struct const. However, making the whole struct const via the typedef
is a much better idea. That'd probably require changing the signature
of init_user_sockptr a bit, which would be fine, but indeed I think
this would be a very positive change.

Jason
