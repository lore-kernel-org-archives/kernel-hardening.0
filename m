Return-Path: <SRS0=LWOI=YS=lists.openwall.com=kernel-hardening-return-17104-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A57CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:24:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6F14B2070B
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:24:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F14B2070B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17104-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28176 invoked by uid 550); 25 Oct 2019 09:24:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28156 invoked from network); 25 Oct 2019 09:24:41 -0000
Date: Fri, 25 Oct 2019 10:24:22 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: samitolvanen@google.com
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/17] arm64: mm: don't use x18 in
 idmap_kpti_install_ng_mappings
Message-ID: <20191025092421.GA40270@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191024225132.13410-1-samitolvanen@google.com>
 <20191024225132.13410-2-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024225132.13410-2-samitolvanen@google.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Thu, Oct 24, 2019 at 03:51:16PM -0700, samitolvanen@google.com wrote:
> idmap_kpti_install_ng_mappings uses x18 as a temporary register, which
> will result in a conflict when x18 is reserved. Use x16 and x17 instead
> where needed.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

AFAICT the new register assignment is sound, so FWIW:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

I was going to suggest adding menmonics for the remamining raw register
names, but after having a go locally I think it's cleaner as-is given
the registers are used in different widths for multiple purposes.

Thanks,
Mark.

> ---
>  arch/arm64/mm/proc.S | 63 ++++++++++++++++++++++----------------------
>  1 file changed, 32 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> index a1e0592d1fbc..fdabf40a83c8 100644
> --- a/arch/arm64/mm/proc.S
> +++ b/arch/arm64/mm/proc.S
> @@ -250,15 +250,15 @@ ENTRY(idmap_kpti_install_ng_mappings)
>  	/* We're the boot CPU. Wait for the others to catch up */
>  	sevl
>  1:	wfe
> -	ldaxr	w18, [flag_ptr]
> -	eor	w18, w18, num_cpus
> -	cbnz	w18, 1b
> +	ldaxr	w17, [flag_ptr]
> +	eor	w17, w17, num_cpus
> +	cbnz	w17, 1b
>  
>  	/* We need to walk swapper, so turn off the MMU. */
>  	pre_disable_mmu_workaround
> -	mrs	x18, sctlr_el1
> -	bic	x18, x18, #SCTLR_ELx_M
> -	msr	sctlr_el1, x18
> +	mrs	x17, sctlr_el1
> +	bic	x17, x17, #SCTLR_ELx_M
> +	msr	sctlr_el1, x17
>  	isb
>  
>  	/* Everybody is enjoying the idmap, so we can rewrite swapper. */
> @@ -281,9 +281,9 @@ skip_pgd:
>  	isb
>  
>  	/* We're done: fire up the MMU again */
> -	mrs	x18, sctlr_el1
> -	orr	x18, x18, #SCTLR_ELx_M
> -	msr	sctlr_el1, x18
> +	mrs	x17, sctlr_el1
> +	orr	x17, x17, #SCTLR_ELx_M
> +	msr	sctlr_el1, x17
>  	isb
>  
>  	/*
> @@ -353,46 +353,47 @@ skip_pte:
>  	b.ne	do_pte
>  	b	next_pmd
>  
> +	.unreq	cpu
> +	.unreq	num_cpus
> +	.unreq	swapper_pa
> +	.unreq	cur_pgdp
> +	.unreq	end_pgdp
> +	.unreq	pgd
> +	.unreq	cur_pudp
> +	.unreq	end_pudp
> +	.unreq	pud
> +	.unreq	cur_pmdp
> +	.unreq	end_pmdp
> +	.unreq	pmd
> +	.unreq	cur_ptep
> +	.unreq	end_ptep
> +	.unreq	pte
> +
>  	/* Secondary CPUs end up here */
>  __idmap_kpti_secondary:
>  	/* Uninstall swapper before surgery begins */
> -	__idmap_cpu_set_reserved_ttbr1 x18, x17
> +	__idmap_cpu_set_reserved_ttbr1 x16, x17
>  
>  	/* Increment the flag to let the boot CPU we're ready */
> -1:	ldxr	w18, [flag_ptr]
> -	add	w18, w18, #1
> -	stxr	w17, w18, [flag_ptr]
> +1:	ldxr	w16, [flag_ptr]
> +	add	w16, w16, #1
> +	stxr	w17, w16, [flag_ptr]
>  	cbnz	w17, 1b
>  
>  	/* Wait for the boot CPU to finish messing around with swapper */
>  	sevl
>  1:	wfe
> -	ldxr	w18, [flag_ptr]
> -	cbnz	w18, 1b
> +	ldxr	w16, [flag_ptr]
> +	cbnz	w16, 1b
>  
>  	/* All done, act like nothing happened */
> -	offset_ttbr1 swapper_ttb, x18
> +	offset_ttbr1 swapper_ttb, x16
>  	msr	ttbr1_el1, swapper_ttb
>  	isb
>  	ret
>  
> -	.unreq	cpu
> -	.unreq	num_cpus
> -	.unreq	swapper_pa
>  	.unreq	swapper_ttb
>  	.unreq	flag_ptr
> -	.unreq	cur_pgdp
> -	.unreq	end_pgdp
> -	.unreq	pgd
> -	.unreq	cur_pudp
> -	.unreq	end_pudp
> -	.unreq	pud
> -	.unreq	cur_pmdp
> -	.unreq	end_pmdp
> -	.unreq	pmd
> -	.unreq	cur_ptep
> -	.unreq	end_ptep
> -	.unreq	pte
>  ENDPROC(idmap_kpti_install_ng_mappings)
>  	.popsection
>  #endif
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 
