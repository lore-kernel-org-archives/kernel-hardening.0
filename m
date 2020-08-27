Return-Path: <SRS0=iGl9=CF=lists.openwall.com=kernel-hardening-return-19681-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A62FEC433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 07:18:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EA57522BEB
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 07:18:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B1zW+bpL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA57522BEB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19681-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30477 invoked by uid 550); 27 Aug 2020 07:18:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30455 invoked from network); 27 Aug 2020 07:18:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598512694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u9fFbu1GhOR5EEBDVCiFc4v2JfgRv9dRTWq43a81ToQ=;
	b=B1zW+bpL2ueJ0/2G/zKnQnmf1BXso/LVdvj8bhM88/Y5xwn8EaPBfTyTpxpBNiGnRyOJhI
	RCvO3p2elqGc77EzEDQBO6V+HZJ8wUftzIzFBJWEFjG0y6RHGIh5QLXsTp06t6dYT678ie
	p1M8iA2jH3yIbKB5RbfnBz58BOGxcKc=
X-MC-Unique: WPSCQlWVN-q06Y4nuVszUQ-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u9fFbu1GhOR5EEBDVCiFc4v2JfgRv9dRTWq43a81ToQ=;
        b=nJrhgopKXdR0nRsjr/dvB56Y16JxqNnEz0kgx0/rZDkkQUUQlZoBbXMNAgUJsHbW8D
         GJ2BOMpHiwjz1I2JM9ZjGMaxoSFgA4bmYybegd5D3UVVgAp3Aa9i9/aw4RV0jmzaAvlM
         05LIyJxG2Va6A37GJs1g18A/+l5VNkeKHvP/BvcgGq4GnK5xejP8X6ePTBy8Mc+02F5C
         sTbXzWmWfnskZjX9EfMEvGFPMlvEe+gd7zXG0rNLrCOqEbYJk2Qq0zL98M7CUPR2r09I
         Ga1kRaSlSf1l4T/RyY2J2xy5T2SDjSyPCjl4NUV01GN59UoBpO0tlVrICUFk8E8s8KGf
         ZXQA==
X-Gm-Message-State: AOAM5305b/BA4z2hdReeedIl8aWn7j9Ur2P1Wt45LaOuDHFk+/ujH4Xe
	ZYARoUbeOLZ5odDRESvtwUWD8O1A1wBFnTISoVbfvwiGIuWgTAkgzubnwafbFysi4rJLZa1G88U
	KlR4BRyvU2IAs9qs0UqqzqL8boZ6OrJwYTg==
X-Received: by 2002:adf:b349:: with SMTP id k9mr13694178wrd.135.1598512687410;
        Thu, 27 Aug 2020 00:18:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwtPSLbAoCV+fY+tWZVhYam7dcbiUmX7cOj0w7rM1ddAdGJMa85Kp5T8Bt7PKtypBfPZj1aw==
X-Received: by 2002:adf:b349:: with SMTP id k9mr13694156wrd.135.1598512687137;
        Thu, 27 Aug 2020 00:18:07 -0700 (PDT)
Date: Thu, 27 Aug 2020 09:18:02 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
	linux-fsdevel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
	Aleksa Sarai <asarai@suse.de>, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 3/3] io_uring: allow disabling rings during the
 creation
Message-ID: <20200827071802.6tzntmixnxc67y33@steredhat.lan>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-4-sgarzare@redhat.com>
 <202008261248.BB37204250@keescook>
MIME-Version: 1.0
In-Reply-To: <202008261248.BB37204250@keescook>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sgarzare@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 26, 2020 at 12:50:31PM -0700, Kees Cook wrote:
> On Thu, Aug 13, 2020 at 05:32:54PM +0200, Stefano Garzarella wrote:
> > This patch adds a new IORING_SETUP_R_DISABLED flag to start the
> > rings disabled, allowing the user to register restrictions,
> > buffers, files, before to start processing SQEs.
> > 
> > When IORING_SETUP_R_DISABLED is set, SQE are not processed and
> > SQPOLL kthread is not started.
> > 
> > The restrictions registration are allowed only when the rings
> > are disable to prevent concurrency issue while processing SQEs.
> > 
> > The rings can be enabled using IORING_REGISTER_ENABLE_RINGS
> > opcode with io_uring_register(2).
> > 
> > Suggested-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> Where can I find the io_uring selftests? I'd expect an additional set of
> patches to implement the selftests for this new feature.

Since the io_uring selftests are stored in the liburing repository, I created
a new test case (test/register-restrictions.c) in my fork and I'll send it
when this series is accepted. It's available in this repository:

https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)

Thanks for the review,
Stefano

