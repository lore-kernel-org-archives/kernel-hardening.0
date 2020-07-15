Return-Path: <SRS0=m/lH=A2=lists.openwall.com=kernel-hardening-return-19325-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEFDDC433E4
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Jul 2020 14:51:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2EC78206F5
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Jul 2020 14:51:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A4S42ZPP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EC78206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19325-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18025 invoked by uid 550); 15 Jul 2020 14:51:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17989 invoked from network); 15 Jul 2020 14:51:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p+Vvf2PHdsVR8vQQusA2PyO4qs67KxkCTpYCHffnum8=;
        b=A4S42ZPPzBqiyERt9HKeUu2Z+Ueli+ANbY7+E5QgAx1eDO0CHYJpbRsZvaxW1nSbu0
         CcXtDBE3vh67OU5B2H6e/PPy6VKKtQSEJkh6nchLxVRKRGlVM67DIB4aW8rgGOy9WZ/1
         +WIyppJxwChJVcbGRwLdd9ZU8n+zKSHQfH4p/fzJNmwJwdYSPdNmNGMy8MpSM5o5pkRA
         DBLiDH2aSf/ZLMpDMZUI0k+B/YD4f7IVd8NXPCZZ1yrOH+VNLNjozbT3XSHhgXsrXdcK
         JZZ+oY8VUw0VMWlVRxEycR+T27xrTzr0a6zkADMPyDgnVuqSRD0BJb2MC5l/M8cQtNSv
         RISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p+Vvf2PHdsVR8vQQusA2PyO4qs67KxkCTpYCHffnum8=;
        b=iXFizk3HZzM3Uy7hpFohzjcoo8aYq3YrbPXJaNJ/NeKOQqzIuTAPMyqgv9g2t39cCA
         sgt16gY0/Adz4YnOA6R9mjqSaJGrRreV2TWKsDVkyYEawhw4VGNtrMKq2J5Cm0vecycx
         YIol//pUOfYpyeeOus9NHCNf0olEKmF0bLDEI5BevI4gk1mgQ/dE73zPAx33u34ztsf5
         Pu8lB3QYGJTCAX21/faf5Re9WE7nzBOf0aT5PVQjdlT/0KWNbJSXq89fl9uVyZYaRVCh
         HwgqiUAKBITxE/yRleuDAaxjMEenPSRtq82OzwMxvjPIoX/UA05Ep2CIFhKUmmtbHn1g
         T70g==
X-Gm-Message-State: AOAM531GDYGR/zgFhDGgNSsR95DxXJzW3UsiHDaWAGtsXmGiixUoGoLj
	uu4HFKnQLLb1hhHhEnrdRIOXwjr/Tpdc3FBj7C8=
X-Google-Smtp-Source: ABdhPJwzr0gIyn/3cNfbye0YJnqnbufcdzZFpzXmO6yxTTyXD7dT3pBcXnbftXsS81Nih+8mBOAKvor/I1xNPvbgsw0=
X-Received: by 2002:a9d:65c2:: with SMTP id z2mr4105oth.264.1594824685301;
 Wed, 15 Jul 2020 07:51:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200711174239.GA3199@ubuntu> <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
 <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com>
 <202007131658.69C96B7D3@keescook> <CAOMdWSJW4xuqMz59zp3Jq2deqBD+8qGTVUJh4SUMVUPs8f1C3w@mail.gmail.com>
 <CAOMdWSLFXhS=KY9fG4SH5Oe9oEgj4sGmrRN8MOe9NZzJtdJOww@mail.gmail.com>
 <202007141617.DB13889164@keescook> <CAOMdWSKURaD=09LCmv1vSk8Js-uK1r5vVWYtPB_bEhDZJmFACw@mail.gmail.com>
In-Reply-To: <CAOMdWSKURaD=09LCmv1vSk8Js-uK1r5vVWYtPB_bEhDZJmFACw@mail.gmail.com>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 15 Jul 2020 20:21:12 +0530
Message-ID: <CAOMdWSLZUpp+1DLr93vwD2P0-DHxSNFKFPDXB2nhq+x86JnLHw@mail.gmail.com>
Subject: Re: Clarification about the series to modernize the tasklet api
To: Kees Cook <keescook@chromium.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

> >
> > rm 0*.patch
> > git format-patch 7f51b77d527325bfa1dd5da21810765066bd60ff
> > git reset --hard 7f51b77d527325bfa1dd5da21810765066bd60ff
> > perl -pi.old -e \
> >         's/Subject: \[PATCH([^\]]+)\] ([^:]+):([^ ])/Subject: [PATCH\1] \2: \3/' 0*patch
> > git am 0*.patch
>
> Thanks, I shall have it fixed.


Fixed all the patches and cleaned them up.

https://github.com/allenpais/tasklets/commits/tasklets_V2

Build tested with "make allmodconfig" and boot tested on x86,  Raspberry Pi3,
qemu(arm64 and x86).

I will have the drivers in staging converted in a day or two.
I haven't yet added the patch to completely remove the old API, I
think it's best
for the current series to be accepted upstream and only when all of them have
been accepted it will be right to send the clean up patch.

Please take a look and let me know if they are good to go out for review.
-- 
       - Allen
