Return-Path: <SRS0=qxVV=6Z=lists.openwall.com=kernel-hardening-return-18750-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 446DEC54E8E
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 May 2020 16:15:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 98686206DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 May 2020 16:15:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UDnQ8rb5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98686206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18750-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1045 invoked by uid 550); 11 May 2020 16:15:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32752 invoked from network); 11 May 2020 16:15:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UXxWyws2LadwTX+een4hFyGMT5uLqqad3ucVUoN1fJM=;
        b=UDnQ8rb5Up4aZykhqT13QD+yq8GS9TgGsCtjb+B8kZ1s2IYczQPA5n09ToCZHLmolC
         psySCzF993GZ9uJ1ltr5wjxtA4emnYvtq1gp+At7iqurdhWjE0DQyg/MD3chLb3Zho0L
         SMU5AkyHfEwO+WuQ+a1TwcUDGgO5LTfN26OfU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UXxWyws2LadwTX+een4hFyGMT5uLqqad3ucVUoN1fJM=;
        b=CEi+8gdLdrCOl3+u8mkDgurB/2a7GGvLSs4PVk+qLXdrr1IkERRu+kA0KuOgxAJH2D
         25G0PN5ZuF5NBx6QwlVbesBYQM3ENttP7fWyQmE+cZ2JTJ5JXdE9ZuzH1BF2TrFSU2FR
         C7jcEoOirWr5orkZPgLiJyd5WAeu2UgA+pTB0u8yI44aUHZqITUeXSEiWsvjaZRnKWBI
         sCueJ6fSCElhxQsYUntlPP3tUjxpH9NPcCJ5zYIS2NEQaz/xMpqogMibC70r6iPzYasE
         fiB7v50IeMv4Y0LDEvDP4rfiSLdfZRvzN5bqrp6sely103XDGo/sZpGPAfJJa5yMTgma
         P9+Q==
X-Gm-Message-State: AGi0PuZetI66vtSxUWNEwANActFP7lR29QIgr8wN401NC9xTs1U/rRZJ
	z8wRM1ZIfSU+MFNClwcN3vcurQ==
X-Google-Smtp-Source: APiQypJN7McBO3fRNpsMnCmhYSAlFJx2x6BEk70EbXm0tbh06oHndOZBLKc7kK0LZS3+CE+ghmOlNg==
X-Received: by 2002:a62:e51a:: with SMTP id n26mr16708082pff.301.1589213720211;
        Mon, 11 May 2020 09:15:20 -0700 (PDT)
Date: Mon, 11 May 2020 09:15:18 -0700
From: Kees Cook <keescook@chromium.org>
To: Oscar Carter <oscar.carter@gmx.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: Get involved in the KSPP
Message-ID: <202005110912.3A26AF11@keescook>
References: <20200509122007.GA5356@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509122007.GA5356@ubuntu>

On Sat, May 09, 2020 at 02:20:08PM +0200, Oscar Carter wrote:
> Hi, my name is Oscar. I would like to get involved in the kernel self protection
> project because I love the software security and I think this is one of the most
> challenging fields.

Hi Oscar! Welcome to the mailing list. :)

> I have experience in microcrontrollers and working with low level software, but
> my experience with the linux kernel development is a few commits in the staging
> area.
> 
> For now, and due to my low experience with the linux kernel code and software
> security, I do not care about the area and task to be done. What I pretend is to
> help this great community and improve my knowledge and skills in this
> challenging field.
> 
> So, I would like to know if I can be assigned to some task that suits me. I've
> taken a look at https://github.com/KSPP/linux/issues but I don't know which task
> to choose and if someone else is working on it.

There's "good first issue" label that might help you choose things:
https://github.com/KSPP/linux/labels/good%20first%20issue

One mostly mechanical bit of work would be this:
https://github.com/KSPP/linux/issues/20
There are likely more fixes needed to build the kernel with
-Wcast-function-type (especially on non-x86 kernels). So that would let
you learn about cross-compiling, etc.

Let us know what you think!

Take care,

-- 
Kees Cook
