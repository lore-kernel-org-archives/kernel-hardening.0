Return-Path: <SRS0=0tFy=A2=lists.openwall.com=kernel-hardening-return-19327-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477D0C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Jul 2020 15:22:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 99ABF2065E
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Jul 2020 15:22:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XUepupFC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99ABF2065E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19327-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1721 invoked by uid 550); 15 Jul 2020 15:22:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1689 invoked from network); 15 Jul 2020 15:22:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O8PMwsC3LiulXdYNpig96aRQoLeFcNFsJzGzpi1fKes=;
        b=XUepupFC2ygpFHy0wd5CzfUB69DbJrSAHBmLD3FvgX+OWJY4HapIyaqlEjujcT4r4q
         s+77r+x7hZe7oSk7Uo18Il0YSC4+Mg8E6eFs57eZe8NZcqLXFwX77fNUDLH50fJCLnFv
         E8CKyRFXc1iXjYwcY7YmyDUdUWZU4tBinKaJJx3ZMHyurQXXeMPOgDRYBh40RYucTJFa
         joQ6jmQt13PwZuCHG3vP6B3frIC1XUrQI4Zrf7Zxvxu/BvczjSmBBuKob5pedpOgamsn
         4SZjWcXrqtipm7y/cJ95/SC101G3M5PGXmY94oYntESrGicWVnGjfn50M3+tBZCboc/6
         +lwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O8PMwsC3LiulXdYNpig96aRQoLeFcNFsJzGzpi1fKes=;
        b=hynD5RLcIwXdYvcNp35yonurtB0znJg/g+qy2e/kr+p0zt5QY5NzRuaqBPS8meQOWp
         3uOB1odYZ3Uz2VT6kPzUlRJMh3QLaJoBDpoWnX7VIgvFPMVtqPZzGilmF5WizCbEDMsk
         iCBc08csNfox4PHta8h5YgdtxEb1moSVcvlClTVXKJQhxowaOIhNBqRfFr347i2LgocB
         gNYwmKJpjIHufOLYcDSTS4evKrzRt7xGJFrNq82VOzXH5HA9+LSzu6h+g0y42Op4h9Nf
         LDQt3JgTa/997npMKOfmS96AyfPvZkarsNf5r+4h54qNxlhYlGwfHFhHBkUJoWPKbJxb
         QOtg==
X-Gm-Message-State: AOAM531wKPJelEKzsPUzCF6cOQ8Kq23b2CoGh08IOitJSad1K/rGcgog
	JfY64hoMtn5LBszUchzIg4VlEC9VgzXcUhJ6QRmLbQ==
X-Google-Smtp-Source: ABdhPJznF6dW7BgOMPcHEqneQ71U2JH8laDvpouiH3FsKW/YI40ia/LDo7SfyVffqN9bOsrybxVpKzpAxQiCDuwfI54=
X-Received: by 2002:a9d:688:: with SMTP id 8mr158447otx.108.1594826510578;
 Wed, 15 Jul 2020 08:21:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200711174239.GA3199@ubuntu> <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
 <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com>
 <202007131658.69C96B7D3@keescook> <CAOMdWSJW4xuqMz59zp3Jq2deqBD+8qGTVUJh4SUMVUPs8f1C3w@mail.gmail.com>
 <CAOMdWSLFXhS=KY9fG4SH5Oe9oEgj4sGmrRN8MOe9NZzJtdJOww@mail.gmail.com>
 <202007141617.DB13889164@keescook> <CAOMdWSKURaD=09LCmv1vSk8Js-uK1r5vVWYtPB_bEhDZJmFACw@mail.gmail.com>
 <CAOMdWSLZUpp+1DLr93vwD2P0-DHxSNFKFPDXB2nhq+x86JnLHw@mail.gmail.com> <202007150811.5A1E82BB3@keescook>
In-Reply-To: <202007150811.5A1E82BB3@keescook>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 15 Jul 2020 20:51:39 +0530
Message-ID: <CAOMdWSL4LwuALVj17mePtk953WxFb+Zd3VMMJDr85PROLBRAAQ@mail.gmail.com>
Subject: Re: Clarification about the series to modernize the tasklet api
To: Kees Cook <keescook@chromium.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

>
> Looking good! I would send the first three first, and point to the
> conversion tree in the cover letter "this is what's planned" etc (since
> the first three need to land before the rest can start going in).
>

Sure, will keep an eye out. In case I miss them, please just
drop me a ping and I will send out the series.

Thanks.


-- 
       - Allen
