Return-Path: <SRS0=WcEP=YL=lists.openwall.com=kernel-hardening-return-17041-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C39CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 16:58:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0E91E2089C
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 16:58:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E91E2089C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17041-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17873 invoked by uid 550); 18 Oct 2019 16:58:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17853 invoked from network); 18 Oct 2019 16:58:29 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: fruit53_8252359efdc20
X-Filterd-Recvd-Size: 2322
Message-ID: <8268ba22cccae0dccf5a8d1902bc1409877fbd4e.camel@perches.com>
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
From: Joe Perches <joe@perches.com>
To: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt
 <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
 Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
 Nick Desaulniers <ndesaulniers@google.com>,
 clang-built-linux@googlegroups.com,  kernel-hardening@lists.openwall.com,
 linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org
Date: Fri, 18 Oct 2019 09:58:14 -0700
In-Reply-To: <20191018161033.261971-7-samitolvanen@google.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
	 <20191018161033.261971-7-samitolvanen@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2019-10-18 at 09:10 -0700, Sami Tolvanen wrote:
> This change adds generic support for Clang's Shadow Call Stack, which
> uses a shadow stack to protect return addresses from being overwritten
> by an attacker
[]
> .diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
[]
> @@ -42,3 +42,5 @@
>   * compilers, like ICC.
>   */
>  #define barrier() __asm__ __volatile__("" : : : "memory")
> +
> +#define __noscs		__attribute__((no_sanitize("shadow-call-stack")))

trivia:

This should likely use the __ prefix and suffix form:

#define __noscs		__attribute__((__no_sanitize__("shadow-call-stack")))

as should the __no_sanitize_address above this

> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
[]
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


