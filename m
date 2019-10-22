Return-Path: <SRS0=pSNK=YP=lists.openwall.com=kernel-hardening-return-17089-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0B2CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 16:29:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2275C21783
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 16:29:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2275C21783
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17089-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32267 invoked by uid 550); 22 Oct 2019 16:29:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32245 invoked from network); 22 Oct 2019 16:29:02 -0000
Date: Tue, 22 Oct 2019 17:28:27 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
Message-ID: <20191022162826.GC699@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-7-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018161033.261971-7-samitolvanen@google.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Fri, Oct 18, 2019 at 09:10:21AM -0700, Sami Tolvanen wrote:
> This change adds generic support for Clang's Shadow Call Stack, which
> uses a shadow stack to protect return addresses from being overwritten
> by an attacker. Details are available here:
> 
>   https://clang.llvm.org/docs/ShadowCallStack.html
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  Makefile                       |   6 ++
>  arch/Kconfig                   |  39 ++++++++
>  include/linux/compiler-clang.h |   2 +
>  include/linux/compiler_types.h |   4 +
>  include/linux/scs.h            |  88 ++++++++++++++++++
>  init/init_task.c               |   6 ++
>  init/main.c                    |   3 +
>  kernel/Makefile                |   1 +
>  kernel/fork.c                  |   9 ++
>  kernel/sched/core.c            |   2 +
>  kernel/sched/sched.h           |   1 +
>  kernel/scs.c                   | 162 +++++++++++++++++++++++++++++++++
>  12 files changed, 323 insertions(+)
>  create mode 100644 include/linux/scs.h
>  create mode 100644 kernel/scs.c
> 
> diff --git a/Makefile b/Makefile
> index ffd7a912fc46..e401fa500f62 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -846,6 +846,12 @@ ifdef CONFIG_LIVEPATCH
>  KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
>  endif
>  
> +ifdef CONFIG_SHADOW_CALL_STACK
> +KBUILD_CFLAGS	+= -fsanitize=shadow-call-stack
> +DISABLE_SCS	:= -fno-sanitize=shadow-call-stack
> +export DISABLE_SCS
> +endif

I think it would be preferable to follow the example of CC_FLAGS_FTRACE
so that this can be filtered out, e.g.

ifdef CONFIG_SHADOW_CALL_STACK
CFLAGS_SCS := -fsanitize=shadow-call-stack
KBUILD_CFLAGS += $(CFLAGS_SCS)
export CC_FLAGS_SCS
endif

... with removal being:

CFLAGS_REMOVE := $(CC_FLAGS_SCS)

... or:

CFLAGS_REMOVE_obj.o := $(CC_FLAGS_SCS)

That way you only need to define the flags once, so the enable and
disable falgs remain in sync by construction.

[...]

> +config ARCH_SUPPORTS_SHADOW_CALL_STACK
> +	bool
> +	help
> +	  An architecture should select this if it supports Clang's Shadow
> +	  Call Stack, has asm/scs.h, and implements runtime support for shadow
> +	  stack switching.
> +
> +config SHADOW_CALL_STACK_VMAP
> +	def_bool n

A bool is default n, so you can just say bool here.

> +	depends on SHADOW_CALL_STACK
> +	help
> +	  Use virtually mapped shadow call stacks. Selecting this option
> +	  provides better stack exhaustion protection, but increases per-thread
> +	  memory consumption as a full page is allocated for each shadow stack.
> +
> +choice
> +	prompt "Return-oriented programming (ROP) protection"
> +	default ROP_PROTECTION_NONE
> +	help
> +	  This option controls kernel protections against return-oriented
> +	  programming (ROP) attacks.

Are we expecting more options here in future?

> +config ROP_PROTECTION_NONE
> +	bool "None"

IIUC this is for the benefit of the kretprobes Kconfig.

I think it would be better to make that depend on !SHADOW_CALL_STACK, as
it's plausible that we can add a different ROP protection mechanism that
is compatible with kretprobes.

> +config SHADOW_CALL_STACK
> +	bool "Clang Shadow Call Stack"
> +	depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
> +	depends on CC_IS_CLANG && CLANG_VERSION >= 70000

Is there a reason for an explicit version check rather than a
CC_HAS_<feature> check? e.g. was this available but broken in prior
versions of clang?

[...]

> +#define SCS_GFP			(GFP_KERNEL | __GFP_ZERO)

Normally GFP_ is a prefix. For consistency, GFP_SCS would be preferable.

> +extern unsigned long init_shadow_call_stack[];

Do we need this exposed here? IIUC this is only assigned by assembly in
arch code.

[...]

> +void scs_set_init_magic(struct task_struct *tsk)
> +{
> +	scs_save(tsk);
> +	scs_set_magic(tsk);
> +	scs_load(tsk);
> +}

Can we initialize this at compile time instead?

Thanks,
Mark.
