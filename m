Return-Path: <SRS0=gfoD=BW=lists.openwall.com=kernel-hardening-return-19609-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF5E9C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Aug 2020 12:32:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0AB6F207F7
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Aug 2020 12:32:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YkqGfxOv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AB6F207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19609-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31871 invoked by uid 550); 12 Aug 2020 12:32:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31837 invoked from network); 12 Aug 2020 12:32:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rVoACvL3vbhn7Hy+rg7NvJC/rRz4OGAEG/IOuYVfJLk=;
        b=YkqGfxOvN96eGolDSvt0iCWOvbZZeKLlCAGi8BAH/XmoiSQNEa5synSoNNTH3X5sLJ
         J0XSC09qP/ds7a/R4Q0SSHomSPcp0o15AVV2+lMvLnTd0vBV6RrhGJjKX/x/0SkqiKwV
         0A06fOqNelj9etWPOTYb+YgdV2enu7Fu10STP5iSBmXYnoCAcjjN9WoirJjjmeTuYc3n
         nbzkPOmaEZpF2jhtGMP8FxV8952FOiOMh2n1AUuK375GNKqppbaAbdxZ1DWWt48ETdQL
         u7QVCoEWkBLGQ3/N4TpSYorKV9FXu36SK0GdrESPraE01ZXd8Fjq2XFQXHvDOrZrjyq5
         8LeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rVoACvL3vbhn7Hy+rg7NvJC/rRz4OGAEG/IOuYVfJLk=;
        b=swgdMSvm/PjgIgv1l9X3WoqdNO1P2sl85dRlLLrO/ut7hwg8RJWgq4aiIis+gguXIt
         XevXfQ3dneWcKuGXrZAwh+I9U66LN5CIrCtkco7CzJ76O3+wNH9pHgZbKKvJ4IkQFrZb
         QGYvMLVvLRVXt9/XjWhTfUM+suT6/NWowMPShCltH2b5lQDXASC2I1i6Q6Wn4faKlCZ5
         all4KgkvLt8dcoQ3wwlAGhMfq196j+Dt8o0fa+WiHx5ju4HFSiPkQbT54S+eNDcTD8+9
         uFXPDkbfIk/olZeBDNc038rO3qwOhuftfACMHjRyA7fqzvFMrxmORajKWlWVCpVKphgK
         cgXA==
X-Gm-Message-State: AOAM531TYFv9+rKvlCy7Qwi1IdryWsWkgdYJVpvtBFkVzajCm1EYJ7iT
	WUL7gUTmH0Rz7RhqUKCiKKywhRFpoSpXkE1Y5Go=
X-Google-Smtp-Source: ABdhPJypHP+8lAnojHqsj+HMjv2Kx5qQD1vR1U48FukFJAYIMQIqPx17kRoJyhSS4FcPT0MB5slRlnJYgqYSUKBAAmw=
X-Received: by 2002:a05:6808:4c5:: with SMTP id a5mr7370620oie.175.1597235526662;
 Wed, 12 Aug 2020 05:32:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200716030847.1564131-1-keescook@chromium.org>
 <87h7tpa3hg.fsf@nanos.tec.linutronix.de> <202007301113.45D24C9D@keescook>
 <CAOMdWSJQKHAWY1P297b9koOLd8sVtezEYEyWGtymN1YeY27M6A@mail.gmail.com> <202008111427.D00FCCF@keescook>
In-Reply-To: <202008111427.D00FCCF@keescook>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 12 Aug 2020 18:01:55 +0530
Message-ID: <CAOMdWS+nJr+g1c0Kb99Z=HwQjHtH_-NCC9hW-o6xFs4huGKsqQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Modernize tasklet callback API
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Oscar Carter <oscar.carter@gmx.com>, Romain Perier <romain.perier@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Peter Zijlstra <peterz@infradead.org>, 
	Will Deacon <will@kernel.org>, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, linux-s390@vger.kernel.org, 
	devel@driverdev.osuosl.org, linux-usb@vger.kernel.org, 
	kgdb-bugreport@lists.sourceforge.net, alsa-devel@alsa-project.org, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

Kees,

> Was a Coccinelle script used for any of these conversions? I wonder if
> it'd be easier to do a single treewide patch for the more mechanical
> changes.

No, I should have written one. Will do it.

> And, actually, I still think the "prepare" patches should just be
> collapsed into the actual "covert" patches -- there are only a few.

Okay. It's been done and pushed to:
https://github.com/allenpais/tasklets/tree/V4

> After those, yeah, I think getting these sent to their respective
> maintainers is the next step.

 Please look at the above branch, if it looks fine, let me know
if I can add your ACK on the patches.
>
> Sure! I will add it to the tracker. Here's for the refactoring:
> https://github.com/KSPP/linux/issues/30
>
> and here's for the removal:
> https://github.com/KSPP/linux/issues/94
>
> if you can added details/examples of how they should be removed, that'd
> help other folks too, if they wanted to jump in. :)

Sure, Thank you.

- Allen
