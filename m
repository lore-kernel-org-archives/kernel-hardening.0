Return-Path: <SRS0=I/Qt=6G=lists.openwall.com=kernel-hardening-return-18607-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C813C54FCB
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 17:55:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 99E5B2075A
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 17:55:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YDPh/qZH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99E5B2075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18607-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3471 invoked by uid 550); 22 Apr 2020 17:55:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3436 invoked from network); 22 Apr 2020 17:54:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PfMww1XblhLOM1IhsyJBLVNLcw2pO4ZG6+psA9WEyjs=;
        b=YDPh/qZHmDwn0Cf2IG2YhPsB13gKlrRXTLNX2r5r9db3rOJAeLL+dGqZfdGoa2y5nG
         C/9COaKvetP3sSgQRHbIIE7qNS8RrCFLDvOVJn0aNzReVrd2os4ke0ezNQx5f21Z6Xmx
         hMQbFR8GhohhPM0ulDN3zvX5oZFoKoKnxRrt4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PfMww1XblhLOM1IhsyJBLVNLcw2pO4ZG6+psA9WEyjs=;
        b=jcrpuVgRQHmmE4J8LWOUPyXh2ElMlEMhXV5qeimvCxLNm+4o4BDkgdkYy2uCjEbYYE
         /UlkFBz/Hwwbo8o8167IWBvrl4evVAokUQAUjKgX/qB8k0A4jTLeQ6NwQ1BVvnfHHtDw
         jQVggkSNmhmylli2mo4ElY0pC91Jso7W1TQ+ucb57fNDrGmR8ztkCuusUaSJboKhABg9
         MiUUyqjAKckl+qmn57RL7r1K+XCqKljDUB1wwikrT7iqb5ORSH4PMo3zGjWiasadkI3K
         1EuAyeGWhEs83CWvildZdMVHUWvyQB6l4n4wmO4Ca0jzlNIBaegtTKP1tL0iJaytEU6I
         n5jw==
X-Gm-Message-State: AGi0PuZm6rCKAC2cRpUUj4BEa642FooZMM1945lpfBg5vLqWo5LNCm4i
	TiU9H8lzJnSTaoU617lVZ0eaHg==
X-Google-Smtp-Source: APiQypJI6N32D6HXJve6NdWmF1PXvwIb9I5552lHRPFXt4sBzsDvwXHfuFst/yvAjqESt5e1QXdO5w==
X-Received: by 2002:a17:902:44d:: with SMTP id 71mr28933127ple.123.1587578086979;
        Wed, 22 Apr 2020 10:54:46 -0700 (PDT)
Date: Wed, 22 Apr 2020 10:54:45 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 01/12] add support for Clang's Shadow Call Stack (SCS)
Message-ID: <202004221052.489CCFEBC@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200421021453.198187-1-samitolvanen@google.com>
 <20200421021453.198187-2-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421021453.198187-2-samitolvanen@google.com>

On Mon, Apr 20, 2020 at 07:14:42PM -0700, Sami Tolvanen wrote:
> This change adds generic support for Clang's Shadow Call Stack,
> which uses a shadow stack to protect return addresses from being
> overwritten by an attacker. Details are available here:
> 
>   https://clang.llvm.org/docs/ShadowCallStack.html
> 
> Note that security guarantees in the kernel differ from the
> ones documented for user space. The kernel must store addresses
> of shadow stacks used by other tasks and interrupt handlers in
> memory, which means an attacker capable reading and writing
> arbitrary memory may be able to locate them and hijack control
> flow by modifying shadow stacks that are not currently in use.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> ---
>  Makefile                       |  6 +++
>  arch/Kconfig                   | 25 +++++++++
>  include/linux/compiler-clang.h |  6 +++
>  include/linux/compiler_types.h |  4 ++
>  include/linux/scs.h            | 92 ++++++++++++++++++++++++++++++++++
>  init/init_task.c               |  8 +++
>  kernel/Makefile                |  1 +
>  kernel/fork.c                  |  9 ++++
>  kernel/sched/core.c            |  2 +
>  kernel/scs.c                   | 67 +++++++++++++++++++++++++
>  10 files changed, 220 insertions(+)
>  create mode 100644 include/linux/scs.h
>  create mode 100644 kernel/scs.c
> 
> diff --git a/Makefile b/Makefile
> index 49b2709ff44e..6094db2c7252 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -866,6 +866,12 @@ ifdef CONFIG_LIVEPATCH
>  KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
>  endif
>  
> +ifdef CONFIG_SHADOW_CALL_STACK
> +CC_FLAGS_SCS	:= -fsanitize=shadow-call-stack
> +KBUILD_CFLAGS	+= $(CC_FLAGS_SCS)
> +export CC_FLAGS_SCS
> +endif
> +
>  # arch Makefile may override CC so keep this after arch Makefile is included
>  NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
>  
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 786a85d4ad40..8450d56e6af6 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -533,6 +533,31 @@ config STACKPROTECTOR_STRONG
>  	  about 20% of all kernel functions, which increases the kernel code
>  	  size by about 2%.
>  
> +config ARCH_SUPPORTS_SHADOW_CALL_STACK
> +	bool
> +	help
> +	  An architecture should select this if it supports Clang's Shadow
> +	  Call Stack, has asm/scs.h, and implements runtime support for shadow
> +	  stack switching.
> +
> +config SHADOW_CALL_STACK
> +	bool "Clang Shadow Call Stack"
> +	depends on CC_IS_CLANG && ARCH_SUPPORTS_SHADOW_CALL_STACK
> +	help
> +	  This option enables Clang's Shadow Call Stack, which uses a
> +	  shadow stack to protect function return addresses from being
> +	  overwritten by an attacker. More information can be found in
> +	  Clang's documentation:
> +
> +	    https://clang.llvm.org/docs/ShadowCallStack.html
> +
> +	  Note that security guarantees in the kernel differ from the ones
> +	  documented for user space. The kernel must store addresses of shadow
> +	  stacks used by other tasks and interrupt handlers in memory, which
> +	  means an attacker capable of reading and writing arbitrary memory
> +	  may be able to locate them and hijack control flow by modifying
> +	  shadow stacks that are not currently in use.
> +
>  config HAVE_ARCH_WITHIN_STACK_FRAMES
>  	bool
>  	help
> diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
> index 333a6695a918..18fc4d29ef27 100644
> --- a/include/linux/compiler-clang.h
> +++ b/include/linux/compiler-clang.h
> @@ -42,3 +42,9 @@
>   * compilers, like ICC.
>   */
>  #define barrier() __asm__ __volatile__("" : : : "memory")
> +
> +#if __has_feature(shadow_call_stack)
> +# define __noscs	__attribute__((__no_sanitize__("shadow-call-stack")))
> +#else
> +# define __noscs
> +#endif
> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> index e970f97a7fcb..97b62f47a80d 100644
> --- a/include/linux/compiler_types.h
> +++ b/include/linux/compiler_types.h
> @@ -193,6 +193,10 @@ struct ftrace_likely_data {
>  # define randomized_struct_fields_end
>  #endif
>  
> +#ifndef __noscs
> +# define __noscs
> +#endif
> +
>  #ifndef asm_volatile_goto
>  #define asm_volatile_goto(x...) asm goto(x)
>  #endif
> diff --git a/include/linux/scs.h b/include/linux/scs.h
> new file mode 100644
> index 000000000000..051d27ad3da4
> --- /dev/null
> +++ b/include/linux/scs.h
> @@ -0,0 +1,92 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Shadow Call Stack support.
> + *
> + * Copyright (C) 2019 Google LLC
> + */
> +
> +#ifndef _LINUX_SCS_H
> +#define _LINUX_SCS_H
> +
> +#include <linux/gfp.h>
> +#include <linux/poison.h>
> +#include <linux/sched.h>
> +#include <asm/page.h>
> +
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +
> +/*
> + * In testing, 1 KiB shadow stack size (i.e. 128 stack frames on a 64-bit
> + * architecture) provided ~40% safety margin on stack usage while keeping
> + * memory allocation overhead reasonable.
> + */
> +#define SCS_SIZE	1024UL
> +#define GFP_SCS		(GFP_KERNEL | __GFP_ZERO)
> +
> +/* An illegal pointer value to mark the end of the shadow stack. */
> +#define SCS_END_MAGIC	(0x5f6UL + POISON_POINTER_DELTA)
> +
> +#define task_scs(tsk)	(task_thread_info(tsk)->shadow_call_stack)
> +
> +static inline void task_set_scs(struct task_struct *tsk, void *s)
> +{
> +	task_scs(tsk) = s;
> +}
> +
> +extern void scs_init(void);
> +
> +static inline void *__scs_base(struct task_struct *tsk)
> +{
> +	/*
> +	 * To minimize the risk of exposure, architectures may clear a
> +	 * task's thread_info::shadow_call_stack while that task is
> +	 * running, and only save/restore the active shadow call stack
> +	 * pointer when the usual register may be clobbered (e.g. across
> +	 * context switches).
> +	 *
> +	 * The shadow call stack is aligned to SCS_SIZE, and grows
> +	 * upwards, so we can mask out the low bits to extract the base
> +	 * when the task is not running.
> +	 */
> +	return (void *)((unsigned long)task_scs(tsk) & ~(SCS_SIZE - 1));
> +}
> +
> +static inline void scs_task_reset(struct task_struct *tsk)
> +{
> +	/*
> +	 * Reset the shadow stack to the base address in case the task
> +	 * is reused.
> +	 */
> +	task_set_scs(tsk, __scs_base(tsk));
> +}
> +
> +extern int scs_prepare(struct task_struct *tsk, int node);
> +
> +static inline unsigned long *__scs_magic(void *s)
> +{
> +	return (unsigned long *)(s + SCS_SIZE) - 1;
> +}
> +
> +static inline bool scs_corrupted(struct task_struct *tsk)
> +{
> +	unsigned long *magic = __scs_magic(__scs_base(tsk));
> +
> +	return READ_ONCE_NOCHECK(*magic) != SCS_END_MAGIC;
> +}
> +
> +extern void scs_release(struct task_struct *tsk);
> +
> +#else /* CONFIG_SHADOW_CALL_STACK */
> +
> +#define task_scs(tsk)	NULL
> +
> +static inline void task_set_scs(struct task_struct *tsk, void *s) {}
> +static inline void scs_init(void) {}
> +static inline void scs_task_reset(struct task_struct *tsk) {}
> +static inline int scs_prepare(struct task_struct *tsk, int node) { return 0; }
> +static inline bool scs_corrupted(struct task_struct *tsk) { return false; }
> +static inline void scs_release(struct task_struct *tsk) {}
> +
> +#endif /* CONFIG_SHADOW_CALL_STACK */
> +
> +#endif /* _LINUX_SCS_H */
> diff --git a/init/init_task.c b/init/init_task.c
> index bd403ed3e418..aaa71366d162 100644
> --- a/init/init_task.c
> +++ b/init/init_task.c
> @@ -11,6 +11,7 @@
>  #include <linux/mm.h>
>  #include <linux/audit.h>
>  #include <linux/numa.h>
> +#include <linux/scs.h>
>  
>  #include <asm/pgtable.h>
>  #include <linux/uaccess.h>
> @@ -185,6 +186,13 @@ struct task_struct init_task
>  };
>  EXPORT_SYMBOL(init_task);
>  
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +unsigned long init_shadow_call_stack[SCS_SIZE / sizeof(long)] __init_task_data
> +		__aligned(SCS_SIZE) = {
> +	[(SCS_SIZE / sizeof(long)) - 1] = SCS_END_MAGIC
> +};
> +#endif
> +
>  /*
>   * Initial thread structure. Alignment of this is handled by a special
>   * linker map entry.
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 4cb4130ced32..c332eb9d4841 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -103,6 +103,7 @@ obj-$(CONFIG_TRACEPOINTS) += trace/
>  obj-$(CONFIG_IRQ_WORK) += irq_work.o
>  obj-$(CONFIG_CPU_PM) += cpu_pm.o
>  obj-$(CONFIG_BPF) += bpf/
> +obj-$(CONFIG_SHADOW_CALL_STACK) += scs.o
>  
>  obj-$(CONFIG_PERF_EVENTS) += events/
>  
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 8c700f881d92..f6339f9d232d 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -94,6 +94,7 @@
>  #include <linux/thread_info.h>
>  #include <linux/stackleak.h>
>  #include <linux/kasan.h>
> +#include <linux/scs.h>
>  
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
> @@ -456,6 +457,8 @@ void put_task_stack(struct task_struct *tsk)
>  
>  void free_task(struct task_struct *tsk)
>  {
> +	scs_release(tsk);
> +
>  #ifndef CONFIG_THREAD_INFO_IN_TASK
>  	/*
>  	 * The task is finally done with both the stack and thread_info,
> @@ -840,6 +843,8 @@ void __init fork_init(void)
>  			  NULL, free_vm_stack_cache);
>  #endif
>  
> +	scs_init();
> +
>  	lockdep_init_task(&init_task);
>  	uprobes_init();
>  }
> @@ -899,6 +904,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
>  	if (err)
>  		goto free_stack;
>  
> +	err = scs_prepare(tsk, node);
> +	if (err)
> +		goto free_stack;
> +
>  #ifdef CONFIG_SECCOMP
>  	/*
>  	 * We must handle setting up seccomp filters once we're under
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 3a61a3b8eaa9..c99620c1ec20 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -11,6 +11,7 @@
>  #include <linux/nospec.h>
>  
>  #include <linux/kcov.h>
> +#include <linux/scs.h>
>  
>  #include <asm/switch_to.h>
>  #include <asm/tlb.h>
> @@ -6045,6 +6046,7 @@ void init_idle(struct task_struct *idle, int cpu)
>  	idle->se.exec_start = sched_clock();
>  	idle->flags |= PF_IDLE;
>  
> +	scs_task_reset(idle);
>  	kasan_unpoison_task_stack(idle);
>  
>  #ifdef CONFIG_SMP
> diff --git a/kernel/scs.c b/kernel/scs.c
> new file mode 100644
> index 000000000000..e1a8fc453b86
> --- /dev/null
> +++ b/kernel/scs.c
> @@ -0,0 +1,67 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Shadow Call Stack support.
> + *
> + * Copyright (C) 2019 Google LLC
> + */
> +
> +#include <linux/kasan.h>
> +#include <linux/scs.h>
> +#include <linux/slab.h>
> +#include <asm/scs.h>
> +
> +static struct kmem_cache *scs_cache;
> +
> +static void *scs_alloc(int node)
> +{
> +	void *s;
> +
> +	s = kmem_cache_alloc_node(scs_cache, GFP_SCS, node);
> +	if (s) {
> +		*__scs_magic(s) = SCS_END_MAGIC;
> +		/*
> +		 * Poison the allocation to catch unintentional accesses to
> +		 * the shadow stack when KASAN is enabled.
> +		 */
> +		kasan_poison_object_data(scs_cache, s);
> +	}
> +
> +	return s;
> +}
> +
> +static void scs_free(void *s)
> +{
> +	kasan_unpoison_object_data(scs_cache, s);
> +	kmem_cache_free(scs_cache, s);
> +}
> +
> +void __init scs_init(void)
> +{
> +	scs_cache = kmem_cache_create("scs_cache", SCS_SIZE, SCS_SIZE,
> +				0, NULL);
> +}
> +
> +int scs_prepare(struct task_struct *tsk, int node)
> +{
> +	void *s;
> +
> +	s = scs_alloc(node);
> +	if (!s)
> +		return -ENOMEM;
> +
> +	task_set_scs(tsk, s);
> +	return 0;
> +}
> +
> +void scs_release(struct task_struct *tsk)
> +{
> +	void *s;
> +
> +	s = __scs_base(tsk);
> +	if (!s)
> +		return;
> +
> +	WARN_ON(scs_corrupted(tsk));
> +

I'd like to have task_set_scs(tsk, NULL) retained here, to avoid need to
depend on the released task memory getting scrubbed at a later time.
Exposures of this pointer would expose the region of other SCSs.

-Kees

> +	scs_free(s);
> +}
> -- 
> 2.26.1.301.g55bc3eb7cb9-goog
> 

-- 
Kees Cook
