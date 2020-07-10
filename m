Return-Path: <SRS0=URkj=AV=lists.openwall.com=kernel-hardening-return-19284-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A636AC433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 10 Jul 2020 16:20:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 02C04206F4
	for <kernel-hardening@archiver.kernel.org>; Fri, 10 Jul 2020 16:20:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gjp2xMlL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02C04206F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19284-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5745 invoked by uid 550); 10 Jul 2020 16:20:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5715 invoked from network); 10 Jul 2020 16:20:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1594398025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q9OBXiOBnT1mGmZ2eGcWLsQs9qpaRL+ZvL1+d8k1S8o=;
	b=gjp2xMlL82kham00+fOQkIMod7p8PBnHK0dIXP36vxyx2N+jYVuesM1mjX0XgTvxUIVYJv
	j54Q6p0aqCtl0hzNp1ufhV9dOIo+9lFvFJhsybVZwkb/63E5o0RmEbD5hpOxZzxufNn8QB
	NamVTrLHbt96WQYWB5LJwNrRUboK0vY=
X-MC-Unique: 2S0WTJwXPr-rezGbv5q2pQ-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q9OBXiOBnT1mGmZ2eGcWLsQs9qpaRL+ZvL1+d8k1S8o=;
        b=Rn+U2d3Wj9XhZxZ5zhk84ISQ/YkVaJrR/HamKPUbRy586TahAZE4uI9pJuv2ZhWQUZ
         ogXQgkrt7RglgwYo/QfuDLphxdWiCKjwDTqWG5BIqKXdBo1vNcvCJOumUu9F3iHkUZ6Z
         K+QNsBgCbSPMQ6SH6H2Y8FaKsuRSzsxD9DUpJUJh9FcJdMwSkCy3zNEAVErFfTbmz31p
         yFVFP5tYasRY/aZQ+BLzQWXDfhkK/eQpY78Aoe9Rwxt0f9m/e458C8gtkWh14E0ZLkIM
         WD92zkcJmA546fb2krGm0GSEfKtfWBjzPo6flOUTl89vN/s2yAO7d/qKdCSuGZlq4UdJ
         E3Ow==
X-Gm-Message-State: AOAM533IVGGfV14kSVXTE7tXWJKQNuoNh3qnw9P/Nkebnfv8pHxxrsxy
	oCHtxYunO4lzojAaoiZX+X8icci+7XjZQtaZZlG8OVEEh33jS8umDdVwdXSwwGTa8s+jV2cxppM
	NpyMgN4DZQSEvH0Vs4pRZBCzlW2lh/E+Osg==
X-Received: by 2002:a5d:630c:: with SMTP id i12mr75515906wru.158.1594398022821;
        Fri, 10 Jul 2020 09:20:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNg29SHEj/1kCIq20X+QBQi6Vi8ell7jTihmuv4S0/ilMJ558e1BkioaTjMsJllIACTM1T8A==
X-Received: by 2002:a5d:630c:: with SMTP id i12mr75515878wru.158.1594398022605;
        Fri, 10 Jul 2020 09:20:22 -0700 (PDT)
Date: Fri, 10 Jul 2020 18:20:17 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sargun Dhillon <sargun@sargun.me>,
	Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Jann Horn <jannh@google.com>, Aleksa Sarai <asarai@suse.de>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, io-uring@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH RFC 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <20200710162017.qdu34ermtxh3rfgl@steredhat>
References: <20200710141945.129329-1-sgarzare@redhat.com>
 <20200710153309.GA4699@char.us.oracle.com>
MIME-Version: 1.0
In-Reply-To: <20200710153309.GA4699@char.us.oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Konrad,

On Fri, Jul 10, 2020 at 11:33:09AM -0400, Konrad Rzeszutek Wilk wrote:
> .snip..
> > Just to recap the proposal, the idea is to add some restrictions to the
> > operations (sqe, register, fixed file) to safely allow untrusted applications
> > or guests to use io_uring queues.
> 
> Hi!
> 
> This is neat and quite cool - but one thing that keeps nagging me is
> what how much overhead does this cut from the existing setup when you use
> virtio (with guests obviously)?

I need to do more tests, but the preliminary results that I reported on
the original proposal [1] show an overhead of ~ 4.17 uS (with iodepth=1)
when I'm using virtio ring processed in a dedicated iothread:

  - 73 kIOPS using virtio-blk + QEMU iothread + io_uring backend
  - 104 kIOPS using io_uring passthrough

>                                 That is from a high level view the
> beaty of io_uring being passed in the guest is you don't have the
> virtio ring -> io_uring processing, right?

Right, and potentially we can share the io_uring queues directly to the
guest userspace applications, cutting down the cost of Linux block
layer in the guest.

Thanks for your feedback,
Stefano

[1] https://lore.kernel.org/io-uring/20200609142406.upuwpfmgqjeji4lc@steredhat/

