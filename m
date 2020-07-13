Return-Path: <SRS0=KBCI=AY=lists.openwall.com=kernel-hardening-return-19291-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D602C433E1
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Jul 2020 08:07:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E274B2073A
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Jul 2020 08:07:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WfTETJ9m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E274B2073A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19291-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7524 invoked by uid 550); 13 Jul 2020 08:07:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7504 invoked from network); 13 Jul 2020 08:07:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1594627655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=thokzV2lTPzLARMZ2GmJNDEymlOB144wptcD2yJ3eYo=;
	b=WfTETJ9mmiGoPzp5fY6EjMT6v4m4ofuuhepGWck5HL8qAR18CI4jTqgOr1BwZW6A933ZfR
	sIge1ch2xVtKffy1M3QPQVrZk9UCJwdBS/oQ4Jyy/KtgDoB+OkN+LyV2m/RzHf7YFZgxsT
	HHv3enir/net/0A5qCnA2tZGolC2b0Y=
X-MC-Unique: Mcc1dfL3NTmqz_KA46VQNg-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=thokzV2lTPzLARMZ2GmJNDEymlOB144wptcD2yJ3eYo=;
        b=ZsVLpvzh2q3OWMwQ37bsrk2ZzjU9aFFLUB3npDpEokxnJNz0mrJekrovbjazDaAWpN
         lQMzk1IhCasTSOi6dXTo+rbJ4S0MM8NTFLfx5K4Evnl/xKO2AELiRIo9mmLmwokCWJIC
         QGZMb8yvIqcHb6rkq7dhnDyx2B4QmY5o2PVX5v0il9x0Mv/uzgdDRQLjO8wuS92lnn57
         D0mV3IqXBSUny9AyZV9t/avjD7HyoNTr32bnh3F4ziapkE3PmTjClWfr5zrDvvQ/KZnf
         wjffFUktmeK8UiITsUSKy7mQ7hNJkcNcfR7OUyj4lBvnLQHN2pwpOqYaggTs9oPqY7Gn
         90hQ==
X-Gm-Message-State: AOAM531NSV6Dxg8Fx1D4nQk8zcjgQDTdz3mZ316mdJ0sbNd88rcH1+f+
	jIH6HbtOwRIM8Ty+KPle1rzXulcu8LUoGfj+I1+fnPiLN4yVsOdFOQshF1uKMC2SoeKYu45p3lk
	PBvTfq7tZasIup9kzhMvq4DpqdB5QNKai6g==
X-Received: by 2002:adf:9051:: with SMTP id h75mr84159392wrh.152.1594627652976;
        Mon, 13 Jul 2020 01:07:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6ugR4SJYyS+JyXgFpzVLUdQEd9gIqid8od/rTaiAEg/puVly9toFCtHHU1aU3hfbT+UQRmQ==
X-Received: by 2002:adf:9051:: with SMTP id h75mr84159371wrh.152.1594627652750;
        Mon, 13 Jul 2020 01:07:32 -0700 (PDT)
Date: Mon, 13 Jul 2020 10:07:29 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Sargun Dhillon <sargun@sargun.me>, Kees Cook <keescook@chromium.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Jann Horn <jannh@google.com>, Aleksa Sarai <asarai@suse.de>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, io-uring@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH RFC 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS
 opcode
Message-ID: <20200713080729.gttt3ymk7aqumle4@steredhat>
References: <20200710141945.129329-1-sgarzare@redhat.com>
 <20200710141945.129329-3-sgarzare@redhat.com>
 <f39fe84d-1353-1066-c7fc-770054f7129e@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <f39fe84d-1353-1066-c7fc-770054f7129e@kernel.dk>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 10, 2020 at 11:52:48AM -0600, Jens Axboe wrote:
> On 7/10/20 8:19 AM, Stefano Garzarella wrote:
> > The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode
> > permanently installs a feature whitelist on an io_ring_ctx.
> > The io_ring_ctx can then be passed to untrusted code with the
> > knowledge that only operations present in the whitelist can be
> > executed.
> > 
> > The whitelist approach ensures that new features added to io_uring
> > do not accidentally become available when an existing application
> > is launched on a newer kernel version.
> 
> Keeping with the trend of the times, you should probably use 'allowlist'
> here instead of 'whitelist'.

Sure, it is better!

> > 
> > Currently is it possible to restrict sqe opcodes and register
> > opcodes. It is also possible to allow only fixed files.
> > 
> > IOURING_REGISTER_RESTRICTIONS can only be made once. Afterwards
> > it is not possible to change restrictions anymore.
> > This prevents untrusted code from removing restrictions.
> 
> A few comments below.
> 
> > @@ -337,6 +344,7 @@ struct io_ring_ctx {
> >  	struct llist_head		file_put_llist;
> >  
> >  	struct work_struct		exit_work;
> > +	struct io_restriction		restrictions;
> >  };
> >  
> >  /*
> 
> Since very few will use this feature, was going to suggest that we make
> it dynamically allocated. But it's just 32 bytes, currently, so probably
> not worth the effort...
> 

Yeah, I'm not sure it will grow in the future, so I'm tempted to leave it
as it is, but I can easily change it if you prefer.

> > @@ -5491,6 +5499,11 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
> >  	if (unlikely(!fixed && io_async_submit(req->ctx)))
> >  		return -EBADF;
> >  
> > +	if (unlikely(!fixed && req->ctx->restrictions.enabled &&
> > +		     test_bit(IORING_RESTRICTION_FIXED_FILES_ONLY,
> > +			      req->ctx->restrictions.restriction_op)))
> > +		return -EACCES;
> > +
> >  	return io_file_get(state, req, fd, &req->file, fixed);
> >  }
> 
> This one hurts, though. I don't want any extra overhead from the
> feature, and you're digging deep in ctx here to figure out of we need to
> check.
> 
> Generally, all the checking needs to be out-of-line, and it needs to
> base the decision on whether to check something or not on a cache hot
> piece of data. So I'd suggest to turn all of these into some flag.
> ctx->flags generally mirrors setup flags, so probably just add a:
> 
> 	unsigned int restrictions : 1;
> 
> after eventfd_async : 1 in io_ring_ctx. That's free, plenty of room
> there and that cacheline is already pulled in for reading.
> 

Thanks for the clear explanation!

I left a TODO comment near the 'enabled' field to look for something better,
and what you're suggesting is what I was looking for :-)

I'll change it!

Thanks,
Stefano

