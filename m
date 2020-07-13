Return-Path: <SRS0=ksCy=AY=lists.openwall.com=kernel-hardening-return-19293-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F60EC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Jul 2020 10:25:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C04C8206F0
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Jul 2020 10:25:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lRDl1xNQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C04C8206F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19293-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1165 invoked by uid 550); 13 Jul 2020 10:25:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1133 invoked from network); 13 Jul 2020 10:25:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IfxmigpMNViE8pJcp4DKVR2TKK0lixJIf09sPLgHqDo=;
        b=lRDl1xNQSaJd0WPpSGR5jStgZEWLFTQmhZ5Z8ijnYd1/nW0DNF6Qq/5yyTx7W+wxWA
         sTieAL3oI6TFKKiE9DU65M1/wP99cRITIjVlv8WJKbYHDIM2t9L2kjR+QJbYa80qLd6g
         a8vNI/GwhxM36wM11vB4Jcxtn5mmltbxYDuE2jMVAArG/TP3TpuRAuT9EreotE0+Tmxl
         An94V0I+9C+C44IAsPnhQWpiNZMGCbdbSgworgjx3kvbzsIbssCCBYDfVVLYjrXhoNC+
         F3Hekw+XEOWg6lUoQfG2kgiwMWhIHhcwIg+rzOdCoqAPj865qXjQk0VSBnVdPfiEGRUI
         FDKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IfxmigpMNViE8pJcp4DKVR2TKK0lixJIf09sPLgHqDo=;
        b=BVD/yKBBzmHWQX+M79KieO5dda8CC2uSU2do9V3EDVUF5cGo2C3+/auguAb6Juy3Qy
         BJ+wJugXBQpuvZMLhfDGGXQfGHjUOa6i9H1m7t5DGZHksHwVGEX6hhuPQZ5UjSCVdo5v
         5+iOlfz0gRIJ1mBDnDeJM8vqq5ZdsOSMFTaJdh11wBS98nylInJ/phhb3n7+UTbC9fcX
         369+j+xCHfhvIdgPz2JtCaK6AztEp4z71ZUlVLfAiOFwBHSuRji5T7ENagGhqcsvTM9Q
         4XU35dTwCjORmDOVgU7OAKEpLgEWel7w5yby/x0iafsGo0Qais3oMcM+Gp5JhHCPjo6A
         XZ9g==
X-Gm-Message-State: AOAM532kY8Wc6tIV/xPvlngoBBQJGGCSrOcpGMcW6JGmaWwr/+vVOrjQ
	PZZ7/8JAyQJMJAAD2Durel5A1qhTkAU1h8L62B8=
X-Google-Smtp-Source: ABdhPJybRic18Q7/vkL/2RzI8UrxJwB/pyZ+N2PqefJeRnj0+00GhU4rAJ04GwRIzB76Lux06HEtCO/So/rdCyqFe5U=
X-Received: by 2002:a9d:65c2:: with SMTP id z2mr35996428oth.264.1594635895716;
 Mon, 13 Jul 2020 03:24:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200711174239.GA3199@ubuntu> <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
In-Reply-To: <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 13 Jul 2020 15:54:44 +0530
Message-ID: <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com>
Subject: Re: Clarification about the series to modernize the tasklet api
To: Oscar Carter <oscar.carter@gmx.com>
Cc: Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

>
> I have a few more things to complete, I shall have it done and pushed
> to github. Will write back
> once that's done.

Here's the link to the list of patches so far. I should hopefully
complete the rest in about
a  week.

https://github.com/allenpais/tasklets/commits/ref_tasklets

What I have done so far is to keep patches close to the original
series, but with changes
from the feedback received to those patches.

Patches 1-10 have been retained as is, except for DECLARE_TASKLET which has been
moved to patch 1 from patch 12 in the series.

Patch 11 is broken down to sub-systems(as it was done for Timer
changes in the past).
Sub-systems:
 arch/*
 drivers/atm/*
 drivers/block/*
 drivers/char/ipmi/*
 drivers/crypto/*
 drivers/dma/*
 drivers/firewire/*
 drivers/gpu/drm/*
 drivers/hsi/*
 drivers/hv/*
 drivers/infiniband/*
 drivers/input/*
 drivers/mailbox/*
 drivers/media/*
 drivers/memstick/*
 drivers/misc/*
 drivers/mmc/*
 drivers/net/*
 drivers/net/ethernet/*
 drivers/net/ppp/*
 drivers/net/usb/*
 drivers/net/wireless/*
 drivers/ntb/*
 drivers/platform/*
 drivers/rapidio/*
 drivers/s390/*
 drivers/scsi/*
 drivers/spi/*
 drivers/tty/*
 drivers/usb/*
 drivers/vme/*
 net/dccp/*
 net/ipv4/*
 net/mac80211/*
 net/mac802154/*
 net/rds/*
 net/sched/*
 net/smc/*
 net/xfrm/*
 sound/core/*
 sound/*
 and ofcourse staging/*

 Patches 12, 13 comments will be addressed and broken down.
 Patches 14, 15 will remain as is.
 Patch 16 will have it's comments addressed.

With this approach, I think it will be a little easier to get the
patches into the kernel and also will be easier for maintainers to have
them reviewed.

Thanks,
-- 
       - Allen
