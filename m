Return-Path: <SRS0=B/db=YX=lists.openwall.com=kernel-hardening-return-17170-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF9CCA9EC5
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 18:12:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EB64E2087E
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 18:12:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB64E2087E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17170-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28571 invoked by uid 550); 30 Oct 2019 18:12:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28539 invoked from network); 30 Oct 2019 18:12:22 -0000
Date: Wed, 30 Oct 2019 19:12:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Shyam Saini <mayhs11saini@gmail.com>
Cc: kernel-hardening@lists.openwall.com, iommu@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christopher Lameter <cl@linux.com>,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH V2] kernel: dma: contigous: Make CMA parameters
 __initdata/__initconst
Message-ID: <20191030181208.GA19513@lst.de>
References: <20191020050322.2634-1-mayhs11saini@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191020050322.2634-1-mayhs11saini@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Applied to the dma-mapping for-next branch after fixing up the commit
message and an overly long line.
