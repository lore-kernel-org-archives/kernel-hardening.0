Return-Path: <SRS0=noYU=BB=lists.openwall.com=kernel-hardening-return-19404-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C68C433E4
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 14:14:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AA90320709
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 14:14:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FOkZQDff"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA90320709
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19404-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13419 invoked by uid 550); 22 Jul 2020 14:14:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13396 invoked from network); 22 Jul 2020 14:14:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1595427253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ps88iqkraXTn/rbzr2+oz1MZHz7VliYQ9j+dqbYwLek=;
	b=FOkZQDffUfRQKnQf+vbJfg15RsxoX3fZ36VmEEhI4nzEaz5oixG9j9mqR1bX7bmjFrsUI5
	37irN5qhC5Z4Pnez/MJsNAzSNEydKKqIfxNCla8O76Bsfp/o5rLJLk3UXuoDoXaXL/VlpI
	KnqJD8vdmoJ/rDnyt0TOkP/y+IqqEbU=
X-MC-Unique: FCWuNoHvOuixJDCHQAxFHA-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ps88iqkraXTn/rbzr2+oz1MZHz7VliYQ9j+dqbYwLek=;
        b=gkIQ9RZPpRNTyFtHutl28lHJQMcmSHcWbYUcx5ZSYtLNdiyufVZtEk89O5MRsl7vSR
         lnzl137sl8NQd2JSQuTk9Pl4hgSyJin7Cp2yzIPydLeIO0McvtlkT/hqJmUw+O3uVRRt
         Y7PGDsdqJGaSb9gDUE2Qxn3rkLXXvxDNMVthN96Dv2/8jim3AgweMVOni5p0B0Xm2tQi
         s3DK37/zLacvjJdKiWPFdiqIBGJVIjiQmKtqXxPDIgeeZeFj3JIjodn3bgcNyzCu+QDi
         g/ZIrzrMW08h/M1dYiBSN3umQv4RKo4hNyzjGJ8GGR3OXFGwJ/Rv0BV1HiIzLgpW4S3T
         tgPQ==
X-Gm-Message-State: AOAM5316mdOeNl8yeX94o0a6fc2V6Jo0lNQ3+o8R0RJ3+UZIvqGxGnp7
	yAzXL3jJgxWkhEhXEaVXHk3nVtdUxF5zHQB5BPDMk40ywWdlMZfEtsx5a/1so84WkJoMWZDvXG5
	eg6Z3CEV8IbZVvbdrB7NleNJUcBH7pPJNhA==
X-Received: by 2002:a7b:cd83:: with SMTP id y3mr8594860wmj.105.1595427250733;
        Wed, 22 Jul 2020 07:14:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz178qGAQ1jCBRTkpJrLbY4BB2WPhou45FPoMFaFZC17iXHMBUam/196r1RSA2qFKbt6kQqYQ==
X-Received: by 2002:a7b:cd83:: with SMTP id y3mr8594833wmj.105.1595427250464;
        Wed, 22 Jul 2020 07:14:10 -0700 (PDT)
Date: Wed, 22 Jul 2020 16:14:04 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Daurnimator <quae@daurnimator.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Kees Cook <keescook@chromium.org>, Aleksa Sarai <asarai@suse.de>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Sargun Dhillon <sargun@sargun.me>, Jann Horn <jannh@google.com>,
	io-uring <io-uring@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS
 opcode
Message-ID: <20200722141404.jfzfl3alpyw7o7dw@steredhat>
References: <20200716124833.93667-1-sgarzare@redhat.com>
 <20200716124833.93667-3-sgarzare@redhat.com>
 <0fbb0393-c14f-3576-26b1-8bb22d2e0615@kernel.dk>
 <20200721104009.lg626hmls5y6ihdr@steredhat>
 <15f7fcf5-c5bb-7752-fa9a-376c4c7fc147@kernel.dk>
 <CAEnbY+fCP-HS_rWfOF2rnUPos-eZRF1dL+m2Q8CZidi_W=a7xw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAEnbY+fCP-HS_rWfOF2rnUPos-eZRF1dL+m2Q8CZidi_W=a7xw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 22, 2020 at 12:35:15PM +1000, Daurnimator wrote:
> On Wed, 22 Jul 2020 at 03:11, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 7/21/20 4:40 AM, Stefano Garzarella wrote:
> > > On Thu, Jul 16, 2020 at 03:26:51PM -0600, Jens Axboe wrote:
> > >> On 7/16/20 6:48 AM, Stefano Garzarella wrote:
> > >>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > >>> index efc50bd0af34..0774d5382c65 100644
> > >>> --- a/include/uapi/linux/io_uring.h
> > >>> +++ b/include/uapi/linux/io_uring.h
> > >>> @@ -265,6 +265,7 @@ enum {
> > >>>     IORING_REGISTER_PROBE,
> > >>>     IORING_REGISTER_PERSONALITY,
> > >>>     IORING_UNREGISTER_PERSONALITY,
> > >>> +   IORING_REGISTER_RESTRICTIONS,
> > >>>
> > >>>     /* this goes last */
> > >>>     IORING_REGISTER_LAST
> > >>> @@ -293,4 +294,30 @@ struct io_uring_probe {
> > >>>     struct io_uring_probe_op ops[0];
> > >>>  };
> > >>>
> > >>> +struct io_uring_restriction {
> > >>> +   __u16 opcode;
> > >>> +   union {
> > >>> +           __u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
> > >>> +           __u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
> > >>> +   };
> > >>> +   __u8 resv;
> > >>> +   __u32 resv2[3];
> > >>> +};
> > >>> +
> > >>> +/*
> > >>> + * io_uring_restriction->opcode values
> > >>> + */
> > >>> +enum {
> > >>> +   /* Allow an io_uring_register(2) opcode */
> > >>> +   IORING_RESTRICTION_REGISTER_OP,
> > >>> +
> > >>> +   /* Allow an sqe opcode */
> > >>> +   IORING_RESTRICTION_SQE_OP,
> > >>> +
> > >>> +   /* Only allow fixed files */
> > >>> +   IORING_RESTRICTION_FIXED_FILES_ONLY,
> > >>> +
> > >>> +   IORING_RESTRICTION_LAST
> > >>> +};
> > >>> +
> > >>
> > >> Not sure I totally love this API. Maybe it'd be cleaner to have separate
> > >> ops for this, instead of muxing it like this. One for registering op
> > >> code restrictions, and one for disallowing other parts (like fixed
> > >> files, etc).
> > >>
> > >> I think that would look a lot cleaner than the above.
> > >>
> > >
> > > Talking with Stefan, an alternative, maybe more near to your suggestion,
> > > would be to remove the 'struct io_uring_restriction' and add the
> > > following register ops:
> > >
> > >     /* Allow an sqe opcode */
> > >     IORING_REGISTER_RESTRICTION_SQE_OP
> > >
> > >     /* Allow an io_uring_register(2) opcode */
> > >     IORING_REGISTER_RESTRICTION_REG_OP
> > >
> > >     /* Register IORING_RESTRICTION_*  */
> > >     IORING_REGISTER_RESTRICTION_OP
> > >
> > >
> > >     enum {
> > >         /* Only allow fixed files */
> > >         IORING_RESTRICTION_FIXED_FILES_ONLY,
> > >
> > >         IORING_RESTRICTION_LAST
> > >     }
> > >
> > >
> > > We can also enable restriction only when the rings started, to avoid to
> > > register IORING_REGISTER_ENABLE_RINGS opcode. Once rings are started,
> > > the restrictions cannot be changed or disabled.
> >
> > My concerns are largely:
> >
> > 1) An API that's straight forward to use
> > 2) Something that'll work with future changes
> >
> > The "allow these opcodes" is straightforward, and ditto for the register
> > opcodes. The fixed file I guess is the odd one out. So if we need to
> > disallow things in the future, we'll need to add a new restriction
> > sub-op. Should this perhaps be "these flags must be set", and that could
> > easily be augmented with "these flags must not be set"?
> >
> > --
> > Jens Axboe
> >
> 
> This is starting to sound a lot like seccomp filtering.
> Perhaps we should go straight to adding a BPF hook that fires when
> reading off the submission queue?
> 

You're right. I e-mailed about that whit Kees Cook [1] and he agreed that the
restrictions in io_uring should allow us to address some issues that with
seccomp it's a bit difficult. For example:
- different restrictions for different io_uring instances in the same
  process
- limit SQEs to use only registered fds and buffers

Maybe seccomp could take advantage of the restrictions to filter SQEs opcodes.

Thanks,
Stefano

[1] https://lore.kernel.org/io-uring/202007160751.ED56C55@keescook/

