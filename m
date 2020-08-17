Return-Path: <SRS0=Z7ig=B3=lists.openwall.com=kernel-hardening-return-19643-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C897C433E1
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Aug 2020 10:42:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 893FE20786
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Aug 2020 10:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D7XuSvz+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 893FE20786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19643-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3203 invoked by uid 550); 17 Aug 2020 10:42:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3183 invoked from network); 17 Aug 2020 10:42:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1597660923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PUJr2mnP6BBvGf0Kjd5lhs/X3Ec756z2m+nUcS2WOv0=;
	b=D7XuSvz+LWy/c/5YEhR7tXF/uuYOW9PbQfS2dd/cjmqPl4gpJ4njhPGm9XXcbct1ja8PBh
	oTExXEk6pKtHvmI/Fe3reSv9ItroqhhgH/aPQXzMZPig5o9ILsXBqfsR60YsyAmMZHrbPZ
	15kRiIV8/2ciBtObT0KcKNxihwdEKb8=
X-MC-Unique: ynulkk50NZabQO-dbkymTA-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PUJr2mnP6BBvGf0Kjd5lhs/X3Ec756z2m+nUcS2WOv0=;
        b=RiThTDyoewXBUtJ6PbkEXu6EAmH9MKFdyBOpXOZpJvcT7N+9ME4+yQ9uNcWy8NwxbW
         uLFYasQPBOlP8AFGv0f3TcR/EFnbQZ1CDsIxIr3VMLvJV0EBPbVMS/8tZbkH9833Z6L6
         qYxE07prJUCrbJpV8YQ/vGgaF23067v/Ztt0WEc+P0R4zPuKgV32uWz/KsWuPr6L3n5z
         E8rPqOQh97QOvY9gQcuNHgIV2jtsUN1Bq2TvppAVwjPCdj+LSUwQa9nP0G2XFFxABX+F
         4UAuobMQF5BnP4X5eQpBQiNmBrSOTafKly6XUMIu7IjigcIKECzNhQ39n+bWfKSZxxJ+
         HJIw==
X-Gm-Message-State: AOAM533PbkU1pGrWnLCHOXq1KTfma+USTqhlU4kqAopSaOs0/a2JChw1
	tC4MuFIKmuwlhGM0i78rDFcKqDPT0+s7h2EkYryaYvavTsAitbOZYOf5soTJe/d1lDTJzmEvLlI
	JJ3o5GrE+lIHiihdH73fjAuZxFoX+MRQ+uA==
X-Received: by 2002:a1c:1904:: with SMTP id 4mr13966083wmz.119.1597660899673;
        Mon, 17 Aug 2020 03:41:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqlBqWFxOiqPpRiM4LJ468Hm0058AImmVCARluPm+REFssSMQSBhWZ3F7LfJGZ19Vvr0lF6Q==
X-Received: by 2002:a1c:1904:: with SMTP id 4mr13966061wmz.119.1597660899335;
        Mon, 17 Aug 2020 03:41:39 -0700 (PDT)
Date: Mon, 17 Aug 2020 12:41:34 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: kernel test robot <lkp@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, kbuild-all@lists.01.org,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
	linux-fsdevel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
	Kees Cook <keescook@chromium.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH v4 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
Message-ID: <20200817104134.fgmrppzchno2hcci@steredhat>
References: <20200813153254.93731-3-sgarzare@redhat.com>
 <202008140142.UYrgnsNY%lkp@intel.com>
MIME-Version: 1.0
In-Reply-To: <202008140142.UYrgnsNY%lkp@intel.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sgarzare@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 14, 2020 at 01:42:15AM +0800, kernel test robot wrote:
> Hi Stefano,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on linus/master]
> [also build test WARNING on v5.8 next-20200813]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Stefano-Garzarella/io_uring-add-restrictions-to-support-untrusted-applications-and-guests/20200813-233653
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git dc06fe51d26efc100ac74121607c01a454867c91
> config: s390-randconfig-c003-20200813 (attached as .config)
> compiler: s390-linux-gcc (GCC) 9.3.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> coccinelle warnings: (new ones prefixed by >>)
> 
> >> fs/io_uring.c:8516:7-14: WARNING opportunity for memdup_user

Yeah, I think make sense.

I'll use memdup_user() in the next version.

> 
> vim +8516 fs/io_uring.c
> 
>   8497	
>   8498	static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
>   8499					    unsigned int nr_args)
>   8500	{
>   8501		struct io_uring_restriction *res;
>   8502		size_t size;
>   8503		int i, ret;
>   8504	
>   8505		/* We allow only a single restrictions registration */
>   8506		if (ctx->restricted)
>   8507			return -EBUSY;
>   8508	
>   8509		if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
>   8510			return -EINVAL;
>   8511	
>   8512		size = array_size(nr_args, sizeof(*res));
>   8513		if (size == SIZE_MAX)
>   8514			return -EOVERFLOW;
>   8515	
> > 8516		res = kmalloc(size, GFP_KERNEL);
>   8517		if (!res)
>   8518			return -ENOMEM;
>   8519	
>   8520		if (copy_from_user(res, arg, size)) {
>   8521			ret = -EFAULT;
>   8522			goto out;
>   8523		}
>   8524	
>   8525		for (i = 0; i < nr_args; i++) {
>   8526			switch (res[i].opcode) {
>   8527			case IORING_RESTRICTION_REGISTER_OP:
>   8528				if (res[i].register_op >= IORING_REGISTER_LAST) {
>   8529					ret = -EINVAL;
>   8530					goto out;
>   8531				}
>   8532	
>   8533				__set_bit(res[i].register_op,
>   8534					  ctx->restrictions.register_op);
>   8535				break;
>   8536			case IORING_RESTRICTION_SQE_OP:
>   8537				if (res[i].sqe_op >= IORING_OP_LAST) {
>   8538					ret = -EINVAL;
>   8539					goto out;
>   8540				}
>   8541	
>   8542				__set_bit(res[i].sqe_op, ctx->restrictions.sqe_op);
>   8543				break;
>   8544			case IORING_RESTRICTION_SQE_FLAGS_ALLOWED:
>   8545				ctx->restrictions.sqe_flags_allowed = res[i].sqe_flags;
>   8546				break;
>   8547			case IORING_RESTRICTION_SQE_FLAGS_REQUIRED:
>   8548				ctx->restrictions.sqe_flags_required = res[i].sqe_flags;
>   8549				break;
>   8550			default:
>   8551				ret = -EINVAL;
>   8552				goto out;
>   8553			}
>   8554		}
>   8555	
>   8556		ctx->restricted = 1;
>   8557	
>   8558		ret = 0;
>   8559	out:
>   8560		/* Reset all restrictions if an error happened */
>   8561		if (ret != 0)
>   8562			memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
>   8563	
>   8564		kfree(res);
>   8565		return ret;
>   8566	}
>   8567	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


