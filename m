Return-Path: <SRS0=ePz0=BW=lists.openwall.com=kernel-hardening-return-19608-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDC6C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Aug 2020 11:33:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BD52D207DA
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Aug 2020 11:33:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="svUM0Ptl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD52D207DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19608-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6016 invoked by uid 550); 12 Aug 2020 11:33:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5984 invoked from network); 12 Aug 2020 11:33:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Em9Sp8XmzIpv/p2/XIEVSGX1+QelGDXMy8mBEoKzQGA=;
        b=svUM0PtlSc/BsJ398hEypGo/dtDceKxpkxJL2XapJiufbso1e8LfFI4bXYobnoySJa
         SRjvv9f/48b5GJPA7fHwECXPGN7eO/ub5qQngsk3EUO83vMzAXxkqcbbp5j1xemvZIq9
         s5mftpWisvt6SbOmNG3lr1AFiu06MFhrdLN47I42cpfWHFnGFPC0kmoM7pnxUZpSyLQj
         +N4Js6sN6aumylIuGGMt2QsXP+hkf1Ol4GBV8Uuo8S00kvpt2DD1ugHsd9sXoZ13vg/2
         3wLqiAgbMsq3tbjK6M6brM8AX2Uig0dYIzJF4KNHkRmKijkDxBWgQ34F0o2mtUai8o4g
         hCHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Em9Sp8XmzIpv/p2/XIEVSGX1+QelGDXMy8mBEoKzQGA=;
        b=jyTOZycpk45tio/a6EnwJJagxcPfhpRt9bQ2ARY2N9SLfa1t+gY+0bPaDtgNPV3TEU
         k85fdt1S4W3q3tceXan7lEXPeQNxWZHhzyORuMTbJnAZtKmMNpi9aHzEZ77Oh6Iqf2vz
         QGBSomT8SHf4d5G+auG6Bg95qIb9I8ccAxJSMZTCVWz9+/eR4uCHO0EDCVqW+0RfxNWY
         HJOtYPwzKs1k+L61icw1+f7vVXQa7OynrPxWjHjsX3nmy0VHNC2BpQtESl31yCpiU09q
         F7NGUahOXqRp1aeQe31kkdWjsAp9Swsv2mCdD2rK7zLkQ8CPmr9Qlha+FaoWtQj64nR4
         Or1w==
X-Gm-Message-State: AOAM532Nrffzi30yYiHgLyvM2AcCLx1+ZaJIr7OMivVh/NeUZUd+Xd+I
	jRZl+8BZZX2A/gTwLQ2dvvHDvPUdw7k6oNqgNds=
X-Google-Smtp-Source: ABdhPJyApW1cAsqfCZE8viTLCHhX3eA/ksSTGjILeL6+zxKJ5TOuIeeZt8iyPAiUApQEScansB5N2ki5ANp9kIXSCiU=
X-Received: by 2002:a9d:128c:: with SMTP id g12mr8585420otg.242.1597231982871;
 Wed, 12 Aug 2020 04:33:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200716030847.1564131-1-keescook@chromium.org>
 <87h7tpa3hg.fsf@nanos.tec.linutronix.de> <202007301113.45D24C9D@keescook>
 <CAOMdWSJQKHAWY1P297b9koOLd8sVtezEYEyWGtymN1YeY27M6A@mail.gmail.com>
 <202008111427.D00FCCF@keescook> <s5hpn7wz8o6.wl-tiwai@suse.de>
In-Reply-To: <s5hpn7wz8o6.wl-tiwai@suse.de>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 12 Aug 2020 17:02:50 +0530
Message-ID: <CAOMdWS+FJm0NZfbj+yyShX2edX6_9w5K+rA+_u+Z6-rrjcwucg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Modernize tasklet callback API
To: Takashi Iwai <tiwai@suse.de>
Cc: Kees Cook <keescook@chromium.org>, devel@driverdev.osuosl.org, 
	linux-s390@vger.kernel.org, alsa-devel@alsa-project.org, 
	Oscar Carter <oscar.carter@gmx.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-input@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net, 
	Thomas Gleixner <tglx@linutronix.de>, Romain Perier <romain.perier@gmail.com>, 
	Will Deacon <will@kernel.org>, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"

>
> I have a patch set to convert the remaining tasklet usage in sound
> drivers to either the threaded IRQ or the work, but it wasn't
> submitted / merged for 5.8 due to the obvious conflict with your API
> changes.
> Each conversion is rather simple, but it's always a question of the
> nature of each tasklet usage which alternative is the best fit.
>
> FWIW, the current version is found in test/kill-tasklet branch of
> sound git tree
>   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git

Great. Currently my tree has these converted to use the new
tasklet_setup() api. I will add these to my threaded IRQ/work tree
(which is still wip).

Thanks.


-- 
       - Allen
