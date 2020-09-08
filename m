Return-Path: <SRS0=YxIB=CR=lists.openwall.com=kernel-hardening-return-19810-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28AF5C433E2
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 13:57:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0623723C40
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 13:57:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="uJazPLWe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0623723C40
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19810-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18191 invoked by uid 550); 8 Sep 2020 13:57:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18168 invoked from network); 8 Sep 2020 13:57:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lLPV/2TbMLCWwjxZmMjGQAv9RQQ5QdmKtS2Q2m060x4=;
        b=uJazPLWezWgC/PxcgavzXTzULVjK+HH/0rnfAycuhBQCpgkDFk/fvQpqKS7RzEpiXG
         ERAROiLm7VLunZJpzttkIeY7b1VyZ7vdAdTmly29bZuLWeEEHdxvjUkOpVL/XgnAQLYP
         U563XLl1LCPU1Vs+xCapjB1tF5YvK5Li0o6rXx6tkcIIdFWG/q5TU59d1Vbfyhey0Iqk
         FjDr8t0q6o0KqVSUzgviXQkWRhNR4U26NzOXYB0n6lNBNEhD4nJZeQCKGy7YfpsuHGrd
         n/zLgKw2/0PIclu34Gpdgs81l5h979bDDAONUe9gK227ECpK+s8PjAKkmwpLLY/KXPFR
         17Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lLPV/2TbMLCWwjxZmMjGQAv9RQQ5QdmKtS2Q2m060x4=;
        b=PBCmvJihtb2IFAXnGt2qgEApd4aJSTksk1K7nqgxUP732m2zngBvmia9WTO2518zXu
         GWB6/HNdWLLZj/Ed81bc7VD132TJy6WHS9hbRAtL5NK2q39RKgRxRLUwjAYy9p7m4g7n
         yxc/aUi+KsRBlZPSEps9lZFQXJ54u8ZjgeMwVpoasDhTIYpddKvmNvuV/C/jp2j9btUJ
         U9TGiLGIKJ5vCgJROKzqcGHg32N8mY7sNLKMrgyF7vVYgJsoDNyb+3u21TzCGa9bxFOa
         Ws2Ojv/Tq5KKn+aZnSL7Iyp6V/sBMWEIYNSJDJsePIcwpBq64MLD2y3b95aYsZgk321f
         /OSw==
X-Gm-Message-State: AOAM532VMF8mN3va725Bexq0eZ2/H6SlhQF6X9U21nzk/13uBgx4wjBa
	/BuNL/Lsouufa2IHg+LeUWw6kQ==
X-Google-Smtp-Source: ABdhPJxhox+LWrxM6t17Fh8h96lJUzdn1I3RGOvUMfkfWJnmtrv7CdbTJs/zo6NSzHwk+R3I3Syr5A==
X-Received: by 2002:a6b:c8d6:: with SMTP id y205mr527426iof.177.1599573430313;
        Tue, 08 Sep 2020 06:57:10 -0700 (PDT)
Subject: Re: [PATCH v6 3/3] io_uring: allow disabling rings during the
 creation
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Stefan Hajnoczi <stefanha@redhat.com>, Jann Horn <jannh@google.com>,
 Jeff Moyer <jmoyer@redhat.com>, Aleksa Sarai <asarai@suse.de>,
 Sargun Dhillon <sargun@sargun.me>, linux-kernel@vger.kernel.org,
 Kees Cook <keescook@chromium.org>
References: <20200827145831.95189-1-sgarzare@redhat.com>
 <20200827145831.95189-4-sgarzare@redhat.com>
 <20200908134448.sg7evdrfn6xa67sn@steredhat>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <045e0907-4771-0b7f-d52a-4af8197e6954@kernel.dk>
Date: Tue, 8 Sep 2020 07:57:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200908134448.sg7evdrfn6xa67sn@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 9/8/20 7:44 AM, Stefano Garzarella wrote:
> Hi Jens,
> 
> On Thu, Aug 27, 2020 at 04:58:31PM +0200, Stefano Garzarella wrote:
>> This patch adds a new IORING_SETUP_R_DISABLED flag to start the
>> rings disabled, allowing the user to register restrictions,
>> buffers, files, before to start processing SQEs.
>>
>> When IORING_SETUP_R_DISABLED is set, SQE are not processed and
>> SQPOLL kthread is not started.
>>
>> The restrictions registration are allowed only when the rings
>> are disable to prevent concurrency issue while processing SQEs.
>>
>> The rings can be enabled using IORING_REGISTER_ENABLE_RINGS
>> opcode with io_uring_register(2).
>>
>> Suggested-by: Jens Axboe <axboe@kernel.dk>
>> Reviewed-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>> v4:
>>  - fixed io_uring_enter() exit path when ring is disabled
>>
>> v3:
>>  - enabled restrictions only when the rings start
>>
>> RFC v2:
>>  - removed return value of io_sq_offload_start()
>> ---
>>  fs/io_uring.c                 | 52 ++++++++++++++++++++++++++++++-----
>>  include/uapi/linux/io_uring.h |  2 ++
>>  2 files changed, 47 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 5f62997c147b..b036f3373fbe 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -226,6 +226,7 @@ struct io_restriction {
>>  	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
>>  	u8 sqe_flags_allowed;
>>  	u8 sqe_flags_required;
>> +	bool registered;
>>  };
>>  
>>  struct io_ring_ctx {
>> @@ -7497,8 +7498,8 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
>>  	return ret;
>>  }
>>  
>> -static int io_sq_offload_start(struct io_ring_ctx *ctx,
>> -			       struct io_uring_params *p)
>> +static int io_sq_offload_create(struct io_ring_ctx *ctx,
>> +				struct io_uring_params *p)
>>  {
>>  	int ret;
>>  
>> @@ -7532,7 +7533,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
>>  			ctx->sqo_thread = NULL;
>>  			goto err;
>>  		}
>> -		wake_up_process(ctx->sqo_thread);
>>  	} else if (p->flags & IORING_SETUP_SQ_AFF) {
>>  		/* Can't have SQ_AFF without SQPOLL */
>>  		ret = -EINVAL;
>> @@ -7549,6 +7549,12 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
>>  	return ret;
>>  }
>>  
>> +static void io_sq_offload_start(struct io_ring_ctx *ctx)
>> +{
>> +	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sqo_thread)
>> +		wake_up_process(ctx->sqo_thread);
>> +}
>> +
>>  static inline void __io_unaccount_mem(struct user_struct *user,
>>  				      unsigned long nr_pages)
>>  {
>> @@ -8295,6 +8301,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>  	if (!percpu_ref_tryget(&ctx->refs))
>>  		goto out_fput;
>>  
>> +	if (ctx->flags & IORING_SETUP_R_DISABLED)
>> +		goto out_fput;
>> +
> 
> While writing the man page paragraph, I discovered that if the rings are
> disabled I returned ENXIO error in io_uring_enter(), coming from the previous
> check.
> 
> I'm not sure it is the best one, maybe I can return EBADFD or another
> error.
> 
> What do you suggest?

EBADFD seems indeed the most appropriate - the fd is valid, but not in the
right state to do this.

> I'll add a test for this case.

Thanks!

-- 
Jens Axboe

