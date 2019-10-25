Return-Path: <SRS0=xe5B=YS=lists.openwall.com=kernel-hardening-return-17129-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD47ACA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 16:23:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9EDC921872
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 16:23:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vqVpSPtD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9EDC921872
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17129-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23834 invoked by uid 550); 25 Oct 2019 16:22:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23812 invoked from network); 25 Oct 2019 16:22:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a8UEe/c9YA3geQLwqM8fOG4XnH0IN/vmDkDyQNkiYZU=;
        b=vqVpSPtDFAheCtHX0cT5AI3hykVAjJEyMBcRcsum5ZWBQeqwb42h5NsApcgdjWTgi4
         Zu4wAi4YrqD4G0DCkkmwuLp5lY5qY86/UOC5Fo2Kg8KnB6KJ7jdsrTHvHPL8XS7T/szA
         eyxqp1PDFSkxnHce1zgnqYwhO82YRwuEq1BjIPIrFzEzzsYtz+LydKV8k0Apzw8TM2v7
         CFWqgQrFQIJPHdyxHc002GRcPdwgQ+0isXxZRsfL+oDWfLPqR06R7HWo40fcTBRKgxQy
         92GwnBA767tJGC6r4lPPQGLTvdZQxp2TtFNaxvAKcp+dNpCKdxVvuoB6ac8DeRhvwAox
         s1HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a8UEe/c9YA3geQLwqM8fOG4XnH0IN/vmDkDyQNkiYZU=;
        b=ZnC72IDXJx8F++zSWBuS5wbZUBSiDUHvLSmsgad0SjrnYDvb1l1OyIFeSBDwisLfpl
         AYv5LlVO95lQA75yCVfZkD0L1TBK0ISx2fKmq71CHg2UJtMOo7UOvZXMRfKXbDRDpKuu
         wUtfhTNvWGyc20D2vwtUYMH6BqmdIC4bOWytW+zzRpxkF5AF7MDeDVcqKSIvYcN/ga9g
         YHNQl4kBeRgxWQSqwlX5b2boKCBbxe9i+qiUuK11N/XRAZ6JuX9HQ0EzfwrvWog9bZ9A
         At+zRL0Myi/FhpZ42P8FcJF2V43mogucOq6pXF5s1dNIupEFpcS6BiZaU7vlN7JW0y+E
         RstQ==
X-Gm-Message-State: APjAAAWgWFARDm/2qGPsvQIbumBbglo/Eeb8C1xZkXfYvQmcE7EQajLg
	q4z6GdIiSrk/MS26AuiKqOYxO0zanvEaJ7m5Rc2hAQ==
X-Google-Smtp-Source: APXvYqxSORgikKojlw14I4Rt1q4TlAekichub9zY0X38oMrDvLk5SJIEcUGJn1ZQ5yd0TpW7OF1obm+OW3di93oq66g=
X-Received: by 2002:a63:5448:: with SMTP id e8mr5390739pgm.10.1572020561975;
 Fri, 25 Oct 2019 09:22:41 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191024225132.13410-1-samitolvanen@google.com> <20191024225132.13410-6-samitolvanen@google.com>
In-Reply-To: <20191024225132.13410-6-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 25 Oct 2019 09:22:30 -0700
Message-ID: <CAKwvOdmfXbnWf0dPN4EGCBVvppVRhuc=eq-pbfmotCCBaRN-Cw@mail.gmail.com>
Subject: Re: [PATCH v2 05/17] add support for Clang's Shadow Call Stack (SCS)
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 24, 2019 at 3:51 PM <samitolvanen@google.com> wrote:
>
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
> ---
>  Makefile                       |   6 ++
>  arch/Kconfig                   |  33 +++++++
>  include/linux/compiler-clang.h |   6 ++
>  include/linux/compiler_types.h |   4 +
>  include/linux/scs.h            |  78 +++++++++++++++++
>  init/init_task.c               |   8 ++
>  kernel/Makefile                |   1 +
>  kernel/fork.c                  |   9 ++
>  kernel/sched/core.c            |   2 +
>  kernel/sched/sched.h           |   1 +
>  kernel/scs.c                   | 155 +++++++++++++++++++++++++++++++++
>  11 files changed, 303 insertions(+)
>  create mode 100644 include/linux/scs.h
>  create mode 100644 kernel/scs.c
>
> diff --git a/Makefile b/Makefile
> index 5475cdb6d57d..2b5c59fb18f2 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -846,6 +846,12 @@ ifdef CONFIG_LIVEPATCH
>  KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
>  endif
>
> +ifdef CONFIG_SHADOW_CALL_STACK
> +CC_FLAGS_SCS   := -fsanitize=shadow-call-stack
> +KBUILD_CFLAGS  += $(CC_FLAGS_SCS)
> +export CC_FLAGS_SCS
> +endif
> +
>  # arch Makefile may override CC so keep this after arch Makefile is included
>  NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
>
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 5f8a5d84dbbe..5e34cbcd8d6a 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -521,6 +521,39 @@ config STACKPROTECTOR_STRONG
>           about 20% of all kernel functions, which increases the kernel code
>           size by about 2%.
>
> +config ARCH_SUPPORTS_SHADOW_CALL_STACK
> +       bool
> +       help
> +         An architecture should select this if it supports Clang's Shadow
> +         Call Stack, has asm/scs.h, and implements runtime support for shadow
> +         stack switching.
> +
> +config SHADOW_CALL_STACK_VMAP
> +       bool
> +       depends on SHADOW_CALL_STACK
> +       help
> +         Use virtually mapped shadow call stacks. Selecting this option
> +         provides better stack exhaustion protection, but increases per-thread
> +         memory consumption as a full page is allocated for each shadow stack.
> +
> +config SHADOW_CALL_STACK
> +       bool "Clang Shadow Call Stack"
> +       depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
> +       help
> +         This option enables Clang's Shadow Call Stack, which uses a
> +         shadow stack to protect function return addresses from being
> +         overwritten by an attacker. More information can be found from
> +         Clang's documentation:
> +
> +           https://clang.llvm.org/docs/ShadowCallStack.html
> +
> +         Note that security guarantees in the kernel differ from the ones
> +         documented for user space. The kernel must store addresses of shadow
> +         stacks used by other tasks and interrupt handlers in memory, which
> +         means an attacker capable reading and writing arbitrary memory may
> +         be able to locate them and hijack control flow by modifying shadow
> +         stacks that are not currently in use.
> +
>  config HAVE_ARCH_WITHIN_STACK_FRAMES
>         bool
>         help
> diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
> index 333a6695a918..afe5e24088b2 100644
> --- a/include/linux/compiler-clang.h
> +++ b/include/linux/compiler-clang.h
> @@ -42,3 +42,9 @@
>   * compilers, like ICC.
>   */
>  #define barrier() __asm__ __volatile__("" : : : "memory")
> +
> +#if __has_feature(shadow_call_stack)
> +# define __noscs       __attribute__((no_sanitize("shadow-call-stack")))
> +#else
> +# define __noscs
> +#endif
> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> index 72393a8c1a6c..be5d5be4b1ae 100644
> --- a/include/linux/compiler_types.h
> +++ b/include/linux/compiler_types.h
> @@ -202,6 +202,10 @@ struct ftrace_likely_data {
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
> index 000000000000..c8b0ccfdd803
> --- /dev/null
> +++ b/include/linux/scs.h
> @@ -0,0 +1,78 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Shadow Call Stack support.
> + *
> + * Copyright (C) 2018 Google LLC
> + */
> +
> +#ifndef _LINUX_SCS_H
> +#define _LINUX_SCS_H
> +
> +#include <linux/gfp.h>
> +#include <linux/sched.h>
> +#include <asm/page.h>
> +
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +
> +#define SCS_SIZE       1024
> +#define SCS_END_MAGIC  0xaf0194819b1635f6UL
> +
> +#define GFP_SCS                (GFP_KERNEL | __GFP_ZERO)
> +
> +static inline void *task_scs(struct task_struct *tsk)
> +{
> +       return task_thread_info(tsk)->shadow_call_stack;
> +}
> +
> +static inline void task_set_scs(struct task_struct *tsk, void *s)
> +{
> +       task_thread_info(tsk)->shadow_call_stack = s;
> +}
> +
> +extern void scs_init(void);
> +extern void scs_task_init(struct task_struct *tsk);
> +extern void scs_task_reset(struct task_struct *tsk);
> +extern int scs_prepare(struct task_struct *tsk, int node);
> +extern bool scs_corrupted(struct task_struct *tsk);
> +extern void scs_release(struct task_struct *tsk);
> +
> +#else /* CONFIG_SHADOW_CALL_STACK */
> +
> +static inline void *task_scs(struct task_struct *tsk)
> +{
> +       return 0;
> +}
> +
> +static inline void task_set_scs(struct task_struct *tsk, void *s)
> +{
> +}
> +
> +static inline void scs_init(void)
> +{
> +}
> +
> +static inline void scs_task_init(struct task_struct *tsk)
> +{
> +}
> +
> +static inline void scs_task_reset(struct task_struct *tsk)
> +{
> +}
> +
> +static inline int scs_prepare(struct task_struct *tsk, int node)
> +{
> +       return 0;
> +}
> +
> +static inline bool scs_corrupted(struct task_struct *tsk)
> +{
> +       return false;
> +}
> +
> +static inline void scs_release(struct task_struct *tsk)
> +{
> +}
> +
> +#endif /* CONFIG_SHADOW_CALL_STACK */
> +
> +#endif /* _LINUX_SCS_H */
> diff --git a/init/init_task.c b/init/init_task.c
> index 9e5cbe5eab7b..cbd40460e903 100644
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
> @@ -184,6 +185,13 @@ struct task_struct init_task
>  };
>  EXPORT_SYMBOL(init_task);
>
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +unsigned long init_shadow_call_stack[SCS_SIZE / sizeof(long)] __init_task_data
> +               __aligned(SCS_SIZE) = {
> +       [(SCS_SIZE / sizeof(long)) - 1] = SCS_END_MAGIC
> +};
> +#endif
> +
>  /*
>   * Initial thread structure. Alignment of this is handled by a special
>   * linker map entry.
> diff --git a/kernel/Makefile b/kernel/Makefile
> index daad787fb795..313dbd44d576 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -102,6 +102,7 @@ obj-$(CONFIG_TRACEPOINTS) += trace/
>  obj-$(CONFIG_IRQ_WORK) += irq_work.o
>  obj-$(CONFIG_CPU_PM) += cpu_pm.o
>  obj-$(CONFIG_BPF) += bpf/
> +obj-$(CONFIG_SHADOW_CALL_STACK) += scs.o
>
>  obj-$(CONFIG_PERF_EVENTS) += events/
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index bcdf53125210..ae7ebe9f0586 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -94,6 +94,7 @@
>  #include <linux/livepatch.h>
>  #include <linux/thread_info.h>
>  #include <linux/stackleak.h>
> +#include <linux/scs.h>
>
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
> @@ -451,6 +452,8 @@ void put_task_stack(struct task_struct *tsk)
>
>  void free_task(struct task_struct *tsk)
>  {
> +       scs_release(tsk);
> +
>  #ifndef CONFIG_THREAD_INFO_IN_TASK
>         /*
>          * The task is finally done with both the stack and thread_info,
> @@ -834,6 +837,8 @@ void __init fork_init(void)
>                           NULL, free_vm_stack_cache);
>  #endif
>
> +       scs_init();
> +
>         lockdep_init_task(&init_task);
>         uprobes_init();
>  }
> @@ -907,6 +912,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
>         clear_user_return_notifier(tsk);
>         clear_tsk_need_resched(tsk);
>         set_task_stack_end_magic(tsk);
> +       scs_task_init(tsk);
>
>  #ifdef CONFIG_STACKPROTECTOR
>         tsk->stack_canary = get_random_canary();
> @@ -2022,6 +2028,9 @@ static __latent_entropy struct task_struct *copy_process(
>                                  args->tls);
>         if (retval)
>                 goto bad_fork_cleanup_io;
> +       retval = scs_prepare(p, node);
> +       if (retval)
> +               goto bad_fork_cleanup_thread;
>
>         stackleak_task_init(p);
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index dd05a378631a..e7faeb383008 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6013,6 +6013,8 @@ void init_idle(struct task_struct *idle, int cpu)
>         raw_spin_lock_irqsave(&idle->pi_lock, flags);
>         raw_spin_lock(&rq->lock);
>
> +       scs_task_reset(idle);
> +
>         __sched_fork(0, idle);
>         idle->state = TASK_RUNNING;
>         idle->se.exec_start = sched_clock();
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 0db2c1b3361e..c153003a011c 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -58,6 +58,7 @@
>  #include <linux/profile.h>
>  #include <linux/psi.h>
>  #include <linux/rcupdate_wait.h>
> +#include <linux/scs.h>
>  #include <linux/security.h>
>  #include <linux/stop_machine.h>
>  #include <linux/suspend.h>
> diff --git a/kernel/scs.c b/kernel/scs.c
> new file mode 100644
> index 000000000000..383d29e8c199
> --- /dev/null
> +++ b/kernel/scs.c
> @@ -0,0 +1,155 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Shadow Call Stack support.
> + *
> + * Copyright (C) 2019 Google LLC
> + */
> +
> +#include <linux/cpuhotplug.h>
> +#include <linux/mm.h>
> +#include <linux/slab.h>
> +#include <linux/scs.h>
> +#include <linux/vmalloc.h>
> +#include <asm/scs.h>
> +
> +static inline void *__scs_base(struct task_struct *tsk)
> +{
> +       return (void *)((uintptr_t)task_scs(tsk) & ~(SCS_SIZE - 1));
> +}
> +
> +#ifdef CONFIG_SHADOW_CALL_STACK_VMAP
> +
> +/* Keep a cache of shadow stacks */
> +#define SCS_CACHE_SIZE 2
> +static DEFINE_PER_CPU(void *, scs_cache[SCS_CACHE_SIZE]);
> +
> +static void *scs_alloc(int node)
> +{
> +       int i;
> +
> +       for (i = 0; i < SCS_CACHE_SIZE; i++) {
> +               void *s;
> +
> +               s = this_cpu_xchg(scs_cache[i], NULL);
> +               if (s) {
> +                       memset(s, 0, SCS_SIZE);
> +                       return s;
> +               }
> +       }
> +
> +       BUILD_BUG_ON(SCS_SIZE > PAGE_SIZE);
> +
> +       return __vmalloc_node_range(PAGE_SIZE, SCS_SIZE,
> +                                   VMALLOC_START, VMALLOC_END,
> +                                   GFP_SCS, PAGE_KERNEL, 0,
> +                                   node, __builtin_return_address(0));
> +}
> +
> +static void scs_free(void *s)
> +{
> +       int i;
> +
> +       for (i = 0; i < SCS_CACHE_SIZE; i++) {
> +               if (this_cpu_cmpxchg(scs_cache[i], 0, s) != 0)
> +                       continue;
> +
> +               return;
> +       }

prefer:

for ...:
  if foo() == 0:
    return

to:

for ...:
  if foo() != 0:
    continue
  return

> +
> +       vfree_atomic(s);
> +}
> +
> +static int scs_cleanup(unsigned int cpu)
> +{
> +       int i;
> +       void **cache = per_cpu_ptr(scs_cache, cpu);
> +
> +       for (i = 0; i < SCS_CACHE_SIZE; i++) {
> +               vfree(cache[i]);
> +               cache[i] = NULL;
> +       }
> +
> +       return 0;
> +}
> +
> +void __init scs_init(void)
> +{
> +       cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "scs:scs_cache", NULL,
> +               scs_cleanup);
> +}
> +
> +#else /* !CONFIG_SHADOW_CALL_STACK_VMAP */
> +
> +static struct kmem_cache *scs_cache;
> +
> +static inline void *scs_alloc(int node)
> +{
> +       return kmem_cache_alloc_node(scs_cache, GFP_SCS, node);
> +}
> +
> +static inline void scs_free(void *s)
> +{
> +       kmem_cache_free(scs_cache, s);
> +}
> +
> +void __init scs_init(void)
> +{
> +       scs_cache = kmem_cache_create("scs_cache", SCS_SIZE, SCS_SIZE,
> +                               0, NULL);
> +       WARN_ON(!scs_cache);
> +}
> +
> +#endif /* CONFIG_SHADOW_CALL_STACK_VMAP */
> +
> +static inline unsigned long *scs_magic(struct task_struct *tsk)
> +{
> +       return (unsigned long *)(__scs_base(tsk) + SCS_SIZE - sizeof(long));
> +}
> +
> +static inline void scs_set_magic(struct task_struct *tsk)
> +{
> +       *scs_magic(tsk) = SCS_END_MAGIC;
> +}
> +
> +void scs_task_init(struct task_struct *tsk)
> +{
> +       task_set_scs(tsk, NULL);
> +}
> +
> +void scs_task_reset(struct task_struct *tsk)
> +{
> +       task_set_scs(tsk, __scs_base(tsk));
> +}
> +
> +int scs_prepare(struct task_struct *tsk, int node)
> +{
> +       void *s;
> +
> +       s = scs_alloc(node);
> +       if (!s)
> +               return -ENOMEM;
> +
> +       task_set_scs(tsk, s);
> +       scs_set_magic(tsk);
> +
> +       return 0;
> +}
> +
> +bool scs_corrupted(struct task_struct *tsk)
> +{
> +       return *scs_magic(tsk) != SCS_END_MAGIC;
> +}
> +
> +void scs_release(struct task_struct *tsk)
> +{
> +       void *s;
> +
> +       s = __scs_base(tsk);
> +       if (!s)
> +               return;
> +
> +       WARN_ON(scs_corrupted(tsk));
> +
> +       scs_task_init(tsk);
> +       scs_free(s);
> +}
> --
> 2.24.0.rc0.303.g954a862665-goog
>


-- 
Thanks,
~Nick Desaulniers
