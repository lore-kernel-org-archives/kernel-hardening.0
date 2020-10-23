Return-Path: <SRS0=prbn=D6=lists.openwall.com=kernel-hardening-return-20255-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54273C4363A
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Oct 2020 12:04:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 59989208E4
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Oct 2020 12:04:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59989208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20255-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18381 invoked by uid 550); 23 Oct 2020 12:03:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15953 invoked from network); 23 Oct 2020 09:02:50 -0000
Date: Fri, 23 Oct 2020 10:02:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Topi Miettinen <toiwoton@gmail.com>,
	Szabolcs Nagy <szabolcs.nagy@arm.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	libc-alpha@sourceware.org, systemd-devel@lists.freedesktop.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, Dave Martin <dave.martin@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Salvatore Mesoraca <s.mesoraca16@gmail.com>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org
Subject: Re: BTI interaction between seccomp filters in systemd and glibc
 mprotect calls, causing service failures
Message-ID: <20201023090232.GA25736@gaia>
References: <8584c14f-5c28-9d70-c054-7c78127d84ea@arm.com>
 <20201022075447.GO3819@arm.com>
 <78464155-f459-773f-d0ee-c5bdbeb39e5d@gmail.com>
 <202010221256.A4F95FD11@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202010221256.A4F95FD11@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Oct 22, 2020 at 01:02:18PM -0700, Kees Cook wrote:
> Regardless, it makes sense to me to have the kernel load the executable
> itself with BTI enabled by default. I prefer gaining Catalin's suggested
> patch[2]. :)
[...]
> [2] https://lore.kernel.org/linux-arm-kernel/20201022093104.GB1229@gaia/

I think I first heard the idea at Mark R ;).

It still needs glibc changes to avoid the mprotect(), or at least ignore
the error. Since this is an ABI change and we don't know which kernels
would have it backported, maybe better to still issue the mprotect() but
ignore the failure.

-- 
Catalin
