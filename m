Return-Path: <SRS0=EehC=AE=lists.openwall.com=kernel-hardening-return-19063-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FB2C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 09:41:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3170820679
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 09:41:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3170820679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19063-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28070 invoked by uid 550); 23 Jun 2020 09:40:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28028 invoked from network); 23 Jun 2020 09:40:54 -0000
Date: Tue, 23 Jun 2020 10:40:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>, kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/5] arm64: entry: Enable random_kstack_offset support
Message-ID: <20200623094036.GD6374@C02TD0UTHF1T.local>
References: <20200622193146.2985288-1-keescook@chromium.org>
 <20200622193146.2985288-6-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622193146.2985288-6-keescook@chromium.org>

On Mon, Jun 22, 2020 at 12:31:46PM -0700, Kees Cook wrote:
> Allow for a randomized stack offset on a per-syscall basis, with roughly
> 5 bits of entropy.
> 
> In order to avoid unconditional stack canaries on syscall entry, also
> downgrade from -fstack-protector-strong to -fstack-protector to avoid
> triggering checks due to alloca(). Examining the resulting syscall.o,
> sees no changes in canary coverage (none before, none now).

Is there any way we can do this on invoke_syscall() specifically with an
attribute? That'd help to keep all the concerns local in the file, and
means that we wouldn't potentially lose protection for other functions
that get added in future.

> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm64/Kconfig          |  1 +
>  arch/arm64/kernel/Makefile  |  5 +++++
>  arch/arm64/kernel/syscall.c | 10 ++++++++++
>  3 files changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index a4a094bedcb2..2902e5316e1a 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -135,6 +135,7 @@ config ARM64
>  	select HAVE_ARCH_MMAP_RND_BITS
>  	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
>  	select HAVE_ARCH_PREL32_RELOCATIONS
> +	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
>  	select HAVE_ARCH_SECCOMP_FILTER
>  	select HAVE_ARCH_STACKLEAK
>  	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 151f28521f1e..39fc23d3770b 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -11,6 +11,11 @@ CFLAGS_REMOVE_ftrace.o = $(CC_FLAGS_FTRACE)
>  CFLAGS_REMOVE_insn.o = $(CC_FLAGS_FTRACE)
>  CFLAGS_REMOVE_return_address.o = $(CC_FLAGS_FTRACE)
>  
> +# Downgrade to -fstack-protector to avoid triggering unneeded stack canary
> +# checks due to randomize_kstack_offset.
> +CFLAGS_REMOVE_syscall.o += -fstack-protector-strong
> +CFLAGS_syscall.o	+= $(subst -fstack-protector-strong,-fstack-protector,$(filter -fstack-protector-strong,$(KBUILD_CFLAGS)))
> +
>  # Object file lists.
>  obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
>  			   entry-common.o entry-fpsimd.o process.o ptrace.o	\
> diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
> index 5f5b868292f5..00d3c84db9cd 100644
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

To explain the alignment requirement a bit better, how about:

	/*
	 * The AAPCS mandates a 16-byte (i.e. 4-bit) aligned SP at
	 * function boundaries. We want at least 5 bits of entropy so we
	 * must randomize at least SP[8:4].
	 */

> +	choose_random_kstack_offset(get_random_int() & 0x1FF);

Do we have a rationale for randomizing bits SP[3:0]? If not, we might
get better code gen with a 0x1F0 mask, since the compiler won't need to
round down the SP.

If we have a rationale that's fine, but we should spell it out more
explicitly in the comment. Even if that's just "randomizing SP[3:0]
isn't harmful, so we randomize those too".

Thanks,
Mark.
