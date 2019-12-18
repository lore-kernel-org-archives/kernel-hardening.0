Return-Path: <SRS0=LSxs=2I=lists.openwall.com=kernel-hardening-return-17508-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39112C43603
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Dec 2019 16:36:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8962A218AC
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Dec 2019 16:36:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eFouNkPT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8962A218AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17508-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9714 invoked by uid 550); 18 Dec 2019 16:35:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9694 invoked from network); 18 Dec 2019 16:35:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FMqMKRVCOcjZgE/EV3cPuX6L8AH27Rm+Sh8f62ETxcQ=;
        b=eFouNkPT+BVqLskLEk9g7X/YCueGVws1Y4L7OAdK67iYfuw5Q3JA28QRS8d/LWFrDG
         1PI0GaIys/kiZnyYwXJr83Bv5EsUHu3bADQCvrKc+yqTejvNWp7QIJtShLaEEWXU6HZS
         gtG2/bpkanXeXAJmHX5+l8j7bSOHLYl8HcMu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FMqMKRVCOcjZgE/EV3cPuX6L8AH27Rm+Sh8f62ETxcQ=;
        b=aeszpU/S+VlPktv6LSghnU/2qwJoiAK+65D9ONA9jgNXHqdEXFBN17gLdAqQhymxNm
         HuQc61puRRZXYk+XysHH8Uvu5ZeuuXd1kSVaOUIrKLFtq24eUdvgJFZ/9QDoqLWZjRvI
         uT9PzKB/4553KL5Xg1aA4ywRvy/gpX5DnlOrDzq/LT02iLkkcRaiXG5aoRP3SJ51MUf5
         1gUAO0z0vuHwfMPpGuf/Z+iweoaQ4Q9dPAkbWgAE0KuP+NB3T1Uylr45jjM1C74fRQsZ
         64llPtmGkLgIMDOMb0hF22vPwQnlJOhOtYleEkeIR6upIuzJSx9N7wi3RUtsmWt+rreg
         2eAA==
X-Gm-Message-State: APjAAAURBL5SqtacUVDgjt5U9cmed9nsGd/iF8NtbSobOC8Hj4tOy5fw
	BhSZvReg7qH2PTHvTgWzxhFOoOLOUDc=
X-Google-Smtp-Source: APXvYqy+KdR8saN5m9imbt4YdgpOsWFRnCH8gvpOg/hdmdpuZSzVbimNrhZw1ScJ0PQITi9ZWahTSQ==
X-Received: by 2002:a50:b876:: with SMTP id k51mr3455723ede.4.1576686945730;
        Wed, 18 Dec 2019 08:35:45 -0800 (PST)
X-Received: by 2002:a5d:51cc:: with SMTP id n12mr3908491wrv.177.1576686943371;
 Wed, 18 Dec 2019 08:35:43 -0800 (PST)
MIME-Version: 1.0
References: <20191205000957.112719-1-thgarnie@chromium.org>
 <20191205000957.112719-2-thgarnie@chromium.org> <20191218124604.GE24886@zn.tnic>
In-Reply-To: <20191218124604.GE24886@zn.tnic>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Wed, 18 Dec 2019 08:35:32 -0800
X-Gmail-Original-Message-ID: <CAJcbSZE56E_JqWpxvpHd194SAVn0fGJRiJWmLy=zfOyTthsGCg@mail.gmail.com>
Message-ID: <CAJcbSZE56E_JqWpxvpHd194SAVn0fGJRiJWmLy=zfOyTthsGCg@mail.gmail.com>
Subject: Re: [PATCH v10 01/11] x86/crypto: Adapt assembly for PIE support
To: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 18, 2019 at 4:46 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Dec 04, 2019 at 04:09:38PM -0800, Thomas Garnier wrote:
> > Change the assembly code to use only relative references of symbols for the
> > kernel to be PIE compatible.
> >
> > Position Independent Executable (PIE) support will allow to extend the
> > KASLR randomization range below 0xffffffff80000000.
>
> FFS, how many times do we have to talk about this auto-sprinkled
> sentence?!
>
> https://lkml.kernel.org/r/20190805163202.GD18785@zn.tnic

In the last discussion, we mentioned Ingo (and other people) asked us
to include more information for context. I don't care about having it
or not, just want to ensure people understand why the change is made.

>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
