Return-Path: <SRS0=x+32=U2=lists.openwall.com=kernel-hardening-return-16300-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE95CC48BD9
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 17:01:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 17A1720659
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 17:01:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dDwRroTK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17A1720659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16300-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17462 invoked by uid 550); 27 Jun 2019 17:01:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17427 invoked from network); 27 Jun 2019 17:01:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=71duD+dj1AWEy6PZjgfTNHUCZN+FWrnSZ3ct8DL9Faw=;
        b=dDwRroTKf1WTr8VEolUKbJHn/8fx7gyq5+0vyHVxnd2l/z08UfbJhphbBccRETXW5m
         MXWs0fJitq0gzMgyFqo1O9hrcmrzRPcdSrQo0HAHAuHDcIzfE7b9Y73/4ifT2JI3jT3w
         U1BWPXbXYhthczog3g+410wQZozTDeA0CU7uA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=71duD+dj1AWEy6PZjgfTNHUCZN+FWrnSZ3ct8DL9Faw=;
        b=jj9PB/pjqyuRXEfUHPwa7tEvhX5NZRtjOmsJIyZ3EqnhT8YMckNh5dE12zA9kdiaEc
         6QExExrhKU4XXBkzrCuADySrjjp6LbUXbcN1R6Ohmpqbud5W9uh2l/qcCwSESOCycyVf
         TFs6HhzGINnCA8UMsU5tgJPL2aOI4076VvkvS0P5ixb7pNeiZEcry7GIOn0khcVgXwmv
         Qim6JuCGKkvkTesS6TY5/1d5ARNyr+yrhjV2DVcd1Y+Z9r+OPdnQ5M3aDqSBjKI/iQai
         25QxX/m637AsUIeT6tweom+RDUJ7F+vsMn9yy3B+/Ou9A0gGBcWOQMhKo6jc1Rvab+bC
         oE0A==
X-Gm-Message-State: APjAAAXiNjxRtz6q6xE9dnWrfv9xRjJIcfpcMKsVLndx4u8bQg5peuso
	P05JIMXVIoJmPcmMmVc7zTErnbTSc4c=
X-Google-Smtp-Source: APXvYqxaBukoSGTFpmbFjfj5I4Y7bedp6+c8gmhfmLzxxDwX1Gl//mLqWYji0qPjAm2InZUkq/pPNg==
X-Received: by 2002:a17:902:2a27:: with SMTP id i36mr5721146plb.161.1561654889482;
        Thu, 27 Jun 2019 10:01:29 -0700 (PDT)
Date: Thu, 27 Jun 2019 10:01:27 -0700
From: Kees Cook <keescook@chromium.org>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: Archive kernel-hardening@lists.openwall.com  on lore.kernel.org
 too
Message-ID: <201906271001.FD341B865A@keescook>
References: <dab4681adb58c769b8b8f580e3d2057b0f4f2607.camel@opteya.com>
 <20190625170043.GA22560@openwall.com>
 <52e1fb49f1f0acf292fb17c0153b7511baaac63e.camel@opteya.com>
 <26aba7bb3d5964a68c325c3753d35d4059956000.camel@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26aba7bb3d5964a68c325c3753d35d4059956000.camel@opteya.com>

On Thu, Jun 27, 2019 at 06:55:07PM +0200, Yann Droneaud wrote:
> Thanks to kernel.org's Konstantin Ryabitsev, with the archives provided
> by Solar Designer, kernel-hardening@lists.openwall.com is now
> registered at https://lore.kernel.org/lists.html.
> 
> Check out https://lore.kernel.org/kernel-hardening/ for the archive.

Yay! Nice work. :)

-- 
Kees Cook
