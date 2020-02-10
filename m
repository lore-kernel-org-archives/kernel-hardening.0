Return-Path: <SRS0=fFfR=36=lists.openwall.com=kernel-hardening-return-17749-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AFBC352A3
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 16:41:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 931A820838
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 16:41:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xZ9yor3P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 931A820838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17749-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3826 invoked by uid 550); 10 Feb 2020 16:41:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3806 invoked from network); 10 Feb 2020 16:41:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581352898;
	bh=swgRA1rNS8tBiz0g1uvNqRf9FaXIwO8m18YRqWdGIWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xZ9yor3PmK0g2VGI7TH5dURt6qVd/7JoQzVJWSGzhMpbis9o4lzC+9ygWQ0663Ml8
	 mNsCjyu4UABSsLLe5Ja4m3XnHu6ZdABdFV/OZcz8udClXlNzbDXjPXG7WWBZAvWWNt
	 S1LX2V8l6/MoP4lkNDVfdgj8iQdTmKUYem8h+bsE=
Date: Mon, 10 Feb 2020 16:41:32 +0000
From: Will Deacon <will@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com,
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
Subject: Re: [PATCH v7 07/11] arm64: efi: restore x18 if it was corrupted
Message-ID: <20200210164131.GB21900@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200128184934.77625-1-samitolvanen@google.com>
 <20200128184934.77625-8-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128184934.77625-8-samitolvanen@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jan 28, 2020 at 10:49:30AM -0800, Sami Tolvanen wrote:
> If we detect a corrupted x18, restore the register before jumping back
> to potentially SCS instrumented code. This is safe, because the wrapper
> is called with preemption disabled and a separate shadow stack is used
> for interrupt handling.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm64/kernel/efi-rt-wrapper.S | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
> index 3fc71106cb2b..6ca6c0dc11a1 100644
> --- a/arch/arm64/kernel/efi-rt-wrapper.S
> +++ b/arch/arm64/kernel/efi-rt-wrapper.S
> @@ -34,5 +34,14 @@ ENTRY(__efi_rt_asm_wrapper)
>  	ldp	x29, x30, [sp], #32
>  	b.ne	0f
>  	ret
> -0:	b	efi_handle_corrupted_x18	// tail call
> +0:
> +	/*
> +	 * With CONFIG_SHADOW_CALL_STACK, the kernel uses x18 to store a
> +	 * shadow stack pointer, which we need to restore before returning to
> +	 * potentially instrumented code. This is safe because the wrapper is
> +	 * called with preemption disabled and a separate shadow stack is used
> +	 * for interrupts.
> +	 */
> +	mov	x18, x2
> +	b	efi_handle_corrupted_x18	// tail call
>  ENDPROC(__efi_rt_asm_wrapper)

Acked-by: Will Deacon <will@kernel.org>

Will
