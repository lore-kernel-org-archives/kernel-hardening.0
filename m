Return-Path: <SRS0=wEq/=AF=lists.openwall.com=kernel-hardening-return-19137-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63F2C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:16:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 496A520768
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:16:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lvI0AvNC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 496A520768
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19137-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19902 invoked by uid 550); 24 Jun 2020 21:15:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19865 invoked from network); 24 Jun 2020 21:15:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CYAOBdXXwk5atGG1OkexemEOJEg2uOXvmf8MxtMHkzA=; b=lvI0AvNCOyQRFPEBPSO732MCmS
	priyMdaeyT9DlHRLc/z9qWhkeCY/G37ozS6HciR55B+xdk3sRO+bn4RdzWVJS4FDFf++roys12UFi
	2Xn0aJcu82shXhcuPUJaxr0NiofjiM9cS72P+0UyExr/CWjZItZDE4OZMDMLf4RBiQ+3eGs0RrR20
	QerCqnR4yK+D/eqXSR/BaYzSzLfSMZBayOvuxe0uMIgumCmxbS4aKn+HlmJxHDAjxC7KlQlu9/mMK
	D//TxmU24AKwnTz6mvW3vYpxg3iJ7ar26Kv6tNzbCv4aRAJOYWk+gjYHLWLDLC4v2if3/bM+oS2fR
	WOLeUYeg==;
Date: Wed, 24 Jun 2020 23:15:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 00/22] add support for Clang LTO
Message-ID: <20200624211540.GS4817@hirez.programming.kicks-ass.net>
References: <20200624203200.78870-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>

On Wed, Jun 24, 2020 at 01:31:38PM -0700, Sami Tolvanen wrote:
> This patch series adds support for building x86_64 and arm64 kernels
> with Clang's Link Time Optimization (LTO).
> 
> In addition to performance, the primary motivation for LTO is to allow
> Clang's Control-Flow Integrity (CFI) to be used in the kernel. Google's
> Pixel devices have shipped with LTO+CFI kernels since 2018.
> 
> Most of the patches are build system changes for handling LLVM bitcode,
> which Clang produces with LTO instead of ELF object files, postponing
> ELF processing until a later stage, and ensuring initcall ordering.
> 
> Note that first objtool patch in the series is already in linux-next,
> but as it's needed with LTO, I'm including it also here to make testing
> easier.

I'm very sad that yet again, memory ordering isn't addressed. LTO vastly
increases the range of the optimizer to wreck things.
