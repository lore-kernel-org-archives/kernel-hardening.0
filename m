Return-Path: <SRS0=JrGt=A2=lists.openwall.com=kernel-hardening-return-19326-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD408C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Jul 2020 15:15:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0F24620658
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Jul 2020 15:15:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Vv3B0rEt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F24620658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19326-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30336 invoked by uid 550); 15 Jul 2020 15:15:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30304 invoked from network); 15 Jul 2020 15:14:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/9T9MBzJz18iPBgtL6UWGINUBYYb3f7mmIJ+6L83PRY=;
        b=Vv3B0rEtp4eTOOSMhSZwKq0dgza3h7O9KQ+L3mY3GKopWrZitWiJGfIfO/hewUVyj4
         hUjnPrb69OSrx1HjYmMRn8WHyoNN1bqNijD8uPywp8QLqNA/KPHs2UjJgOxVbN49YwTP
         jne2h2B2U2DFnzBN08/wGVOTNLzf2XuYkdaUs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/9T9MBzJz18iPBgtL6UWGINUBYYb3f7mmIJ+6L83PRY=;
        b=afcd+J2jFWUtkgzXrI/z/PNfpGDQNwcJgWDoo2ibXTpBWtsIKmgQsw+qR7qosnkKbO
         SrYmbwGYv1PQr6vJrDT3imIzCSyVwsea+V8+4Dt0tjjfwX3AogLq6z25Lw8YQhq7yd4r
         a470sbqtHduvw+Bbwe5V5IprgJYDxBNIdvbDBlHFM9UtULf2Cr2yp/F6mQ8BPYkX97SB
         4EXkqzDxV1N1jxuTBpnptZvr+mKJXgRjdp+oMHoDypkj0cXiVw7+s72EbSOsCEyfIAw5
         vBLKDW4nhl5O8ozXJOO6rWyVf5rL5fau7c2dGk/KeG2TN+jVGIunP2NntXk0Xav99Fcr
         nE/Q==
X-Gm-Message-State: AOAM532r9uA71xyPn2DuigtM3apQ498pteMSLR/LjYJ+UWxbIdxWND6f
	yX3K0UWLl6Gjc7Pq4RtZjGxCfg==
X-Google-Smtp-Source: ABdhPJxFdE2LX/dbnBrfgaSW2YotZlBbeqlwfUZt3SlfwP12SGsRItcMZ6eyk61lv3tZcG14YWn/1A==
X-Received: by 2002:a17:902:aa91:: with SMTP id d17mr8571126plr.93.1594826087517;
        Wed, 15 Jul 2020 08:14:47 -0700 (PDT)
Date: Wed, 15 Jul 2020 08:14:45 -0700
From: Kees Cook <keescook@chromium.org>
To: Allen <allen.lkml@gmail.com>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Clarification about the series to modernize the tasklet api
Message-ID: <202007150811.5A1E82BB3@keescook>
References: <20200711174239.GA3199@ubuntu>
 <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
 <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com>
 <202007131658.69C96B7D3@keescook>
 <CAOMdWSJW4xuqMz59zp3Jq2deqBD+8qGTVUJh4SUMVUPs8f1C3w@mail.gmail.com>
 <CAOMdWSLFXhS=KY9fG4SH5Oe9oEgj4sGmrRN8MOe9NZzJtdJOww@mail.gmail.com>
 <202007141617.DB13889164@keescook>
 <CAOMdWSKURaD=09LCmv1vSk8Js-uK1r5vVWYtPB_bEhDZJmFACw@mail.gmail.com>
 <CAOMdWSLZUpp+1DLr93vwD2P0-DHxSNFKFPDXB2nhq+x86JnLHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMdWSLZUpp+1DLr93vwD2P0-DHxSNFKFPDXB2nhq+x86JnLHw@mail.gmail.com>

On Wed, Jul 15, 2020 at 08:21:12PM +0530, Allen wrote:
> > >
> > > rm 0*.patch
> > > git format-patch 7f51b77d527325bfa1dd5da21810765066bd60ff
> > > git reset --hard 7f51b77d527325bfa1dd5da21810765066bd60ff
> > > perl -pi.old -e \
> > >         's/Subject: \[PATCH([^\]]+)\] ([^:]+):([^ ])/Subject: [PATCH\1] \2: \3/' 0*patch
> > > git am 0*.patch
> >
> > Thanks, I shall have it fixed.
> 
> 
> Fixed all the patches and cleaned them up.
> 
> https://github.com/allenpais/tasklets/commits/tasklets_V2
> 
> Build tested with "make allmodconfig" and boot tested on x86,  Raspberry Pi3,
> qemu(arm64 and x86).
> 
> I will have the drivers in staging converted in a day or two.
> I haven't yet added the patch to completely remove the old API, I
> think it's best
> for the current series to be accepted upstream and only when all of them have
> been accepted it will be right to send the clean up patch.
> 
> Please take a look and let me know if they are good to go out for review.

Looking good! I would send the first three first, and point to the
conversion tree in the cover letter "this is what's planned" etc (since
the first three need to land before the rest can start going in).

-- 
Kees Cook
