Return-Path: <SRS0=oELO=CF=lists.openwall.com=kernel-hardening-return-19700-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15718C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 14:41:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 588342087D
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 14:41:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TpZM04KT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 588342087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19700-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1879 invoked by uid 550); 27 Aug 2020 14:41:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1856 invoked from network); 27 Aug 2020 14:41:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598539298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kSkJbE4XJrwDOFMLE7e16e7obrhoIIgU7bHmd2/ZWC4=;
	b=TpZM04KTg4NwTk4Sto29OLsrmtaWs4tN/GPelBeaN8wyGSqyV+/9z2OGB4JJ73HR6us/HM
	kTrUB43lgLMnM5jlcLRQijyp5JMLVXA8wBYtyL8HrAmvi0xBmy6K1J4o7R+Rokr2yKrvDv
	U4RlmGxway1U8YTRAj4REG5oaPf4rU4=
X-MC-Unique: 88QMEdU_OriL69mD3UP5rA-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kSkJbE4XJrwDOFMLE7e16e7obrhoIIgU7bHmd2/ZWC4=;
        b=uDBG2pSJU1XKOoCiUkGSsVbtVGiwynxFpml2mJ/QD8t9LPJ8Koz9SerKg82YXobOtM
         uNjI7oeRuHnPQ6njwu2S/ApgafIEYSZhZELAp+KHpqDeNnu9kwR4eTCP5OudvtP6lzwp
         MhL4lj/v/Hbkjidi8sH6HsAOH3jCSHL8IJ3e80bDRmxI54Xn8stHwGUGMvtUOn6ugoYK
         ZKZ6t52/EFvnwf54xiVJWH/HE3NheTg0kJa87lPjyNjIne2j4b4RZrzNvDoWIwAaOjlg
         nVgz/7k2XOv6doZo7uKiZXrv0vpUtm5Su5j4uye0ZGWgJ7SPeogmSUy9WICI1QND/kMU
         7qwQ==
X-Gm-Message-State: AOAM5325StFlj2bksLXW09SxMjg54cPbRfWiU4hNsF+iwXnHMx2Ew22k
	5mKlSPNd741Mpn/qcyQuJT3vYXOcgMq+LEka0J5PE2Jn9i2cd337UZp4pMKPwQho7fXZkDJ0Km8
	Ks63UjnhiL2gQpDrsHxLmTPDWZk3qwBKvjA==
X-Received: by 2002:a05:600c:2292:: with SMTP id 18mr11627453wmf.136.1598539294167;
        Thu, 27 Aug 2020 07:41:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLjn6ioesLZuvJno4GpX4fuvfwIAu0+UbwSF5co10COtOk6HNz4fDGRY0086+HvxSJxGfKEA==
X-Received: by 2002:a05:600c:2292:: with SMTP id 18mr11627429wmf.136.1598539293910;
        Thu, 27 Aug 2020 07:41:33 -0700 (PDT)
Date: Thu, 27 Aug 2020 16:41:29 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Aleksa Sarai <asarai@suse.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
	Christian Brauner <christian.brauner@ubuntu.com>,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
	Sargun Dhillon <sargun@sargun.me>,
	Kees Cook <keescook@chromium.org>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v5 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <20200827144129.5yvu2icj7a5jfp3p@steredhat.lan>
References: <20200827134044.82821-1-sgarzare@redhat.com>
 <2ded8df7-6dcb-ee8a-c1fd-e0c420b7b95d@kernel.dk>
 <20200827141002.an34n2nx6m4dfhce@steredhat.lan>
 <f7c0ff79-87c0-6c7e-b048-b82a45d0f44a@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <f7c0ff79-87c0-6c7e-b048-b82a45d0f44a@kernel.dk>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sgarzare@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 27, 2020 at 08:10:49AM -0600, Jens Axboe wrote:
> On 8/27/20 8:10 AM, Stefano Garzarella wrote:
> > On Thu, Aug 27, 2020 at 07:50:44AM -0600, Jens Axboe wrote:
> >> On 8/27/20 7:40 AM, Stefano Garzarella wrote:
> >>> v5:
> >>>  - explicitly assigned enum values [Kees]
> >>>  - replaced kmalloc/copy_from_user with memdup_user [kernel test robot]
> >>>  - added Kees' R-b tags
> >>>
> >>> v4: https://lore.kernel.org/io-uring/20200813153254.93731-1-sgarzare@redhat.com/
> >>> v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.com/
> >>> RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com
> >>> RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@redhat.com
> >>>
> >>> Following the proposal that I send about restrictions [1], I wrote this series
> >>> to add restrictions in io_uring.
> >>>
> >>> I also wrote helpers in liburing and a test case (test/register-restrictions.c)
> >>> available in this repository:
> >>> https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)
> >>>
> >>> Just to recap the proposal, the idea is to add some restrictions to the
> >>> operations (sqe opcode and flags, register opcode) to safely allow untrusted
> >>> applications or guests to use io_uring queues.
> >>>
> >>> The first patch changes io_uring_register(2) opcodes into an enumeration to
> >>> keep track of the last opcode available.
> >>>
> >>> The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
> >>> handle restrictions.
> >>>
> >>> The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
> >>> allowing the user to register restrictions, buffers, files, before to start
> >>> processing SQEs.
> >>>
> >>> Comments and suggestions are very welcome.
> >>
> >> Looks good to me, just a few very minor comments in patch 2. If you
> >> could fix those up, let's get this queued for 5.10.
> >>
> > 
> > Sure, I'll fix the issues. This is great :-)
> 
> Thanks! I'll pull in your liburing tests as well once we get the kernel
> side sorted.

Yeah. Let me know if you'd prefer that I send patches on io-uring ML.

About io-uring UAPI, do you think we should set explicitly the enum
values also for IOSQE_*_BIT and IORING_OP_*?

I can send a separated patch for this.

Thanks,
Stefano

