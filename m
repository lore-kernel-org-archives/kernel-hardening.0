Return-Path: <SRS0=gNjB=2B=lists.openwall.com=kernel-hardening-return-17496-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA26C43603
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Dec 2019 16:57:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4688422527
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Dec 2019 16:57:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HBOJcsNd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4688422527
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17496-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1404 invoked by uid 550); 11 Dec 2019 16:56:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1367 invoked from network); 11 Dec 2019 16:56:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W/d+yr7KgXhByLIpgiEXK6Nig0QpxVVQC2tZ5bF2Qi4=;
        b=HBOJcsNdTBlNX6VV247RVW5qKsZHF5VRW9GkWI2cfEQNZl0iQHXABCyKEYeryURNzj
         7tOK+ChcTVeCuqyS4wnIqFFDYqSF9Qr3nJB088cZ7viuZXEAKVKviEdG0IPtoyWoFQK/
         4behDRcRLfbTHFpCzY/5xPHUxQnrJhTOi9DDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W/d+yr7KgXhByLIpgiEXK6Nig0QpxVVQC2tZ5bF2Qi4=;
        b=glPUTK/DEbuSYPK9EXQxB5RALNOiDwgQoaS1Bc1e6bbLSKfAtllIp51rbSwxBXIzuT
         GgluL58E2n5r3kSdiXk64SvgBvthhYEw2TMw8rJrIvyIwKZcAYsynKGi6++R8tJEOiMa
         FTg0nFmgHhkhqgwOHy8uwAFVLcaTRdMsQxs2r6qk38/SqGPZnJ5vI+zPGD+sp3ZgiAE5
         rWdQ6K+9YzUTBBDrRHEvDNvMAXiuj91rEe1MGTHvs6Kx7mAzZ/709qYEh06ZRiu/Qj6d
         ANqvOUCCmEFXtS6jyPJWIcWP43H9cAaPO1m8Meb/TdGd5mIZ5vX+S+xOhiSTRZHQQTTp
         CQHQ==
X-Gm-Message-State: APjAAAXMoANl+9uhhRihQ2Xkss8CEKKNG+yMWFtAujEsUPvCyZOI8rSn
	ZOS5PuKJbytxJ9r6Ha5QkBhzYg==
X-Google-Smtp-Source: APXvYqxxqFgQ0KcWGPjJAFVZZdrg6lYFk8iN9apUOHaKqroVoJJoC93SAs2D/iq3g2HZJ6ssQx4S0A==
X-Received: by 2002:a17:90a:e2ce:: with SMTP id fr14mr4441253pjb.99.1576083406113;
        Wed, 11 Dec 2019 08:56:46 -0800 (PST)
Date: Wed, 11 Dec 2019 08:56:44 -0800
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>,
	io-uring <io-uring@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 07/11] io_uring: use atomic_t for refcounts
Message-ID: <201912110851.88536F3F@keescook>
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-8-axboe@kernel.dk>
 <CAG48ez3yh7zRhMyM+VhH1g9Gp81_3FMjwAyj3TB6HQYETpxHmA@mail.gmail.com>
 <02ba41a9-14f2-e3be-f43f-99f311c662ef@kernel.dk>
 <201912101445.CF208B717@keescook>
 <d6ff9af3-5e72-329c-4aed-cbe6d9373235@kernel.dk>
 <20191211102012.GA4123@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211102012.GA4123@willie-the-truck>

On Wed, Dec 11, 2019 at 10:20:13AM +0000, Will Deacon wrote:
> On Tue, Dec 10, 2019 at 03:55:05PM -0700, Jens Axboe wrote:
> > On 12/10/19 3:46 PM, Kees Cook wrote:
> > > On Tue, Dec 10, 2019 at 03:21:04PM -0700, Jens Axboe wrote:
> > >> On 12/10/19 3:04 PM, Jann Horn wrote:
> > >>> [context preserved for additional CCs]
> > >>>
> > >>> On Tue, Dec 10, 2019 at 4:57 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >>>> Recently had a regression that turned out to be because
> > >>>> CONFIG_REFCOUNT_FULL was set.
> > >>>
> > >>> I assume "regression" here refers to a performance regression? Do you
> > >>> have more concrete numbers on this? Is one of the refcounting calls
> > >>> particularly problematic compared to the others?
> > >>
> > >> Yes, a performance regression. io_uring is using io-wq now, which does
> > >> an extra get/put on the work item to make it safe against async cancel.
> > >> That get/put translates into a refcount_inc and refcount_dec per work
> > >> item, and meant that we went from 0.5% refcount CPU in the test case to
> > >> 1.5%. That's a pretty substantial increase.
> > >>
> > >>> I really don't like it when raw atomic_t is used for refcounting
> > >>> purposes - not only because that gets rid of the overflow checks, but
> > >>> also because it is less clear semantically.
> > >>
> > >> Not a huge fan either, but... It's hard to give up 1% of extra CPU. You
> > >> could argue I could just turn off REFCOUNT_FULL, and I could. Maybe
> > >> that's what I should do. But I'd prefer to just drop the refcount on the
> > >> io_uring side and keep it on for other potential useful cases.
> > > 
> > > There is no CONFIG_REFCOUNT_FULL any more. Will Deacon's version came
> > > out as nearly identical to the x86 asm version. Can you share the
> > > workload where you saw this? We really don't want to regression refcount
> > > protections, especially in the face of new APIs.
> > > 
> > > Will, do you have a moment to dig into this?
> > 
> > Ah, hopefully it'll work out ok, then. The patch came from testing the
> > full backport on 5.2.

Oh good! I thought we had some kind of impossible workload. :)

> > Do you have a link to the "nearly identical"? I can backport that
> > patch and try on 5.2.
> 
> You could try my refcount/full branch, which is what ended up getting merged
> during the merge window:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=refcount/full

Yeah, as you can see in the measured tight-loop timings in
https://git.kernel.org/linus/dcb786493f3e48da3272b710028d42ec608cfda1
there was 0.1% difference for Will's series compared to the x86 assembly
version, where as the old FULL was almost 70%.

-- 
Kees Cook
