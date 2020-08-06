Return-Path: <SRS0=tj3B=BQ=lists.openwall.com=kernel-hardening-return-19565-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084A6C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Aug 2020 11:53:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5111522CF7
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Aug 2020 11:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E4o0X9D0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5111522CF7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19565-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15681 invoked by uid 550); 6 Aug 2020 07:49:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15655 invoked from network); 6 Aug 2020 07:49:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1596700182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xB6SfwN9zZAFK1inviExT4PSWJ9s32aoWCOt/UwHdpI=;
	b=E4o0X9D0hPHyRBoDYPW2EmbTYh8EQ0FDc/I0JrrL0t82NJomloyMcb4OC/kJ+BWfPDNk6M
	v+2pB8rEZ4kVt1IhIfUzNEac2iNvA8J1BLhrUTM3fnVCdecQJC7CB87Vru00RUD9+Flzz4
	IweqrRizyOJawUh2o5ihFcNv1JdpD9g=
X-MC-Unique: _BrwO3SvPi63BC_h932BiA-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xB6SfwN9zZAFK1inviExT4PSWJ9s32aoWCOt/UwHdpI=;
        b=iIGp5OiCZkdIplU2f2QqsTZIMgxFAI95qItfr4IjfCoJGVVaDsiMyL1nRHzLuCVqVl
         5G6+TP8Uqicdi3vvoybJjYprDYYEXM4pTvYyNz7K9oWvImoyjGCb68HGnOguHfiZmo6w
         xnMQyDL5rRV8D8aIrMouaSLKZfodPHLLVxwREPTOOvDdAOYrm7cX8pcXjwKac7/UGceE
         275aJpzeZ68hF4C/wbNOAq7E5y2iKuf0LR4iHlnO52jfgnlc1xQmmTRk/ej1olvIXcWu
         vq0ELvINJaO+SWmhRneu9mt9wckG+J5/biEQCfsIjiPYtAD51E5Ab8yKVs1PpHvIzHdD
         JmYA==
X-Gm-Message-State: AOAM532DndNLc+QppKSDP7LeTOLFKKiBqbY6fvE2kcPXe50ucUzFMfN2
	b2YrO4pWhtmD7Ey6ysyhtJg8/+1OG1xvgmyUp2d5/KEWbggq/63RoK1I3grN0Z6xXeHJktM4hS8
	zuflGdMeu1poa8C+tVX4LdvIcZ9UubLhgoQ==
X-Received: by 2002:a1c:e244:: with SMTP id z65mr6663778wmg.34.1596700177239;
        Thu, 06 Aug 2020 00:49:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZ5kIFKf/UdkmWPj9U+O2NxXnYswiWnhDgQNIX/nObMw+EYpBVxwz7xoUqJ3nnWezsts3JEg==
X-Received: by 2002:a1c:e244:: with SMTP id z65mr6663754wmg.34.1596700176991;
        Thu, 06 Aug 2020 00:49:36 -0700 (PDT)
Date: Thu, 6 Aug 2020 09:49:29 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Kees Cook <keescook@chromium.org>, Jeff Moyer <jmoyer@redhat.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Aleksa Sarai <asarai@suse.de>, Sargun Dhillon <sargun@sargun.me>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <20200806074929.bl6utxrmmx3hf2y2@steredhat>
References: <20200728160101.48554-1-sgarzare@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200728160101.48554-1-sgarzare@redhat.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sgarzare@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Gentle ping.

I'll rebase on master, but if there are any things that I can improve,
I'll be happy to do.

Thanks,
Stefano

On Tue, Jul 28, 2020 at 06:00:58PM +0200, Stefano Garzarella wrote:
> v3:
>  - added IORING_RESTRICTION_SQE_FLAGS_ALLOWED and
>    IORING_RESTRICTION_SQE_FLAGS_REQUIRED
>  - removed IORING_RESTRICTION_FIXED_FILES_ONLY opcode
>  - enabled restrictions only when the rings start
> 
> RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com
> 
> RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@redhat.com
> 
> Following the proposal that I send about restrictions [1], I wrote this series
> to add restrictions in io_uring.
> 
> I also wrote helpers in liburing and a test case (test/register-restrictions.c)
> available in this repository:
> https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)
> 
> Just to recap the proposal, the idea is to add some restrictions to the
> operations (sqe opcode and flags, register opcode) to safely allow untrusted
> applications or guests to use io_uring queues.
> 
> The first patch changes io_uring_register(2) opcodes into an enumeration to
> keep track of the last opcode available.
> 
> The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
> handle restrictions.
> 
> The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
> allowing the user to register restrictions, buffers, files, before to start
> processing SQEs.
> 
> Comments and suggestions are very welcome.
> 
> Thank you in advance,
> Stefano
> 
> [1] https://lore.kernel.org/io-uring/20200609142406.upuwpfmgqjeji4lc@steredhat/
> 
> Stefano Garzarella (3):
>   io_uring: use an enumeration for io_uring_register(2) opcodes
>   io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
>   io_uring: allow disabling rings during the creation
> 
>  fs/io_uring.c                 | 167 ++++++++++++++++++++++++++++++++--
>  include/uapi/linux/io_uring.h |  60 +++++++++---
>  2 files changed, 207 insertions(+), 20 deletions(-)
> 
> -- 
> 2.26.2
> 

