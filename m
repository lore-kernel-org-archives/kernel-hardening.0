Return-Path: <SRS0=Mp2j=CE=lists.openwall.com=kernel-hardening-return-19670-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21DDC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Aug 2020 19:50:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3F3DA20786
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Aug 2020 19:50:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aU8siOpp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F3DA20786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19670-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6041 invoked by uid 550); 26 Aug 2020 19:50:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6021 invoked from network); 26 Aug 2020 19:50:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uxqzqvKmp7TiheniHf4IhKcDFcjxbiVLlnBXpofjwMk=;
        b=aU8siOppe3gnQyuaHzROkStSBHp1R5OW7cyHZa9Qz7+3P9SoF3bduzgEtFv0LgQ6EB
         SoPfRvVMaGGz7cgLY3D80QJOfKTkdjKYwQBRF982bGuQfjWlAASB6m3+ZBBr5WHfyh2w
         9WogV6NaCd7ry+cSTti/fvS9ekjLyQoNnN7HM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uxqzqvKmp7TiheniHf4IhKcDFcjxbiVLlnBXpofjwMk=;
        b=HT2x+bIiu2nkAypiMIkSSxHgt1L4kcOhvFyiqSE7CcbKVWvn3YfTM+wPyY7jLSALlY
         NDOGQSESMWpN0jinkmGwAlYFiNzbe9G5av4apW7Rjzc4pmfAgNtOEMm1A7Gxo+7huIfN
         Tdqpij8Y5Sh3vG0B5n39ff1O2YFE/nKO7cF6FLdj/m2kTfznGOeC65Ctj0KERJWpgfDQ
         dFgykjigZII74iamAt5aXPf8nw7ukdwIS840lM5khvrpSPolqfj/zy5n66pcdwNdVi8F
         fPGRzeu6UzPRFAz1W4kHVPTBe6GUbhnF46yarnZz1D3Q9KFDAHcyg98nTBjy6+EU3fGr
         uC4Q==
X-Gm-Message-State: AOAM5317lS9p9kZn074WJBjc50UqYkKGkcTWlGbn9c8eoZf+5oAH51Cz
	8yjfCbCT7E4AC42kJLsUZ9qihg==
X-Google-Smtp-Source: ABdhPJzxqVFKo5Bu6GBfBDh+chu3duJcUOhxiTiRE4q8mDWtHYdG37wKhgbCE4yKAY4sw60hABcZoA==
X-Received: by 2002:a63:df13:: with SMTP id u19mr11904336pgg.275.1598471433358;
        Wed, 26 Aug 2020 12:50:33 -0700 (PDT)
Date: Wed, 26 Aug 2020 12:50:31 -0700
From: Kees Cook <keescook@chromium.org>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
	linux-fsdevel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
	Aleksa Sarai <asarai@suse.de>, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 3/3] io_uring: allow disabling rings during the
 creation
Message-ID: <202008261248.BB37204250@keescook>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-4-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813153254.93731-4-sgarzare@redhat.com>

On Thu, Aug 13, 2020 at 05:32:54PM +0200, Stefano Garzarella wrote:
> This patch adds a new IORING_SETUP_R_DISABLED flag to start the
> rings disabled, allowing the user to register restrictions,
> buffers, files, before to start processing SQEs.
> 
> When IORING_SETUP_R_DISABLED is set, SQE are not processed and
> SQPOLL kthread is not started.
> 
> The restrictions registration are allowed only when the rings
> are disable to prevent concurrency issue while processing SQEs.
> 
> The rings can be enabled using IORING_REGISTER_ENABLE_RINGS
> opcode with io_uring_register(2).
> 
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

Where can I find the io_uring selftests? I'd expect an additional set of
patches to implement the selftests for this new feature.

-- 
Kees Cook
