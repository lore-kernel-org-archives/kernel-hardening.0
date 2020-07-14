Return-Path: <SRS0=3RCC=AZ=lists.openwall.com=kernel-hardening-return-19301-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42C0C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 05:13:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3C80A21D93
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 05:13:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j3OS70vt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C80A21D93
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19301-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7789 invoked by uid 550); 14 Jul 2020 05:13:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7756 invoked from network); 14 Jul 2020 05:13:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OsLiatvC2XNGiH1EXnGosEusbhbYVSBtpe8IA6yLYWA=;
        b=j3OS70vtgQXtjPQw39zx73txIIDUSxIKng5o2GaO+dmEN3zX0XufhySyPugHdpybsW
         7nybnSC1m0C3Pn7opAAQXHy9SutJ0fPXIs+FabrLDdWFLYzvhpDjYim6GuHWD1f6+2DB
         ZAyt+BRPCo3J6nACpvSRRQsYo7kd8+ZIooI4ef1FRUGb76Xybigt81ldfSHg1xlfCCxd
         dwW0VP6Zsrp3K0pOjH2NMIW23vtykVJpLQhSMLbcLE5yC3kHW+oV7LzgPy+fTjJTDccg
         zyZXvtqYazYgws8mBMX+LZTNmIs1FrtEwbKPZgbWVofOh/6wbfsd8p2N1HX98Hesfhk2
         K48A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OsLiatvC2XNGiH1EXnGosEusbhbYVSBtpe8IA6yLYWA=;
        b=dhCEhGAosY3D1eoYiNe2wkuCXzx682Ul941dzJNIPwExcunJcRAYylIFA6za50MpDQ
         zZ1X1vAcgCI0O4B7iyipK4MwgKqzx/w50nPaKgBcAsaDBbrlH8K1nGYh9SrRVMQqKTnq
         8nbGsK4nWv5KyIp3phHzgN38o4syou840zEfl1B43mFW2uu6jKCvQWDW/t5PCPQqj1+6
         t+wb6GED14jOEclAmy6tWnrGW1EvYbSwH6wQ5hE25PIU5jHhO8XDVqDRdaZqAslQy8Up
         iIeycPgZeDD8VK28pFAWaCN/TCrw1KrXsRDoxyULI8DCar8A4z1DQNLc82N8swgmdstV
         fmZA==
X-Gm-Message-State: AOAM531jyYfJN5L+2VJpFRq1vhs8bDy4B13iO1lEgFbtAf1aJQxWdzho
	fCI70vS24nfMe7BdciS/N92EeiHuDV4EIaaIbNc=
X-Google-Smtp-Source: ABdhPJzwoy85Z2s7spLwb6SUyHN1GGcqMRPzO38dIIXYT3z23FDFRdj1J1WjtQhPrD4Cn9uO4DpCc8txs4PHcNCARLQ=
X-Received: by 2002:a54:408e:: with SMTP id i14mr2357565oii.175.1594703572694;
 Mon, 13 Jul 2020 22:12:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200711174239.GA3199@ubuntu> <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
 <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com> <202007131658.69C96B7D3@keescook>
In-Reply-To: <202007131658.69C96B7D3@keescook>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 14 Jul 2020 10:42:41 +0530
Message-ID: <CAOMdWSJW4xuqMz59zp3Jq2deqBD+8qGTVUJh4SUMVUPs8f1C3w@mail.gmail.com>
Subject: Re: Clarification about the series to modernize the tasklet api
To: Kees Cook <keescook@chromium.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

>
> Okay, I took a look at this series. I'd like to introduce the new API
> differently than was done for timer_struct because I think it'll be
> easier and more CFI-friendly. Here's what I've got:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/tasklets/new-api/v1

 Okay, I took a quick look and I like it. I shall get this in and work
on the rest of
the patches and hopefully get it all ready by the end of this week.

>
> All the rest can apply on top of that (though it looks like many patches
> need work, I got a lot of errors from "make allmodconfig && make".

My bad, I should have told you that github was just a placeholder for
WIP patches. I have been testing a set of patches regularly, no issues.
I shall push the updated branch.

Thank you.
-- 
       - Allen
