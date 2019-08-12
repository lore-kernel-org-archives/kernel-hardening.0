Return-Path: <SRS0=h+Jn=WI=lists.openwall.com=kernel-hardening-return-16781-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FADC433FF
	for <kernel-hardening@archiver.kernel.org>; Mon, 12 Aug 2019 11:43:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7778320684
	for <kernel-hardening@archiver.kernel.org>; Mon, 12 Aug 2019 11:43:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="T5n47MKc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7778320684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=web.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16781-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17751 invoked by uid 550); 12 Aug 2019 11:43:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20217 invoked from network); 12 Aug 2019 10:01:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
	s=dbaedf251592; t=1565604060;
	bh=cIbV8TNZ6P1Oot98inSuptsBLdkK9s4ARR+DiDfLzpQ=;
	h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
	b=T5n47MKcmeq89PMqZ1noAOLndZTyEhCWlxz+0oJRsK4SDAq998e5jF/AVhQAPe5l5
	 b/5Jl8gtiSIhJz0OIyZr1/gm9wormy9b1+LkmzbRVwJcHFAlsT4TaIKa4YPylzA9j8
	 3P0h0ZiSBQACu/6rdgl3m+ac1M/cB1tNQNOipExo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
To: Alexander Popov <alex.popov@linux.com>, Jann Horn <jannh@google.com>,
 Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
 cocci@systeme.lip6.fr
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>,
 Denis Efremov <efremov@linux.com>, Gilles Muller <Gilles.Muller@lip6.fr>,
 Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jikos@kernel.org>,
 Michal Marek <michal.lkml@markovi.net>, Mukesh Ojha <mojha@codeaurora.org>,
 Nicolas Palix <nicolas.palix@imag.fr>
References: <3ee24295-6d63-6da9-774f-f1a599418685@linux.com>
Subject: Re: floppy: fix usercopy direction
From: Markus Elfring <Markus.Elfring@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <e514a05f-6e9f-1d62-9b38-163e13578bff@web.de>
Date: Mon, 12 Aug 2019 12:00:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3ee24295-6d63-6da9-774f-f1a599418685@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Lq+S+0zUpkv9IKiOBh3L967rFcylnMgd7xdu1zCinFBfeZODjJm
 4NCn3xwdhtvkPmBbetWnwUSK+7Z3qGtDz8uzgTvBXrWshMJRJ68JJuwzn8y8qZ1bRFt/lHA
 cK2zo6skIS4QAMDvHEa+NY45ePPvkz+kn+tNNBAdafp4MwSPdKzfB7u3ynVauhFp0p1345G
 /7IS0cfK93Uj3EntCMH2w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gbMIUPXj9qA=:bvqc9ICAFUMD2Vu28lkK0H
 3qiZrzd2NpQleJ16WGBSlnPe0haEa+PAPWvM7DxVLefN1f95omJtZ+tuygh+tmJcr9gdnXTmq
 F5tjDOHYkhCg962Dc/8iOrwvfAkKmR3m+LXnjA82fEcqUFHHH8GRVq0b0Xxd/5VS+XjISYWaL
 HjupPST4dcFxUGVw0WRwEbVHlRKrVm703lAQrryCNwkgXGbb9iyWH94V6TKs9PpfRHkeixmNl
 ZH2shgphJJRxethZpOFVHycBZ+U0v2ENVzT08iJATuyofSdRnZ4F1X14V65Rs0hrFqnj9T7ez
 B2EvfDdeEPi9AaqCczjeoBxxPbDUGqF7yQQAkg3Ch3CPlHtc3txh2SwGc5KH1eHFqKXgGDIbo
 qtOLdOHpJchY/gqei5fv9BIU9HvOvoeEm7YX/EPLQrOa4tlwE1fZiFQyo7lmMhbZ8bxhlIxy2
 EbzJH7//X8tioPbgErUDFpd7Dq0kmXVaEwNBujNFiVjBdDuijnaMCqCDPCjfXqSiAsj/jbTTV
 YbOWiJ7NLmPmx2eomdPBWN7FX6vdD7hB4T1toSAoFYdvAZ2T7vtqn9IF6iB/or2YA1x0OZXxc
 0JxUa5eFBloHm9yFNIMp814en+NCIkqpOAzfFbc69X436pZfraK8v9wIPxa7uuMxD2oyHnjUK
 pEPD9sBu9U/WUR1ccnA87tLxgbHwTjXOL26Vd9qSMBjQDDvaLlqiHUEDv+g/271sPtDbafjU/
 2fMCqwwwTCK0SluevjvIsvN5b0mQrjG4lSbmGHy+WJubkgrZ84zv2594eQLN/tM+26spqxdq3
 WERKDLVBLOc8DZKsZkL6Jzk/mJ5DVIhcaxU+H6i0RWgIQAJ2LdEcqD/2Ft7ua/DMq1qVL4qV4
 SKvOWc1C3oUrrOsFnjoZe45qfuX8OiW2ZI+j3qzpB32GMGcy55/zQP83+A/U2okFYqgUwbJ9X
 p3qL1ZdDN9L6cb1QxX4SoSq7HJsDDO3m5rz57PrYsvtk+vNDC4aBaNo7kvV5BYNeTjDBDphwt
 6KeAwpNx5+ECkC1pt9OC+f9TbVG+wt8j+4cO5xzkA9JuRzIDDNq7QSfCbrsmmEdSxLVVuRn3E
 LPLAl/qUAQUVYpcbU6gzrfmMAtCrfgChCe2MDbpZ85UGYZzehkcg4t83U2hkiWhtoZFMz/fMj
 sBqmE=

> =E2=80=A6, I see `exists` allows to drop `<+ +>`, right?

I would interpret the combination of such SmPL specifications in a differe=
nt way.


> It turned out that sparse already can find these bugs.

This is generally nice, isn't it?


> Is this rule useful anyway?

I hope so.

Can scripts for the semantic patch language help any more?


> If so, I can prepare a patch.

Would you like to take corresponding adjustments into account?

Regards,
Markus
