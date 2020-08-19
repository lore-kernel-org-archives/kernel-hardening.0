Return-Path: <SRS0=8Dpi=B5=lists.openwall.com=kernel-hardening-return-19660-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991F7C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Aug 2020 23:36:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E7C902076E
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Aug 2020 23:36:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RYffqW5j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7C902076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19660-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23580 invoked by uid 550); 19 Aug 2020 23:36:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23558 invoked from network); 19 Aug 2020 23:36:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OL8pogAZ7nK/GHwOhHpYX84wczTBnNXhUKszoax97yw=;
        b=RYffqW5j0gjcmqcAj0G4MNruh3ppWqpBsZ8QlvxrvGV6E83CWwux4WS6qnUuvz51sr
         E4NgGnt7fx4sHD6mIqOgU+uA98mMhWEO2MXccxzbH4uSQ2urHK6W+Zr7hPVMgV/c8r+g
         0DTIsord8MCQKQPhvMj67W6EgsU2F5nK7rUZw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OL8pogAZ7nK/GHwOhHpYX84wczTBnNXhUKszoax97yw=;
        b=TI9siEEn48g2CwozIztBUr4Hgi0gahGLpXl17Dv3Rx5Qk6ctqRRBX40u24A3UjDgc8
         ASJiZleCdqlQtjlqpQ2FCV5RlqaHKzGv6P58JHzQEWIdAr/q+o6Z+PSSFTwzuPiOHRQC
         a24qNq9CF3XKrPnMRhrNm5rTx0+0W+j37Yzctw8HGcUM+bSY9r9i8C0J/xEJnsqJiWRm
         HecJ7mZhJ61YaWMnDdeCe7WPzmbssEJPQ71ANTWLTsSqS7uVXFOl8qXBRXc08vlHLKh3
         p46RVr23S26Y4dThrunGWykNwVl/rXM8TCJh+xo0GkycKIEmWEwn5RPzCcngHAGUiy5k
         AQpw==
X-Gm-Message-State: AOAM533yjrYfAvWL0DHBP4vF7AU/3NkBkuliuppSdUHmD65BEMOFxpnc
	Z/Tp8kOrtLMrDeM8Nrl2s79I5Q==
X-Google-Smtp-Source: ABdhPJztG561lgarz0fyj0g5MgwaALC3qNQDwRg7Mg7XodZzm8ie+lc4uJ10jF+RtiVvGy+Gslmjlw==
X-Received: by 2002:a17:90a:c682:: with SMTP id n2mr239820pjt.72.1597880175006;
        Wed, 19 Aug 2020 16:36:15 -0700 (PDT)
Date: Wed, 19 Aug 2020 16:36:10 -0700
From: Kees Cook <keescook@chromium.org>
To: Jirka Hladky <jhladky@redhat.com>
Cc: Alexander Potapenko <glider@google.com>,
	kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org
Subject: Re: init_on_alloc/init_on_free boot options
Message-ID: <202008191626.1420C63231@keescook>
References: <CAE4VaGD8sKqUgOxr0im+OJgwrLxbbXDaKTSqpyAGRx=rr9isUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE4VaGD8sKqUgOxr0im+OJgwrLxbbXDaKTSqpyAGRx=rr9isUg@mail.gmail.com>

On Thu, Aug 20, 2020 at 12:18:33AM +0200, Jirka Hladky wrote:
> Could you please help me to clarify the purpose of init_on_alloc=1
> when init_on_free is enabled?

It's to zero memory at allocation time. :) (They are independent
options.)

> If I get it right, init_on_free=1 alone guarantees that the memory
> returned by the page allocator and SL[AU]B is initialized with zeroes.

No, it's guarantees memory freed by the page/slab allocators are zeroed.

> What is the purpose of init_on_alloc=1 in that case? We are zeroing
> memory twice, or am I missing something?

If you have both enabled, yes, you will zero twice. (In theory, if you
have any kind of Use-After-Free/dangling pointers that get written
through after free and before alloc, those contents wouldn't strictly be
zero at alloc time without init_on_alloc. But that's pretty rare.

I wouldn't expect many people to run with both options enabled;
init_on_alloc is more performance-friendly (i.e. cache-friendly), and
init_on_free minimizes the lifetime of stale data in memory.

It appears that the shipping kernel defaults for several distros (Ubuntu,
Arch, Debian, others?) and devices (Android, Chrome OS, others?) are using
init_on_alloc=1. Will Fedora and/or RedHat be joining this trend?  :)

-- 
Kees Cook
