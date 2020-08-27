Return-Path: <SRS0=D7/u=CF=lists.openwall.com=kernel-hardening-return-19697-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F3DC433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 14:10:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 33D4B2087D
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 14:10:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z6/aD7aa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33D4B2087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19697-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13408 invoked by uid 550); 27 Aug 2020 14:10:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13382 invoked from network); 27 Aug 2020 14:10:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598537412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p3UaJor8m6UPSLfz0Cwgwz9tei6T+Ko+yHdee7F5pCI=;
	b=Z6/aD7aayfZGJGYzFtRel5H7/Bau4W+coulSGA6ERh9GqpMpee6MiYfnQ0OiDch4HJCY0q
	QRP2pFpMkp3Vt/9dIjfcnvP8aNs1/J30hLlgq637ikXODQ8MRZ2e6jHBbn0H+PbAgkbubA
	v57TQhxbtOUUX8bm9UQ5vCuaBD+DvmQ=
X-MC-Unique: 1LEFM0XYMPythrtxLdRzJg-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p3UaJor8m6UPSLfz0Cwgwz9tei6T+Ko+yHdee7F5pCI=;
        b=p+dWSY7yCUXu1AScXt9A8snizPTMG6H6VLljmYE0yfjewKzPy4vG+86BR4ZJ9TCfsH
         wVxMakNXUp3irbzh1p7q1Rrpde3G1ydhhI+cD2G6H8G7fU4STRCvcldoHTVtlUXaFWy5
         FMV4DuJflXfAoDoTQ7izjkxM147n3GxFssqJ81TzqmtfLBRf1GT71iTLbwjWaPcUBpep
         L50XZIwvUKzfrOxCpjr2ZEuWpnJ95REPLdgnxSAeig4MAcvtFHNEqJnuYByqQgzvGPjI
         M4V89QhseNATaz1uA2QmJNa+Ls6KVgmWuT/poZ0w5YaVA++gqOLlDhjTPWga2nGedEZX
         YyhA==
X-Gm-Message-State: AOAM530duts2zsLZ581nRMbqpJcVVMk6aylZt1sWsgIa/PRQ7STkdImS
	JHdIzv8dvyMOmtheUV2iCqSlZPT3ZA0jqAKdYQaq4HgwY3lZ1QnWKBjS8zP524yKbSubW05ZLM+
	Aw+YsGrP7kG0dRv6wM7Qg2kIwBXpKwMzj0A==
X-Received: by 2002:adf:ea0b:: with SMTP id q11mr18400747wrm.285.1598537407343;
        Thu, 27 Aug 2020 07:10:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIyoHL6pydlVZ4mUCwXiexrkWU5beyLiimAC7oyStXfYcu8GXZZ2ytD3aLAfsrScWOA6WOpQ==
X-Received: by 2002:adf:ea0b:: with SMTP id q11mr18400722wrm.285.1598537407089;
        Thu, 27 Aug 2020 07:10:07 -0700 (PDT)
Date: Thu, 27 Aug 2020 16:10:02 +0200
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
Message-ID: <20200827141002.an34n2nx6m4dfhce@steredhat.lan>
References: <20200827134044.82821-1-sgarzare@redhat.com>
 <2ded8df7-6dcb-ee8a-c1fd-e0c420b7b95d@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <2ded8df7-6dcb-ee8a-c1fd-e0c420b7b95d@kernel.dk>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sgarzare@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 27, 2020 at 07:50:44AM -0600, Jens Axboe wrote:
> On 8/27/20 7:40 AM, Stefano Garzarella wrote:
> > v5:
> >  - explicitly assigned enum values [Kees]
> >  - replaced kmalloc/copy_from_user with memdup_user [kernel test robot]
> >  - added Kees' R-b tags
> > 
> > v4: https://lore.kernel.org/io-uring/20200813153254.93731-1-sgarzare@redhat.com/
> > v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.com/
> > RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com
> > RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@redhat.com
> > 
> > Following the proposal that I send about restrictions [1], I wrote this series
> > to add restrictions in io_uring.
> > 
> > I also wrote helpers in liburing and a test case (test/register-restrictions.c)
> > available in this repository:
> > https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)
> > 
> > Just to recap the proposal, the idea is to add some restrictions to the
> > operations (sqe opcode and flags, register opcode) to safely allow untrusted
> > applications or guests to use io_uring queues.
> > 
> > The first patch changes io_uring_register(2) opcodes into an enumeration to
> > keep track of the last opcode available.
> > 
> > The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
> > handle restrictions.
> > 
> > The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
> > allowing the user to register restrictions, buffers, files, before to start
> > processing SQEs.
> > 
> > Comments and suggestions are very welcome.
> 
> Looks good to me, just a few very minor comments in patch 2. If you
> could fix those up, let's get this queued for 5.10.
> 

Sure, I'll fix the issues. This is great :-)

Thanks,
Stefano

