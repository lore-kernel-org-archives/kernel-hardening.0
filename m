Return-Path: <SRS0=gTBP=CF=lists.openwall.com=kernel-hardening-return-19680-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C6BC433E4
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 07:12:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B824C22BED
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 07:12:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jCAO6CFi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B824C22BED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19680-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23902 invoked by uid 550); 27 Aug 2020 07:12:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23874 invoked from network); 27 Aug 2020 07:12:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598512355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JL0Nic4lUYEvTQAyILRqVFTBlq5K5PuaRWhSncRHSwg=;
	b=jCAO6CFiJ9r6N/6UpmAGenQWzEPJIHktVq1NqHm2KN58QA3uTsDaFBuus38oJ3tDapI1IC
	7wlAuPnRJmNB2qpIqoYQuaEN6W1diKZzGCWrNY5L5bjzveisDExKyUcDVsCZPcvzGSL6rT
	P1fubMEUWWDu5swIjr1Z4fzsNZh1WXc=
X-MC-Unique: Ytc3ftjoNWKiFqYo8MT9sA-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JL0Nic4lUYEvTQAyILRqVFTBlq5K5PuaRWhSncRHSwg=;
        b=poroJmJykKMZUcVRjnG0LXagYnGTaPgMHeWuWN/O+vlhtqTkmE/E4zAcDPnidEl95g
         YfC1R2goCeSvk5AeTp+l/I7tScScTvHCuh5qclbXLkZ7SLuWpb6uq8zXX5dRjxs6gjMB
         Qg1/gA/pqJkXc+h1Rvbc2ilXAIlllW0Rq9YwVwWvFZAmMjSrz5j9ON+nOAxc//r834AJ
         y79vXfuuevyAKnn2pNlSqaazh2Hklk89NQeKTegyURdNeJBjyud0+2tQR/tXBMiP8za0
         o64gmBrs0waP75n+U6IWR8SjD3yAXWabDpmJ6K13EF6PoJo0ziY0jCb9j+lzs68zCiNi
         Pejw==
X-Gm-Message-State: AOAM5333+Jd1FPUittCTi5RsVegL73pEAUYV61KSmglee+l2CoTQ/8Kx
	JS3fHh2l6wzDTOWJg5/EJK0VKfiH58omuWCvRN/igt26uJvFfF3dzNa/cyM2uxwyJvrmDH3En/X
	UqRuJMhVQQb6eR/WTZs5621hatjag/Huaxw==
X-Received: by 2002:a5d:650b:: with SMTP id x11mr305690wru.46.1598512352239;
        Thu, 27 Aug 2020 00:12:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUHzxCz2Spgqmv60oYq58isMCoWeEsBIsG0b8y0nTVMsLWHJ63NS9EGPcX3VzzE1QFXWCdbg==
X-Received: by 2002:a5d:650b:: with SMTP id x11mr305672wru.46.1598512351999;
        Thu, 27 Aug 2020 00:12:31 -0700 (PDT)
Date: Thu, 27 Aug 2020 09:12:27 +0200
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
Subject: Re: [PATCH v4 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
Message-ID: <20200827071227.tozlhvidn3iet6xy@steredhat.lan>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-3-sgarzare@redhat.com>
 <202008261245.245E36654@keescook>
MIME-Version: 1.0
In-Reply-To: <202008261245.245E36654@keescook>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sgarzare@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 26, 2020 at 12:46:24PM -0700, Kees Cook wrote:
> On Thu, Aug 13, 2020 at 05:32:53PM +0200, Stefano Garzarella wrote:
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
> > +	/* Allow sqe flags */
> > +	IORING_RESTRICTION_SQE_FLAGS_ALLOWED,
> > +
> > +	/* Require sqe flags (these flags must be set on each submission) */
> > +	IORING_RESTRICTION_SQE_FLAGS_REQUIRED,
> > +
> > +	IORING_RESTRICTION_LAST
> > +};
> 
> Same thought on enum literals, but otherwise, looks good:

Sure, I'll fix the enum in the next version.

> 
> Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks for the review,
Stefano

