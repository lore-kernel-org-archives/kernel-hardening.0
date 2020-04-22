Return-Path: <SRS0=jFX8=6G=lists.openwall.com=kernel-hardening-return-18602-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C695C54FCB
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 17:11:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BB36420776
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 17:11:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB36420776
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18602-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22097 invoked by uid 550); 22 Apr 2020 17:11:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22062 invoked from network); 22 Apr 2020 17:11:44 -0000
Date: Wed, 22 Apr 2020 18:11:22 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Phong Tran <tranmanphong@gmail.com>, steve.capper@arm.com,
	steven.price@arm.com, keescook@chromium.org, greg@kroah.com,
	akpm@linux-foundation.org, alexios.zavras@intel.com,
	broonie@kernel.org, kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de
Subject: Re: [PATCH v2] arm64: add check_wx_pages debugfs for CHECK_WX
Message-ID: <20200422171122.GA40812@lakrids.cambridge.arm.com>
References: <20200307093926.27145-1-tranmanphong@gmail.com>
 <20200421173557.10817-1-tranmanphong@gmail.com>
 <20200422143526.GD54796@lakrids.cambridge.arm.com>
 <20200422152656.GF676@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422152656.GF676@willie-the-truck>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Wed, Apr 22, 2020 at 04:26:56PM +0100, Will Deacon wrote:
> On Wed, Apr 22, 2020 at 03:35:27PM +0100, Mark Rutland wrote:
> > Thanks,
> > Marm.
> 
> Wow, employee of the month!

Muscle-memory has finally defeated me...

Marm.
