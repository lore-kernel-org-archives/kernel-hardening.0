Return-Path: <SRS0=Zs6o=WZ=lists.openwall.com=kernel-hardening-return-16831-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F34C3A59F
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 18:36:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 243C6205C9
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 18:36:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WTQPrfM+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 243C6205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16831-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5533 invoked by uid 550); 29 Aug 2019 18:36:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5497 invoked from network); 29 Aug 2019 18:36:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lfSfLCrT5r+uoCR1cVKZTVeHWOMnqZIzdT9cIpXjvs4=;
        b=WTQPrfM+DuNFtYRnM4lfwCcYrgz38e+GcP+XP5bquQ3iOgIABl5SAz+BSWT6cquod2
         sl72IDRs3WUlOY118i+zzvykbaHEixHuHKrxMgH6jmcFY9txGtwize/IxuYRoFUadPYD
         Bxht/+h4DDT+CldVlhirvRYediK4ZeRMiMiVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lfSfLCrT5r+uoCR1cVKZTVeHWOMnqZIzdT9cIpXjvs4=;
        b=ZjeJevkkAU8QsrRZ2u67U0fEVKWTRXweL/jBsU5c/Prrt8QTkrj/A72Bz6navMmO92
         QIfuwS3PBuGXlZ64k84myHmUH2zx0/yQvpnEydOpLIthmaXGYgsTmAqDaC6kDGtTSYVl
         DQbiCksRDUW+KD5ARuuMpHCHAdlw60yUD4HGiHZ0SjRaQ4rHRV/A9Uhr+N2IleQeb67A
         klJyGQXTYOrDISfWgfJCxSbu1hkmWuCm3u2J0Ayva6JEWSxU5aDFbr4003DoiwI2bgTk
         dEGh3aXwsGi5a9IY6GVDXLQvbkGKhfAji8uajiUEgVGMD2zIZr/XnPKCmG3z9hClx3Ui
         5hgg==
X-Gm-Message-State: APjAAAWYoe1u3ZwgR87I8WlKI4H2gSWiqvxBCKJXwQc6X7LsZdvX0Jut
	yBU0HX/s3ofQGwuPgcToQi6jrg==
X-Google-Smtp-Source: APXvYqxrBG96hEmJOJCRPB3pWWfhxEOO2XxB5VczVK2C6V4CVcTPjZiXakYMGz/oAX/418jWOAXMeQ==
X-Received: by 2002:a63:f13:: with SMTP id e19mr9656214pgl.132.1567103753795;
        Thu, 29 Aug 2019 11:35:53 -0700 (PDT)
Date: Thu, 29 Aug 2019 11:35:51 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: refactor tasklets to avoid unsigned long argument
Message-ID: <201908291118.2ADF97C@keescook>
References: <201907020849.FB210CA@keescook>
 <CABgxDoJ6ra4DoPzEk8w25e0iTSHtNuYanHT-s+30JSzjfWestQ@mail.gmail.com>
 <201907031513.8E342FF@keescook>
 <CABgxDoLz76_nTqpdqMMH6+i1ia3k2bgiHkTV4Gc9X7vCe=CKRA@mail.gmail.com>
 <201907221017.F61AFC08E@keescook>
 <CABgxDo+FSk0Tkvu=uFd5tjd+6TnnkwxwrP1a0QLBSkhhJ4CqUw@mail.gmail.com>
 <CABgxDo+ys-84ifkAMQp2Snv2PV4yTEYwi+3Jj9aGARn0hbhuWQ@mail.gmail.com>
 <201908081344.B616EB365F@keescook>
 <20190812172951.GA5361@debby.home>
 <20190829181321.GA6213@debby.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829181321.GA6213@debby.home>

On Thu, Aug 29, 2019 at 08:13:21PM +0200, Romain Perier wrote:
> On Mon, Aug 12, 2019 at 07:29:51PM +0200, Romain Perier wrote:
> 
> Hi !
> 
> https://salsa.debian.org/rperier-guest/linux-tree/tree/tasklet_init
> 
> It is mostly done ! I have just finished the commit for removing the data field
> ... and... I have completly forgot the macro DECLARE_TASKLET() :=D . Well, it
> is not a big issue because there are only few calls.

Heh, oops. Yeah, I kept tripping over things like that with the
timer_struct too.

> What I can do is the following:
> 
> 1. After the commit that convert all tasklet_init() to tasklet_setup(),
> I can a new commit that modifies the content of DECLARE_TASKLET()
> (pass the pointer of the callback as .data) and convert the callback of all
> DECLARE_TASKLET() for handling the argument with from_tasklet() correctly
> 
> 2. Then the commit for removing the .data field in the tasklet_struct
> structure that also removes the data field in DECLARE_TASKLET() (without
> changing the API of the macro, I just remove the field data from the
> content of the macro)

Yup, I think that's the best approach. The .data removal is basically
the last step (well, and the removal of tasklet_init() and the
TASKLET_*_TYPE macros).

Also, looking at your tree: I don't think you need to add the cocci
script to the tree (since you'll just be removing it). I just included
the script in my commit log for the bulk refactoring commit.

In the "tasklet: Prepare to change tasklet callback argument type"
commit, perhaps reference the timer_struct conversion series too, if
people want to see the earlier conversion methods.

English nit pick: "Prepare to the new tasklet API" I would phrase as
"Prepare to use the new tasklet API" or "Prepare for new tasklet API".

-- 
Kees Cook
