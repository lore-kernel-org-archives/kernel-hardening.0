Return-Path: <SRS0=sbCm=4H=lists.openwall.com=kernel-hardening-return-17844-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EE3C34047
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 11:34:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6B23D21D56
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 11:34:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B23D21D56
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17844-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19681 invoked by uid 550); 19 Feb 2020 11:34:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19657 invoked from network); 19 Feb 2020 11:34:15 -0000
Date: Wed, 19 Feb 2020 11:33:52 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, james.morse@arm.com,
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
Subject: Re: [PATCH v8 04/12] scs: disable when function graph tracing is
 enabled
Message-ID: <20200219113351.GA14462@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200219000817.195049-1-samitolvanen@google.com>
 <20200219000817.195049-5-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219000817.195049-5-samitolvanen@google.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Tue, Feb 18, 2020 at 04:08:09PM -0800, Sami Tolvanen wrote:
> The graph tracer hooks returns by modifying frame records on the
> (regular) stack, but with SCS the return address is taken from the
> shadow stack, and the value in the frame record has no effect. As we
> don't currently have a mechanism to determine the corresponding slot
> on the shadow stack (and to pass this through the ftrace
> infrastructure), for now let's disable SCS when the graph tracer is
> enabled.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 66b34fd0df54..4102b8e0eea9 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -535,6 +535,7 @@ config ARCH_SUPPORTS_SHADOW_CALL_STACK
>  
>  config SHADOW_CALL_STACK
>  	bool "Clang Shadow Call Stack"
> +	depends on !FUNCTION_GRAPH_TRACER

Fangrui Song has implemented `-fpatchable-function-entry` in LLVM (for
10.x onwards), so we can support this when DYNAMIC_FTRACE_WITH_REGS is
selected.

This can be:

	depends on DYNAMIC_FTRACE_WITH_REGS || !FUNCTION_GRAPH_TRACER

... and we can update the commit message to something like:

| With SCS the return address is taken from the shadow stack and the
| value in the frame record has no effect. The mcount based graph tracer
| hooks returns by modifying frame records on the (regular) stack, and
| thus is not compatible. The patchable-function-entry graph tracer
| used for DYNAMIC_FTRACE_WITH_REGS modifies the LR before it is saved
| to the shadow stack, and is compatible.
|
| Modifying the mcount based graph tracer to work with SCS would require
| a mechanism to determine the corresponding slot on the shadow stack
| (and to pass this through the ftrace infrastructure), and we expect
| that everyone will eventually move to the patchable-function-entry
| based graph tracer anyway, so for now let's disable SCS when the
| mcount-based graph tracer is enabled.
|
| SCS and patchable-function-entry are both supported from LLVM 10.x.

Assuming you're happy with that:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.
