Return-Path: <SRS0=R+ha=FH=lists.openwall.com=kernel-hardening-return-20515-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D62C64E8A
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 11:26:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 730C5206A1
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 11:26:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 730C5206A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20515-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26046 invoked by uid 550); 3 Dec 2020 11:26:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26026 invoked from network); 3 Dec 2020 11:26:42 -0000
Date: Thu, 3 Dec 2020 11:26:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1606994790;
	bh=Z6fRxajiQsjMgIcL2B8U6vdSMQSDFY19TKRTAoS5XwM=;
	h=From:To:Cc:Subject:References:In-Reply-To:From;
	b=BmIBlbUTavBbJSA9SMVKb3tOHpXr6pmjMIykJxf8ysFQLdGr4NcG39u+tYjgBM15e
	 ND0gIZQk/Z9Q2lye0p54KpIoxeRbEo86wBhS+sakJ/LTeGH97qgsHZUNuhciXa3sjH
	 Sdap/WsTwkwgmaDLJvxtIbvdHONV85FJ/NQJoTHO+D6r6+nGzh+djD8BmVCZPcr1UA
	 9KjdS0id2HpEqXYn1f4KtDSfcRnH9mLEjtLYqQpbDQNvRQtx3PhNUaVOjUSpg7p1Fx
	 +aW7XBdMBvjBOcwlwLm9jvoC5FZG3oy1RfqNQMCD7k9DXou+nfkgGL9P6MIG326q2n
	 FxiM1lHhq2TrA==
From: Will Deacon <will@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
Message-ID: <20201203112622.GA31188@willie-the-truck>
References: <20201201213707.541432-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201213707.541432-1-samitolvanen@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Sami,

On Tue, Dec 01, 2020 at 01:36:51PM -0800, Sami Tolvanen wrote:
> This patch series adds support for building the kernel with Clang's
> Link Time Optimization (LTO). In addition to performance, the primary
> motivation for LTO is to allow Clang's Control-Flow Integrity (CFI)
> to be used in the kernel. Google has shipped millions of Pixel
> devices running three major kernel versions with LTO+CFI since 2018.
> 
> Most of the patches are build system changes for handling LLVM
> bitcode, which Clang produces with LTO instead of ELF object files,
> postponing ELF processing until a later stage, and ensuring initcall
> ordering.
> 
> Note that arm64 support depends on Will's memory ordering patches
> [1]. I will post x86_64 patches separately after we have fixed the
> remaining objtool warnings [2][3].

I took this series for a spin, with my for-next/lto branch merged in but
I see a failure during the LTO stage with clang 11.0.5 because it doesn't
understand the '.arch_extension rcpc' directive we throw out in READ_ONCE().

We actually check that this extension is available before using it in
the arm64 Kconfig:

	config AS_HAS_LDAPR
		def_bool $(as-instr,.arch_extension rcpc)

so this shouldn't happen. I then realised, I wasn't passing LLVM_IAS=1
on my Make command line; with that, then the detection works correctly
and the LTO step succeeds.

Why is it necessary to pass LLVM_IAS=1 if LTO is enabled? I think it
would be _much_ better if this was implicit (or if LTO depended on it).

Cheers,

Will
