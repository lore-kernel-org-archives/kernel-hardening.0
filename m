Return-Path: <SRS0=Irw0=CJ=lists.openwall.com=kernel-hardening-return-19714-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10FAC433E2
	for <kernel-hardening@archiver.kernel.org>; Mon, 31 Aug 2020 19:21:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4F12620EDD
	for <kernel-hardening@archiver.kernel.org>; Mon, 31 Aug 2020 19:21:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oK07dzDK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F12620EDD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19714-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13892 invoked by uid 550); 31 Aug 2020 19:21:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13859 invoked from network); 31 Aug 2020 19:21:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aa6aqn9122tGXBIpDI/AOlNftMS4Am5GJG39E8WwFfA=;
        b=oK07dzDKLtkSju8l9ALxgilzzB6XyF7O11Ve5INwmv9RKxq6X36t3jepvEa5q8CNqs
         TnmOG3KimNaMU/2QJZZ1ZseeeftJzZhBJRYVE+X+h8r2dD+PpN55WEfZtkgxQEzKKi2P
         GRBwmyN3gz8I1f9OM5aPxOXu8hnJ7LGKCdWDI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aa6aqn9122tGXBIpDI/AOlNftMS4Am5GJG39E8WwFfA=;
        b=Uc8KcRIkOBCErg2gJZdPZX9A+NlACEa5uN9o8P6ztpsqUzkb+eQGUwCxrgE21l8ROy
         VHIteexoHb4vGhcYpmTCH2PTq8I1dWBhQXJduDB6ywUzNAFvmq4P7U39JCQmfS1magV7
         P89qnZgNvu8/NPvD0+vUK+sNjyVLombE40F6RyQQnFsesWLWgUIyRekPmQJ9oCB+XV+4
         VIe9e64UD5sGl2OPiy+bE0eVaKnShbsjUdQPlZxBHqmfdEoF/ZvdGry9uL4Qoan17/ce
         guInZzBmbx1jX5H+vMqb8g3s5LurHPuXjUmaDcAPPrIc3uN2Okw3OJJ9IhoejVOqE/3t
         Ejkw==
X-Gm-Message-State: AOAM533SdBL71Ey6JXaG/gkFOVwcmLPFztsCREqQhTgYgo3mZfwowsOo
	aiK9RWraFNlFfGDvA60oJ1oOPQ==
X-Google-Smtp-Source: ABdhPJznehFObRR7Lqvf/9fzo6cME8RmsOZeOGJe7GmzGTye7ow0uvkdJkEz07x9Bk2sjUXZ2j/2bg==
X-Received: by 2002:a17:90b:4a51:: with SMTP id lb17mr692847pjb.235.1598901648253;
        Mon, 31 Aug 2020 12:20:48 -0700 (PDT)
Date: Mon, 31 Aug 2020 12:20:45 -0700
From: Kees Cook <keescook@chromium.org>
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mrinal Pandey <mrinalmni@gmail.com>, skhan@linuxfoundation.org,
	Linux-kernel-mentees@lists.linuxfoundation.org, re.emese@gmail.com,
	maennich@google.com, tglx@linutronix.de, gregkh@linuxfoundation.org,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
	linux-spdx@vger.kernel.org
Subject: Re: [PATCH] scripts: Add intended executable mode and SPDX license
Message-ID: <202008311219.8ECE17B6B@keescook>
References: <20200827092405.b6hymjxufn2nvgml@mrinalpandey>
 <20200830174409.c24c3f67addcce0cea9a9d4c@linux-foundation.org>
 <alpine.DEB.2.21.2008310714560.8556@felia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2008310714560.8556@felia>

On Mon, Aug 31, 2020 at 07:45:25AM +0200, Lukas Bulwahn wrote:
> 
> 
> On Sun, 30 Aug 2020, Andrew Morton wrote:
> 
> > On Thu, 27 Aug 2020 14:54:05 +0530 Mrinal Pandey <mrinalmni@gmail.com> wrote:
> > 
> > > commit b72231eb7084 ("scripts: add spdxcheck.py self test") added the file
> > > spdxcheck-test.sh to the repository without the executable flag and license
> > > information.
> > 
> > The x bit shouldn't matter.
> > 
> > If someone downloads and applies patch-5.9.xz (which is a supported way
> > of obtaining a kernel) then patch(1) will erase the x bit anyway.
> >
> 
> Andrew, Kees,
> 
> thanks for the feedback.
> 
> As his mentor, I see two valuable tasks for Mrinal to work on:
> 
> 1. Document this knowledge how scripts should be called, not relying on 
> the executable bit, probably best somewhere here:
> ./Documentation/kbuild/makefiles.rst, a new section on using dedicated 
> scripts in chapter 3 ("The  kbuild files").
> 
> https://www.kernel.org/doc/html/latest/kbuild/makefiles.html#the-kbuild-files

Yes, that would be excellent.

> 2. Determine if there are places in the build Makefiles that do rely on 
> the executable bit and fix those script invocations. (Kees' idea of remove 
> all executable bits and see...)

I think this has value, yes. I don't think patches to remove the x bits
are needed, but any cases where they are depended on need to be fixed.

And I think "3" could be "wire up or remove spdx shell script"

-- 
Kees Cook
