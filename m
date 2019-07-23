Return-Path: <SRS0=ibCm=VU=lists.openwall.com=kernel-hardening-return-16549-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2ECC7618E
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 08:16:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7CB9E20449
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 08:16:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ls9/AmmP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CB9E20449
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16549-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18326 invoked by uid 550); 23 Jul 2019 08:16:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18289 invoked from network); 23 Jul 2019 08:16:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ffVv24zh2a5eBoGQmBcwJdGHyZNx5+n0FhQ8ExH3Mik=;
        b=Ls9/AmmPNhmQFCDuoWz7YsQJP61VYIMqkstucfy7/7TTc/c7E3ufqbWeOb0qoaAmmU
         5QxI6GdaE54iw2vT0UZAhXFGdmqMz4RjoQn1m84PaHiI10I9daTSSgcz75YE9l81nGue
         uQORHT28te3C5QIksJ04NTzSGewjNgimlQgIvPai95jRmmpWr+l/sBf/ZXpE3lJ26cL/
         LTXDj9ylTWKyv81/Pe7LsYowL1rYMgFgjCsvmT2HBuWATQULrsyPCu/1ZdOJsUbdYwh+
         1UseUOIyoUpj7okaXWh/dzgFQMtVdSeEuUHx+AJOyOL45LZcrGRKf+ArDUQxansCmlXe
         z88g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ffVv24zh2a5eBoGQmBcwJdGHyZNx5+n0FhQ8ExH3Mik=;
        b=QohrljFHJ7ZsmzNKeZijAdNElgip2pJmzXL1VhGqTkuyPhCsYNAwBnhNu9RHg/V9RZ
         cKRM+CwPVKxuVMu1K98XczUlKkyqWlmN50qrveUARALUU5qLKpqb70PNbE0MVtCevHT3
         ZN/hl+kfTj/IjIfcNomlIZTyGod7cIPiNVkX9YmV1xO+RKe6k3L/TNmDR2w/d4dQb6/w
         NPqld5Eul0OxpUjy3ktWwZRzJFjq6QmGi8B+zLvCP8IpiEAzcuj+kraHU5XlKnTIeG8a
         VhoZ87axLtXxNZ0nIM4d+Ez636/QQGXz/90hwsw0MKaQ0S8yf67tqlPuSNjwQyVPPx15
         iwew==
X-Gm-Message-State: APjAAAVIhTx1NqxsTK5dft+rxKE1V4+f8GaOYMk8JbqQ7Q1++47cRlHh
	lkn2qoRfUls4cCnmwceF7/FqXvqSIrJO1OzRbf0=
X-Google-Smtp-Source: APXvYqy81zZSaLILK4pURceToIiDh/HBST/kS9edwGl+85tZQVDFxsbYvbwDyO0ybZLaAHBf1Z3e4NkANsyXDysW8L0=
X-Received: by 2002:a17:902:e287:: with SMTP id cf7mr78597295plb.32.1563869761999;
 Tue, 23 Jul 2019 01:16:01 -0700 (PDT)
MIME-Version: 1.0
References: <CABgxDoJzu-Pfq78AYJmf61KqJ2A3YXNJ7jMSS6p3kCzhFox0=w@mail.gmail.com>
 <201907020849.FB210CA@keescook> <CABgxDoJ6ra4DoPzEk8w25e0iTSHtNuYanHT-s+30JSzjfWestQ@mail.gmail.com>
 <201907031513.8E342FF@keescook> <CABgxDoLz76_nTqpdqMMH6+i1ia3k2bgiHkTV4Gc9X7vCe=CKRA@mail.gmail.com>
 <201907221017.F61AFC08E@keescook>
In-Reply-To: <201907221017.F61AFC08E@keescook>
From: Romain Perier <romain.perier@gmail.com>
Date: Tue, 23 Jul 2019 10:15:50 +0200
Message-ID: <CABgxDo+FSk0Tkvu=uFd5tjd+6TnnkwxwrP1a0QLBSkhhJ4CqUw@mail.gmail.com>
Subject: Re: refactor tasklets to avoid unsigned long argument
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Shyam Saini <mayhs11saini@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lun. 22 juil. 2019 =C3=A0 19:19, Kees Cook <keescook@chromium.org> a =C3=
=A9crit :
>
> On Sun, Jul 21, 2019 at 07:55:33PM +0200, Romain Perier wrote:
> > Ok, thanks for these explanations.
>
> (Reminder: please use inline-context email replies instead of
> top-posting, this makes threads much easier to read.)

Arf, good point. My bad :)

>
>
> Looks good! I wonder if you're able to use Coccinelle to generate the
> conversion patch? There appear to be just under 400 callers of
> tasklet_init(), which is a lot to type by hand. :)

Mmmhhh, I did not thought *at all* to coccinelle for this, good idea.
I am gonna to read some docs about the tool

>
> Also, have you found any other tasklet users that are NOT using
> tasklet_init()? The timer_struct conversion had about three ways
> to do initialization. :(

This is what I was looking before you give me details about the task.
It seems, there
is only one way to init a tasklet. I have just re-checked, it seems ok.

Thanks for your feedbacks,
Regards,
Romain
