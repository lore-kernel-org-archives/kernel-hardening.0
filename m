Return-Path: <SRS0=YtyF=4F=lists.openwall.com=kernel-hardening-return-17823-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34291C34022
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Feb 2020 18:24:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 88E4D20836
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Feb 2020 18:24:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="C1iP7TA1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88E4D20836
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17823-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30085 invoked by uid 550); 17 Feb 2020 18:24:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30051 invoked from network); 17 Feb 2020 18:24:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0srqEljW8b3TKAGarpdMoBnqDEjP8vjgl3sbj3TcwTE=;
        b=C1iP7TA1/3mF/Gv5AtvUgORE6v+Pf7ChrbCJ1D+9ghcgzmL2YQSu++hq+QXnG9fMTJ
         l1eCk0MR+ejTctaRP0HXwlY42lEzuCNNkBW0oPSGousoRZqjS65Csp36gjM7QRv1r/PP
         ua+sg5CEO68iOP1LiEuZfjD133Yr2RAZNU6Mk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0srqEljW8b3TKAGarpdMoBnqDEjP8vjgl3sbj3TcwTE=;
        b=IUs9eAnpHVubkrYobhKlcEW62BU9i9Xs9udx7AiWxZRPocoPdOVY2MHKD29mP1p6UJ
         xVDXMMjHTbKCzgRByUE1+8TabKiCEWH1W6sW1zWr8wgBRtK3fq1ZpSWX6ymBJj/VknrK
         TjuznK4sxWxPP1Ka2sy6fbyVOZYyQ6MZouSmlpqOA9KbY2+d5bHTQKYwxFm10pSSt2Ki
         RhieukOnghNdrdjCgtOIRa/C6hUo95O+w5ORgvNAgkg75FF9FGuQZUbxUK5lVS/qXNOA
         DhuNBb3uxz1+MbOFWZpv9Al15+VU078v53yiadBoGllqpvNZPSi2582qLctRIM5IcRMB
         WTMA==
X-Gm-Message-State: APjAAAW/I0GHkyPvdhs6Hlud2owhOy0y0i0EaaZWADTyQFN+ljLDtoy3
	MDcdyxzKTKsR4vmK5DlhxaN4UQ==
X-Google-Smtp-Source: APXvYqwUN/fCTmVy1iJMEoHfXaCl7sLbCmRahiC3AgpcPHlFkSJYRwR6M52Y86DwbNsdflSYmrmRXw==
X-Received: by 2002:a63:7254:: with SMTP id c20mr16464913pgn.75.1581963837711;
        Mon, 17 Feb 2020 10:23:57 -0800 (PST)
Date: Mon, 17 Feb 2020 10:23:55 -0800
From: Kees Cook <keescook@chromium.org>
To: zerons <zeronsaxm@gmail.com>
Cc: Alexander Popov <alex.popov@linux.com>,
	Andrey Konovalov <andreyknvl@google.com>,
	kernel-hardening@lists.openwall.com, Shawn <citypw@gmail.com>,
	spender@grsecurity.net
Subject: Re: Maybe inappropriate use BUG_ON() in CONFIG_SLAB_FREELIST_HARDENED
Message-ID: <202002171019.A7B4679@keescook>
References: <e535d698-5268-e5fc-a238-0649c509cc4f@gmail.com>
 <CAAeHK+y-FdpH20Z7HsB0U+mgD9CK0gECCqShXFtFWpFp01jAmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeHK+y-FdpH20Z7HsB0U+mgD9CK0gECCqShXFtFWpFp01jAmA@mail.gmail.com>

On Mon, Feb 17, 2020 at 04:15:44PM +0100, Andrey Konovalov wrote:
> On Thu, Feb 13, 2020 at 4:43 PM zerons <zeronsaxm@gmail.com> wrote:
> >
> > Hi,
> >
> > In slub.c(https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/slub.c?h=v5.4.19#n305),
> > for SLAB_FREELIST_HARDENED, an extra detection of the double free bug has been added.
> >
> > This patch can (maybe only) detect something like this: kfree(a) kfree(a).
> > However, it does nothing when another process calls kfree(b) between the two kfree above.
> >
> > The problem is, if the panic_on_oops option is not set(Ubuntu 16.04/18.04 default option),
> > for a bug which kfree an object twice in a row, if another process can preempt the process
> > triggered this bug and then call kmalloc() to get the object, the patch doesn't work.
> >
> > Case 0: failure race
> > Process A:
> >         kfree(a)
> >         kfree(a)
> > the patch could terminate Process A.
> >
> > Case 1: race done
> > Process A:
> >         kfree(a)
> > Process B:
> >         kmalloc() -> a
> > Process A:
> >         kfree(a)
> > the patch does nothing.
> >
> > The attacker can check the return status of process A to see if the race is done.
> >
> > Without this extra detection, the kernel could be unstable while the attacker
> > trying to do the race.

The check was just for the trivial case. It was an inexpensive check,
but was never designed to be a robust double-free defense.

> > In my opinion, this patch can somehow help attacker exploit this kind of bugs
> > more reliable.

Why do you think this makes races easier to win?

> +Alexander Popov, who is the author of the double free check in
> SLAB_FREELIST_HARDENED.
> 
> Ah, so as long as the double free happens in a user process context,
> you can retry triggering it until you succeed in winning the race to
> reallocate the object (without causing slab freelist corruption, as it
> would have had happened before SLAB_FREELIST_HARDENED). Nice idea!

Do you see improvements that could be made here?

-- 
Kees Cook
