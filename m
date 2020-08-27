Return-Path: <SRS0=1FxP=CF=lists.openwall.com=kernel-hardening-return-19682-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3086FC433E3
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 07:24:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6FBAA22BEA
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 07:24:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YCB/pEU9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FBAA22BEA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19682-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3652 invoked by uid 550); 27 Aug 2020 07:24:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3631 invoked from network); 27 Aug 2020 07:24:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598513050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ri7f4MnEHGg+Eh3Xov6f6gkwDfi0Dd6vvMS8AIDLQKU=;
	b=YCB/pEU9HC71u0HFEKaE7mDZ3JDRBj/nk3+0p/EJchISNgeqQkzTtAoaeSKHvfRtaJCQSj
	lVby6HvILsJ3qNQWeiTfJfDyQ0RfW2/TK1FljMIcMevWzWEzpyOc9DPUNo35gqzShfGSJP
	G37O/F1rh5eHEl50SpcwagGgm6vSw6w=
X-MC-Unique: oHPvp41BObOm-vpCR89TxQ-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ri7f4MnEHGg+Eh3Xov6f6gkwDfi0Dd6vvMS8AIDLQKU=;
        b=a9vb7wt6EGuSk0uQSr03dLOMmCQcyjjvPq2T1moIuZXtFmtJBhLkqlQA1pjJLraGbR
         H0+z5lgAtTPMSsCPX/peHD9f/ANhKgWWTyvIrOexmBfxHeC281c1CQixxY9wU/8EchiX
         +j/rgYoYaLBfvH/hc/El7iMsg/J0VHnkxj2o9vQtpTvAQJy/3fMr7eFtvlQAVnNV+K1P
         DTCIrfKTNtrCQdsITlIgof+BNlXIE7DnAI3/+4RLjcmFWyfKGeZMvVHytH7u3PHQhGme
         2ROXDwiFd0mX4MwB4nks8Uj+tOaqEyqr+Q1Id0OnFoXa6XtXqRSqtW/ud7namWIUMyHE
         jiXA==
X-Gm-Message-State: AOAM532CdxOTa/xNpezGUEjqAz0U0x8OjSURFzILzLMX2xxYq3aItmbi
	XTUnCu/wgyb4TbOqc4+MM+g9XoW4qiCJZyPwfN/vKXAlmOEiSN3WmoM0Uy0BmjZitpPqI+KFJr2
	tONhCjdEwhbxPQ1cJsHUoHi+nArnq95m8Bg==
X-Received: by 2002:a5d:4ecf:: with SMTP id s15mr19040990wrv.202.1598513047593;
        Thu, 27 Aug 2020 00:24:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9Qp8WqcCYQavb33blI2gxdMXFRgjEWEltO/ZyM+YWomBld9pX31Pz59UjLz4iXha0wYfDuw==
X-Received: by 2002:a5d:4ecf:: with SMTP id s15mr19040959wrv.202.1598513047320;
        Thu, 27 Aug 2020 00:24:07 -0700 (PDT)
Date: Thu, 27 Aug 2020 09:24:01 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Sargun Dhillon <sargun@sargun.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	Aleksa Sarai <asarai@suse.de>, io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <20200827072401.6o5bqg6r5iozpcgc@steredhat.lan>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <CAGxU2F55zzMzc043P88TWJNr2poUTVwrRmu86qyh0uM-8gimng@mail.gmail.com>
 <82061082-42c8-1e1c-1f36-6f42e7dd10cb@kernel.dk>
 <202008261237.904C1E6@keescook>
MIME-Version: 1.0
In-Reply-To: <202008261237.904C1E6@keescook>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sgarzare@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 26, 2020 at 12:40:24PM -0700, Kees Cook wrote:
> On Wed, Aug 26, 2020 at 10:47:36AM -0600, Jens Axboe wrote:
> > On 8/25/20 9:20 AM, Stefano Garzarella wrote:
> > > Hi Jens,
> > > this is a gentle ping.
> > > 
> > > I'll respin, using memdup_user() for restriction registration.
> > > I'd like to get some feedback to see if I should change anything else.
> > > 
> > > Do you think it's in good shape?
> > 
> > As far as I'm concerned, this is fine. But I want to make sure that Kees
> > is happy with it, as he's the one that's been making noise on this front.
> 
> Oop! Sorry, I didn't realize this was blocked on me. Once I saw how
> orthogonal io_uring was to "regular" process trees, I figured this
> series didn't need seccomp input. (I mean, I am still concerned about
> attack surface reduction, but that seems like a hard problem given
> io_uring's design -- it is, however, totally covered by the LSMs, so I'm
> satisfied from that perspective.)
> 
> I'll go review... thanks for the poke. :)
> 

Jens, Kees, thanks for your feedbacks!
I'll send v5 adding the values to the enumerations.

Stefano

