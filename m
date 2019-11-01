Return-Path: <SRS0=jaF+=YZ=lists.openwall.com=kernel-hardening-return-17222-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C8CCA9EC9
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 04:00:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1D063208E3
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 04:00:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gAic49MA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D063208E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17222-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5267 invoked by uid 550); 1 Nov 2019 04:00:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5247 invoked from network); 1 Nov 2019 04:00:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DqG2K0fvYUAA4E302d2Wr4MEutud0mjKuHdZBEE6NhQ=;
        b=gAic49MAeOc0RHQwT7q95mZfaWy/E6IhEpBpV5hJ3STSid/jPRu+sGJtzjSfKCXuEf
         cHqE/dxdIBbercFZyX9sSIjRyybd8IPXMMKNRCD5XgWMmq1WJvMLtGj8wgTBt16jV32H
         m8Pv3sMDvWULeXDkmLgUa3AZ6LDQXwbzmCxlc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DqG2K0fvYUAA4E302d2Wr4MEutud0mjKuHdZBEE6NhQ=;
        b=s5qaVo7EmJ6RhC23Bx1SGL0yAD+zSVBBkNluJ0PiddwCdVB01ZAbbAw2RhAHbPgIG8
         QAExSvBQKq/1RDhnaLGEQTYQDpjfRFoN6tO8l079u06MuFvfVPgSerURPX346L2I7Q2L
         gvOIVpsI3fGBt4A0nkunhkc2QHRZPG/haaGhyCwEsn6CoX2gRhbRtFFP2ZjchWOMcjrv
         nWUP0W9FlCu63eoDiSAPa2R8ZmDgh2KMo9AfoUVsPEfPDiia+FC2qeUUnshUK0QNCAYn
         UdRZkWXcgOYCvRKAQGMAzbIwn+RknwuPXRUcA9ZxT9DakUVEMF/v+BKd2vyc1CbaS7YY
         OMPg==
X-Gm-Message-State: APjAAAVoTjk/X6IUUsLbrxn3HCRJSDB2W6hxF0zU0DH673xtHSe8FV2o
	hRUxOTB56jok1EXIGgISVfe+Pw==
X-Google-Smtp-Source: APXvYqwjxz9PkVBJaSe/Y1M2wUY5vJE9zTstT50unKznJW5kGeoF7F85nWGFPaym5lZ0YmXY+dykwQ==
X-Received: by 2002:aa7:90da:: with SMTP id k26mr1506175pfk.162.1572580833083;
        Thu, 31 Oct 2019 21:00:33 -0700 (PDT)
Date: Thu, 31 Oct 2019 21:00:31 -0700
From: Kees Cook <keescook@chromium.org>
To: samitolvanen@google.com
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 14/17] arm64: efi: restore x18 if it was corrupted
Message-ID: <201910312100.E35C214206@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com>
 <20191031164637.48901-15-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031164637.48901-15-samitolvanen@google.com>

On Thu, Oct 31, 2019 at 09:46:34AM -0700, samitolvanen@google.com wrote:
> If we detect a corrupted x18 and SCS is enabled, restore the register
> before jumping back to instrumented code. This is safe, because the
> wrapper is called with preemption disabled and a separate shadow stack
> is used for interrupt handling.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/arm64/kernel/efi-rt-wrapper.S | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
> index 3fc71106cb2b..945744f16086 100644
> --- a/arch/arm64/kernel/efi-rt-wrapper.S
> +++ b/arch/arm64/kernel/efi-rt-wrapper.S
> @@ -34,5 +34,10 @@ ENTRY(__efi_rt_asm_wrapper)
>  	ldp	x29, x30, [sp], #32
>  	b.ne	0f
>  	ret
> -0:	b	efi_handle_corrupted_x18	// tail call
> +0:
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	/* Restore x18 before returning to instrumented code. */
> +	mov	x18, x2
> +#endif
> +	b	efi_handle_corrupted_x18	// tail call
>  ENDPROC(__efi_rt_asm_wrapper)
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 

-- 
Kees Cook
