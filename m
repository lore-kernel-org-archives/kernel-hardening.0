Return-Path: <SRS0=Dm9J=ZH=lists.openwall.com=kernel-hardening-return-17387-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC226C432C3
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 15:21:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1609D20733
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 15:21:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1609D20733
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17387-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21568 invoked by uid 550); 15 Nov 2019 15:21:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21539 invoked from network); 15 Nov 2019 15:21:04 -0000
Date: Fri, 15 Nov 2019 15:20:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
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
Subject: Re: [PATCH v5 14/14] arm64: implement Shadow Call Stack
Message-ID: <20191115152047.GI41572@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191105235608.107702-1-samitolvanen@google.com>
 <20191105235608.107702-15-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105235608.107702-15-samitolvanen@google.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Tue, Nov 05, 2019 at 03:56:08PM -0800, Sami Tolvanen wrote:
> This change implements shadow stack switching, initial SCS set-up,
> and interrupt shadow stacks for arm64.

Each CPU also has an overflow stack, and two SDEI stacks, which should
presumably be given their own SCS. SDEI is effectively a software-NMI,
so it should almost certainly have the same treatement as IRQ.

> +static __always_inline void scs_save(struct task_struct *tsk)
> +{
> +	void *s;
> +
> +	asm volatile("mov %0, x18" : "=r" (s));
> +	task_set_scs(tsk, s);
> +}

An alternative would be to follow <asm/stack_pointer.h>, and have:

register unsigned long *current_scs_pointer asm ("x18");

static __always_inline void scs_save(struct task_struct *tsk)
{
	task_set_scs(tsk, current_scs_pointer);
}

... which would avoid the need for a temporary register where this is
used.

However, given we only use this in cpu_die(), having this as-is should
be fine. Maybe the asm volatile is preferable if we use this elsewhere,
so that we know we have a consistent snapshot that the compiler can't
reload, etc.

[...]

> @@ -409,6 +428,10 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
>  	 */
>  	.macro	irq_stack_exit
>  	mov	sp, x19
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	/* x20 is also preserved */
> +	mov	x18, x20
> +#endif
>  	.endm

Can we please fold this comment into the one above, and have:

	/*
	 * The callee-saved regs (x19-x29) should be preserved between
	 * irq_stack_entry and irq_stack_exit.
	 */
	.macro irq_stack_exit
	mov     sp, x19
#ifdef CONFIG_SHADOW_CALL_STACK
	mov     x18, x20
#endif
	.endm

Thanks,
Mark.
 
