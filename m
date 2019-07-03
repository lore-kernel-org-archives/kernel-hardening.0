Return-Path: <SRS0=kPkg=VA=lists.openwall.com=kernel-hardening-return-16342-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86359C0650E
	for <kernel-hardening@archiver.kernel.org>; Wed,  3 Jul 2019 15:49:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CB4402187F
	for <kernel-hardening@archiver.kernel.org>; Wed,  3 Jul 2019 15:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P9WBRTNl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB4402187F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16342-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1739 invoked by uid 550); 3 Jul 2019 15:49:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1698 invoked from network); 3 Jul 2019 15:49:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5PW5tSICHWBHsnLdH++fjGMWMp6j+jnYd1/G/gq0JGg=;
        b=P9WBRTNl2y0nxtPwLrjMFCJ7erj70n9REPPqZ41/eudlFiCscDXFpdAOWOajgmTXkU
         c0x91/2fKax0AZXi0YUtEynLtUyDFtrjrFA+b3UK9s4/+Mp31TmlvTJ+JmCZ0gIgKKNZ
         j5kisrUtFCFYgXEHM8bLuSUW8GSRY1xbL92UQKRXbsMU83uuClAN7WWo8P3Z55wanmj4
         qsjhI8kT9X40016JiadeXjgdm3MHuTcwlrAANa7lAi/SH0dcqvHjPAk6SmtYzNP/2JAs
         thPnBaCzEqLfV04hDgxbRTnb9mJL4BhVJ1oMi7uu0gZSxXx4B3t0vjyUVvUuInVqcnlG
         oVtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5PW5tSICHWBHsnLdH++fjGMWMp6j+jnYd1/G/gq0JGg=;
        b=CQ0KFRZ60JhB1B8QoAphWleIO55N4lnDl6AWCiXvgUSjKBkW0jc1Syc3g63GGgw4h/
         MQVK/NVZaYsJyxKa5yfjeghqA5bJ1s7OTP96JBn6UEE7dASP+D1/xkGx26eXs069lzZq
         MDrt4gfpEv1f6/p6cJGngTPRx3sOE5foCStkTX3DuOgwi6De64KMUs36CLPh69vQfePn
         QM917Fpdx3l0tAWan2YUIuOz55S0gHEfyD/Eb9NAI55DYZbhBUJsrQDEfiOwhoMtp+Fo
         vfMqJJwvhOLxYzUQlmLL4/PKbSmdybX0DQF9qn7MdXH9KyDDXYLIYty/VgMtmLxoWdAY
         vjyg==
X-Gm-Message-State: APjAAAVpQ4bPNiKecCaYeumFkXXTSJq/SH8/w1n36N091cpZiogv5Av/
	btD7ZhLmZWUbuKPGqwLgceTmQPHgVbkltM9M5Ts=
X-Google-Smtp-Source: APXvYqzT1v5cdepKGJr/p+yUrKZB8ro9ykdMDprOOZqWH/5F/Q2I6Ef3ici1mOw+8xDHaNBMJIFgKuVnej5aTv6Hu8I=
X-Received: by 2002:a17:90a:2190:: with SMTP id q16mr13174390pjc.23.1562168933403;
 Wed, 03 Jul 2019 08:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <CABgxDoJzu-Pfq78AYJmf61KqJ2A3YXNJ7jMSS6p3kCzhFox0=w@mail.gmail.com>
 <201907020849.FB210CA@keescook>
In-Reply-To: <201907020849.FB210CA@keescook>
From: Romain Perier <romain.perier@gmail.com>
Date: Wed, 3 Jul 2019 17:48:42 +0200
Message-ID: <CABgxDoJ6ra4DoPzEk8w25e0iTSHtNuYanHT-s+30JSzjfWestQ@mail.gmail.com>
Subject: Re: refactor tasklets to avoid unsigned long argument
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Shyam Saini <mayhs11saini@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It Looks interesting :)

Mhhh, so If I understand it right, the purpose of this task is to
remove the "unsigned long data"  argument passed to tasklet_init() ,
that
is mostly used to pass the pointer of the parent structure that
contains the tasklet_struct to the handler.

We don't change the API of tasklet, we simply remove the code that use
this "unsigned long data" wrongly to pass the pointer of the parent
structure
(by using container_of() or something equivalent).

For example this is the case in:   drivers/firewire/ohci.c   or
drivers/s390/block/dasd.c  .

Several question come:

1. I am not sure but, do we need to modify the prototype of
tasklet_init() ?  well, this "unsigned long data" might be use for
something else that pass the pointer of the parent struct. So I would
say "no"


2. In term of security, this is a problem ? Or this is just an
improvement to force developpers to do things correctly ?

I will update the WIKI

Thanks,
Regards,
Romain




Le mar. 2 juil. 2019 =C3=A0 23:04, Kees Cook <keescook@chromium.org> a =C3=
=A9crit :
>
> On Tue, Jul 02, 2019 at 09:35:17AM +0200, Romain Perier wrote:
> > I would be interested by this task (so I will mark it as "WIP" on the
> > wiki). I just need context :)
>
> Sounds good!
>
> This task is similar to the struct timer_list refactoring. Instead of
> passing an arbitrary "unsigned long" argument, it's better that the
> "parent" structure that holds the tasklet should be found using
> container_of(), and the argument should be the tasklet itself.
>
> Let me know if you need more detail on what that should look like! (And
> as always, double-check the sanity of this work: perhaps the refactoring
> creates more problems than it solves? Part of this work item is
> evaluating the work itself.)
>
> Thanks!
>
> --
> Kees Cook
