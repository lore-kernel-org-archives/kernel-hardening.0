Return-Path: <SRS0=y3Oz=ZV=lists.openwall.com=kernel-hardening-return-17449-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE906C432C3
	for <kernel-hardening@archiver.kernel.org>; Fri, 29 Nov 2019 11:29:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 05AA320833
	for <kernel-hardening@archiver.kernel.org>; Fri, 29 Nov 2019 11:29:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05AA320833
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17449-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15778 invoked by uid 550); 29 Nov 2019 11:29:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15744 invoked from network); 29 Nov 2019 11:29:31 -0000
Date: Fri, 29 Nov 2019 11:29:13 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Kassad <aashad940@gmail.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org
Subject: Re: Contributing to KSPP newbie
Message-ID: <20191129112825.GA27873@lakrids.cambridge.arm.com>
References: <CA+OAcEM94aAcaXB17Z2q9_iMWVEepCR8SycY6WSTcKYd+5rCAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+OAcEM94aAcaXB17Z2q9_iMWVEepCR8SycY6WSTcKYd+5rCAg@mail.gmail.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Thu, Nov 28, 2019 at 11:39:11PM -0500, Kassad wrote:
> Hey Kees,
> 
> I'm 3rd university student interested in learning more about the linux kernel.
> I'm came across this subsystem, since it aligns with my interest in security.
> Do you think as a newbie this task https://github.com/KSPP/linux/issues/11 will
> be a good starting point?

I think this specific task (Disable arm32 kuser helpers) has already
been done, and the ticket is stale.

On arm CONFIG_KUSER_HELPERS can be disabled on kernels that don't need
to run on HW prior to ARMv6. See commit:

  f6f91b0d9fd971c6 ("ARM: allow kuser helpers to be removed from the vector page")

On arm64, CONFIG_KUSER_HELPERS can be disabled on any kernel. See
commit:

  1b3cf2c2a3f42b ("arm64: compat: Add KUSER_HELPERS config option")

Thanks,
Mark.
