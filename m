Return-Path: <SRS0=Xj6v=6G=lists.openwall.com=kernel-hardening-return-18600-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F419C54FCB
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 15:27:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F3CE42074B
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 15:27:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2nktKRWL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3CE42074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18600-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25630 invoked by uid 550); 22 Apr 2020 15:27:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24571 invoked from network); 22 Apr 2020 15:27:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587569221;
	bh=iFj8MYiWc1vTLbtxX79bjqZqrGedGEOkRoAIX7PaOm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2nktKRWLprljtpWMUuVD9MoVOINAjjG5gwTPDM2UKS/8aCjWrkckWAnkD9y9wDRgc
	 6J8ImMMDeDpVDhF9TCJd9YN1hRSv9TJfa+8vlyUuYPv8ZVvyDtAk6ne9AncLpJy0JT
	 +0Oxe0JPM8bURH6ch8grpO4+XAURnv6fcSu5F6FE=
Date: Wed, 22 Apr 2020 16:26:56 +0100
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Phong Tran <tranmanphong@gmail.com>, steve.capper@arm.com,
	steven.price@arm.com, keescook@chromium.org, greg@kroah.com,
	akpm@linux-foundation.org, alexios.zavras@intel.com,
	broonie@kernel.org, kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de
Subject: Re: [PATCH v2] arm64: add check_wx_pages debugfs for CHECK_WX
Message-ID: <20200422152656.GF676@willie-the-truck>
References: <20200307093926.27145-1-tranmanphong@gmail.com>
 <20200421173557.10817-1-tranmanphong@gmail.com>
 <20200422143526.GD54796@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422143526.GD54796@lakrids.cambridge.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Apr 22, 2020 at 03:35:27PM +0100, Mark Rutland wrote:
> On Wed, Apr 22, 2020 at 12:35:58AM +0700, Phong Tran wrote:
> > follow the suggestion from
> > https://github.com/KSPP/linux/issues/35
> > 
> > Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> > ---
> > Change since v1:
> > - Update the Kconfig help text
> > - Don't check the return value of debugfs_create_file()
> > - Tested on QEMU aarch64
> 
> As on v1, I think that this should be generic across all architectures
> with CONFIG_DEBUG_WX. Adding this only on arm64 under
> CONFIG_PTDUMP_DEBUGFS (which does not generally imply a WX check)
> doesn't seem right.
> 
> Maybe we need a new ARCH_HAS_CHECK_WX config to make that simpler, but
> that seems simple to me.

Agreed. When I asked about respinning, I assumed this would be done in
generic code as you requested on the first version. Phong -- do you think
you can take a look at that, please?

> Thanks,
> Marm.

Wow, employee of the month!

Will
