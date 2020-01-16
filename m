Return-Path: <SRS0=7xj+=3F=lists.openwall.com=kernel-hardening-return-17574-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D88FC33CB6
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 17:49:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4ABC82468D
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 17:49:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qZiF6LJX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4ABC82468D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17574-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15639 invoked by uid 550); 16 Jan 2020 17:49:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15617 invoked from network); 16 Jan 2020 17:49:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579196932;
	bh=yRvYIY5/icd2WficOCFNqLrfEVkGFG14cg7dYGwt1ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qZiF6LJXtmfzV8cl0/IHOiStIoYgH5m1Q/Xqo9Z0X25QzK5/mZqjwFRsR4fO14kb7
	 NemreBeS57WXPRukoHkNrzHdW47paPD2QFCnvc7csqw381kkjKK1Fa7EdZxh3e6LXw
	 +guMDfAnElzwAmHo2LFnfFjteIdfOljXqQ6w7ZPY=
Date: Thu, 16 Jan 2020 17:48:47 +0000
From: Will Deacon <will@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>, james.morse@arm.com
Cc: Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: Re: [PATCH v6 15/15] arm64: scs: add shadow stacks for SDEI
Message-ID: <20200116174846.GG21396@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191206221351.38241-1-samitolvanen@google.com>
 <20191206221351.38241-16-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206221351.38241-16-samitolvanen@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

[+James, since this needs his Ack before it can be merged]

On Fri, Dec 06, 2019 at 02:13:51PM -0800, Sami Tolvanen wrote:
> This change adds per-CPU shadow call stacks for the SDEI handler.
> Similarly to how the kernel stacks are handled, we add separate shadow
> stacks for normal and critical events.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  arch/arm64/include/asm/scs.h |   2 +
>  arch/arm64/kernel/entry.S    |  14 ++++-
>  arch/arm64/kernel/scs.c      | 106 +++++++++++++++++++++++++++++------
>  arch/arm64/kernel/sdei.c     |   7 +++
>  4 files changed, 112 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/scs.h b/arch/arm64/include/asm/scs.h
> index c50d2b0c6c5f..8e327e14bc15 100644
> --- a/arch/arm64/include/asm/scs.h
> +++ b/arch/arm64/include/asm/scs.h
> @@ -9,6 +9,7 @@
>  #ifdef CONFIG_SHADOW_CALL_STACK
>  
>  extern void scs_init_irq(void);
> +extern int scs_init_sdei(void);
>  
>  static __always_inline void scs_save(struct task_struct *tsk)
>  {
> @@ -27,6 +28,7 @@ static inline void scs_overflow_check(struct task_struct *tsk)
>  #else /* CONFIG_SHADOW_CALL_STACK */
>  
>  static inline void scs_init_irq(void) {}
> +static inline int scs_init_sdei(void) { return 0; }
>  static inline void scs_save(struct task_struct *tsk) {}
>  static inline void scs_overflow_check(struct task_struct *tsk) {}
>  
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 7aa2d366b2df..9327c3d21b64 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -1048,13 +1048,16 @@ ENTRY(__sdei_asm_handler)
>  
>  	mov	x19, x1
>  
> +#if defined(CONFIG_VMAP_STACK) || defined(CONFIG_SHADOW_CALL_STACK)
> +	ldrb	w4, [x19, #SDEI_EVENT_PRIORITY]
> +#endif
> +
>  #ifdef CONFIG_VMAP_STACK
>  	/*
>  	 * entry.S may have been using sp as a scratch register, find whether
>  	 * this is a normal or critical event and switch to the appropriate
>  	 * stack for this CPU.
>  	 */
> -	ldrb	w4, [x19, #SDEI_EVENT_PRIORITY]
>  	cbnz	w4, 1f
>  	ldr_this_cpu dst=x5, sym=sdei_stack_normal_ptr, tmp=x6
>  	b	2f
> @@ -1064,6 +1067,15 @@ ENTRY(__sdei_asm_handler)
>  	mov	sp, x5
>  #endif
>  
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	/* Use a separate shadow call stack for normal and critical events */
> +	cbnz	w4, 3f
> +	ldr_this_cpu dst=x18, sym=sdei_shadow_call_stack_normal_ptr, tmp=x6
> +	b	4f
> +3:	ldr_this_cpu dst=x18, sym=sdei_shadow_call_stack_critical_ptr, tmp=x6
> +4:
> +#endif
> +
>  	/*
>  	 * We may have interrupted userspace, or a guest, or exit-from or
>  	 * return-to either of these. We can't trust sp_el0, restore it.
> diff --git a/arch/arm64/kernel/scs.c b/arch/arm64/kernel/scs.c
> index eaadf5430baa..dddb7c56518b 100644
> --- a/arch/arm64/kernel/scs.c
> +++ b/arch/arm64/kernel/scs.c
> @@ -10,31 +10,105 @@
>  #include <asm/pgtable.h>
>  #include <asm/scs.h>
>  
> -DEFINE_PER_CPU(unsigned long *, irq_shadow_call_stack_ptr);
> +#define DECLARE_SCS(name)						\
> +	DECLARE_PER_CPU(unsigned long *, name ## _ptr);			\
> +	DECLARE_PER_CPU(unsigned long [SCS_SIZE/sizeof(long)], name)
>  
> -#ifndef CONFIG_SHADOW_CALL_STACK_VMAP
> -DEFINE_PER_CPU(unsigned long [SCS_SIZE/sizeof(long)], irq_shadow_call_stack)
> -	__aligned(SCS_SIZE);
> +#ifdef CONFIG_SHADOW_CALL_STACK_VMAP
> +#define DEFINE_SCS(name)						\
> +	DEFINE_PER_CPU(unsigned long *, name ## _ptr)
> +#else
> +/* Allocate a static per-CPU shadow stack */
> +#define DEFINE_SCS(name)						\
> +	DEFINE_PER_CPU(unsigned long *, name ## _ptr);			\
> +	DEFINE_PER_CPU(unsigned long [SCS_SIZE/sizeof(long)], name)	\
> +		__aligned(SCS_SIZE)
> +#endif /* CONFIG_SHADOW_CALL_STACK_VMAP */
> +
> +DECLARE_SCS(irq_shadow_call_stack);
> +DECLARE_SCS(sdei_shadow_call_stack_normal);
> +DECLARE_SCS(sdei_shadow_call_stack_critical);
> +
> +DEFINE_SCS(irq_shadow_call_stack);
> +#ifdef CONFIG_ARM_SDE_INTERFACE
> +DEFINE_SCS(sdei_shadow_call_stack_normal);
> +DEFINE_SCS(sdei_shadow_call_stack_critical);
>  #endif
>  
> +static int scs_alloc_percpu(unsigned long * __percpu *ptr, int cpu)
> +{
> +	unsigned long *p;
> +
> +	p = __vmalloc_node_range(PAGE_SIZE, SCS_SIZE,
> +				 VMALLOC_START, VMALLOC_END,
> +				 GFP_SCS, PAGE_KERNEL,
> +				 0, cpu_to_node(cpu),
> +				 __builtin_return_address(0));
> +
> +	if (!p)
> +		return -ENOMEM;
> +	per_cpu(*ptr, cpu) = p;
> +
> +	return 0;
> +}
> +
> +static void scs_free_percpu(unsigned long * __percpu *ptr, int cpu)
> +{
> +	unsigned long *p = per_cpu(*ptr, cpu);
> +
> +	if (p) {
> +		per_cpu(*ptr, cpu) = NULL;
> +		vfree(p);
> +	}
> +}
> +
> +static void scs_free_sdei(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		scs_free_percpu(&sdei_shadow_call_stack_normal_ptr, cpu);
> +		scs_free_percpu(&sdei_shadow_call_stack_critical_ptr, cpu);
> +	}
> +}
> +
>  void scs_init_irq(void)
>  {
>  	int cpu;
>  
>  	for_each_possible_cpu(cpu) {
> -#ifdef CONFIG_SHADOW_CALL_STACK_VMAP
> -		unsigned long *p;
> +		if (IS_ENABLED(CONFIG_SHADOW_CALL_STACK_VMAP))
> +			WARN_ON(scs_alloc_percpu(&irq_shadow_call_stack_ptr,
> +						 cpu));
> +		else
> +			per_cpu(irq_shadow_call_stack_ptr, cpu) =
> +				per_cpu(irq_shadow_call_stack, cpu);
> +	}
> +}
>  
> -		p = __vmalloc_node_range(PAGE_SIZE, SCS_SIZE,
> -					 VMALLOC_START, VMALLOC_END,
> -					 GFP_SCS, PAGE_KERNEL,
> -					 0, cpu_to_node(cpu),
> -					 __builtin_return_address(0));
> +int scs_init_sdei(void)
> +{
> +	int cpu;
>  
> -		per_cpu(irq_shadow_call_stack_ptr, cpu) = p;
> -#else
> -		per_cpu(irq_shadow_call_stack_ptr, cpu) =
> -			per_cpu(irq_shadow_call_stack, cpu);
> -#endif /* CONFIG_SHADOW_CALL_STACK_VMAP */
> +	if (!IS_ENABLED(CONFIG_ARM_SDE_INTERFACE))
> +		return 0;
> +
> +	for_each_possible_cpu(cpu) {
> +		if (IS_ENABLED(CONFIG_SHADOW_CALL_STACK_VMAP)) {
> +			if (scs_alloc_percpu(
> +				&sdei_shadow_call_stack_normal_ptr, cpu) ||
> +			    scs_alloc_percpu(
> +				&sdei_shadow_call_stack_critical_ptr, cpu)) {
> +				scs_free_sdei();
> +				return -ENOMEM;
> +			}
> +		} else {
> +			per_cpu(sdei_shadow_call_stack_normal_ptr, cpu) =
> +				per_cpu(sdei_shadow_call_stack_normal, cpu);
> +			per_cpu(sdei_shadow_call_stack_critical_ptr, cpu) =
> +				per_cpu(sdei_shadow_call_stack_critical, cpu);
> +		}
>  	}
> +
> +	return 0;
>  }
> diff --git a/arch/arm64/kernel/sdei.c b/arch/arm64/kernel/sdei.c
> index d6259dac62b6..2854b9f7760a 100644
> --- a/arch/arm64/kernel/sdei.c
> +++ b/arch/arm64/kernel/sdei.c
> @@ -13,6 +13,7 @@
>  #include <asm/kprobes.h>
>  #include <asm/mmu.h>
>  #include <asm/ptrace.h>
> +#include <asm/scs.h>
>  #include <asm/sections.h>
>  #include <asm/stacktrace.h>
>  #include <asm/sysreg.h>
> @@ -162,6 +163,12 @@ unsigned long sdei_arch_get_entry_point(int conduit)
>  			return 0;
>  	}
>  
> +	if (scs_init_sdei()) {
> +		if (IS_ENABLED(CONFIG_VMAP_STACK))
> +			free_sdei_stacks();
> +		return 0;
> +	}
> +
>  	sdei_exit_mode = (conduit == SMCCC_CONDUIT_HVC) ? SDEI_EXIT_HVC : SDEI_EXIT_SMC;
>  
>  #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
> -- 
> 2.24.0.393.g34dc348eaf-goog
> 
