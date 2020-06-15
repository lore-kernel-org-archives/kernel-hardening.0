Return-Path: <SRS0=pWdA=74=lists.openwall.com=kernel-hardening-return-18973-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2418EC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 09:34:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 764FD206D7
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 09:34:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GQO48Y7H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 764FD206D7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18973-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24282 invoked by uid 550); 15 Jun 2020 09:34:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26425 invoked from network); 15 Jun 2020 07:25:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1592205937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XHwguCxo4c2cVMancqpzmFcNo1EaIuQKAA2ekR4KvOU=;
	b=GQO48Y7H7OSovPkuta2dq3dwywWCrC8ONAWgnO27bRXRI4RgPL1xMIP/NFpUrfJ5KdgOJl
	aB8txB4F/GnxkeibxyfTulA7sCmyq7mX1/NoRmKXFJyGcLFbwz64xiLiAYSYcXsX5q25ER
	r5EBjun6FYdnezmz0P3VnQIIk2Wr1wk=
X-MC-Unique: uEL_LsrKPMarRWnCZEB5bQ-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XHwguCxo4c2cVMancqpzmFcNo1EaIuQKAA2ekR4KvOU=;
        b=mLl5drjQNCd7o5EoZSD0eh3r6ybDHPALHuL2yLvWFyGZ5iRMSKc2di1oOAvou3VGNh
         weKHP839wlEFVQaHbkXoazqEVSXp8BfRdWUl2+ky0pzdYp1RMYiln8tc09n4dGIeFkko
         8L57QR4npEU2+W79ScFfOTnqAYNu5c/6Q/gaAqScCujs6HKxVZdCOLApf1ouF0LdVk5C
         4g0qPPWYH93SmoAEeAJeA/PvnPMBmpt09or1imz2eppXSISGsSAvfjwzJsKkHyQCbMie
         Vb9tME116jdd37mBYNHIMiOE7PIuQDt1qvNYxJPnWKmgFrgxUVtVDDU0FjkHUcy2BTAa
         jOGg==
X-Gm-Message-State: AOAM533JLGCr1hZheGtA2h6WE63zyPMMswtHnimmkeJ4TjYyhDIHhVyP
	sgmn+c3l7viZ0u9ml5V0QQYE+j8dOUUofd4WYxpSmm8bIRGNPIG6Sc9CNM/kjgAx+bSsv6RsIH9
	sQ/RWFDHRJM9VoE58LNgLb8JB41nUx/+7nQ==
X-Received: by 2002:a62:7ccb:: with SMTP id x194mr23171914pfc.318.1592205933420;
        Mon, 15 Jun 2020 00:25:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYaTupNZjWJqlIUP4l94FShAOlauozvMBU4WlPvbNTKjhwYoirQ+2pYQeFVKE9wK3gIS1IOw==
X-Received: by 2002:a62:7ccb:: with SMTP id x194mr23171888pfc.318.1592205933006;
        Mon, 15 Jun 2020 00:25:33 -0700 (PDT)
Date: Mon, 15 Jun 2020 15:25:21 +0800
From: Gao Xiang <hsiangkao@redhat.com>
To: Jason Yan <yanaijie@huawei.com>
Cc: xiang@kernel.org, chao@kernel.org, gregkh@linuxfoundation.org,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] erofs: Eliminate usage of uninitialized_var() macro
Message-ID: <20200615072521.GA25317@xiangao.remote.csb>
References: <20200615040141.3627746-1-yanaijie@huawei.com>
MIME-Version: 1.0
In-Reply-To: <20200615040141.3627746-1-yanaijie@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jason,

On Mon, Jun 15, 2020 at 12:01:41PM +0800, Jason Yan wrote:
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
> The gcc option "-Wmaybe-uninitialized" has been disabled and this change
> will not produce any warnnings even with "make W=1".
> 
> [1] https://github.com/KSPP/linux/issues/81
> [2] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---

I'm fine with the patch since "-Wmaybe-uninitialized" has been disabled and
I've also asked Kees for it in private previously.

I still remembered that Kees sent out a treewide patch. Sorry about that
I don't catch up it... But what is wrong with the original patchset?

Thanks,
Gao Xiang

