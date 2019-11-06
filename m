Return-Path: <SRS0=Kkvp=Y6=lists.openwall.com=kernel-hardening-return-17320-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E00C5DF63
	for <kernel-hardening@archiver.kernel.org>; Wed,  6 Nov 2019 20:39:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 686B621848
	for <kernel-hardening@archiver.kernel.org>; Wed,  6 Nov 2019 20:39:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CrBxheWL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 686B621848
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17320-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7567 invoked by uid 550); 6 Nov 2019 20:39:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7541 invoked from network); 6 Nov 2019 20:39:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bp86L5fucSA+9Bwlt84/eQbHaJRbEE/iIVDIU2TrYmM=;
        b=CrBxheWL+VkOfPX3aTBccoLvNQF92thO3oi5LNHeY04/wZsBJ5+Awp3yG38gVaW419
         EwFnyiPDR1gnnZmr8ul0W/yKVfgIK5xZNdfgklRC9owvzvrb5YtTfIJlYj3tqqOBxrYA
         puDhDKyZABgAkq3XZb5IJ/rCNzuAn76ZWc52ybg9wLNMg+z+ZgcGsKJOYHhRkT6tP0wM
         ec8iwNatVcZ1mqzjbPOeUiHln+ne0fBBsTlHbQGoAkvksK/Txg3rLgikXk+7vSpyZ9Zz
         Pee10GCisuUq4SYMJ+mByVVfZzuStCOWn9eeJ1oEBMVnENoJixSlbPeRYZP5cyGdf0TZ
         UunA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bp86L5fucSA+9Bwlt84/eQbHaJRbEE/iIVDIU2TrYmM=;
        b=DXMo55s6+sTrrRu1f4szF6wiIDkxZGF+SLIMfeWjB8mIBiGqSSMkUhZkjYQHiI2nZU
         W+nZdvn0J3C8GUTVsZnd5hZP/+vJZuMr0j8s7WXZO4728JzNNkm9m9E+rodwY3FRO5xL
         QSPI8O45AGY5Z8Fed43JuFCRDwQKuNIwJCCyCd20b21HpYwRPmEeu1TvNV9+vYWksxwZ
         SuIL554+/HrNI7k/2SEW01d6i15u/UdSgO+cUfaIS9HkaFf2TiLcP+l7QY03rH2lwFOn
         ceBAePFUa40vjM5VR8vVkQw3FWYh5AbuXhn8nVGJFdUZ3qmSjlUS9hb+V88IG+nsjEDA
         Tbzg==
X-Gm-Message-State: APjAAAWE2xqwDAzc+V3DU5GrFL+1wGv7ITsvp+fcIJiyUYTifdY81CKr
	7bbvVD2G6jiP1crYv2I3PcPNMWSY6WwAPqfQIMCX5g==
X-Google-Smtp-Source: APXvYqzpFAhempBHWwl6LQCKUCJ19FjjZGAWA1oF9chpT593c5XiKJbvgs2xxIRCQukRs4o+FH4Rat+2Sk/7ytURtoo=
X-Received: by 2002:aa7:8e56:: with SMTP id d22mr5854475pfr.3.1573072766085;
 Wed, 06 Nov 2019 12:39:26 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191105235608.107702-1-samitolvanen@google.com> <20191105235608.107702-11-samitolvanen@google.com>
In-Reply-To: <20191105235608.107702-11-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 6 Nov 2019 12:39:14 -0800
Message-ID: <CAKwvOdkGUn+X2HCnV7zM8ruCPYBsRi_UD8JY4VW4FbuOam8Pmg@mail.gmail.com>
Subject: Re: [PATCH v5 10/14] arm64: preserve x18 when CPU is suspended
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 5, 2019 at 3:56 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> Don't lose the current task's shadow stack when the CPU is suspended.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Re-LGTM

> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm64/include/asm/suspend.h |  2 +-
>  arch/arm64/mm/proc.S             | 14 ++++++++++++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/suspend.h b/arch/arm64/include/asm/suspend.h
> index 8939c87c4dce..0cde2f473971 100644
> --- a/arch/arm64/include/asm/suspend.h
> +++ b/arch/arm64/include/asm/suspend.h
> @@ -2,7 +2,7 @@
>  #ifndef __ASM_SUSPEND_H
>  #define __ASM_SUSPEND_H
>
> -#define NR_CTX_REGS 12
> +#define NR_CTX_REGS 13
>  #define NR_CALLEE_SAVED_REGS 12
>
>  /*
> diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> index fdabf40a83c8..5c8219c55948 100644
> --- a/arch/arm64/mm/proc.S
> +++ b/arch/arm64/mm/proc.S
> @@ -49,6 +49,8 @@
>   * cpu_do_suspend - save CPU registers context
>   *
>   * x0: virtual address of context pointer
> + *
> + * This must be kept in sync with struct cpu_suspend_ctx in <asm/suspend.h>.
>   */
>  ENTRY(cpu_do_suspend)
>         mrs     x2, tpidr_el0
> @@ -73,6 +75,11 @@ alternative_endif
>         stp     x8, x9, [x0, #48]
>         stp     x10, x11, [x0, #64]
>         stp     x12, x13, [x0, #80]
> +       /*
> +        * Save x18 as it may be used as a platform register, e.g. by shadow
> +        * call stack.
> +        */
> +       str     x18, [x0, #96]
>         ret
>  ENDPROC(cpu_do_suspend)
>
> @@ -89,6 +96,13 @@ ENTRY(cpu_do_resume)
>         ldp     x9, x10, [x0, #48]
>         ldp     x11, x12, [x0, #64]
>         ldp     x13, x14, [x0, #80]
> +       /*
> +        * Restore x18, as it may be used as a platform register, and clear
> +        * the buffer to minimize the risk of exposure when used for shadow
> +        * call stack.
> +        */
> +       ldr     x18, [x0, #96]
> +       str     xzr, [x0, #96]
>         msr     tpidr_el0, x2
>         msr     tpidrro_el0, x3
>         msr     contextidr_el1, x4
> --
> 2.24.0.rc1.363.gb1bccd3e3d-goog
>


-- 
Thanks,
~Nick Desaulniers
