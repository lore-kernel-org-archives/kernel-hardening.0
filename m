Return-Path: <SRS0=ZBuq=AO=lists.openwall.com=kernel-hardening-return-19211-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87A1C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Jul 2020 16:16:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EA64220899
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Jul 2020 16:16:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMngjesK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA64220899
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19211-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5893 invoked by uid 550); 3 Jul 2020 16:16:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5858 invoked from network); 3 Jul 2020 16:16:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593792993;
	bh=bcCqWKhO1eod5uVd0pvGzOy2B4jq7cJ/KO64kFKi5zU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZMngjesKjraQ4+whMJCBKz84JD49c6POw0yboJIvh3D580dsKin7ypugXnrf4LGTr
	 teRdjCRVEmsFqcYF0hG0PcaLMbGDUGCTC3O8uHPG+GI4uvUwDzi3Xvl0RbE+VQJy5G
	 btneIHC5KV7aKVZbpcnDBKgNSlmKPIA8KwS9OpQA=
Date: Fri, 3 Jul 2020 17:16:29 +0100
From: Will Deacon <will@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC PATCH v2] arm64/acpi: disallow AML memory opregions to
 access kernel memory
Message-ID: <20200703161628.GB19595@willie-the-truck>
References: <20200623093755.1534006-1-ardb@kernel.org>
 <20200623162655.GA22650@red-moon.cambridge.arm.com>
 <CAMj1kXEwnDGV=J7kdtzrPY9hT=Bp6XRCw85urK2MLXsZG3zdMw@mail.gmail.com>
 <20200703161429.GA19595@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703161429.GA19595@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Jul 03, 2020 at 05:14:29PM +0100, Will Deacon wrote:
> Is this 5.9 material, or do you want it to go in as a fix?

Sorry, just spotted the v3, but the same question applies there!

Will
