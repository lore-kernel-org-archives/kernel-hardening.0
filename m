Return-Path: <SRS0=p5CE=3F=lists.openwall.com=kernel-hardening-return-17571-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CD2C33CB3
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 17:45:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CB0FA24784
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 17:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="zlHbDbVJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB0FA24784
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17571-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9778 invoked by uid 550); 16 Jan 2020 17:45:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9758 invoked from network); 16 Jan 2020 17:45:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579196697;
	bh=eZc1L4+pca2HQRZ4NlFHXHq40yJapRdOmzlFzQ/cknQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zlHbDbVJTAEzMxf/SUtdxJAXgWWsPwuJLkj5y/dsFpdWk6r25yTkB4U8bYfo9zX64
	 84fLlEQVbP4jGLbiOgOA8O5xtVXhKMTROUWezOITnG+sEvonw9zZ2G1XCxQxKBbcNo
	 IIkiMjs9fllhsIEfoPhk17Sc1+ru8i2vFwMMaDwY=
Date: Thu, 16 Jan 2020 17:44:51 +0000
From: Will Deacon <will@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
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
Subject: Re: [PATCH v6 11/15] arm64: efi: restore x18 if it was corrupted
Message-ID: <20200116174450.GD21396@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191206221351.38241-1-samitolvanen@google.com>
 <20191206221351.38241-12-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206221351.38241-12-samitolvanen@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Dec 06, 2019 at 02:13:47PM -0800, Sami Tolvanen wrote:
> If we detect a corrupted x18 and SCS is enabled, restore the register
> before jumping back to instrumented code. This is safe, because the
> wrapper is called with preemption disabled and a separate shadow stack
> is used for interrupt handling.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm64/kernel/efi-rt-wrapper.S | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
> index 3fc71106cb2b..62f0260f5c17 100644
> --- a/arch/arm64/kernel/efi-rt-wrapper.S
> +++ b/arch/arm64/kernel/efi-rt-wrapper.S
> @@ -34,5 +34,14 @@ ENTRY(__efi_rt_asm_wrapper)
>  	ldp	x29, x30, [sp], #32
>  	b.ne	0f
>  	ret
> -0:	b	efi_handle_corrupted_x18	// tail call
> +0:
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	/*
> +	 * Restore x18 before returning to instrumented code. This is
> +	 * safe because the wrapper is called with preemption disabled and
> +	 * a separate shadow stack is used for interrupts.
> +	 */
> +	mov	x18, x2
> +#endif

Why not restore it regardless of CONFIG_SHADOW_CALL_STACK?

Will
