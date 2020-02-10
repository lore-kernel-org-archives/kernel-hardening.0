Return-Path: <SRS0=9mrM=36=lists.openwall.com=kernel-hardening-return-17753-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB60BC35254
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 17:52:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 463FD2080C
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 17:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="SwvUPgIl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 463FD2080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17753-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11307 invoked by uid 550); 10 Feb 2020 17:52:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11281 invoked from network); 10 Feb 2020 17:52:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581357142;
	bh=w4QaI4rwl8xDK0pPvWLaHd5U0Rdh0Tn4UR8oOFoh5Pg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SwvUPgIlRB37NIGfkknNFZdWlQ7zdhhxoI9oOpxIjAVtbw5kEW46Z3Xua3ED9FVVz
	 Qe5ek2fpczwxrW3E2Q2bxRjmv2GVXM5HzJ/+ZCQ75nikohMXSsDTxFneXJ9W328+oF
	 NUm3yhGlentzJM3zl1Cd+UZ7gCE75VqB9vrOyToY=
Date: Mon, 10 Feb 2020 17:52:15 +0000
From: Will Deacon <will@kernel.org>
To: James Morse <james.morse@arm.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 09/11] arm64: disable SCS for hypervisor code
Message-ID: <20200210175214.GA23318@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200128184934.77625-1-samitolvanen@google.com>
 <20200128184934.77625-10-samitolvanen@google.com>
 <6f62b3c0-e796-e91c-f53b-23bd80fcb065@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f62b3c0-e796-e91c-f53b-23bd80fcb065@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Feb 10, 2020 at 05:18:58PM +0000, James Morse wrote:
> On 28/01/2020 18:49, Sami Tolvanen wrote:
> > Filter out CC_FLAGS_SCS and -ffixed-x18 for code that runs at a
> > different exception level.
> 
> Hmmm, there are two things being disabled here.
> 
> Stashing the lr in memory pointed to by VA won't work transparently at EL2 ... but
> shouldn't KVM's C code still treat x18 as a fixed register?

My review of v6 suggested dropping the -ffixed-x18 as well, since it's only
introduced by SCS (in patch 5) and so isn't required by anything else. Why
do you think it's needed?

> As you have an __attribute__((no_sanitize("shadow-call-stack"))), could we add that to
> __hyp_text instead? (its a smaller hammer!) All of KVM's EL2 code is marked __hyp_text,
> but that isn't everything in these files. Doing it like this would leave KVM's VHE-only
> paths covered.
> 
> As an example, with VHE the kernel and KVM both run at EL2, and KVM behaves differently:
> kvm_vcpu_put_sysregs() in kvm/hyp/sysreg-sr.c is called from a preempt notifier as
> the EL2 registers are always accessible.

That's a good point, and I agree that it would be nice to have SCS covering
the VHE paths. If you do that as a function attribute (which feels pretty
fragile to me), then I guess we'll have to keep the -ffixed-x18 for the
non-VHE code after all because GCC at least doesn't like having the register
saving ABI specified on a per-function basis.

Will
