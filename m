Return-Path: <SRS0=tJq9=XZ=lists.openwall.com=kernel-hardening-return-16976-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE50CC32792
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Sep 2019 23:07:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 433642086A
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Sep 2019 23:07:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hUuH4bQ5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 433642086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16976-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3661 invoked by uid 550); 30 Sep 2019 23:07:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3624 invoked from network); 30 Sep 2019 23:07:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cr3eQPwLdTJ6o27POy2W2qtLAUu+UzKXjcAxLDLJlM8=;
        b=hUuH4bQ5gqcS2zRF4VYLrd+qWM6VbFgE5j2apvBbkqomZR5bo7ooi4tjkYiW+0rsMW
         eLtb3MeUdCIinocF4VRCXZl0iF569LTdKCXu5GADWvSN79p0odRg7U/jsHRWFd0pgg6S
         c3JglgwyfdN7Hb0FKJNT9/C5Y5PUrvKUphuHs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cr3eQPwLdTJ6o27POy2W2qtLAUu+UzKXjcAxLDLJlM8=;
        b=oGiwtyYLsFsuPqghyr7dQS7RDuDmxZAq3dqvwwpW5efMGtPxT8Geh50+lO5QZS2E30
         qawFCcu7NFFdLDfabDxxKd9485Y1F1Trp542aGb3R/eLOMqccd9H4pBCPvwbm7Q1MR3F
         STqmJUKquwXmb5/6WsMAGyfx38uL1D/PmqtJPc3zlfeOx/bIYbPA2/hIPc/cTMetADZD
         5UsMq5NfDeL+LJ6epyMmtz4ldyad05CdRMbTWwP68nokwCtMDyreKdRnHM+ZrTsj9VTS
         U4N9vEGFLfJB2JFckdMBn6aQJEJsjewBjrwi1hy5aPdMcz1lMaS78t7lJtuULB3yyONB
         hZdg==
X-Gm-Message-State: APjAAAUcfYL4TGpxUt+L3tfSn1Xo66RXLnWUhf/n9tQt+JzEgY3Zedz5
	9vow0DsHcLwuaznWKb6Fy1zr/n+HJ0M=
X-Google-Smtp-Source: APXvYqwMXQfOIXk9Jai0fxdNyvssXP61Rt6SMFNIBoBxJg3WGq+GJTekSkbtuKDHQTqrvSV3ArCMHQ==
X-Received: by 2002:a17:902:a9cb:: with SMTP id b11mr2576241plr.340.1569884813889;
        Mon, 30 Sep 2019 16:06:53 -0700 (PDT)
Date: Mon, 30 Sep 2019 16:06:50 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PRE-REVIEW PATCH 00/16] Modernize the tasklet API
Message-ID: <201909301552.4AAB4D4@keescook>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>

On Sun, Sep 29, 2019 at 06:30:12PM +0200, Romain Perier wrote:
> Hello,
> 
> Nowadays, modern kernel subsystems that use callbacks pass the data
> structure associated with a given callback as argument to the callback.
> The data structure specific to the driver or subsystem that uses this
> callback framework is usually "derivated" from the data structure that
> is passed as argument to the callback.
> 
> The tasklet subsystem remains the one to pass callback argument as an
> arbitrary unsigned long argument (This has several issues that are
> explained in the first commit).
> 
> This series aims to improve the tasklet API and converts all the code
> that is using it. It is based on the series for timer_list at [1].
> 
> 1. https://lore.kernel.org/patchwork/patch/835464
> 
> 
> Romain Perier (16):
>   tasklet: Prepare to change tasklet callback argument type
>   crypto: ccp - Prepare to use the new tasklet API
>   mmc: renesas_sdhi: Prepare to use the new tasklet API
>   net: liquidio: Prepare to use the new tasklet API
>   chelsio: Prepare to use the new tasklet API
>   net: mvpp2: Prepare to use the new tasklet API
>   qed: Prepare to use the new tasklet API
>   isdn: Prepare to use the new tasklet API
>   scsi: pm8001: Prepare to use the new tasklet API
>   scsi: pmcraid: Prepare to use the new tasklet API
>   treewide: Globally replace tasklet_init() by tasklet_setup()
>   tasklet: Pass tasklet_struct pointer as .data in DECLARE_TASKLET
>   tasklet: Pass tasklet_struct pointer to callbacks unconditionally
>   tasklet: Remove the data argument from DECLARE_TASKLET() macros
>   tasklet: convert callbacks prototype for using struct tasklet_struct *
>     arguments
>   tasklet: Add the new initialization function permanently

This is looking really good; thank you! I think for easier review it
would make sense to break out the "special" cases (where you're changing
structures, etc) into their own patches (and not as a bulk change --
they need review by different subsystem maintainers, etc).

Then the patch phases can be:

1) Introduce new APIs and casts
2) Convert special cases include passing the tasklet as their .data
   (while also changing the prototypes and replacing tasklet_init() with
    tasklet_setup())
3) Convert DECLARE_TASKLET() users to the same
4) Manual one-off conversions of tasklet_init() -> tasklet_setup()
5) Mechanical mass conversion of tasklet_init() -> tasklet_setup()
6) Mass removal of .data argument from DECLARE_TASKLET()
7) tasklet API internal swap and removal of .data
8) tasklet_init() and helper cast removals.

Step 1 needs to happen in an -rc1 (e.g. v5.5-rc1).

Then steps 2, 3, and 4 can happen simultaneously across all the
maintainers that need to be aware of it and land in the next release
(the linux-next for v5.6).

Finally steps 5, 6, 7, and 8 happen in the next release's -rc1
(v5.6-rc1).

If we can get the "phase 1" patch ready quick, maybe we can get into
-rc2 for v5.4 and move things up by a release...

-Kees

-- 
Kees Cook
