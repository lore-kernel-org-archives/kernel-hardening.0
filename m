Return-Path: <SRS0=bWB+=JE=lists.openwall.com=kernel-hardening-return-21174-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D75C433B4
	for <kernel-hardening@archiver.kernel.org>; Wed,  7 Apr 2021 21:35:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A4E7D611C9
	for <kernel-hardening@archiver.kernel.org>; Wed,  7 Apr 2021 21:35:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4E7D611C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21174-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26054 invoked by uid 550); 7 Apr 2021 21:35:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26034 invoked from network); 7 Apr 2021 21:35:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1617831309;
	bh=IdAzorjKFWWP7Wbg08Lv/fd2wz/xa0/RkGQZvq+ZFQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hmTeEKanC/hf6TByQCGKkTTUeM0E3DzNiv25DryA5VMVSM3MRfh1VaH/2bbk8mzAQ
	 2l7iQHBwvDXErGQ5gwe6x49SltrcvCmFZv8UdNehv4i436SIzm+GPK66TXcSoKZfFp
	 /DUWiQKJb2d92wMnFU6jW3qYY3vi7sKASbdIp7dhhpxoH+YMTrRJhgoYCOooTZEgiK
	 3+aiEEnTbrwWo6qXF5t0wmK8fQB1MKDEQrNESJknOo+jl6F4Yn9H7EUSsXBReAYM03
	 zYkvCMpwQTJ/ga0Fju36msC7V5ZPjiJpbv/7LWokEKiAW1CinZFro/xOWT6BKLi7Rt
	 9KFhqRBPoiRqA==
Date: Wed, 7 Apr 2021 22:35:03 +0100
From: Will Deacon <will@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 5/6] arm64: entry: Enable random_kstack_offset support
Message-ID: <20210407213502.GA16569@willie-the-truck>
References: <20210401232347.2791257-1-keescook@chromium.org>
 <20210401232347.2791257-6-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401232347.2791257-6-keescook@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Apr 01, 2021 at 04:23:46PM -0700, Kees Cook wrote:
> Allow for a randomized stack offset on a per-syscall basis, with roughly
> 5 bits of entropy. (And include AAPCS rationale AAPCS thanks to Mark
> Rutland.)
> 
> In order to avoid unconditional stack canaries on syscall entry (due to
> the use of alloca()), also disable stack protector to avoid triggering
> needless checks and slowing down the entry path. As there is no general
> way to control stack protector coverage with a function attribute[1],
> this must be disabled at the compilation unit level. This isn't a problem
> here, though, since stack protector was not triggered before: examining
> the resulting syscall.o, there are no changes in canary coverage (none
> before, none now).
> 
> [1] a working __attribute__((no_stack_protector)) has been added to GCC
> and Clang but has not been released in any version yet:
> https://gcc.gnu.org/git/gitweb.cgi?p=gcc.git;h=346b302d09c1e6db56d9fe69048acb32fbb97845
> https://reviews.llvm.org/rG4fbf84c1732fca596ad1d6e96015e19760eb8a9b
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm64/Kconfig          |  1 +
>  arch/arm64/kernel/Makefile  |  5 +++++
>  arch/arm64/kernel/syscall.c | 16 ++++++++++++++++
>  3 files changed, 22 insertions(+)

Acked-by: Will Deacon <will@kernel.org>

Will
