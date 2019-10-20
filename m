Return-Path: <SRS0=Bjsb=YN=lists.openwall.com=kernel-hardening-return-17063-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70251CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Sun, 20 Oct 2019 06:07:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B8B7E222C3
	for <kernel-hardening@archiver.kernel.org>; Sun, 20 Oct 2019 06:07:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wy52xd07"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8B7E222C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17063-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22296 invoked by uid 550); 20 Oct 2019 06:07:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22262 invoked from network); 20 Oct 2019 06:07:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YCK09w6PWU3uSu7DLwK1iOj9r8NGNR+mR7i729KtO90=;
        b=Wy52xd07pgpnE6lyPI6PxBww3Zh9ymaVHCiql7MqKwXaQ7SgMR2MNOhWrT9dPupoDs
         NZ50DC7P0cDNGGGyE0T7iWOMI5eZhFmtT2L+hk7LylL6LaIlxTIDgWlUAeUFwoUA7p+j
         i4DGkxX03Tct9YSIb42M3v6pWb/6/9yGsDCkm852oX/Ic2A+OPdUrBCZizlaxCGKmv1F
         QilyEiqE33EfzX+n8ZTSUuKHAffANTDDVHiU1ZeE6jfu48v95mKBGFCSGiTBJidaETiR
         94Iv0c9pOy2YAQhlA9Na9rmZVMzpi3Vuj7DoAi3P8v7kcz1AEnVnZgybM0Foe8e03OTc
         hGyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YCK09w6PWU3uSu7DLwK1iOj9r8NGNR+mR7i729KtO90=;
        b=enliqJhjCxlVAYrU09ZCQqMz7dwtq7KIsBrf3cVhwkpqQ2/gJ2BTXwCKyB/OHMnSn1
         MHD3BkyOPvwzu6k942WcFruyNL8o1f47nkxckht6J6QeQQ+Mza1lAlwXOyP3WTvMx4pf
         5NH+ts/dNrjerazDgnS0LdfzC4RH5ktyqw7pkeAfPZgT8Hh8DK6TepirCTeVByiOQd/j
         66kq4zTHgrKtsrpWh+SrQGx3b7rlqGEk1tAqquzdmfobqBQt7thmtU0YlCJ9QSVYlnQv
         5ayXLCWkYkTIpBlc4odytqu0MOqF7qem6ltWxKbzcwBl1A/KR97rm5zkjC4MgyVI/9Qz
         h2uw==
X-Gm-Message-State: APjAAAUxqjiNROA1UtULwfAOg9UnTvYaQ93K4ESC3RFK8cOEhF95YiaM
	eoIAF5jkL2CM2d1K3MF825RFWUa6SgiNVf6Er2Q=
X-Google-Smtp-Source: APXvYqwJE3ZvYgE+VEd+R8rFhmp8PG/+65EdbgKNxRUva5Hj0LB2yjJy3dvKhuHxAWhHWtsjyKyBfDqZCeuA3uyqYK0=
X-Received: by 2002:a05:6830:58:: with SMTP id d24mr14372911otp.128.1571551614997;
 Sat, 19 Oct 2019 23:06:54 -0700 (PDT)
MIME-Version: 1.0
References: <20191010103151.7708-1-mayhs11saini@gmail.com> <alpine.DEB.2.21.1910101418500.27284@www.lameter.com>
 <20191010174413.GT32665@bombadil.infradead.org>
In-Reply-To: <20191010174413.GT32665@bombadil.infradead.org>
From: Shyam Saini <mayhs11saini@gmail.com>
Date: Sun, 20 Oct 2019 11:36:42 +0530
Message-ID: <CAOfkYf765S3sef+gdN7h34iSCzxXxU6ifTb9572WksCqNXo0WA@mail.gmail.com>
Subject: Re: [PATCH] slab: Redefine ZERO_SIZE_PTR to include ERR_PTR range
To: Matthew Wilcox <willy@infradead.org>, Christopher Lameter <cl@linux.com>
Cc: linux-mm <linux-mm@kvack.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi Matthew, Christopher,

> > > This will help error related to ERR_PTR stand out better.
> >
> > Maybe make ZERO_SIZE_PTR an ERRNO value instead? Then allow ERR_PTRs to be
> > used instead of ZERO_SIZE_PTRs
> >
> > ERRNO_ZERO_OBJECT
> >
> > or something like that?
>
> I was wondering about something like that too, but allocating zero bytes
> isn't actually an error, and if we have code that does something like:
>
>         void *p = my_funky_alloc(size, ...);
>
>         if (IS_ERR(p))
>                 return PTR_ERR(p);
>
> then we might get this errno returned to userspace.
>
> The change is definitely worth thinking about.

Any further comments on this ?

Please let me know.

Thanks!!
