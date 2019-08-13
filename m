Return-Path: <SRS0=WNnY=WJ=lists.openwall.com=kernel-hardening-return-16787-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81D0C433FF
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Aug 2019 17:10:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CCC7220679
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Aug 2019 17:10:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="cZYdEYqH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCC7220679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=web.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16787-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21756 invoked by uid 550); 13 Aug 2019 17:10:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12203 invoked from network); 13 Aug 2019 07:51:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
	s=dbaedf251592; t=1565682664;
	bh=V01gp/w04ZjopqkMSgzFlyhYSrsB6LuFV8+G4mLHDnM=;
	h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
	b=cZYdEYqHUIF71PCyXjlATlwdpEVAZ+vhpWKFUN3b+1zioxjZ2JTPowAMU5ogAjdrS
	 X/4ybfqUvdOTFCRqaX1sXEctegexyQKs3EQAkHedu58dAyEfohsjYux903HT16vMvs
	 H7G2KwusiDZPOLKhh/GAKeMkS2rShZdrZe0kq4Uw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Cc: kernel-hardening@lists.openwall.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 Denis Efremov <efremov@linux.com>, Gilles Muller <Gilles.Muller@lip6.fr>,
 Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
 Jiri Kosina <jikos@kernel.org>, Julia Lawall <julia.lawall@lip6.fr>,
 Michal Marek <michal.lkml@markovi.net>, Mukesh Ojha <mojha@codeaurora.org>,
 Nicolas Palix <nicolas.palix@imag.fr>
References: <9ced7a06-5048-ad1a-3428-c8f943f7469c@linux.com>
Subject: Re: floppy: fix usercopy direction
To: Alexander Popov <alex.popov@linux.com>, cocci@systeme.lip6.fr
From: Markus Elfring <Markus.Elfring@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <6168f58a-891c-1527-93ec-4d3778a59aa2@web.de>
Date: Tue, 13 Aug 2019 09:50:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9ced7a06-5048-ad1a-3428-c8f943f7469c@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:RtvWsN85Lv08lGLSsKH9XvVQOe95drRnwlvrMlEEiFj+RuEg1o5
 J2lEmjxW9l5b2whmTn+59ttXvoYVGYYB4MWL5BdmTdNcEZTOkMlEJfxVWfvf/kurv8RxPOX
 8QiRLdocKPm2lAK7j/XmNZwa8NZ35fkxQaslhD3QUcW7bUWKRm2IPKTrNBg+FWjDU/+xX9+
 fCFV6Vo2r96eStQaa33UA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:94H3yKCCfVM=:gEDyJIzOxmXRU/yY+w5GuA
 kKTyQJk6mvlRnbmDDNJ7fkJo/kvo0ylqFfvqDeIi63Y4bD4xL7Pyfo45iqtWfU9erCuJdor2M
 YuUQjLlpQBgX17kl9e9nAqxmdMpnp9mdCHOV6RPLqIv+2AxEOoN7Fe4m3AZ7kqNAaWPw8SxjX
 J5nvYGcYzOZRlS1S/G2tS4OEgDqByEyvKRdSYb0lnFpSoooEx2R7IZ0bd2ZvKfpnrQY/l0+WA
 0ykfL/EishjZbXewDAk1g7XcJ+S7cjti3WU3KO9vClfmGIuuO43YwstwxCyLJ/m6kPd4RQ3Qz
 Zokm4AwDL7AwPLMIRNPyw8i3u11KJD0p4fJ1ffBuU8hC7liSDPIFjKXlvy27WLUUeikuyHOm+
 8LKwTXc74V+EB33rUG5orGpP2l3aRZoxF1egZo0cnUrH6nRpveiI994BXq8SkiwtPoL712hHv
 wgn6zeC47Aa3fVjZyMhXPyOgqqjTOARPToDA18A35artmEchn32+1wGVZA+N59SonGjFXfKUb
 v6Ziu1ESbhHm5oAv/T9hfCc8ku2uID1fxroVRmJIE/opurxKqwYxPfrHKAMHpo8C8AIl3Uj/I
 zJiBqn4XFBXzga5vhMNe2x+plUUt9klgMCe5Ak/ht2f5fTXh+S+ptnzo3671o/j68e8sdrXAS
 kEx/eE5OQX+1racJxeWJ0VBvIrsrG6tg+hSpvfIGtqaC5fLSQ+LNIV39YiwLK8GMeeNILDZu5
 8xEUiN0hKJ+56YGvg2+fTutaH8SBYJotJjIiK8D26vPSkSBb1Ysw8aS/UKdXZd6uTq+u9UQo1
 DjGJ8N9fJMZftm2H3n3H7AIyaSpndef5+/hbv87XAzxuRv0kj+cPVLZhcntNjCo0xThSDHBxM
 hH9nHA5qpAUNfhLE7p1XYvAHNQL4Xf6viZJStCass4QFt9xpCBbmerhLstnYUb1LrEHQwK3ix
 23cseQoW7AGf9nqgPKvxghWUPw4JIPqXpEwxu2iSQBRwdHQeSff+Tw2/yqxnEd1843BKoms95
 qgmJ/g2vpI6yQJnK5JYgtRG8zA5Vuq8/m6ITeVN5ZROynfkXHkTnuKFS/GVtiwHto2foPyaGC
 v75pCT1eJd0k4R3rvhWrpyso1Hxm5H4weGplm0cxvdOL3Bpo1E02lRODCIYsQDX911latoRCj
 qtJxQ=

> @script:python@
> f << cfu.f;
> t << cfu.t;
> v << cfu.v;
> decl_p << cfu.decl_p;
> copy_p << cfu.copy_p;
> @@
>
> if '__user' in t:

Can this check be specified as a constraint for a metavariable
in the initial SmPL rule?
Would you like to move it to an other place?

Regards,
Markus
