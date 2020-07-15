Return-Path: <SRS0=LUEA=A2=lists.openwall.com=kernel-hardening-return-19328-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E74C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Jul 2020 15:29:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DDA3820663
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Jul 2020 15:29:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="c7jcZJYA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDA3820663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19328-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5784 invoked by uid 550); 15 Jul 2020 15:29:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5748 invoked from network); 15 Jul 2020 15:29:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MGzhT9pZtMbaNz4QR+GgW9O2k1/AWzuwjB9vu9rns6U=;
        b=c7jcZJYAXp5EDzG0KqwVoGaSBKC0H1KADZ5I9q48gP/UsZHA7Am7uhPgFFC4Ozeizl
         Ylgw3oSWGnCLcKZTORH3FhJejri9mpinoSxAfxUmu47DGY8I3iLpg5o1VzjYbOSo9KBb
         oSQ1LUlnq4iabGa/SYa9QfLlgDl5uwrGGiBZQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MGzhT9pZtMbaNz4QR+GgW9O2k1/AWzuwjB9vu9rns6U=;
        b=uUouA3VUCLZm9VdLLYvh3DGwRts7AZds8OtJUKMoMhtStaQF18DTbPrk4dO44Tqn5W
         fOAHZuE0VXINE8iHqcianyOpaNYErC12nT34q26RHbC6swweHVESidpaYwEwlyCXOYC4
         wNHqhI5G6ZpN5Qa0ALPM11Hf5pyQXknpi4or6wz7V3BVuRhogtqm/r97VYk5h/8RZxVh
         4XE8tfEZIBuFesoh9L5rlYeuhNC7hplFVDbcokuGJOdaSn7bm49mcxHztquNtjzb74pA
         7ObcqbM5uF4RDxOint/lgq7NxEqv2xzTsG/jApSN/zNBMWaRkae28h4nsFRBFp6ZaMyN
         12zQ==
X-Gm-Message-State: AOAM5324g+edIuAWvx4Y090hTX2bCvaM0sepeY4xgC8AXxO0HLkqcfSl
	d4xLbjMyUin0M5GCSiWq5yM4pw==
X-Google-Smtp-Source: ABdhPJz0BJmcnqxaLtakB3bkXRZd0So9II2Ne4EWaprHK3nAL0ixc4FK+hCvkfi87FKNS3B2vPvKxg==
X-Received: by 2002:a17:90a:7185:: with SMTP id i5mr199361pjk.170.1594826946306;
        Wed, 15 Jul 2020 08:29:06 -0700 (PDT)
Date: Wed, 15 Jul 2020 08:29:04 -0700
From: Kees Cook <keescook@chromium.org>
To: Allen <allen.lkml@gmail.com>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Clarification about the series to modernize the tasklet api
Message-ID: <202007150828.BD556EF6@keescook>
References: <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
 <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com>
 <202007131658.69C96B7D3@keescook>
 <CAOMdWSJW4xuqMz59zp3Jq2deqBD+8qGTVUJh4SUMVUPs8f1C3w@mail.gmail.com>
 <CAOMdWSLFXhS=KY9fG4SH5Oe9oEgj4sGmrRN8MOe9NZzJtdJOww@mail.gmail.com>
 <202007141617.DB13889164@keescook>
 <CAOMdWSKURaD=09LCmv1vSk8Js-uK1r5vVWYtPB_bEhDZJmFACw@mail.gmail.com>
 <CAOMdWSLZUpp+1DLr93vwD2P0-DHxSNFKFPDXB2nhq+x86JnLHw@mail.gmail.com>
 <202007150811.5A1E82BB3@keescook>
 <CAOMdWSL4LwuALVj17mePtk953WxFb+Zd3VMMJDr85PROLBRAAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMdWSL4LwuALVj17mePtk953WxFb+Zd3VMMJDr85PROLBRAAQ@mail.gmail.com>

On Wed, Jul 15, 2020 at 08:51:39PM +0530, Allen wrote:
> >
> > Looking good! I would send the first three first, and point to the
> > conversion tree in the cover letter "this is what's planned" etc (since
> > the first three need to land before the rest can start going in).
> >
> 
> Sure, will keep an eye out. In case I miss them, please just
> drop me a ping and I will send out the series.

Oh, maybe we misunderstood each other? Should I send the first three, or
do you want to do it? I'm fine either way.

-- 
Kees Cook
