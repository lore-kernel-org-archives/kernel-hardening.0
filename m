Return-Path: <SRS0=LkDN=I6=lists.openwall.com=kernel-hardening-return-21111-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1D8C433ED
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 08:34:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A14BB610A5
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 08:34:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A14BB610A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21111-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3334 invoked by uid 550); 1 Apr 2021 08:34:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3296 invoked from network); 1 Apr 2021 08:34:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1617266078;
	bh=4MAUhgc2EjPF0O1tuWck19E4Snr5jqCQk7ne8IYrk8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iqtdHgInDXI1MQnKwtqnGygpiJU+b1cS5TSDJIpQMaPUKb4UWN04LNYTSX14ou/VC
	 /StqBni3nozP8e18DkcEonvC8/kbOfeu0Cmythwz7ZW9RMZOWfIsGypfHYnqjIo76n
	 BJCFOnmo/Jq/YI1wK7TFnCIKuNYtjSZwMKVNthbvx+M34Lp0N9pyMVbKWQr+AunV1E
	 5FLnFSAxNlJv4uL+SkQ98thgQqlv8XQGU1C4Thk0pwm+CfHbmWzgkqxixqX2TW/In7
	 ylX3KlL16wlbcZwOjRvNBg7Giq3DMfV08s09HcRWsg8ytywG+ERiDgPqKorkXj6QUC
	 uhG5NKIUf0Ong==
Date: Thu, 1 Apr 2021 09:34:31 +0100
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
Subject: Re: [PATCH v7 5/6] arm64: entry: Enable random_kstack_offset support
Message-ID: <20210401083430.GB8554@willie-the-truck>
References: <20210319212835.3928492-1-keescook@chromium.org>
 <20210319212835.3928492-6-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319212835.3928492-6-keescook@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Mar 19, 2021 at 02:28:34PM -0700, Kees Cook wrote:
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
>  arch/arm64/kernel/syscall.c | 10 ++++++++++
>  3 files changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 1f212b47a48a..2d0e5f544429 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -146,6 +146,7 @@ config ARM64
>  	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
>  	select HAVE_ARCH_PFN_VALID
>  	select HAVE_ARCH_PREL32_RELOCATIONS
> +	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
>  	select HAVE_ARCH_SECCOMP_FILTER
>  	select HAVE_ARCH_STACKLEAK
>  	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index ed65576ce710..6cc97730790e 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -9,6 +9,11 @@ CFLAGS_REMOVE_ftrace.o = $(CC_FLAGS_FTRACE)
>  CFLAGS_REMOVE_insn.o = $(CC_FLAGS_FTRACE)
>  CFLAGS_REMOVE_return_address.o = $(CC_FLAGS_FTRACE)
>  
> +# Remove stack protector to avoid triggering unneeded stack canary
> +# checks due to randomize_kstack_offset.
> +CFLAGS_REMOVE_syscall.o	 = -fstack-protector -fstack-protector-strong
> +CFLAGS_syscall.o	+= -fno-stack-protector
> +
>  # Object file lists.
>  obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
>  			   entry-common.o entry-fpsimd.o process.o ptrace.o	\
> diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
> index b9cf12b271d7..58227a1c207e 100644
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
> @@ -43,6 +44,8 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
>  {
>  	long ret;
>  
> +	add_random_kstack_offset();
> +
>  	if (scno < sc_nr) {
>  		syscall_fn_t syscall_fn;
>  		syscall_fn = syscall_table[array_index_nospec(scno, sc_nr)];
> @@ -55,6 +58,13 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
>  		ret = lower_32_bits(ret);
>  
>  	regs->regs[0] = ret;
> +
> +	/*
> +	 * The AAPCS mandates a 16-byte (i.e. 4-bit) aligned SP at
> +	 * function boundaries. We want at least 5 bits of entropy so we
> +	 * must randomize at least SP[8:4].
> +	 */
> +	choose_random_kstack_offset(get_random_int() & 0x1FF);

Not sure about either of these new calls -- aren't we preemptible in
invoke_syscall()?

Will
