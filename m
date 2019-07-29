Return-Path: <SRS0=vIfR=V2=lists.openwall.com=kernel-hardening-return-16617-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A09EC7618B
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 14:38:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D074020578
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 14:38:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nXtEMeP3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D074020578
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16617-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5298 invoked by uid 550); 29 Jul 2019 14:38:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32259 invoked from network); 29 Jul 2019 14:32:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=LQVvrxHhNozlLrCeoa/r+A8a1Nth6EeS0mzOOGaTr78=; b=nXtEMeP3eXdw0s5WVf3Dx0y+L
	4ZsAitEjAUHYUWry1q9onLEND2XAwrHbDYKRNGr8TWIFA0wrFrLwSmnowIGSxI1DqSfqPONkLhb73
	A+8gZx3qMyyFH0f09dKY/0epJqv7+H8jZDiDg5AxYuZcdQf395uliYZFmldMl7Fmvj3zRR9u73DlQ
	J8IFNkhmCrUOUfUcPtAscivnTfeiOSHPo3y2xDD8UkSW19mGq+ZYnzoSYs4DdoN5diyyFd5CFSrhJ
	GAlG8sA05FpHaTRzs8iyQQkVH02LrPi1xvcBBhskH7fgi8LPtDac8u4FkMu/oMZCDCSANW2GkPrNK
	XqtY66wsQ==;
Date: Mon, 29 Jul 2019 07:31:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jason Yan <yanaijie@huawei.com>
Cc: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
	diana.craciun@nxp.com, christophe.leroy@c-s.fr,
	benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
	keescook@chromium.org, kernel-hardening@lists.openwall.com,
	wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org,
	jingxiangfeng@huawei.com, thunder.leizhen@huawei.com,
	fanchengyang@huawei.com, yebin10@huawei.com
Subject: Re: [RFC PATCH 02/10] powerpc: move memstart_addr and kernstart_addr
 to init-common.c
Message-ID: <20190729143155.GA11737@infradead.org>
References: <20190717080621.40424-1-yanaijie@huawei.com>
 <20190717080621.40424-3-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717080621.40424-3-yanaijie@huawei.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I think you need to keep the more restrictive EXPORT_SYMBOL_GPL from
the 64-bit code to keep the intention of all authors intact.
