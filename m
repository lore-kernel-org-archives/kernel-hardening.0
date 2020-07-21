Return-Path: <SRS0=rfeJ=BA=lists.openwall.com=kernel-hardening-return-19399-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 821B3C433E4
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Jul 2020 10:40:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D392D2065F
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Jul 2020 10:40:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JSOHTNBv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D392D2065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19399-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13906 invoked by uid 550); 21 Jul 2020 10:40:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13880 invoked from network); 21 Jul 2020 10:40:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1595328018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JJxds48R6O9rnMt3T/vIXqCudN9Py5s51DW/o643deI=;
	b=JSOHTNBvOqcKoFucvISSaDWrNsxWIjmhdER47qeXF/ijupx13IFe+DiEcNJXtJM25osXs7
	S6ngtjUTAKqcqAIp4YFlxHz6OzB3mT/qZkcom3wLCV275WczVq/2JYTlk0FwYsMpP/exf7
	QHJvwWkVY0XcshdMFe1qG1SKQQtwVxQ=
X-MC-Unique: nohmnDJNNNiEEwpZkVui1A-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JJxds48R6O9rnMt3T/vIXqCudN9Py5s51DW/o643deI=;
        b=ipRqGD3bSxIKVwL933MwsbS6QJ9hIulRfDZOvzCc85XVxBicP1c59F0ZaIBzMjju9r
         YXKF4VqqDEEQUbz23tL6VLiN8eJkdAiTDXKXDu54h09Iu5xdxjnf3Fp8WaDf+rA5r+4+
         mR3pW/lsTy35RHpfblT7kmfnRyBq47ozX4QUZzDVk4c+3ZkI715c5jhXdkx4OJJYget/
         S1BFavYgxHWkLuIL/OFA2wBh19GhcYQMU8Li2zfbpOwQr9+X+AuaoMScBWfOS4g8m5vJ
         bc0V4/VDOHx807gjW2BtMjxJUyfGEuhNo/ujZNs/+IOw3+qHq0rBDKPtnet/ryP4R7IB
         FzuA==
X-Gm-Message-State: AOAM532qOZ0JQSVrRhdtHR3HIGfJVlC1/TboZfUEXkvdfwSfxELiOKeh
	hSNOHNKA5i63263ADFOY+aomIKHGtYXh/0gOaFweOgPf2WTvyesV+OpHZOmQX5GrmsX76lrDQA2
	cZLlXILOIxVSsJIdmhuNJoSPeVzvmmIxrzw==
X-Received: by 2002:adf:db86:: with SMTP id u6mr27108022wri.27.1595328015239;
        Tue, 21 Jul 2020 03:40:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBo3RCatz2sWoHwy1o+Mv1N6KLRKOUoDm7SJGud2x81ODcAOg8M1F10bzf/K0KK5XuzJcSCQ==
X-Received: by 2002:adf:db86:: with SMTP id u6mr27107996wri.27.1595328014996;
        Tue, 21 Jul 2020 03:40:14 -0700 (PDT)
Date: Tue, 21 Jul 2020 12:40:09 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Kees Cook <keescook@chromium.org>, Aleksa Sarai <asarai@suse.de>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Sargun Dhillon <sargun@sargun.me>, Jann Horn <jannh@google.com>,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS
 opcode
Message-ID: <20200721104009.lg626hmls5y6ihdr@steredhat>
References: <20200716124833.93667-1-sgarzare@redhat.com>
 <20200716124833.93667-3-sgarzare@redhat.com>
 <0fbb0393-c14f-3576-26b1-8bb22d2e0615@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <0fbb0393-c14f-3576-26b1-8bb22d2e0615@kernel.dk>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 16, 2020 at 03:26:51PM -0600, Jens Axboe wrote:
> On 7/16/20 6:48 AM, Stefano Garzarella wrote:
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index efc50bd0af34..0774d5382c65 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -265,6 +265,7 @@ enum {
> >  	IORING_REGISTER_PROBE,
> >  	IORING_REGISTER_PERSONALITY,
> >  	IORING_UNREGISTER_PERSONALITY,
> > +	IORING_REGISTER_RESTRICTIONS,
> >  
> >  	/* this goes last */
> >  	IORING_REGISTER_LAST
> > @@ -293,4 +294,30 @@ struct io_uring_probe {
> >  	struct io_uring_probe_op ops[0];
> >  };
> >  
> > +struct io_uring_restriction {
> > +	__u16 opcode;
> > +	union {
> > +		__u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
> > +		__u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
> > +	};
> > +	__u8 resv;
> > +	__u32 resv2[3];
> > +};
> > +
> > +/*
> > + * io_uring_restriction->opcode values
> > + */
> > +enum {
> > +	/* Allow an io_uring_register(2) opcode */
> > +	IORING_RESTRICTION_REGISTER_OP,
> > +
> > +	/* Allow an sqe opcode */
> > +	IORING_RESTRICTION_SQE_OP,
> > +
> > +	/* Only allow fixed files */
> > +	IORING_RESTRICTION_FIXED_FILES_ONLY,
> > +
> > +	IORING_RESTRICTION_LAST
> > +};
> > +
> 
> Not sure I totally love this API. Maybe it'd be cleaner to have separate
> ops for this, instead of muxing it like this. One for registering op
> code restrictions, and one for disallowing other parts (like fixed
> files, etc).
> 
> I think that would look a lot cleaner than the above.
> 

Talking with Stefan, an alternative, maybe more near to your suggestion,
would be to remove the 'struct io_uring_restriction' and add the
following register ops:

    /* Allow an sqe opcode */
    IORING_REGISTER_RESTRICTION_SQE_OP

    /* Allow an io_uring_register(2) opcode */
    IORING_REGISTER_RESTRICTION_REG_OP

    /* Register IORING_RESTRICTION_*  */
    IORING_REGISTER_RESTRICTION_OP


    enum {
        /* Only allow fixed files */
        IORING_RESTRICTION_FIXED_FILES_ONLY,

        IORING_RESTRICTION_LAST
    }


We can also enable restriction only when the rings started, to avoid to
register IORING_REGISTER_ENABLE_RINGS opcode. Once rings are started,
the restrictions cannot be changed or disabled.

If you agree, I'll send a v3 following this.

Thanks,
Stefano

