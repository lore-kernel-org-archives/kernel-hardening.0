Return-Path: <SRS0=bTF9=6E=lists.openwall.com=kernel-hardening-return-18576-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFA9C54FD0
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 20:42:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 20302206E9
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 20:42:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xMeM05XE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20302206E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18576-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5883 invoked by uid 550); 20 Apr 2020 20:42:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5846 invoked from network); 20 Apr 2020 20:42:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587415343;
	bh=SYmDL71+i0dxipydp4fzdeCa0qcgn3q6383QGXptJxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xMeM05XEdBoL/1hRghTVBJkRL92JNBsc0vONEfPdXkSjSKxdOO+hwrPBHdB/Cr1Z9
	 GOD/PkSOModeIzIKldikpS1QexS3bmWDjnQ1l890YR72ONrmjqRMU1CbRcBJio2bGZ
	 DiXKGrl9oq/t5wptbUrKeawIy93SgtP0oDiVXJH0=
Date: Mon, 20 Apr 2020 21:42:18 +0100
From: Will Deacon <will@kernel.org>
To: Phong Tran <tranmanphong@gmail.com>
Cc: catalin.marinas@arm.com, alexios.zavras@intel.com, tglx@linutronix.de,
	akpm@linux-foundation.org, steven.price@arm.com,
	steve.capper@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	keescook@chromium.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] arm64: add check_wx_pages debugfs for CHECK_WX
Message-ID: <20200420204217.GA29998@willie-the-truck>
References: <20200307093926.27145-1-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200307093926.27145-1-tranmanphong@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Sat, Mar 07, 2020 at 04:39:26PM +0700, Phong Tran wrote:
> follow the suggestion from
> https://github.com/KSPP/linux/issues/35
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
>  arch/arm64/Kconfig.debug        |  3 ++-
>  arch/arm64/include/asm/ptdump.h |  2 ++
>  arch/arm64/mm/dump.c            |  1 +
>  arch/arm64/mm/ptdump_debugfs.c  | 18 ++++++++++++++++++
>  4 files changed, 23 insertions(+), 1 deletion(-)

Any plans to spin an updated version of this? The review feedback all seemed
reasonable to me.

Thanks,

Will
