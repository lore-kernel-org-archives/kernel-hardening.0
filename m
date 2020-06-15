Return-Path: <SRS0=IvIy=74=lists.openwall.com=kernel-hardening-return-18985-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E25CC433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 20:12:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 68D01206F1
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 20:12:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="l6YV1FGo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68D01206F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18985-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13366 invoked by uid 550); 15 Jun 2020 20:11:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13331 invoked from network); 15 Jun 2020 20:11:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yrq+7tIQLTLfowElVM/LAUx+j6R1G8S30nvCECShhQQ=;
        b=l6YV1FGo7TU7pAG9+qw2VIKRm2zpVhJYfNx5Q3J6oTPJYQgyGzOfcrhTa0eJoLKTfn
         6NfDhsnF08XkpsSWX1cIl04wPTRWtjc8sLkIwWt83YoJPjzvbq0i2dqsxkNArhbh3t0Y
         BD6QOc6aFvItzd5w5V1qKCCHaAGNorfpDSIn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yrq+7tIQLTLfowElVM/LAUx+j6R1G8S30nvCECShhQQ=;
        b=tiOC8GRWnvtkYomuTXP17KMC/BSaSbX756mkeXdcejKsbRfYHexm1ZOEQb5F+iTqF4
         +Z59bhiInHhDYVi73hc9PYC/6MFKrmO51mDCxY0q3xHR0nUPOWSStBbsDiWZ6S1gkcKD
         BLDj1bejiIJMgw9sL3IsW8eNweotZqAEyfy+eqCFoJLAtzjzDVULPA4cQEuiBomB31RF
         qYWapMoPivZxRcODpcawLEt0KshV+dTp66vRSKA5frO3I2stdh5J9mui+a6o430p0h/u
         WAM015/RRdmgxoNqFjKesboHPYi8pSpjZpxgi1hf8VQjPk0NKWGhJdTrJcprUXFkG0US
         98LA==
X-Gm-Message-State: AOAM533E7t+yYJbzCS7ZH+zYaBO2q6cYvTBvG93l6Vv9UCJRaPqcRVw7
	3HKmgb/KXD1cX8XoR9/Sazv4uQ==
X-Google-Smtp-Source: ABdhPJwhR93Vg5Nwqs2HYvPt9tQ/0LeMR6QDPhfir7kLCDe1EmntTkidhoi/vgyMd2V+CJ/mzmlt1g==
X-Received: by 2002:a63:925a:: with SMTP id s26mr14310236pgn.21.1592251900590;
        Mon, 15 Jun 2020 13:11:40 -0700 (PDT)
Date: Mon, 15 Jun 2020 13:11:38 -0700
From: Kees Cook <keescook@chromium.org>
To: Jason Yan <yanaijie@huawei.com>
Cc: jaegeuk@kernel.org, chao@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH] f2fs: Eliminate usage of uninitialized_var() macro
Message-ID: <202006151311.138CD1D@keescook>
References: <20200615085132.166470-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615085132.166470-1-yanaijie@huawei.com>

On Mon, Jun 15, 2020 at 04:51:32PM +0800, Jason Yan wrote:
> This is an effort to eliminate the uninitialized_var() macro[1].
> 
> The use of this macro is the wrong solution because it forces off ANY
> analysis by the compiler for a given variable. It even masks "unused
> variable" warnings.
> 
> Quoted from Linus[2]:
> 
> "It's a horrible thing to use, in that it adds extra cruft to the
> source code, and then shuts up a compiler warning (even the _reliable_
> warnings from gcc)."
> 
> Fix it by remove this variable since it is not needed at all.
> 
> [1] https://github.com/KSPP/linux/issues/81
> [2] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> 
> Cc: Kees Cook <keescook@chromium.org>
> Suggested-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  v2: Directly remove this variable.

Thanks! I've applied this to my uninitialized_var() macro removal
series.

-- 
Kees Cook
