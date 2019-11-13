Return-Path: <SRS0=THiL=ZF=lists.openwall.com=kernel-hardening-return-17346-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50CAC17442
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Nov 2019 12:05:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F065322459
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Nov 2019 12:05:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xzp4NRxM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F065322459
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17346-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11875 invoked by uid 550); 13 Nov 2019 12:05:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11380 invoked from network); 13 Nov 2019 12:03:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573646624;
	bh=BRAnggnfsbJTgIQ5lZaz2HxeSPSfVSTjxwdPk8Pofm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xzp4NRxMOJpx/y4unzpizB452z625+l9fYQ4y2pPh8Jr8JH8Gbg4TYdE+wmmx2FDj
	 q3HJwGgk5l8lI5cyRdIz4/d5ajRorVMfbEoF2VB1/4r3LUK9DrdvCEkMlReB1zlG71
	 zSTA8aSv2TN/opgU3z5GAvp5x6uy6tCRImCbEgvY=
Date: Wed, 13 Nov 2019 12:03:38 +0000
From: Will Deacon <will@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/14] add support for Clang's Shadow Call Stack
Message-ID: <20191113120337.GA26599@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191105235608.107702-1-samitolvanen@google.com>
 <201911121530.FA3D7321F@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201911121530.FA3D7321F@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Nov 12, 2019 at 03:44:42PM -0800, Kees Cook wrote:
> On Tue, Nov 05, 2019 at 03:55:54PM -0800, Sami Tolvanen wrote:
> > This patch series adds support for Clang's Shadow Call Stack
> > (SCS) mitigation, which uses a separately allocated shadow stack
> > to protect against return address overwrites. More information
> 
> Will, Catalin, Mark,
> 
> What's the next step here? I *think* all the comments have been
> addressed. Is it possible to land this via the arm tree for v5.5?

I was planning to queue this for 5.6, given that I'd really like it to
spend some quality time in linux-next.

Will
