Return-Path: <SRS0=Yfi6=AZ=lists.openwall.com=kernel-hardening-return-19322-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E47C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 23:21:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4F99420658
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 23:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dTPSZg7o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F99420658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19322-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3886 invoked by uid 550); 14 Jul 2020 23:21:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3853 invoked from network); 14 Jul 2020 23:21:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yZ7AwJ8R9KbSc+2PUevmOpZc51qhbNB9v/oDicjM9Cw=;
        b=dTPSZg7o9fSdsQqvgnRf69ioaCYTAEHqho5D8TDxaer3wYs9lnP5eQ5imXKZqYSom6
         5WG5v9TJeUc7BNOGArSlDQYpGkuKyTLBoNqDMGpmW82/vcXECauSNRcYmNDpYy6SpsaW
         2U29d3dt3OO8JQZ0YcU67n1q9DNBpFifh2fGY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yZ7AwJ8R9KbSc+2PUevmOpZc51qhbNB9v/oDicjM9Cw=;
        b=YTGr6k4ueu3OqwxpgxJaC8iImjwxSvHtHpkveNcWzPmJ2TsG9dHw3LnMD8u+HZY+dV
         DB2eMK9JPI7eIJCmbG+fzjv/X9PljClXwL8r8j6+baLP6P0fPaaBNv1ogGAv3vJPlVjl
         xvX53qpNidMZuB+zUvAfxVqc/2n+C12yfucEs3L5p5t2wf8+3g0kYL9DmMpHBmOJ08Gn
         nHa7OUim7f0ciHNgKbm3/kWtUqxfzv9+vt2Wpeo1pPgllTCvH7vhy/PpAO8zeJa5PNl2
         RWIsD8V75fK2r8OZVPQEyHU06dxLo9sN1qMPiXJiIPRt3FCCRQ2BRCR/+P7oOA9oe3io
         1R2g==
X-Gm-Message-State: AOAM532yrJEND44TqtsQwkpL9taL4Pt9YrJSCHdcIS2Q9jMZ08UB6B8X
	t1JW5+vaPuQgVyNGJ9sMDJWDYQ==
X-Google-Smtp-Source: ABdhPJwdY0SRh4N0/7rXo4dG6PpvhLHIf0T5Upyh0TqHeetDf0PliSU1cpGMTA6MdqRZC9lj7LoMkQ==
X-Received: by 2002:a17:90a:8c01:: with SMTP id a1mr6719114pjo.97.1594768851120;
        Tue, 14 Jul 2020 16:20:51 -0700 (PDT)
Date: Tue, 14 Jul 2020 16:20:49 -0700
From: Kees Cook <keescook@chromium.org>
To: Allen <allen.lkml@gmail.com>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Clarification about the series to modernize the tasklet api
Message-ID: <202007141617.DB13889164@keescook>
References: <20200711174239.GA3199@ubuntu>
 <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
 <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com>
 <202007131658.69C96B7D3@keescook>
 <CAOMdWSJW4xuqMz59zp3Jq2deqBD+8qGTVUJh4SUMVUPs8f1C3w@mail.gmail.com>
 <CAOMdWSLFXhS=KY9fG4SH5Oe9oEgj4sGmrRN8MOe9NZzJtdJOww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMdWSLFXhS=KY9fG4SH5Oe9oEgj4sGmrRN8MOe9NZzJtdJOww@mail.gmail.com>

On Tue, Jul 14, 2020 at 07:57:06PM +0530, Allen wrote:
> >
> > My bad, I should have told you that github was just a placeholder for
> > WIP patches. I have been testing a set of patches regularly, no issues.
> > I shall push the updated branch.
> >
> 
>  Made some progress today. I have a few more things to complete
> before the series can go out for review. I have pushed out the changes to:
> 
> https://github.com/allenpais/tasklets/commits/tasklets_V1

Nice! One style nit is the Subject lines needs spaces after the ":"s.
For example, "crypto:hifn_795x: replace tasklet...." should be
"crypto: hifn_795x: replace tasklet...."

I did this to fix it:

rm 0*.patch
git format-patch 7f51b77d527325bfa1dd5da21810765066bd60ff
git reset --hard 7f51b77d527325bfa1dd5da21810765066bd60ff
perl -pi.old -e \
	's/Subject: \[PATCH([^\]]+)\] ([^:]+):([^ ])/Subject: [PATCH\1] \2: \3/' 0*patch
git am 0*.patch


-- 
Kees Cook
