Return-Path: <SRS0=Jx36=A5=lists.openwall.com=kernel-hardening-return-19392-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01912C433E0
	for <kernel-hardening@archiver.kernel.org>; Sat, 18 Jul 2020 12:35:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 526DF20656
	for <kernel-hardening@archiver.kernel.org>; Sat, 18 Jul 2020 12:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="TUkwVBe4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 526DF20656
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19392-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17472 invoked by uid 550); 18 Jul 2020 12:35:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17437 invoked from network); 18 Jul 2020 12:35:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1595075699;
	bh=4XQaBh4pa8UzM9FM1hRh2zjxDv4Evfbr8x71vMLCQ30=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TUkwVBe4iAdWwWKbvDewzxRLcgQp3LL1MC/4aVtnj0r+ZUdzYmlH+p+e/z9gs3ovy
	 MAVAVdOTc1kKSss5GC4Y1dso1cfW5eVLLXbbrbqvYVGAL05WeioqGv4XOcOfbe2Z3i
	 LlSesVLCAuOvLqwZ3hbJfu8vacwSvm7TGxnKjrzM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 18 Jul 2020 14:34:57 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Kees Cook <keescook@chromium.org>, Allen <allen.lkml@gmail.com>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Clarification about the series to modernize the tasklet api
Message-ID: <20200718123457.GB3153@ubuntu>
References: <20200711174239.GA3199@ubuntu>
 <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
 <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com>
 <202007130916.CD26577@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202007130916.CD26577@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:RKVuIXJWZ8azRrLhL1kJwyNcDBVCCKJKD7LP0+V7hsrQKLNrSCQ
 uYRef4qFJZ4V0zRdFMBoLOKL8QbSmLejvoBydUr+m7TA6R7hrVNwCvndgoScv5lD5gOZB9e
 BlkAqLEXP1F8nM1xl4S3DpvFTSYz8tSPXyDpayejBWLErwUohKH4lR+s4QLGycZUj8gW+fr
 BANJZxJHhcdx2y0frykuA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Vy4+RSbLUiE=:X3NPaXV/LlU3sHpVSc1Vwp
 dBI4nc5ZKiTsvIfjjAtB/MllHczyeCoDvBUGrpH0iDQs7egoovvdrIxUZXIbV8aIDdgmH4jny
 dwKtohv9tmV3iBDvml/1ctrmFyonZlei1cDXEAA5cyVgiWTu27CvrZe0NeN4CmDLuu77zlly3
 HVdwGy0+xUErvXoO6xtBtOj4wL+iCIzaxm8SQlOM+5iyJbqcAGa+4K6/WVA8lsmg9RyxKUeVZ
 vCARmPu8SFXODu3yDrC2RDqRW7vx6IcUWSxgrbQ4wRxexmZG7E4bvQpkwxx5bDZqv3DlgUJcH
 x2zh6Cbwpwq0UPsrRJEskG/kZnqNBBUh6OmdF4GrmIQd6R6IRVRRlo5YARg+TU2k7g92r2PaH
 T2kuhYls0FRV3uqJ1klcVTKukihmEx9p35i1mkKu2NYLOfWkZkt5lZdLV1c7v1R3qeX1eziNF
 s+ni0gkIQbtuZQ4Upo72tBKTi8IStetpYFL9SpPogIpQ+6hNAHpIppxcoNN3TdKB1Rb4ITqKR
 YKtX3ZoZtg3fVODE8Ty+Gxc7rAK+MySEubk/4rDpnek/z7UTYgHUW/6wWoEbnpTxMZo4DqDSB
 K7CkeAj0U4xbZN0kefCoLW7MIbOVhKwoWiJKixCYd4RFJ7TLc4VvuHa7bJPs55ik4xAMsNtdO
 GExzWcHFisr0kQm7OB/qYXAp1BzShHY2s/SLz5w1im7p8dX/gXt2gr66+hGtqYq1hCsY85qcJ
 9cguAaaWBnj3t/QLIXEBOmDsgVZsm0C8ARSjLgRj8aJFzZ6TbZg1eJ6m8T5i/3jdDycfz3Yra
 MN1kIYX4KAe3UNSb6P4eW0ar3AHm48p7ZDB0vF3bIeq4N4nqku4EXOIG0C5TfLgtJDan8k5fM
 Ks9kF5Jv5Q45teJmUS3ykCmlb7wn+hMTrHeHvb51DtGBULwBLoLNiePDongg1k+eFf4VsLM7l
 cGuG5c+lZBnO63E/4o4NvxbXgq8b5/wkMg/KtvnvWqy2nuMfcU4YROqKAUAtK173zevad1UXV
 Q2apNj/7vTFeaJaxmAuGAM/8ofY+BwKrgs/LY6sPI7Hrv/1HIrOkWM58JXMh53aZNSdAKLXhr
 3h9YV4ecAybQbmss0EfnOG/mqp21MCcOpgc6LOtH+Re6QLPpoQx67Lf3/UrOGtoeMFqFsi40P
 18aS7LNstc8rwOq12ASzVDjRyHPV8JwIDO4mp6X/beYZTay/C5SdTeOHunuga0XC80YT+WIrP
 qcdo93RgczC8iFd34qXjh60SJR3t4PhfZy1w71g==
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2020 at 09:27:34AM -0700, Kees Cook wrote:
> On Mon, Jul 13, 2020 at 03:54:44PM +0530, Allen wrote:
> > >
> > > I have a few more things to complete, I shall have it done and pushe=
d
> > > to github. Will write back
> > > once that's done.
> >
> > Here's the link to the list of patches so far. I should hopefully
> > complete the rest in about
> > a  week.
> >
> > https://github.com/allenpais/tasklets/commits/ref_tasklets
>
> Thanks for the update! I wonder if there is a way to collaborate better
> on this, so we're not all waiting on each other? (i.e. Romain got busy,
> Allen picked up the work, then Allen got busy, then Oscar picked up the
> work, then Allen returned, etc...)
>
> Perhaps split up testing? I'll like you and Oscar work it out. :)

Sure. If you need help give me some task. It will be a pleasure to help on
this. The only inconvenience is that my time to work on this is only a few
hours during the weekend. If the task have no timeout I will finish it as
soon as possible. Sorry, I would like to have more time to work on the lin=
ux
kernel.

> > What I have done so far is to keep patches close to the original
> > series, but with changes
> > from the feedback received to those patches.
> >
> > Patches 1-10 have been retained as is, except for DECLARE_TASKLET whic=
h has been
> > moved to patch 1 from patch 12 in the series.
>
> I think the "prepare" patches should be collapsed into the "convert"
> patches (i.e. let's just touch a given driver once with a single patch).
>
> > Patch 11 is broken down to sub-systems(as it was done for Timer
> > changes in the past).
> > Sub-systems:
> >  arch/*
> >  drivers/atm/*
> >  drivers/block/*
> >  drivers/char/ipmi/*
> >  drivers/crypto/*
> >  drivers/dma/*
> >  drivers/firewire/*
> >  drivers/gpu/drm/*
> >  drivers/hsi/*
> >  drivers/hv/*
> >  drivers/infiniband/*
> >  drivers/input/*
> >  drivers/mailbox/*
> >  drivers/media/*
> >  drivers/memstick/*
> >  drivers/misc/*
> >  drivers/mmc/*
> >  drivers/net/*
> >  drivers/net/ethernet/*
> >  drivers/net/ppp/*
> >  drivers/net/usb/*
> >  drivers/net/wireless/*
> >  drivers/ntb/*
> >  drivers/platform/*
> >  drivers/rapidio/*
> >  drivers/s390/*
> >  drivers/scsi/*
> >  drivers/spi/*
> >  drivers/tty/*
> >  drivers/usb/*
> >  drivers/vme/*
> >  net/dccp/*
> >  net/ipv4/*
> >  net/mac80211/*
> >  net/mac802154/*
> >  net/rds/*
> >  net/sched/*
> >  net/smc/*
> >  net/xfrm/*
> >  sound/core/*
> >  sound/*
> >  and ofcourse staging/*
> >
> >  Patches 12, 13 comments will be addressed and broken down.
> >  Patches 14, 15 will remain as is.
> >  Patch 16 will have it's comments addressed.
> >
> > With this approach, I think it will be a little easier to get the
> > patches into the kernel and also will be easier for maintainers to hav=
e
> > them reviewed.
>
> Yup -- it's that first patch that needs to land in a release so the rest=
 can start
> landing too. (Timing here is the awkward part: the infrastructure change
> needs to be in -rc1 or -rc2 so the next development cycle can use it
> (i.e. subsystem maintainers effectively fork after the merge window is
> over). We can play other tricks (common merged branch) but I don't think
> that's needed here.
>
> Thanks to all three of you for poking at this!
>
> --
> Kees Cook

Thanks,
Oscar Carter
