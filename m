Return-Path: <SRS0=3Rnm=5J=lists.openwall.com=kernel-hardening-return-18215-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A850C10DCE
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 22:07:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 95A652078A
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 22:07:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aAS4Q+6s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95A652078A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18215-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18028 invoked by uid 550); 24 Mar 2020 22:07:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17996 invoked from network); 24 Mar 2020 22:07:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RgOSv5leUzdh9drlvUWI/yMDTMMdqFPXz0ZLHcJ9Qrk=; b=aAS4Q+6sODIaHbIvnMNlQ5KsSS
	WQ6pOZIKF1v1HbpnjpTp0sEEqKotsv7YAX/6keV3jCJi4monNTYQgMJDjQc6zZgSJyWEoAJJxrCn6
	2Wtau+W4MCGQhoG1DYaVOae5ieyPMQantZoA70LPpgA2d92YcmM9Opq94LM+64idGuHIarHnOa+fJ
	8g/FtxwMBiYi5ljyGa6nG/AzrKDh3BPJpxrV/7Nn030GCm7jOEH3LpTrxhyQH2Gl6SJDFbCgh7/Yu
	EHVYqlnS6JEoOjv8O8HKtL1Xt5PUyZ3W+zgHvzKrF2zatGASlP9ApCKZ12nWFczNHgWiHpAVILumF
	lFViESkw==;
Date: Tue, 24 Mar 2020 23:06:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	"Perla, Enrico" <enrico.perla@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] jump_label: Provide CONFIG-driven build state
 defaults
Message-ID: <20200324220641.GT2452@worktop.programming.kicks-ass.net>
References: <20200324203231.64324-1-keescook@chromium.org>
 <20200324203231.64324-2-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324203231.64324-2-keescook@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 24, 2020 at 01:32:27PM -0700, Kees Cook wrote:
> Choosing the initial state of static branches changes the assembly
> layout (if the condition is expected to be likely, inline, or unlikely,
> out of line via a jump). A few places in the kernel use (or could be
> using) a CONFIG to choose the default state, so provide the
> infrastructure to do this and convert the existing cases (init_on_alloc
> and init_on_free) to the new macros.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Cute,

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
