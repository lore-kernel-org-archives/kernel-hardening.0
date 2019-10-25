Return-Path: <SRS0=70+4=YS=lists.openwall.com=kernel-hardening-return-17125-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F18CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:42:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5522921D71
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:42:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5522921D71
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17125-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29905 invoked by uid 550); 25 Oct 2019 09:41:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29887 invoked from network); 25 Oct 2019 09:41:53 -0000
Date: Fri, 25 Oct 2019 10:41:37 +0100
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
Subject: Re: [PATCH v2 02/17] arm64/lib: copy_page: avoid x18 register in
 assembler code
Message-ID: <20191025094137.GB40270@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191024225132.13410-1-samitolvanen@google.com>
 <20191024225132.13410-3-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024225132.13410-3-samitolvanen@google.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Thu, Oct 24, 2019 at 03:51:17PM -0700, samitolvanen@google.com wrote:
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Register x18 will no longer be used as a caller save register in the
> future, so stop using it in the copy_page() code.
> 
> Link: https://patchwork.kernel.org/patch/9836869/
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  arch/arm64/lib/copy_page.S | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/lib/copy_page.S b/arch/arm64/lib/copy_page.S
> index bbb8562396af..8b562264c165 100644
> --- a/arch/arm64/lib/copy_page.S
> +++ b/arch/arm64/lib/copy_page.S
> @@ -34,45 +34,45 @@ alternative_else_nop_endif
>  	ldp	x14, x15, [x1, #96]
>  	ldp	x16, x17, [x1, #112]
>  
> -	mov	x18, #(PAGE_SIZE - 128)
> +	add	x0, x0, #256
>  	add	x1, x1, #128
>  1:
> -	subs	x18, x18, #128
> +	tst	x0, #(PAGE_SIZE - 1)
>  
>  alternative_if ARM64_HAS_NO_HW_PREFETCH
>  	prfm	pldl1strm, [x1, #384]
>  alternative_else_nop_endif
>  
> -	stnp	x2, x3, [x0]
> +	stnp	x2, x3, [x0, #-256]
>  	ldp	x2, x3, [x1]
> -	stnp	x4, x5, [x0, #16]
> +	stnp	x4, x5, [x0, #-240]
>  	ldp	x4, x5, [x1, #16]

For legibility, could we make the offset and bias explicit in the STNPs
so that these line up? e.g.

	stnp	x4, x5, [x0, #16 - 256]
	ldp	x4, x5, [x1, #16]

... that'd make it much easier to see by eye that this is sound, much as
I trust my mental arithmetic. ;)

> -	stnp	x6, x7, [x0, #32]
> +	stnp	x6, x7, [x0, #-224]
>  	ldp	x6, x7, [x1, #32]
> -	stnp	x8, x9, [x0, #48]
> +	stnp	x8, x9, [x0, #-208]
>  	ldp	x8, x9, [x1, #48]
> -	stnp	x10, x11, [x0, #64]
> +	stnp	x10, x11, [x0, #-192]
>  	ldp	x10, x11, [x1, #64]
> -	stnp	x12, x13, [x0, #80]
> +	stnp	x12, x13, [x0, #-176]
>  	ldp	x12, x13, [x1, #80]
> -	stnp	x14, x15, [x0, #96]
> +	stnp	x14, x15, [x0, #-160]
>  	ldp	x14, x15, [x1, #96]
> -	stnp	x16, x17, [x0, #112]
> +	stnp	x16, x17, [x0, #-144]
>  	ldp	x16, x17, [x1, #112]
>  
>  	add	x0, x0, #128
>  	add	x1, x1, #128
>  
> -	b.gt	1b
> +	b.ne	1b
>  
> -	stnp	x2, x3, [x0]
> -	stnp	x4, x5, [x0, #16]
> -	stnp	x6, x7, [x0, #32]
> -	stnp	x8, x9, [x0, #48]
> -	stnp	x10, x11, [x0, #64]
> -	stnp	x12, x13, [x0, #80]
> -	stnp	x14, x15, [x0, #96]
> -	stnp	x16, x17, [x0, #112]
> +	stnp	x2, x3, [x0, #-256]
> +	stnp	x4, x5, [x0, #-240]
> +	stnp	x6, x7, [x0, #-224]
> +	stnp	x8, x9, [x0, #-208]
> +	stnp	x10, x11, [x0, #-192]
> +	stnp	x12, x13, [x0, #-176]
> +	stnp	x14, x15, [x0, #-160]
> +	stnp	x16, x17, [x0, #-144]

... likewise here:

	stnp	xt1, xt2, [x0, #off - 256]

I don't see a nicer way to write this sequence without using an
additional register, so with those changes:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

>  
>  	ret
>  ENDPROC(copy_page)
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 
