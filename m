Return-Path: <SRS0=nGaG=YD=lists.openwall.com=kernel-hardening-return-17009-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE7FC4360C
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 22:34:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 64DC721835
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 22:34:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VvF+VL6z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64DC721835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17009-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30533 invoked by uid 550); 10 Oct 2019 22:34:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30501 invoked from network); 10 Oct 2019 22:34:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gxB184ffpeOi6SR8F9J3qHRwveMXWowqSzNDOa6l0L8=;
        b=VvF+VL6zVmRte4cxRYP0Ekxoaecs0yWe23v1R3BuS5nq4wE+mYaVzj10XmXhgtkQPL
         xto84UCyFHPSzTLeTCaAxXXBakGf11pBhYbrI7njJN9mlr88vxxu/7iIs+lCfTAPcrJS
         crfVaXbHBmEkGniuduR9XF5DdfpzYWlWaWAQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gxB184ffpeOi6SR8F9J3qHRwveMXWowqSzNDOa6l0L8=;
        b=ZamgifEIh5zvY6gGWNY08EqjG9Q8OVut1ubN4mBDbiv+jQVSf5LpoXtU4fEav0VBC/
         5UazyEDfVq9S1zvvm3qEb548oSxSGL+l9ce8Imbx0OVXqkYKBHU1OWxNtN24bJFD8rq5
         cEON1SvwiCV4v+2b/MDIKCZJqTH2R+bse5Wm3oMgZgHrlgI+tRr9ko5vepqR86hLkXbT
         b6Y3ByIsf+Lecbm5AzLjnXrv5PhOg/WNcSuPNeJG4xprp9nnctR/2xGbkqR9RPao5UiC
         pej86nBErUhk6oYU9AXXAOTDfHAX7YXs7MXNxvXia0Xjta7s+RzHvF4O9Up6r+LUvBvG
         jYCQ==
X-Gm-Message-State: APjAAAWSKAm+trayHlFfSo8olV6IRUMyPEED8PAwPovNmtOL1bB6N6bc
	8xYOYKk87tQcR3mafkr/6cEI0w==
X-Google-Smtp-Source: APXvYqwJvEhbeWJWcNCLseBCX1j5Krp4aMW9luaCF6oN25WOAT0HDLJdmd1oHz/ee4hx5FLRjGe4qA==
X-Received: by 2002:aa7:86d6:: with SMTP id h22mr13185136pfo.72.1570746871978;
        Thu, 10 Oct 2019 15:34:31 -0700 (PDT)
Date: Thu, 10 Oct 2019 15:34:30 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PRE-REVIEW PATCH 00/16] Modernize the tasklet API
Message-ID: <201910101531.482D28315@keescook>
References: <20190929163028.9665-1-romain.perier@gmail.com>
 <201909301552.4AAB4D4@keescook>
 <20191001174752.GD2748@debby.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001174752.GD2748@debby.home>

On Tue, Oct 01, 2019 at 07:47:52PM +0200, Romain Perier wrote:
> 	=> So, one commit per driver for preparing the data structure to
> 	own a sub "struct tasklet_struct" + tasklet_init() ->
> 	tasklet_setup() with use of "from_tasklet" in the same commit.
> 	Right ?
> 
> 	For example:
> 	the commit "[PRE-REVIEW PATCH 03/16] mmc:
> 	renesas_sdhi: Prepare to use the new tasklet API"
> 
> 	would contain changes for preparing the driver to use a
> 	"struct tasklet_struct" correctly + convert the driver to
> 	the new API (tasklet_init() -> tasklet_setup())
> 
> 	Same for commit "[PRE-REVIEW PATCH 04/16] net: liquidio: Prepare
> 	to use the new tasklet API".
> 
> 	This is what you had in mind ?

Right -- the commit would be complete from a "touch-once" perspective.
The one commit completely swaps to the new API and nothing will ever
have to poke this file again. (The exception being any explicit casts
that might be rarely needed for weird direct initialization, etc: most
patches should be entirely self-contained, though they depend on the new
API from patch #1.)

> > 3) Convert DECLARE_TASKLET() users to the same
> 
> Yeah, this is what you explain in reply to "[PRE-REVIEW PATCH 12/16]
> tasklet: Pass tasklet_struct pointer as .data in DECLARE_TASKLET", right
> ?

Right -- after all the other stuff, do the the DECLARE_TASKLET changes,
with a final mechanical patch that drops the unused .data argument from
all the users.

This is all a normally thankless set of patches, so I'll go out of my
way to say again: thank you for working on this! I know how tedious it
can be from when I did timer_struct. :)

-- 
Kees Cook
