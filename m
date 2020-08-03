Return-Path: <SRS0=ea0p=BN=lists.openwall.com=kernel-hardening-return-19532-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58FD4C433DF
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 08:46:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A881320678
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 08:46:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WpMWmZ08"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A881320678
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19532-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4059 invoked by uid 550); 3 Aug 2020 08:46:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4023 invoked from network); 3 Aug 2020 08:46:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ldpq9lUOsWhKwe/FZyOZtBINOPkrHNfkHnfcPwlRPCU=;
        b=WpMWmZ08n26KnNJ8Kee1MYAG1Jm/zPcTsurcm70Oz6QCv5oFfJJeXvq3VcoC9Bqmp3
         ZwUe+YLsT+FIs/9kGKQtxteKlRXHSSQ+XStDVRPK0FJ9rDWqULujkoduvfNvMAyy0GOg
         NoXxh8OaGSL/tRiXvcDRUH0pjdIKGIrcWXdgMqadI1W4uKjz2xIadtm/umq1TPcJ2dwv
         x921GXZ22H8R3fB7B0gACzntSyHHPZ4Uep08cGKEx1pE00WBaNIlW5skBV0VR9xSPFsw
         +/MQUrW8/mEWr+pwjxhIKc3bVJJhFwBIXZ+8+jfHudxJdG2f4k8YUNGYS662utnJkUBW
         AW1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ldpq9lUOsWhKwe/FZyOZtBINOPkrHNfkHnfcPwlRPCU=;
        b=nuc0DuA3EOcbwAK/dacvra3Fo+vMrzpTlGvz3P52YD8E59DIDZrU7HRAlEFTybzuwn
         NGFncKDMtUxVf/xxSMEisDe2MxOyjmWOhKFtx8d6lsHd4pTqxfsmkms89pB+ihalufYF
         D/VFmki4PUzNvUkoJi4zgTR3vA6YOVlxYvJZqpueq/DVNVxpX/v2JQxI5GgsY72US6RL
         VsK6Lb76ZEmIKPd2P57Yfrv0dRxaBqrBZLCwZf1gIlB8Z8+aYlox5Sun1TjX6yvqlRrc
         CyLgySedEMNO/RoFwnhdy0voJfjuMJo62CFvChNFPqY0RqcYb20J20tMNS+as/F9ILGx
         /BaA==
X-Gm-Message-State: AOAM530htbGAX7vEtBRbD+SLEFEUWXaRN6bPWI1RDrJJXf0wO9BHTXQW
	5/m2oGQmr3HMv72mjn57NCElQZBQZgopdBSRjl0=
X-Google-Smtp-Source: ABdhPJywEIvpuyitAoDTtD0/wC6yQxi+TGZF6FmBDXPPZy9GwNZrNEeGyjiIoXvh3WcLO7UKIwA2uajhqG5WgWac/6c=
X-Received: by 2002:a05:6830:1c65:: with SMTP id s5mr12486238otg.264.1596444390081;
 Mon, 03 Aug 2020 01:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200716030847.1564131-1-keescook@chromium.org>
 <87h7tpa3hg.fsf@nanos.tec.linutronix.de> <202007301113.45D24C9D@keescook>
In-Reply-To: <202007301113.45D24C9D@keescook>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 3 Aug 2020 14:16:15 +0530
Message-ID: <CAOMdWSJQKHAWY1P297b9koOLd8sVtezEYEyWGtymN1YeY27M6A@mail.gmail.com>
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

>
> [heavily trimmed CC list because I think lkml is ignoring this
> thread...]
>
> On Thu, Jul 30, 2020 at 09:03:55AM +0200, Thomas Gleixner wrote:
> > Kees,
> >
> > Kees Cook <keescook@chromium.org> writes:
> > > This is the infrastructure changes to prepare the tasklet API for
> > > conversion to passing the tasklet struct as the callback argument instead
> > > of an arbitrary unsigned long. The first patch details why this is useful
> > > (it's the same rationale as the timer_struct changes from a bit ago:
> > > less abuse during memory corruption attacks, more in line with existing
> > > ways of doing things in the kernel, save a little space in struct,
> > > etc). Notably, the existing tasklet API use is much less messy, so there
> > > is less to clean up.
> > >
> > > It's not clear to me which tree this should go through... Greg since it
> > > starts with a USB clean-up, -tip for timer or interrupt, or if I should
> > > just carry it. I'm open to suggestions, but if I don't hear otherwise,
> > > I'll just carry it.
> > >
> > > My goal is to have this merged for v5.9-rc1 so that during the v5.10
> > > development cycle the new API will be available. The entire tree of
> > > changes is here[1] currently, but to split it up by maintainer the
> > > infrastructure changes need to be landed first.
> > >
> > > Review and Acks appreciated! :)
> >
> > I'd rather see tasklets vanish from the planet completely, but that's
> > going to be a daring feat. So, grudgingly:
>
> Understood! I will update the comments near the tasklet API.
>
> > Acked-by: Thomas Gleixner <tglx@linutronix.de>
>

Here's the series re-based on top of 5.8
https://github.com/allenpais/tasklets/tree/V3

Let me know how you would want these to be reviewed.

Also, I was thinking if removing tasklets completely could be a task
on KSPP wiki. If yes, I did like to take ownership of that task. I have a
couple of ideas in mind, which could be discussed in a separate email.

Thanks.

-- 
       - Allen
