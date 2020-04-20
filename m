Return-Path: <SRS0=97h6=6E=lists.openwall.com=kernel-hardening-return-18577-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3EFCC55181
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 20:55:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0F288206E9
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 20:55:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="DCVwMIiU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F288206E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18577-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18274 invoked by uid 550); 20 Apr 2020 20:55:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18235 invoked from network); 20 Apr 2020 20:55:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587416104;
	bh=3Rft6Xo+yUX9yKXCCAXSFprstMdX0LEXPTtKv5UxrqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DCVwMIiUex03OuMbSo1VvNRl1hdp13/WfOl0GKswvu3nBoHT1SxNaGZ63K5poBEwk
	 CFbl2CKaxWkijsFgfx/uGBWozQbk3I0p+2+rK4tOQqAlDXzMS8o2pN72/mp7qypVK0
	 tGiUnz4ZcN/2NHsEiBMou/2dPAI+MKqgJ89DTi4A=
Date: Mon, 20 Apr 2020 21:54:58 +0100
From: Will Deacon <will@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	"Perla, Enrico" <enrico.perla@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] arm64: entry: Enable random_kstack_offset support
Message-ID: <20200420205458.GC29998@willie-the-truck>
References: <20200324203231.64324-1-keescook@chromium.org>
 <20200324203231.64324-6-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324203231.64324-6-keescook@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 24, 2020 at 01:32:31PM -0700, Kees Cook wrote:
> Allow for a randomized stack offset on a per-syscall basis, with roughly
> 5 bits of entropy.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm64/Kconfig          |  1 +
>  arch/arm64/kernel/syscall.c | 10 ++++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 0b30e884e088..4d5aa4959f72 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -127,6 +127,7 @@ config ARM64
>  	select HAVE_ARCH_MMAP_RND_BITS
>  	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
>  	select HAVE_ARCH_PREL32_RELOCATIONS
> +	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
>  	select HAVE_ARCH_SECCOMP_FILTER
>  	select HAVE_ARCH_STACKLEAK
>  	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
> diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
> index a12c0c88d345..238dbd753b44 100644
> --- a/arch/arm64/kernel/syscall.c
> +++ b/arch/arm64/kernel/syscall.c
> @@ -5,6 +5,7 @@
>  #include <linux/errno.h>
>  #include <linux/nospec.h>
>  #include <linux/ptrace.h>
> +#include <linux/randomize_kstack.h>
>  #include <linux/syscalls.h>
>  
>  #include <asm/daifflags.h>
> @@ -42,6 +43,8 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
>  {
>  	long ret;
>  
> +	add_random_kstack_offset();
> +
>  	if (scno < sc_nr) {
>  		syscall_fn_t syscall_fn;
>  		syscall_fn = syscall_table[array_index_nospec(scno, sc_nr)];
> @@ -51,6 +54,13 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
>  	}
>  
>  	regs->regs[0] = ret;
> +
> +	/*
> +	 * Since the compiler chooses a 4 bit alignment for the stack,
> +	 * let's save one additional bit (9 total), which gets us up
> +	 * near 5 bits of entropy.
> +	 */
> +	choose_random_kstack_offset(get_random_int() & 0x1FF);

Hmm, this comment doesn't make any sense to me. I mean, I get that 0x1ff
is 9 bits, and that is 4+5 but so what?

Will
