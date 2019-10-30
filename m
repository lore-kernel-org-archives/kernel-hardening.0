Return-Path: <SRS0=xbF+=YX=lists.openwall.com=kernel-hardening-return-17167-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD8CCA9EC5
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 12:14:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6EA2A20862
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 12:14:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EA2A20862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17167-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9395 invoked by uid 550); 30 Oct 2019 12:14:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9357 invoked from network); 30 Oct 2019 12:14:29 -0000
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 96664dee5cf1815777286227b09884b4f019727f
In-Reply-To: <20190907061124.1947-2-cmr@informatik.wtf>
To: "Christopher M. Riedl" <cmr@informatik.wtf>, linuxppc-dev@ozlabs.org, kernel-hardening@lists.openwall.com
From: Michael Ellerman <patch-notifications@ellerman.id.au>
Cc: ajd@linux.ibm.com, dja@axtens.net
Subject: Re: [PATCH v7 1/2] powerpc/xmon: Allow listing and clearing breakpoints in read-only mode
Message-Id: <4736nh54WPz9sQm@ozlabs.org>
Date: Wed, 30 Oct 2019 23:14:16 +1100 (AEDT)

On Sat, 2019-09-07 at 06:11:23 UTC, "Christopher M. Riedl" wrote:
> Read-only mode should not prevent listing and clearing any active
> breakpoints.
> 
> Tested-by: Daniel Axtens <dja@axtens.net>
> Reviewed-by: Daniel Axtens <dja@axtens.net>
> Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>

Series applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/96664dee5cf1815777286227b09884b4f019727f

cheers
