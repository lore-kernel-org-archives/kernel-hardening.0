Return-Path: <SRS0=HA2P=3R=lists.openwall.com=kernel-hardening-return-17633-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640C9C2D0DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jan 2020 22:50:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B6E12207FD
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jan 2020 22:50:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="T1hFsGEO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6E12207FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17633-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28194 invoked by uid 550); 28 Jan 2020 22:50:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28174 invoked from network); 28 Jan 2020 22:50:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eHEMtu7LgfkFmyO7oGGN1Lq9IQ3mukp2v1f/r5o0L0s=;
        b=T1hFsGEO0/ylAav9HFUtgqeRhLCk+8mN4axKzOMQw6onWhdziR92MjVxq99AAlFqvU
         kku1dM+53W1OlgPVvAdZpJUQQFRFZXSDYoFSRxG+GgXnjw7uLYw9w3Uwi+5GnyvWh7Zr
         AS8uPHr3/+DROwe5Czh3qwOMmnX6Zh6aNF314=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eHEMtu7LgfkFmyO7oGGN1Lq9IQ3mukp2v1f/r5o0L0s=;
        b=K+ekwjowL8PLtbCCctataKslpwGPE5a7aLfAkiK36KoZTeEOClnVU5Kzctd+trC0IE
         hUE/YIZ2sb1dGENOIPG2nGuMSntsOtr/KhAuO0Q0suIElRO8eh/CtRLunuHViJ66+jcy
         0cbqC8FD+BqJpV3ZAEa0RzblnVY2ToQnUH7guu28brbOZTj6ig1TCRnxzAZw4JfltRlL
         5kAcdfOeyEfX1Ek2mgnGHi87jXbOWjdoLuSpfnRF4+jx+V20dgLUod7jk5za4eOOpPrm
         5YcAuSLHa5UQpzq8VZGhCiU1hBFUJlP0BK2+8zeMmN6m+EvpUOFmRWRYFpKFbHGHDBGp
         G7TQ==
X-Gm-Message-State: APjAAAV0ydNw2NshuqW8roG1Ugfh/uRXzj8bam6Mt4yN5TKMhgyKnM6I
	VNamEc7PHCCvbf46+8gKcRZ1eA==
X-Google-Smtp-Source: APXvYqx9wzHAeZmTEPl0AGnf9TAiBUX0F1ZcpzaNR4O6MA9xWbzMW0w2pC5Y4TVfo8+2jVMqh5iIHw==
X-Received: by 2002:a65:5786:: with SMTP id b6mr27614437pgr.316.1580251802779;
        Tue, 28 Jan 2020 14:50:02 -0800 (PST)
Date: Tue, 28 Jan 2020 14:50:00 -0800
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 04/11] scs: disable when function graph tracing is
 enabled
Message-ID: <202001281449.FB1671805E@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200128184934.77625-1-samitolvanen@google.com>
 <20200128184934.77625-5-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128184934.77625-5-samitolvanen@google.com>

On Tue, Jan 28, 2020 at 10:49:27AM -0800, Sami Tolvanen wrote:
> The graph tracer hooks returns by modifying frame records on the
> (regular) stack, but with SCS the return address is taken from the
> shadow stack, and the value in the frame record has no effect. As we
> don't currently have a mechanism to determine the corresponding slot
> on the shadow stack (and to pass this through the ftrace
> infrastructure), for now let's disable SCS when the graph tracer is
> enabled.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 1b16aa9a3fe5..0d746373c52e 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -530,6 +530,7 @@ config ARCH_SUPPORTS_SHADOW_CALL_STACK
>  
>  config SHADOW_CALL_STACK
>  	bool "Clang Shadow Call Stack"
> +	depends on !FUNCTION_GRAPH_TRACER
>  	depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
>  	help
>  	  This option enables Clang's Shadow Call Stack, which uses a
> -- 
> 2.25.0.341.g760bfbb309-goog
> 

-- 
Kees Cook
