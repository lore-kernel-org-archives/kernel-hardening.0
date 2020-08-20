Return-Path: <SRS0=WJEq=B6=lists.openwall.com=kernel-hardening-return-19661-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027D0C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Aug 2020 12:08:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 518A7207BB
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Aug 2020 12:08:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I44SqANg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 518A7207BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19661-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21888 invoked by uid 550); 20 Aug 2020 12:08:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24364 invoked from network); 20 Aug 2020 00:35:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1597883718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MWnHjLON1AfOs3QMZm9Z3/r0rb/4p0ijKhFTvUBOc+k=;
	b=I44SqANg7ABKcfJm5YCpUGvkLF6qSBfJMNnKng4tFslGd+bwkBx3fYMTSUmcCAYoH2r6KM
	VUsmanVlm2SJzp0ubasL2zCA/rnl425G2FdnLc50uq6wEpm75TTcZimV6KYycEbGnVc4/C
	M9FI4Vxwxp3gD9F9EMC+xT618XaQCNI=
X-MC-Unique: 4hpfgfsSMGaIWDTHhniVnQ-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MWnHjLON1AfOs3QMZm9Z3/r0rb/4p0ijKhFTvUBOc+k=;
        b=ptyx666O5fZV/IP4GYJjeAxqRkCKq/Ij/IW9PvmiIHiDWugPciAH4TV4o8qwW1f7yn
         SqvGsgDHY0ThUlXUVX79wclKle3GZIZhw9hQNggoDbAfAhR6mj+LAVit1NtSBOcIttaA
         rczfnPKGrY1hJ7G0sjfDosCUXJmyCWVZxnWoxNEB9c7XIsSLXQVtFdmefanjasPs1OAd
         CiGLo5I8fE7CEfgJkvBWeaENs2K/aA9636hl6Ea92/Op4nQGIVswVNjCTeEGFPfwke7I
         AkZt8H1Vxa620oLLKOo4VpsyHY6nqUNaaLQ6EfTJCW7nctvIjSvF5pJeWqVqpI/qv8c8
         QBvQ==
X-Gm-Message-State: AOAM530Az/NkT6CZWdJKZykaexnIjkRu6Lie4JSfXpSuUhhZXLh75oUb
	ceCP/ekWXCZ/AnIf8qP0n7KkzHlVZKlMVOVsLuNVc8UFMG9LBs2opDHyXvLSl8ics6B2SOp5ppf
	ajJZ4SwK8uFK3ca+IADc2mLOMDYK4NHpw3YJECZO3GDaGdy7aYA==
X-Received: by 2002:a17:906:a0c5:: with SMTP id bh5mr865248ejb.120.1597883714930;
        Wed, 19 Aug 2020 17:35:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7eXB6HBV617/T7RupL6xoWk4Q/Xd1WoVjayR5ltC7LorRr4B5FkqEg13RK1ed3/MHQ5trENdPQOFI5AxyD+0=
X-Received: by 2002:a17:906:a0c5:: with SMTP id bh5mr865230ejb.120.1597883714728;
 Wed, 19 Aug 2020 17:35:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAE4VaGD8sKqUgOxr0im+OJgwrLxbbXDaKTSqpyAGRx=rr9isUg@mail.gmail.com>
 <202008191626.1420C63231@keescook>
In-Reply-To: <202008191626.1420C63231@keescook>
From: Jirka Hladky <jhladky@redhat.com>
Date: Thu, 20 Aug 2020 02:35:04 +0200
Message-ID: <CAE4VaGAGHNj0rWmTN4r5xJuN-ty2xYAsFxWwKEAod6tvMqjpUA@mail.gmail.com>
Subject: Re: init_on_alloc/init_on_free boot options
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>, kernel-hardening@lists.openwall.com, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jhladky@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Thanks a lot for the clarification! I was scratching my head if it
makes sense to enable both options simultaneously.


On Thu, Aug 20, 2020 at 1:36 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Aug 20, 2020 at 12:18:33AM +0200, Jirka Hladky wrote:
> > Could you please help me to clarify the purpose of init_on_alloc=1
> > when init_on_free is enabled?
>
> It's to zero memory at allocation time. :) (They are independent
> options.)
>
> > If I get it right, init_on_free=1 alone guarantees that the memory
> > returned by the page allocator and SL[AU]B is initialized with zeroes.
>
> No, it's guarantees memory freed by the page/slab allocators are zeroed.
>
> > What is the purpose of init_on_alloc=1 in that case? We are zeroing
> > memory twice, or am I missing something?
>
> If you have both enabled, yes, you will zero twice. (In theory, if you
> have any kind of Use-After-Free/dangling pointers that get written
> through after free and before alloc, those contents wouldn't strictly be
> zero at alloc time without init_on_alloc. But that's pretty rare.
>
> I wouldn't expect many people to run with both options enabled;
> init_on_alloc is more performance-friendly (i.e. cache-friendly), and
> init_on_free minimizes the lifetime of stale data in memory.
>
> It appears that the shipping kernel defaults for several distros (Ubuntu,
> Arch, Debian, others?) and devices (Android, Chrome OS, others?) are using
> init_on_alloc=1. Will Fedora and/or RedHat be joining this trend?  :)
>
> --
> Kees Cook
>


-- 
-Jirka

