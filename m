Return-Path: <SRS0=UapI=H2=lists.openwall.com=kernel-hardening-return-20818-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B101AC433DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 14:15:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B3D4964DD0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 14:15:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3D4964DD0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20818-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14096 invoked by uid 550); 24 Feb 2021 14:15:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11738 invoked from network); 24 Feb 2021 14:11:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1614175879;
	bh=BpYruk68R6kEq7xF24RrqNtwpV+CW2aJPPDU8jzgAT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zk+epHjJBrdH00f9FVkblXRodT6Lfd8mxT1WJMGWIPy6IYQr7VuAAY1O8pmYZlbq1
	 JzSKh1yqqDoR+yc0x/eS76/0Y8CYsZyVeuLPb1HnQXpLbrXcv6TixCRbz/uxppnwMK
	 qxBgf344XsL3afsoJduMVjX8gxf64Ssh0OLWyh1A=
Date: Wed, 24 Feb 2021 15:11:16 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "Lan Zheng (lanzheng)" <lanzheng@cisco.com>
Cc: "security@kernel.org" <security@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] Kernel Config to make randomize_va_space
 read-only.
Message-ID: <YDZehClJ+FaX9RC4@kroah.com>
References: <99738B18-C4E2-4DBA-A142-8F20650D7ADC@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99738B18-C4E2-4DBA-A142-8F20650D7ADC@cisco.com>

On Wed, Feb 24, 2021 at 03:53:37AM +0000, Lan Zheng (lanzheng) wrote:
> From ba2ec52f170a8e69d6c44238bb578f9518a7e3b7 Mon Sep 17 00:00:00 2001
> 
> From: lanzheng <lanzheng@cisco.com>

<snip>

You are still sending html email, which is rejected by the kernel
mailing lists.

And no need to cc: security@kernel.org, that is only for reporting
security issues, not new kernel changes like this.

good luck!

greg k-h
