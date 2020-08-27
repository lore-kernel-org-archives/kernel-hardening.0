Return-Path: <SRS0=hmYE=CF=lists.openwall.com=kernel-hardening-return-19695-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D53C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 13:51:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E022C206F0
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 13:51:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="qxwcVn5J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E022C206F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19695-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1048 invoked by uid 550); 27 Aug 2020 13:50:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1025 invoked from network); 27 Aug 2020 13:50:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iAwILKXaGwE32BKWKaWMGVaA1oh3sBt+J35AZWjjyZY=;
        b=qxwcVn5JQ9XYTQbP2HLcOTAwz30rF8EQCFatdqtquebkoj614HXR5RCCZn47g/sFms
         b1B9FEawJrQ0st6va0eVKzrouTvhxlfCKY5lceQ5M0mEFmP87mCM1WfcXMY0rTnFfVWm
         ySrewvO/AFV5vFAEV6VVxXDaIpQGU8hvL4BcPZuxNtv5wV6r5lx2MWlDm6fmA38V1ah8
         r1c5ALWfnWIYR9RXi08rgC36D4UJkyd3fxxLQOp2nslXWKm67FvJLiKHgCs5NPTS1n7/
         7nibAib6cK52NRtC/4y31vn1506yvBpqn+dx3MKZwQuMTZ4yMdm+HHMTG3w2Tel1aVZ1
         ytUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iAwILKXaGwE32BKWKaWMGVaA1oh3sBt+J35AZWjjyZY=;
        b=D0nA1fNaOSDHjQzPP6dEZROJiCzkkbwbIS0DqDd9huO/reeAy7PiTC2kIqBLVyrzPA
         uJ4IPG8HHp8/KhWlLQgg8OUqJC7hBapxiQxuPujjeAKPsxBjsJ8bdbEOMp1FOnr+cO9N
         SaYPOjDRW7rb5AcHYlN2y6W3i2WPPYKq78E09ZCCULvW3KhXtXUP7M0FcGGpkmUzuSDN
         ikxUJirnkO75P4MvNXOVrwguy1RZRkbsZMdJGnDO2cahu7lRKQr2swlEZivqZjrS2UT2
         et2Z/iYcWVKvSJMFfSo0I20UtyYAUYXD4vycUxIxANXhHFXU0zy0i/D9QBZ20tBpvJRO
         VTzA==
X-Gm-Message-State: AOAM530I4XeYlePjulugs4u9BSFrMh82en/Iil/ie6jf+8cMefCWSFHF
	8jL0LmU9VoBx8moZjGUPVhGh/w==
X-Google-Smtp-Source: ABdhPJzOPDGdpeaugrph99pH0rYwmDwtHxNDF8nsNnio4tgus2HsTtEiJ9SU9c3mUcm6yO9cBck+8w==
X-Received: by 2002:a05:6e02:1066:: with SMTP id q6mr17103230ilj.29.1598536245882;
        Thu, 27 Aug 2020 06:50:45 -0700 (PDT)
Subject: Re: [PATCH v5 0/3] io_uring: add restrictions to support untrusted
 applications and guests
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Aleksa Sarai <asarai@suse.de>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
 Christian Brauner <christian.brauner@ubuntu.com>,
 linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
 Sargun Dhillon <sargun@sargun.me>, Kees Cook <keescook@chromium.org>,
 Jeff Moyer <jmoyer@redhat.com>
References: <20200827134044.82821-1-sgarzare@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2ded8df7-6dcb-ee8a-c1fd-e0c420b7b95d@kernel.dk>
Date: Thu, 27 Aug 2020 07:50:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827134044.82821-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 8/27/20 7:40 AM, Stefano Garzarella wrote:
> v5:
>  - explicitly assigned enum values [Kees]
>  - replaced kmalloc/copy_from_user with memdup_user [kernel test robot]
>  - added Kees' R-b tags
> 
> v4: https://lore.kernel.org/io-uring/20200813153254.93731-1-sgarzare@redhat.com/
> v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.com/
> RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com
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

Looks good to me, just a few very minor comments in patch 2. If you
could fix those up, let's get this queued for 5.10.

-- 
Jens Axboe

