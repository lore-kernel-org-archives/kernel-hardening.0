Return-Path: <SRS0=JIyO=CF=lists.openwall.com=kernel-hardening-return-19706-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95532C433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 15:04:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E3D9B20678
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 15:04:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GQ0jmdkW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3D9B20678
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19706-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20260 invoked by uid 550); 27 Aug 2020 15:04:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20237 invoked from network); 27 Aug 2020 15:04:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KtUav8kJRw7NW9MJAIseBMSxLDruLjM6HXWwKu/0M74=;
        b=GQ0jmdkWMjQEAalY++3/Ht0h8crzz739ENSMCZK40b0dOvb1c0kZUmimmf9K8t4Zgx
         Fao+oOBxd4WqUDkaMoDp6QkT7HgLYirHRqq+Fk9tpRQi8On7xp9MwFMWUauS7YXIVztA
         W9VmcStAzDZlNyQOegil/seXWpDF/Iz/wobtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KtUav8kJRw7NW9MJAIseBMSxLDruLjM6HXWwKu/0M74=;
        b=kEZSRBkRHLm/hsQpqy5TGzZGEIn52z8ktDAbxBKWp2ekD5uXTdFRuujVqtG1BodK+7
         Jx81WflfnWBkUM9s+QkPwlpQHQOZQ8pRID2BwZUrrYYs25z0VvDcCEp0UW1zjUPhJm8f
         GpvxCMr18AWhGNBlWmDL2yM9irWIdyp4OU6obnODpn7QV90JvgavYx2FpKN+fdn8mWRi
         PVkLc+4Tj6p4JSx8T0WOgC1sGfhp9K/j4EgzMVu9hTb+AZ4ZLeUOyjFzwh1To50T/DHl
         IzrGl1z/iYL9nGB1CQBd4Et2vswu+BNFvKmXj3i4P52sCbpe1avYSiDtArtd1ckmdxIs
         lbPQ==
X-Gm-Message-State: AOAM533Jn05JXccCajtm+rPWdRqZBDQ6HFYIr+kTRH1Q25OwKg3N1CwO
	7V1FS84TGGC23NyqiEWFZyxZQg==
X-Google-Smtp-Source: ABdhPJwXBmp6C1isCRM1EzGs2j/sEIzbekMjfQYDts14g/FnXYPAwZwvsuLxGAshJVtz3JQiRyN6iw==
X-Received: by 2002:a63:1822:: with SMTP id y34mr15725223pgl.364.1598540657751;
        Thu, 27 Aug 2020 08:04:17 -0700 (PDT)
Date: Thu, 27 Aug 2020 08:04:15 -0700
From: Kees Cook <keescook@chromium.org>
To: Stefano Garzarella <sgarzare@redhat.com>
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
Message-ID: <202008270803.6FD7F63@keescook>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-4-sgarzare@redhat.com>
 <202008261248.BB37204250@keescook>
 <20200827071802.6tzntmixnxc67y33@steredhat.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827071802.6tzntmixnxc67y33@steredhat.lan>

On Thu, Aug 27, 2020 at 09:18:02AM +0200, Stefano Garzarella wrote:
> On Wed, Aug 26, 2020 at 12:50:31PM -0700, Kees Cook wrote:
> > On Thu, Aug 13, 2020 at 05:32:54PM +0200, Stefano Garzarella wrote:
> > > This patch adds a new IORING_SETUP_R_DISABLED flag to start the
> > > rings disabled, allowing the user to register restrictions,
> > > buffers, files, before to start processing SQEs.
> > > 
> > > When IORING_SETUP_R_DISABLED is set, SQE are not processed and
> > > SQPOLL kthread is not started.
> > > 
> > > The restrictions registration are allowed only when the rings
> > > are disable to prevent concurrency issue while processing SQEs.
> > > 
> > > The rings can be enabled using IORING_REGISTER_ENABLE_RINGS
> > > opcode with io_uring_register(2).
> > > 
> > > Suggested-by: Jens Axboe <axboe@kernel.dk>
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > 
> > Where can I find the io_uring selftests? I'd expect an additional set of
> > patches to implement the selftests for this new feature.
> 
> Since the io_uring selftests are stored in the liburing repository, I created
> a new test case (test/register-restrictions.c) in my fork and I'll send it
> when this series is accepted. It's available in this repository:
> 
> https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)

Ah-ha; thank you! Looks good. :)

-- 
Kees Cook
