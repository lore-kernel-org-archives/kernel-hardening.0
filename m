Return-Path: <SRS0=/COz=A4=lists.openwall.com=kernel-hardening-return-19373-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2274C433E3
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jul 2020 08:55:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6377B207F5
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jul 2020 08:55:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MenN+Rb4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6377B207F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19373-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6137 invoked by uid 550); 17 Jul 2020 08:55:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6112 invoked from network); 17 Jul 2020 08:55:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1594976124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+XI4nEZZeTErLSUZryeEot9E65dRQ6gK4ETg2301d/w=;
	b=MenN+Rb4Cxh7aSt0rwCNWhDrYwG4hhKkUv/J6ftHT5aMxaSaj6paxl1Bh+BFHy0i9y8e8C
	iQrh+sQmbUuA17kmKq/t0EhurL+I6nODvHTNYKm07ijAEoes+1Kngur1I0esSc77M2Y5M4
	RUNjjXwcmair05FoTNn7KWeuldnRBIY=
X-MC-Unique: lOJpIKJ3M_CoNVwUF_n9qg-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+XI4nEZZeTErLSUZryeEot9E65dRQ6gK4ETg2301d/w=;
        b=snf807/JwrOSz/tgWUR5dP8JfFy20hKoy7w4oNSmeC6bBmKJotL7jiRKniW18oY2wH
         gW+i9vFe8n73x/6E8RtXYvZd8BLwFMSz6j3otZidQEbU8RZM3QKjYmRloFNW6VrGH9f4
         Dn5NAFKgrJzaM4SfBIiqUhoGGmYyr+ZrQpknI9HtmDD7lM0fHdLvOkjznWUG8JvSDYbQ
         +Lw9DdE3r8n521PF4lVeWebtP37ZctvplInLuzPEXS25A8Ys0em0AwUlC5ML2RRuYNwb
         bfmwIErlJK0DcihPHTkdEm7leaF11Bb8EVS/UC3iJjjfO5uWJYWYyWMbB4gChhO5gSLm
         7Zfg==
X-Gm-Message-State: AOAM530RJ8Fb1Bp7dYkg4AArEcgAW0Z9zn/XONeWge3e5fTfnwNNfwII
	ExwzbMw5fdEIL2lyLJA5NPnhn5vOwa0OFlnNC+FmnBjHQ1ZJ1KGzSGisaEZAdcBReQxuUuioEww
	fsxv3NZnRK/Tk4ght2cx0MFOpgAQBFG8M8g==
X-Received: by 2002:a7b:c775:: with SMTP id x21mr8378223wmk.34.1594976121808;
        Fri, 17 Jul 2020 01:55:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlQPFtvZT51Z58AIE5vT4594yCNMsfr9Ds3LKq+kNbUdm3mAvMl22NKFAoesPZEMojsUSFeg==
X-Received: by 2002:a7b:c775:: with SMTP id x21mr8378199wmk.34.1594976121566;
        Fri, 17 Jul 2020 01:55:21 -0700 (PDT)
Date: Fri, 17 Jul 2020 10:55:17 +0200
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
Message-ID: <20200717085517.56jis3aw53wssf5a@steredhat.lan>
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

I'm not sure I got your point.

Do you mean two different register ops?
For example, maybe with better names... ;-):

	IORING_REGISTER_RESTRICTIONS_OPS
	IORING_REGISTER_RESTRICTIONS_OTHERS


Or a single register op like now, and a new restriction opcode adding
also a new field in the struct io_uring_restriction?
For example:

	struct io_uring_restriction {
		__u16 opcode;
		union {
			__u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
			__u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
			__u8 restriction; /* IORING_RESTRICTION_OP */
		};
		__u8 resv;
		__u32 resv2[3];
	};

	/*
	 * io_uring_restriction->opcode values
	 */
	enum {
		/* Allow an io_uring_register(2) opcode */
		IORING_RESTRICTION_REGISTER_OP,

		/* Allow an sqe opcode */
		IORING_RESTRICTION_SQE_OP,

		IORING_RESTRICTION_OP,

		IORING_RESTRICTION_LAST
	};

	enum {
		/* Only allow fixed files */
		IORING_RESTRICTION_OP_FIXED_FILES_ONLY,
	};


Thanks,
Stefano

