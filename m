Return-Path: <SRS0=dOUl=4W=lists.openwall.com=kernel-hardening-return-18092-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C07C3F2D1
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 21:17:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E76B3208CD
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 21:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XNKMdglo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E76B3208CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18092-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5799 invoked by uid 550); 5 Mar 2020 21:17:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5767 invoked from network); 5 Mar 2020 21:17:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v1upWCD1mlNbaZtpOS/pHEyeFFYjDyZbTGORJ9Hi0Po=;
        b=XNKMdglo9YOUj0vtGHLxx4w9M+D74XpIcU4euCxAw/oRnX95qUBq3YYOSLvlws4gkk
         atLHgbiIjNl4Lp9deokObeR0JVIWdr2FmZPhgIfkwyijrv/GEYGYZm2UEGlBVLPDxs+J
         0LEUO4jLu6BKbSOTzI6Mg6d7fY6bdnZ4QBEbQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v1upWCD1mlNbaZtpOS/pHEyeFFYjDyZbTGORJ9Hi0Po=;
        b=Boryx40sfw9arXHOfTJIaCB9vYKTnjCUSffUZW7NkHqt06ITN3ZSOSjUWdZ4YpYeHX
         ibGLAVzHQYBwNYdwl4QdCu1cwUztZH6n82gzi1qvDYj7mEPaOIPYYVvQGcGPtZIqzA6Q
         Tj2BqCx7qzvQm+aeHv0XUk7EVVy21NuKktNYqn1dWq+pJAR68XGMcZRUn+jOVNcuusX1
         CjShIK0FBUCv7CH/nRAspWEaXbvNIViLdmJqx7KJRD0CIxqPzeZIo5CMNEFM2AYwDk5J
         H2C7hJne1l9RuuZpeXwag7CfQ5j95y3NmRXhnrtFmwDPHCA5/r0SSoZWRAqE4c9lNFo2
         rWsA==
X-Gm-Message-State: ANhLgQ191vTi+aaSWGz4X9sPruNvIuIO3j9bcYs1xxI7z0bgJXJVTbcp
	Lee+NkmdJWE/EfaFp9aliYckag==
X-Google-Smtp-Source: ADFU+vuo71xr7b8efmkr7fBfrfvy+omdGcPEhfxnxPNTCL+ixBfzvYE9MKbAXGRIxUwFoXEpYSZksw==
X-Received: by 2002:a17:902:b617:: with SMTP id b23mr10279367pls.285.1583443023339;
        Thu, 05 Mar 2020 13:17:03 -0800 (PST)
Date: Thu, 5 Mar 2020 13:17:01 -0800
From: Kees Cook <keescook@chromium.org>
To: Tycho Andersen <tycho@tycho.ws>
Cc: Arvind Sankar <nivedita@alum.mit.edu>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Joe Perches <joe@perches.com>, "Tobin C . Harding" <me@tobin.cc>,
	kernel-hardening@lists.openwall.com,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: Stop printing the virtual memory layout
Message-ID: <202003051310.F4AC41A@keescook>
References: <202003021038.8F0369D907@keescook>
 <20200305151010.835954-1-nivedita@alum.mit.edu>
 <f672417e-1323-4ef2-58a1-1158c482d569@physik.fu-berlin.de>
 <31d1567c4c195f3bc5c6b610386cf0f559f9094f.camel@perches.com>
 <3c628a5a-35c7-3d92-b94b-23704500f7c4@physik.fu-berlin.de>
 <20200305154657.GA848330@rani.riverdale.lan>
 <456fddd9-c980-b0f2-9dd0-19befee7861e@physik.fu-berlin.de>
 <20200305155628.GA857024@rani.riverdale.lan>
 <20200305205158.GF6506@cisco>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305205158.GF6506@cisco>

On Thu, Mar 05, 2020 at 01:51:58PM -0700, Tycho Andersen wrote:
> On Thu, Mar 05, 2020 at 10:56:29AM -0500, Arvind Sankar wrote:
> > On Thu, Mar 05, 2020 at 04:49:22PM +0100, John Paul Adrian Glaubitz wrote:
> > > On 3/5/20 4:46 PM, Arvind Sankar wrote:
> > > > Not really too late. I can do s/pr_info/pr_devel and resubmit.
> > > > 
> > > > parisc for eg actually hides this in #if 0 rather than deleting the
> > > > code.
> > > > 
> > > > Kees, you fine with that?
> > > 
> > > But wasn't it removed for all the other architectures already? Or are these
> > > changes not in Linus' tree yet?
> > > 
> > > Adrian
> > 
> > The ones mentioned in the commit message, yes, those are long gone. But
> > I don't see any reason why the remaining ones (there are 6 left that I
> > submitted patches just now for) couldn't switch to pr_devel instead.
> 
> If you do happen to re-send with pr_debug() instead, feel free to add

(FYI, pr_devel() was suggested, not pr_debug() -- the former is
compile-time enabled with DEBUG and the latter can be enabled dynamically
in some cases in the kernel, so pr_debug() should not be used.)

> my ack to that series as well. But in any case, this one is also:
> 
> Acked-by: Tycho Andersen <tycho@tycho.ws>

Same for me. :) Consider the series:

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
