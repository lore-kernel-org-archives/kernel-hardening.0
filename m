Return-Path: <SRS0=IiX4=ZH=lists.openwall.com=kernel-hardening-return-17389-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE1CC432C3
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 16:49:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3CF6720728
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 16:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RgkFP3a9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CF6720728
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17389-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5766 invoked by uid 550); 15 Nov 2019 16:49:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5728 invoked from network); 15 Nov 2019 16:49:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VLpzj5GM/mlBjL0K2sCFmpTMFSROa82RYmL4861eSc0=;
        b=RgkFP3a9s426OYYkZ7W21MD1zAotJvoKIJcOx8fEGlAapE+TfvDLycmtw0489eXEiW
         Fl4qZmK8/64lup/wMwN3kesYT96O/AbpCg4kKCpfpZNM3t0JygH/7aRhN85B9VNN+TOD
         1U2MWrHiTYG9FXUsiFNTenULOK35swEYq9okE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VLpzj5GM/mlBjL0K2sCFmpTMFSROa82RYmL4861eSc0=;
        b=rNLpdct9TAGDhxjaiVAJCyrcxuxotBhD3XyX9kKn/M+Pp7xzPzqyydNuzGRfXyoAot
         iwqNbLSo09bYGjmI6dPxgXOLuMQiTxAJLphd9srHUg2LYT9hRS9NnEaIiNvsPTk92o8p
         KyMIGsGmKIH1YE3hUxR0wbLqD6bc7ZNiS3q9wODHc5wK2khoCnaSfKJWUmw1rZaFTBZR
         hMCdhJderFZJFlo0X2qL4ZDpuecMuRseuIQ93H7PyfAu5wZKmX23pFOgIs6T7jsauLsv
         i5RUDpUddWAwjVq8jyOQuOJbir/oujn8frKRVx3HqQfGWW391F/fz++X5EWL1EDbY0fj
         7phg==
X-Gm-Message-State: APjAAAUMdROgbSnnFxtaD+nSnmy+owCpZ9xp7LxM59JDsXQ9e3/Az0gu
	jpM8sJpjBJRADQJLQUB4s+29Sg==
X-Google-Smtp-Source: APXvYqzK/lcD05IQBl/MSOo179tz+tQRcqFgCWgHTRpFQFjaLXWwuRaGkmv3yTQ5UcYy81I/Mzn1Vw==
X-Received: by 2002:a63:4961:: with SMTP id y33mr2498326pgk.264.1573836543743;
        Fri, 15 Nov 2019 08:49:03 -0800 (PST)
Date: Fri, 15 Nov 2019 08:48:55 -0800
From: Kees Cook <keescook@chromium.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
	Romain Perier <romain.perier@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl*: Remove tasklet callback casts
Message-ID: <201911150848.12F713465F@keescook>
References: <201911142135.5656E23@keescook>
 <20191115074003.GB19101@kadam.lan>
 <20191115074235.GJ19079@kadam.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115074235.GJ19079@kadam.lan>

On Fri, Nov 15, 2019 at 10:42:35AM +0300, Dan Carpenter wrote:
> On Fri, Nov 15, 2019 at 10:40:03AM +0300, Dan Carpenter wrote:
> > On Thu, Nov 14, 2019 at 09:39:00PM -0800, Kees Cook wrote:
> > > In order to make the entire kernel usable under Clang's Control Flow
> > > Integrity protections, function prototype casts need to be avoided
> > > because this will trip CFI checks at runtime (i.e. a mismatch between
> > > the caller's expected function prototype and the destination function's
> > > prototype). Many of these cases can be found with -Wcast-function-type,
> > > which found that the rtl wifi drivers had a bunch of needless function
> > > casts. Remove function casts for tasklet callbacks in the various drivers.
> > > 
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > 
> > Clang should treat void pointers as a special case.  If void pointers
> > are bad, surely replacing them with unsigned long is even more ambigous
> > and worse.
> 
> Wow...  Never mind.  I completely misread this patch.  I am ashamed.

Okay, whew. I was starting to try to wrap my brain around what you
meant and was failing badly. :)

> The patch is fine.
> 
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks!

-Kees

> 
> regards,
> dan carpenter
> 

-- 
Kees Cook
