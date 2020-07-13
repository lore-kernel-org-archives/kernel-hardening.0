Return-Path: <SRS0=SJoV=AY=lists.openwall.com=kernel-hardening-return-19297-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591E1C433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Jul 2020 16:27:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AC6D92065E
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Jul 2020 16:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="AnGAsnml"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC6D92065E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19297-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11421 invoked by uid 550); 13 Jul 2020 16:27:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11389 invoked from network); 13 Jul 2020 16:27:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zA4WyeDE9ADeqGFI5fpsrtnR+977K2LTQwEIrm/1uEI=;
        b=AnGAsnmlV0cyXjeZhSWuutDDOfYj1/lmyXyMjRUJpNKMSBPY/rXFm7ZuGzSpUmTrQf
         rVjLMAW9SYubqQhfkaYuWgCZuxAvdYfsROMHZfHvj/87XrtDtCwZWpkeH7O6nQdHbFBu
         Gn0VR3+qXad/8E8x5H8+jfBCdCktjLNs4Mm9g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zA4WyeDE9ADeqGFI5fpsrtnR+977K2LTQwEIrm/1uEI=;
        b=bQrLe7NLrDtMH2KBP2V3fQTVSFzUADYF1Uzpwzun2CcQAheQ7CwpQHtWRktRGn8hvu
         m8q/xNrj2/B7ynBRVVorvsEA3che9nPmfdRFTwz/6849lxoXyk5GP+SwrPU16dZ9coBx
         gceeZYmlCabmMyxoIWACt/E29AM6o/pJtY9rTxHT+vngkPOfbd3vG65mUFSSTEJdLG3B
         RlcpfNAeMVgrIrl/8gqzSfO8HTlS2FvNXI3cgd8LyAJnPFIvr4aVJoqdyK+Ev2ULZCfU
         SxsjmOrRKBxgYmWcYdtd+KVSG/ZHQHFCiRjFwtPutx2wNDG2wbn4nqNR8bf0fSjN9BQb
         9C/g==
X-Gm-Message-State: AOAM5308iuq8aMBD1VxyVvZDTrnuh5LU+gVpIZ53+VMmFwcs3e7bXf3F
	A7nEvk2Y3lu9UnykPxLxbt3t+A==
X-Google-Smtp-Source: ABdhPJxVYFPB5E95sf3Kw4Iv3tCI5lDLACoSfwJ+Mtx0vXDnwgL2lybxI1R3nRMBamCRf7oTTZhIfg==
X-Received: by 2002:a17:90a:8a07:: with SMTP id w7mr142280pjn.219.1594657656890;
        Mon, 13 Jul 2020 09:27:36 -0700 (PDT)
Date: Mon, 13 Jul 2020 09:27:34 -0700
From: Kees Cook <keescook@chromium.org>
To: Allen <allen.lkml@gmail.com>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Clarification about the series to modernize the tasklet api
Message-ID: <202007130916.CD26577@keescook>
References: <20200711174239.GA3199@ubuntu>
 <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
 <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com>

On Mon, Jul 13, 2020 at 03:54:44PM +0530, Allen wrote:
> >
> > I have a few more things to complete, I shall have it done and pushed
> > to github. Will write back
> > once that's done.
> 
> Here's the link to the list of patches so far. I should hopefully
> complete the rest in about
> a  week.
> 
> https://github.com/allenpais/tasklets/commits/ref_tasklets

Thanks for the update! I wonder if there is a way to collaborate better
on this, so we're not all waiting on each other? (i.e. Romain got busy,
Allen picked up the work, then Allen got busy, then Oscar picked up the
work, then Allen returned, etc...)

Perhaps split up testing? I'll like you and Oscar work it out. :)

> What I have done so far is to keep patches close to the original
> series, but with changes
> from the feedback received to those patches.
> 
> Patches 1-10 have been retained as is, except for DECLARE_TASKLET which has been
> moved to patch 1 from patch 12 in the series.

I think the "prepare" patches should be collapsed into the "convert"
patches (i.e. let's just touch a given driver once with a single patch).

> Patch 11 is broken down to sub-systems(as it was done for Timer
> changes in the past).
> Sub-systems:
>  arch/*
>  drivers/atm/*
>  drivers/block/*
>  drivers/char/ipmi/*
>  drivers/crypto/*
>  drivers/dma/*
>  drivers/firewire/*
>  drivers/gpu/drm/*
>  drivers/hsi/*
>  drivers/hv/*
>  drivers/infiniband/*
>  drivers/input/*
>  drivers/mailbox/*
>  drivers/media/*
>  drivers/memstick/*
>  drivers/misc/*
>  drivers/mmc/*
>  drivers/net/*
>  drivers/net/ethernet/*
>  drivers/net/ppp/*
>  drivers/net/usb/*
>  drivers/net/wireless/*
>  drivers/ntb/*
>  drivers/platform/*
>  drivers/rapidio/*
>  drivers/s390/*
>  drivers/scsi/*
>  drivers/spi/*
>  drivers/tty/*
>  drivers/usb/*
>  drivers/vme/*
>  net/dccp/*
>  net/ipv4/*
>  net/mac80211/*
>  net/mac802154/*
>  net/rds/*
>  net/sched/*
>  net/smc/*
>  net/xfrm/*
>  sound/core/*
>  sound/*
>  and ofcourse staging/*
> 
>  Patches 12, 13 comments will be addressed and broken down.
>  Patches 14, 15 will remain as is.
>  Patch 16 will have it's comments addressed.
> 
> With this approach, I think it will be a little easier to get the
> patches into the kernel and also will be easier for maintainers to have
> them reviewed.

Yup -- it's that first patch that needs to land in a release so the rest can start
landing too. (Timing here is the awkward part: the infrastructure change
needs to be in -rc1 or -rc2 so the next development cycle can use it
(i.e. subsystem maintainers effectively fork after the merge window is
over). We can play other tricks (common merged branch) but I don't think
that's needed here.

Thanks to all three of you for poking at this!

-- 
Kees Cook
