Return-Path: <SRS0=HiWe=4O=lists.openwall.com=kernel-hardening-return-17967-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF8FEC4BA24
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 21:57:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1ADB521D7E
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 21:57:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CVWa98Uw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ADB521D7E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17967-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19924 invoked by uid 550); 26 Feb 2020 21:57:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19892 invoked from network); 26 Feb 2020 21:57:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=agTSg4xTvTJ902v/wRSeSnCJDmYFaVhC2jp/Gq4x83M=;
        b=CVWa98Uw4W2DSuAZ6nw8SSnOHBSkNazKVCAoUkannuWdT6ct919lXMS1jGfBN/0TGA
         vi1r29dNanFqfnfQjHgMsWQeCfa8dPlKyRhtjdPBabDi/YdPfx1Nd5hK0amb+n6+XDYz
         3A6pmEuOxzK9cvXLOsHwTn/z5Ld4PVK8tO180=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=agTSg4xTvTJ902v/wRSeSnCJDmYFaVhC2jp/Gq4x83M=;
        b=Iw1xeX7apSZARPMJ8fD7jFRnKXva4AfiaKR9C3kijC2g0Vpxrt7IXvaQDuF8ZEt3jr
         KMdCmm97UXJuNqWsGy07t/zRyzBRWz2JhgQmG04wyi7w5WzuGBqc9Xh49VMXsIKQ0A0o
         oh/kTWY+7i8f6EM5Ac6lEXjnSAJNqNpCe99RxlY7rMmDY4YLVOdJ6qBvHPXAulhfkKZM
         dj7MjAn4NabhS+70qEJAe+YQNFeMuOw9oSdDfC3BWOfmAzEwT97xakePHgcAZj5b5sSV
         lODoAwP3fBcMRdQpIw5lytMeuzZDlUy6EIHXE07rKN55ZT2mM0qEkEDE38ML0xSI1OLS
         Lnwg==
X-Gm-Message-State: APjAAAWs6LgFrHXWvcSfvT+sCpoHa9avMaa/FWeca1fVd9J/JpfPd43A
	r28Es3zszPa6233wqsfUIRTq9w==
X-Google-Smtp-Source: APXvYqyJGeL4QW5uWg6MxaWO+Pm23Yck/xgVU4oSTq3yCWFAC8LuFM9MWFMSX+jv/vuaDnFk8SNXQA==
X-Received: by 2002:aa7:95b0:: with SMTP id a16mr688779pfk.253.1582754217916;
        Wed, 26 Feb 2020 13:56:57 -0800 (PST)
Date: Wed, 26 Feb 2020 13:56:56 -0800
From: Kees Cook <keescook@chromium.org>
To: Daniel Axtens <dja@axtens.net>
Cc: Daniel Micay <danielmicay@gmail.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux-MM <linux-mm@kvack.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/5] [RFC] mm: annotate memory allocation functions with
 their sizes
Message-ID: <202002261356.B632368@keescook>
References: <20200120074344.504-1-dja@axtens.net>
 <20200120074344.504-6-dja@axtens.net>
 <CA+DvKQJ6jRHZeZteqY7q-9sU8v3xacSPj65uac3PQfst4cKiMA@mail.gmail.com>
 <202002251035.AD29F84@keescook>
 <87wo89rieh.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo89rieh.fsf@dja-thinkpad.axtens.net>

On Wed, Feb 26, 2020 at 05:07:18PM +1100, Daniel Axtens wrote:
> Kees Cook <keescook@chromium.org> writes:
> 
> > On Fri, Feb 07, 2020 at 03:38:22PM -0500, Daniel Micay wrote:
> >> There are some uses of ksize in the kernel making use of the real
> >> usable size of memory allocations rather than only the requested
> >> amount. It's incorrect when mixed with alloc_size markers, since if a
> >> number like 14 is passed that's used as the upper bound, rather than a
> >> rounded size like 16 returned by ksize. It's unlikely to trigger any
> >> issues with only CONFIG_FORTIFY_SOURCE, but it becomes more likely
> >> with -fsanitize=object-size or other library-based usage of
> >> __builtin_object_size.
> >
> > I think the solution here is to use a macro that does the per-bucket
> > rounding and applies them to the attributes. Keep the bucket size lists
> > in sync will likely need some BUILD_BUG_ON()s or similar.
> 
> I can have a go at this but with various other work projects it has
> unfortunately slipped way down the to-do list. So I've very happy for
> anyone else to take this and run with it.

Sounds good. I've added the above note from Micay to the KSPP bug tracker:
https://github.com/KSPP/linux/issues/5

Thanks for bringing this topic back up!

-- 
Kees Cook
