Return-Path: <SRS0=VImw=WE=lists.openwall.com=kernel-hardening-return-16760-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13900C433FF
	for <kernel-hardening@archiver.kernel.org>; Thu,  8 Aug 2019 21:03:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5CC972173E
	for <kernel-hardening@archiver.kernel.org>; Thu,  8 Aug 2019 21:03:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dtjvpRdo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CC972173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16760-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17638 invoked by uid 550); 8 Aug 2019 21:03:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17580 invoked from network); 8 Aug 2019 21:03:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=u7I3DJPXIYVWIdKzNbWAianRUQ1VpcH16ru2Cgl5KxU=;
        b=dtjvpRdov2jUJ9OXN1nFxfqdLgQ67Df6yhlpZ0lGq/TnL/p8xJYaFcDFX6FylRLDE5
         gg+AfTbHjf15SnbuElB+C+PzV9FL/umUsEpANBn58np+2vEsmGS3no+/bezZUzmBVbf5
         i6Z6bkukCu3llsBisvjaqLjdWmyxmZDztlGNE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=u7I3DJPXIYVWIdKzNbWAianRUQ1VpcH16ru2Cgl5KxU=;
        b=udp3GZ7O7+w8E+M528ArYfUOs9aPwx+Eb5DeMctA5ncZsZT0F6mzodbjuBW65rdOz+
         tjf38mrWHcPbrJhQnIRgJEqwU3EoU9o0tyNLONLGQgLPUy8lER3oadBhYkJkGw0ei0JG
         cKn/FnPpmvlgYY1fbBleXkQnOzUpXxtLXWwnWnqOj7PiwMgZkYz5j9ACpDT6QFniePef
         Aa2B8KtWeUH77pjyhikjPwz1LWNBlsp9v3DE/s4O+R/OnipAVDWW2yBv9kzpcGiEb8RE
         ASTfEjWyXyYXfqMUl/yKN5IZgcm5wQLD/UqsXTwKeSvBfhk8g2GYD/YTTNBkjTNoMdwH
         rXPw==
X-Gm-Message-State: APjAAAVoXUyimZQmbNOY8RLqVW8vWbWuQOKMRU1zC45/9qYu59fgrnFG
	kYTC6paKUeeJY0omOHIVHslFtg==
X-Google-Smtp-Source: APXvYqzcDOL+qDu7pSUFRs+hpNilfPfvgL1m8mIXWTPshgMpOLdcoA/6R27WC6TEeS3hXEoIxqgcUg==
X-Received: by 2002:a63:cb4f:: with SMTP id m15mr14358429pgi.100.1565298174689;
        Thu, 08 Aug 2019 14:02:54 -0700 (PDT)
Date: Thu, 8 Aug 2019 14:02:52 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: refactor tasklets to avoid unsigned long argument
Message-ID: <201908081344.B616EB365F@keescook>
References: <CABgxDoJzu-Pfq78AYJmf61KqJ2A3YXNJ7jMSS6p3kCzhFox0=w@mail.gmail.com>
 <201907020849.FB210CA@keescook>
 <CABgxDoJ6ra4DoPzEk8w25e0iTSHtNuYanHT-s+30JSzjfWestQ@mail.gmail.com>
 <201907031513.8E342FF@keescook>
 <CABgxDoLz76_nTqpdqMMH6+i1ia3k2bgiHkTV4Gc9X7vCe=CKRA@mail.gmail.com>
 <201907221017.F61AFC08E@keescook>
 <CABgxDo+FSk0Tkvu=uFd5tjd+6TnnkwxwrP1a0QLBSkhhJ4CqUw@mail.gmail.com>
 <CABgxDo+ys-84ifkAMQp2Snv2PV4yTEYwi+3Jj9aGARn0hbhuWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgxDo+ys-84ifkAMQp2Snv2PV4yTEYwi+3Jj9aGARn0hbhuWQ@mail.gmail.com>

On Thu, Aug 08, 2019 at 05:47:29PM +0200, Romain Perier wrote:
> Le mar. 23 juil. 2019 à 10:15, Romain Perier <romain.perier@gmail.com> a écrit :
> >
> > Le lun. 22 juil. 2019 à 19:19, Kees Cook <keescook@chromium.org> a écrit :
> > >
> > > On Sun, Jul 21, 2019 at 07:55:33PM +0200, Romain Perier wrote:
> > > > Ok, thanks for these explanations.
> > >
> > > (Reminder: please use inline-context email replies instead of
> > > top-posting, this makes threads much easier to read.)
> >
> > Arf, good point. My bad :)
> >
> > >
> > >
> > > Looks good! I wonder if you're able to use Coccinelle to generate the
> > > conversion patch? There appear to be just under 400 callers of
> > > tasklet_init(), which is a lot to type by hand. :)
> >
> > Mmmhhh, I did not thought *at all* to coccinelle for this, good idea.
> > I am gonna to read some docs about the tool
> >
> > >
> > > Also, have you found any other tasklet users that are NOT using
> > > tasklet_init()? The timer_struct conversion had about three ways
> > > to do initialization. :(
> >
> > This is what I was looking before you give me details about the task.
> > It seems, there
> > is only one way to init a tasklet. I have just re-checked, it seems ok.
> 
> Work is in progress (that's an hobby not full time). I am testing the
> build with "allyesconfig".

That's good -- I tend to use allmodconfig (since it sort of tests a
larger set of functions -- the module init code is more complex than the
static init code, IIRC), but I think for this series, you're fine either
way.

> Do you think it is acceptable to change
> drivers/mmc/host/renesas_sdhi_internal_dmac.c  to add a pointer to the
> "struct device" or to the "host", so
> renesas_sdhi_internal_dmac_complete_tasklet_fn() could access "host"
> from the tasklet parameter
> because currently, it is not possible.
> from the tasklet you can access "dma_priv", from "dma_priv" you can
> access "priv", then from "priv", you're blocked :)
> 
> 
> This is what I have done for now  :
> https://salsa.debian.org/rperier-guest/linux-tree/commit/a0e5735129b4118a1df55b02fead6fa9b7996520
>    (separately)
> 
> Then the handler would be something like:
> https://salsa.debian.org/rperier-guest/linux-tree/commit/5fe1eaeb45060a7df10d166cc96e0bdcf0024368
>   (scroll down to renesas_sdhi_internal_dmac_complete_tasklet_fn() ).

I did things like this in a few cases for timer_struct, yes. The only
question I have is if "struct device" is what you want or "struct
platform_device" is what you want?

+	priv->dev = &pdev->dev;

You're already dereferencing "pdev" to get "dev", and then:

+	struct platform_device *pdev = container_of(priv->dev, typeof(*pdev), dev);

What you really want is the pdev anyway in the handler. Maybe just store
that instead?

Also, I think you can avoid the "dma_priv" variable with a from_tasklet()
that uses dma_priv.dma_complete. Something like:

struct renesas_sdhi *priv = from_tasklet(priv, t, dma_priv.dma_complete);

The only other gotcha to check is if it's ever possible for the pointer
you're storing to change through some other means, which would cause you
to be doing a use-after-free in this handler? (I assume not, since dma
completion is tied to the device...)

-- 
Kees Cook
