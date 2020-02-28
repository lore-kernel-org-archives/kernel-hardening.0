Return-Path: <SRS0=7OWS=4Q=lists.openwall.com=kernel-hardening-return-18008-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218CFC3F2D2
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 16:32:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7B6F3246BD
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 16:32:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B6F3246BD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18008-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21777 invoked by uid 550); 28 Feb 2020 16:32:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21757 invoked from network); 28 Feb 2020 16:32:09 -0000
Subject: Re: [PATCH v9 10/12] arm64: implement Shadow Call Stack
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Mark Rutland <mark.rutland@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
 Jann Horn <jannh@google.com>, Miguel Ojeda
 <miguel.ojeda.sandonis@gmail.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200225173933.74818-1-samitolvanen@google.com>
 <20200225173933.74818-11-samitolvanen@google.com>
From: James Morse <james.morse@arm.com>
Message-ID: <56b82a54-044a-75ec-64e5-6ba25b19571f@arm.com>
Date: Fri, 28 Feb 2020 16:31:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200225173933.74818-11-samitolvanen@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit

Hi Sami,

On 25/02/2020 17:39, Sami Tolvanen wrote:
> This change implements shadow stack switching, initial SCS set-up,
> and interrupt shadow stacks for arm64.

> diff --git a/arch/arm64/include/asm/scs.h b/arch/arm64/include/asm/scs.h
> new file mode 100644
> index 000000000000..c50d2b0c6c5f
> --- /dev/null
> +++ b/arch/arm64/include/asm/scs.h
> @@ -0,0 +1,37 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_SCS_H
> +#define _ASM_SCS_H
> +
> +#ifndef __ASSEMBLY__

As the whole file is guarded by this, why do you need to include it in assembly files at all?


> +
> +#include <linux/scs.h>
> +
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +
> +extern void scs_init_irq(void);
> +
> +static __always_inline void scs_save(struct task_struct *tsk)
> +{
> +	void *s;
> +
> +	asm volatile("mov %0, x18" : "=r" (s));
> +	task_set_scs(tsk, s);
> +}
> +
> +static inline void scs_overflow_check(struct task_struct *tsk)
> +{
> +	if (unlikely(scs_corrupted(tsk)))
> +		panic("corrupted shadow stack detected inside scheduler\n");

Could this ever catch anything with CONFIG_SHADOW_CALL_STACK_VMAP?
Wouldn't we have hit the vmalloc guard page at the point of overflow?


> +}
> +
> +#else /* CONFIG_SHADOW_CALL_STACK */
> +
> +static inline void scs_init_irq(void) {}
> +static inline void scs_save(struct task_struct *tsk) {}
> +static inline void scs_overflow_check(struct task_struct *tsk) {}
> +
> +#endif /* CONFIG_SHADOW_CALL_STACK */
> +
> +#endif /* __ASSEMBLY __ */
> +
> +#endif /* _ASM_SCS_H */



> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 9461d812ae27..4b18c3bbdea5 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S

If I corrupt x18 so that we take an exception (mov x18, xzr), we take that exception
whenever we run C code. The CPU 'vanishes' and I get a very upset scheduler shortly after.

Stack misalignment has the same problem, but the overflow test (eventually) catches that,
then calls panic() using the overflow stack. (See the kernel_ventry macro and __bad_stack
in entry.S)

It would be nice to have a per-cpu stack that we switch to when on the overflow stack.
(this would catch the scs overflow hitting the guard page too, as we should eat through
the regular stack until we overflowed it!)


> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index d4ed9a19d8fe..f2cb344f998c 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -358,6 +359,9 @@ void cpu_die(void)
>  {
>  	unsigned int cpu = smp_processor_id();
>
> +	/* Save the shadow stack pointer before exiting the idle task */

I can't work out why this needs to be before before idle_task_exit()...
It needs to run before init_idle(), which calls scs_task_reset(), but all that is on the
cpu_up() path. (if it is to pair those up, any reason core code can't do both?)


> +	scs_save(current);
> +
>  	idle_task_exit();
>
>  	local_daif_mask();
>


Reviewed-by: James Morse <james.morse@arm.com>


Thanks!

James
