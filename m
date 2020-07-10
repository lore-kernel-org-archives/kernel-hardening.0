Return-Path: <SRS0=h1t1=AV=lists.openwall.com=kernel-hardening-return-19285-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A599C433E5
	for <kernel-hardening@archiver.kernel.org>; Fri, 10 Jul 2020 17:53:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CBDF12078D
	for <kernel-hardening@archiver.kernel.org>; Fri, 10 Jul 2020 17:53:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="ZOwmy3Tc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBDF12078D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19285-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22339 invoked by uid 550); 10 Jul 2020 17:53:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22311 invoked from network); 10 Jul 2020 17:53:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X4sn28XQAInZ6oRA/4Miu/453HHyk6jIfO1A6nENhso=;
        b=ZOwmy3TcyKaYApKKIQPxqj0LaKTYVT7Yme9kGN/xV7hHfvlyAwatmbOYm1j0fas7mF
         5ROVhfgF9tarevn4hiEZhn7AcCnN6kSKkA53aFbJdS7IVJqgfI7pX7sMVIOphfExGnpg
         5JtVT5rTSDrM8HYhogou6Z8s46HSr3YVCvtQq+aJYqXxuyYm4Z7Ur0DOvFv80a/ISPTD
         FK/UA61DACU3FI3jSQ54LvnEZ5CntbU7BYeHIHHiaiA++Bh5kd4Hlz76H+3lbj4IFkZo
         +ddZgu2t9g24vcKnMae55i04/pg+X13EK++ZigSSfoJtwccft/3D6UK6AyWtLLeoxFld
         yr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X4sn28XQAInZ6oRA/4Miu/453HHyk6jIfO1A6nENhso=;
        b=rDH7lxZKrBOTL8JMufwsovexEoCEmtRfQ2ToljbNR1hjolTg5ip+eQuxrllA069o+2
         GlhLXPu/rtRema+eagZPzb+lU3QACP1tBzC1+HMM7AwUYNK5Gz/QietcOXuUOusJmbQ1
         R7I7xi3RjjqcMmWhzqSJWcPrjHxeSKtyRE4Y8ocecBlM/s+9KEE7NnUnt3NhmpRID1tg
         vvaHeNq4MASnmIZkXR+gfmWTtjN5ZQfE9utquxlpQsWxcCbq0G+2+HYj6Sd77ueboeL3
         8vU1OPHszI6AEV5gC0glQd1NtN1g+/M4TvMmeTohlts0M779cq0hKtbVwsvMCOlCqPo8
         jrLw==
X-Gm-Message-State: AOAM5309IwVYinL6VJK2DL8CGHEkv05DJgHTWhz5UqKbGnCZBy/9Guop
	YmcXm3BBnbBCcPxvaUwT8etKUg==
X-Google-Smtp-Source: ABdhPJwPQKF+EcvlyUkz8Mn5ccD8YvTlNprEGWbyCG+1XhL4L0vi4FeRZSlpkfHNv5e7wABJkHpTaQ==
X-Received: by 2002:a5d:8d12:: with SMTP id p18mr48507405ioj.148.1594403570543;
        Fri, 10 Jul 2020 10:52:50 -0700 (PDT)
Subject: Re: [PATCH RFC 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS
 opcode
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Sargun Dhillon <sargun@sargun.me>, Kees Cook <keescook@chromium.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Jann Horn <jannh@google.com>, Aleksa Sarai <asarai@suse.de>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, io-uring@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Moyer <jmoyer@redhat.com>
References: <20200710141945.129329-1-sgarzare@redhat.com>
 <20200710141945.129329-3-sgarzare@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f39fe84d-1353-1066-c7fc-770054f7129e@kernel.dk>
Date: Fri, 10 Jul 2020 11:52:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710141945.129329-3-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 7/10/20 8:19 AM, Stefano Garzarella wrote:
> The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode
> permanently installs a feature whitelist on an io_ring_ctx.
> The io_ring_ctx can then be passed to untrusted code with the
> knowledge that only operations present in the whitelist can be
> executed.
> 
> The whitelist approach ensures that new features added to io_uring
> do not accidentally become available when an existing application
> is launched on a newer kernel version.

Keeping with the trend of the times, you should probably use 'allowlist'
here instead of 'whitelist'.
> 
> Currently is it possible to restrict sqe opcodes and register
> opcodes. It is also possible to allow only fixed files.
> 
> IOURING_REGISTER_RESTRICTIONS can only be made once. Afterwards
> it is not possible to change restrictions anymore.
> This prevents untrusted code from removing restrictions.

A few comments below.

> @@ -337,6 +344,7 @@ struct io_ring_ctx {
>  	struct llist_head		file_put_llist;
>  
>  	struct work_struct		exit_work;
> +	struct io_restriction		restrictions;
>  };
>  
>  /*

Since very few will use this feature, was going to suggest that we make
it dynamically allocated. But it's just 32 bytes, currently, so probably
not worth the effort...

> @@ -5491,6 +5499,11 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
>  	if (unlikely(!fixed && io_async_submit(req->ctx)))
>  		return -EBADF;
>  
> +	if (unlikely(!fixed && req->ctx->restrictions.enabled &&
> +		     test_bit(IORING_RESTRICTION_FIXED_FILES_ONLY,
> +			      req->ctx->restrictions.restriction_op)))
> +		return -EACCES;
> +
>  	return io_file_get(state, req, fd, &req->file, fixed);
>  }

This one hurts, though. I don't want any extra overhead from the
feature, and you're digging deep in ctx here to figure out of we need to
check.

Generally, all the checking needs to be out-of-line, and it needs to
base the decision on whether to check something or not on a cache hot
piece of data. So I'd suggest to turn all of these into some flag.
ctx->flags generally mirrors setup flags, so probably just add a:

	unsigned int restrictions : 1;

after eventfd_async : 1 in io_ring_ctx. That's free, plenty of room
there and that cacheline is already pulled in for reading.


-- 
Jens Axboe

