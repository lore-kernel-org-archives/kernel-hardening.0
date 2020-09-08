Return-Path: <SRS0=X+hw=CR=lists.openwall.com=kernel-hardening-return-19811-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD305C43461
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 14:10:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 714FC207DE
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 14:10:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RG2ZgtiP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 714FC207DE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19811-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22444 invoked by uid 550); 8 Sep 2020 14:10:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22424 invoked from network); 8 Sep 2020 14:10:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1599574212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kn9hbknpyWVhQlSOafeEsxNFb47fyKdNL+eDglfupFs=;
	b=RG2ZgtiPO4J8h4ydFJDa/Bou5WinfjYEMy+Zbgp6dHHGUKdP6RCFmfrWINR0Ic8pw6nyZG
	ov89Jv47T/8f4psaQJENoEwNbUg7DXQEdIDanwUoUtGrgxMFPCO8mFRAR+xc3j8NGz/THL
	DSQ2DDfUx+jRurUv2wg8wvIbK5Rl7ZI=
X-MC-Unique: Fb2q3VyUNY--R21jyh-fRA-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kn9hbknpyWVhQlSOafeEsxNFb47fyKdNL+eDglfupFs=;
        b=egdS3qW90BEhCJZLz6y25POBgqXGnwmP8H1EQxaQtNeO+2kdRJWLWdWNJSzaFchPei
         GMliogSb4H1y5rWi2G+BgsKWIgftoxVyCMNd67ArzzpgTK89XQPm9FcWXqGPCshnsMQw
         ZG4z3pAjeT7EL/mN5Aho3T3pJNNu6l8mEToLikgCmOC+3oTB3tr8kCUL8fyNPCxKtry3
         bqgy9Q/BrSZBbENHUDrMomIIXpRFtiHxQ6KgGSfGf+7CaGyzSDWicWdKkU1dvgL8BPO6
         Qx/6OlqTBbvRTzHWOEpNtpFnGXDtnQUhEYBuX9a/Rc/nrrP0gWrfQwETGhnHZujmkSrs
         03Cg==
X-Gm-Message-State: AOAM5339ZXYUbjZqKLvAigf3VeZw9Hz0e4N9Ew4pyYeFggCYfu86ClTC
	SkR2qrEnxirtKW/jwiiXTsY3B0YSuc2fL1v/L3wfi4daRTyG3pgQi1mZDc0H5kkA/JhVfriYdPO
	aXPE68tMr2h1vrQHex/WXdz+O8gQrPkGRyA==
X-Received: by 2002:a5d:67d2:: with SMTP id n18mr26920263wrw.223.1599574207370;
        Tue, 08 Sep 2020 07:10:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCoZsLpCl42/yvJP59b0CJVR6x3OGhbvD44BBTGIzdJCIH1DWhXch6JnHrzE/D/eGYFzCq9A==
X-Received: by 2002:a5d:67d2:: with SMTP id n18mr26920239wrw.223.1599574207050;
        Tue, 08 Sep 2020 07:10:07 -0700 (PDT)
Date: Tue, 8 Sep 2020 16:10:03 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Stefan Hajnoczi <stefanha@redhat.com>, Jann Horn <jannh@google.com>,
	Jeff Moyer <jmoyer@redhat.com>, Aleksa Sarai <asarai@suse.de>,
	Sargun Dhillon <sargun@sargun.me>, linux-kernel@vger.kernel.org,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v6 3/3] io_uring: allow disabling rings during the
 creation
Message-ID: <20200908141003.wsm6pclfj6tsaffr@steredhat>
References: <20200827145831.95189-1-sgarzare@redhat.com>
 <20200827145831.95189-4-sgarzare@redhat.com>
 <20200908134448.sg7evdrfn6xa67sn@steredhat>
 <045e0907-4771-0b7f-d52a-4af8197e6954@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <045e0907-4771-0b7f-d52a-4af8197e6954@kernel.dk>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sgarzare@redhat.com
X-Mimecast-Spam-Score: 0.003
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 08, 2020 at 07:57:08AM -0600, Jens Axboe wrote:
> On 9/8/20 7:44 AM, Stefano Garzarella wrote:
> > Hi Jens,
> > 
> > On Thu, Aug 27, 2020 at 04:58:31PM +0200, Stefano Garzarella wrote:
> >> This patch adds a new IORING_SETUP_R_DISABLED flag to start the
> >> rings disabled, allowing the user to register restrictions,
> >> buffers, files, before to start processing SQEs.
> >>
> >> When IORING_SETUP_R_DISABLED is set, SQE are not processed and
> >> SQPOLL kthread is not started.
> >>
> >> The restrictions registration are allowed only when the rings
> >> are disable to prevent concurrency issue while processing SQEs.
> >>
> >> The rings can be enabled using IORING_REGISTER_ENABLE_RINGS
> >> opcode with io_uring_register(2).
> >>
> >> Suggested-by: Jens Axboe <axboe@kernel.dk>
> >> Reviewed-by: Kees Cook <keescook@chromium.org>
> >> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> >> ---
> >> v4:
> >>  - fixed io_uring_enter() exit path when ring is disabled
> >>
> >> v3:
> >>  - enabled restrictions only when the rings start
> >>
> >> RFC v2:
> >>  - removed return value of io_sq_offload_start()
> >> ---
> >>  fs/io_uring.c                 | 52 ++++++++++++++++++++++++++++++-----
> >>  include/uapi/linux/io_uring.h |  2 ++
> >>  2 files changed, 47 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >> index 5f62997c147b..b036f3373fbe 100644
> >> --- a/fs/io_uring.c
> >> +++ b/fs/io_uring.c
> >> @@ -226,6 +226,7 @@ struct io_restriction {
> >>  	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
> >>  	u8 sqe_flags_allowed;
> >>  	u8 sqe_flags_required;
> >> +	bool registered;
> >>  };
> >>  
> >>  struct io_ring_ctx {
> >> @@ -7497,8 +7498,8 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
> >>  	return ret;
> >>  }
> >>  
> >> -static int io_sq_offload_start(struct io_ring_ctx *ctx,
> >> -			       struct io_uring_params *p)
> >> +static int io_sq_offload_create(struct io_ring_ctx *ctx,
> >> +				struct io_uring_params *p)
> >>  {
> >>  	int ret;
> >>  
> >> @@ -7532,7 +7533,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
> >>  			ctx->sqo_thread = NULL;
> >>  			goto err;
> >>  		}
> >> -		wake_up_process(ctx->sqo_thread);
> >>  	} else if (p->flags & IORING_SETUP_SQ_AFF) {
> >>  		/* Can't have SQ_AFF without SQPOLL */
> >>  		ret = -EINVAL;
> >> @@ -7549,6 +7549,12 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
> >>  	return ret;
> >>  }
> >>  
> >> +static void io_sq_offload_start(struct io_ring_ctx *ctx)
> >> +{
> >> +	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sqo_thread)
> >> +		wake_up_process(ctx->sqo_thread);
> >> +}
> >> +
> >>  static inline void __io_unaccount_mem(struct user_struct *user,
> >>  				      unsigned long nr_pages)
> >>  {
> >> @@ -8295,6 +8301,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
> >>  	if (!percpu_ref_tryget(&ctx->refs))
> >>  		goto out_fput;
> >>  
> >> +	if (ctx->flags & IORING_SETUP_R_DISABLED)
> >> +		goto out_fput;
> >> +
> > 
> > While writing the man page paragraph, I discovered that if the rings are
> > disabled I returned ENXIO error in io_uring_enter(), coming from the previous
> > check.
> > 
> > I'm not sure it is the best one, maybe I can return EBADFD or another
> > error.
> > 
> > What do you suggest?
> 
> EBADFD seems indeed the most appropriate - the fd is valid, but not in the
> right state to do this.

Yeah, the same interpretation as mine!

Also, in io_uring_register() I'm returning EINVAL if the rings are not
disabled and the user wants to register restrictions.
Maybe also in this case I can return EBADFD.

I'll send a patch with the fixes.

Thanks,
Stefano

