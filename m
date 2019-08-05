Return-Path: <SRS0=OS/9=WB=lists.openwall.com=kernel-hardening-return-16715-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E923C0650F
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Aug 2019 17:54:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A01C920B1F
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Aug 2019 17:54:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XfOUnVg5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A01C920B1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16715-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15945 invoked by uid 550); 5 Aug 2019 17:54:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15924 invoked from network); 5 Aug 2019 17:54:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EZ8m1iqTznWb8vi5XPTFdc0ZbQusxg4ERCrVoyD9ISg=;
        b=XfOUnVg5KOyMkHHbMLHfSyWW3eShErC1ZO7KaeuVE4c54XbH0wRE4McEEJQN83CJv7
         vlEx46cX8pvZJ4EDx1NikoDX7WrjLnpOIy7MO2/56Otw5kV7wyI3yDsbvoN3ZpT5D/O6
         ANPGCeMkcoH/YNWa/o+tvNrJPHEu96Dp3rLi8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EZ8m1iqTznWb8vi5XPTFdc0ZbQusxg4ERCrVoyD9ISg=;
        b=nbG26vHJwLQC3XEAHoBVH8xRilL3sBe0qQeAft7eQ03saZWVChMpCHxmi+WhLsLtil
         bq98QdRFr3bNppvGtlkaksGm2UH24D2u+tarmLYymWZwMh2q7Tg9GmyT0Sp5IQsKF/4o
         00u2O9TJOrUGbcrt+wHFese+Jbwepmq305qtyezIHKhGqQX2JMMbY/IWOp/G9TbvdERt
         dxNyyZQtjGf7y7HlbuoKhTcyp/vJ89X4Y7B6YaNstjY2ioVENwNOu5+KZTK0mtmaZy6I
         HA8U7STKoCxlrA8y2mnhb2PunfBGQ8fp5BpoODZdCX3UsHOw9oqzxiSbPXfOnPRfZqXg
         pxRw==
X-Gm-Message-State: APjAAAXOyu0llyr1U0mpbvzFHji+ETSKWQaDyn6MSU3OeDoYNvP70Ha3
	j3QfzDV/pApg+Pl4o6xgoMRaehfEnqA=
X-Google-Smtp-Source: APXvYqxuZxOOVIGa5kPaQasb/GT20u/TVH5gnLM64x/mJCsTztZZVqe0xdpk1fPLCTouXAJMg9LoQg==
X-Received: by 2002:a50:b13b:: with SMTP id k56mr138876256edd.192.1565027634066;
        Mon, 05 Aug 2019 10:53:54 -0700 (PDT)
X-Received: by 2002:a1c:7c11:: with SMTP id x17mr18318882wmc.22.1565027633048;
 Mon, 05 Aug 2019 10:53:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-2-thgarnie@chromium.org> <20190805163202.GD18785@zn.tnic>
 <201908050952.BC1F7C3@keescook> <20190805172733.GE18785@zn.tnic>
In-Reply-To: <20190805172733.GE18785@zn.tnic>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Mon, 5 Aug 2019 10:53:41 -0700
X-Gmail-Original-Message-ID: <CAJcbSZEnPeCnkpc+uHmBWRJeaaw4TPy9HPkSGeriDb6mN6HR1g@mail.gmail.com>
Message-ID: <CAJcbSZEnPeCnkpc+uHmBWRJeaaw4TPy9HPkSGeriDb6mN6HR1g@mail.gmail.com>
Subject: Re: [PATCH v9 01/11] x86/crypto: Adapt assembly for PIE support
To: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, "the arch/x86 maintainers" <x86@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 5, 2019 at 10:27 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Mon, Aug 05, 2019 at 09:54:44AM -0700, Kees Cook wrote:
> > I think there was some long-ago feedback from someone (Ingo?) about
> > giving context for the patch so looking at one individually would let
> > someone know that it was part of a larger series.

That's correct.

>
> Strange. But then we'd have to "mark" all patches which belong to a
> larger series this way, no? And we don't do that...
>
> > Do you think it should just be dropped in each patch?
>
> I think reading it once is enough. If the change alone in some commit
> message is not clear why it is being done - to support PIE - then sure,
> by all means. But slapping it everywhere...

I assume the last sentence could be removed in most cases.

>
> --
> Regards/Gruss,
>     Boris.
>
> Good mailing practices for 400: avoid top-posting and trim the reply.
