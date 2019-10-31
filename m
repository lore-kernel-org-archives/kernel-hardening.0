Return-Path: <SRS0=SGQz=YY=lists.openwall.com=kernel-hardening-return-17204-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 542D6CA9ECB
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:19:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8B43720873
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:19:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sAYUg0xO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B43720873
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17204-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31940 invoked by uid 550); 31 Oct 2019 17:18:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31916 invoked from network); 31 Oct 2019 17:18:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b+sTelK7MqY9vqwBDqCXPdhr5H6iAxzQESslNr9zDOQ=;
        b=sAYUg0xOdfPTn+R7wNZGdRYPWXJ0IdrBAI1isYFeeATDEGBf/DeF/t/ZC+H3KIMgan
         scNTMCKvOZRUj4tgeq6prlPtSshBDQBCF8nDaSqtG/BB51WfgyTuiGolOBB0Hk97OVfz
         FFZL2/SpGY2l/y2lqqJAw5+jcGGYpBSNf5bJcjlclOWtICbLQxkBTOk8MvT5oITN3pnG
         u+i+4fHB5kQ65haNFrEGLXiuPbYXS6McAD9HBk//2n+3DoaI5W2ndyF8sGSN0/ZerFFI
         3ArURY5RQHp58GR8A9bgodEJWmPTR5znmgAKkcDzIz1L01aQy+rSiF9f4uhSMFQIKuF+
         AFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b+sTelK7MqY9vqwBDqCXPdhr5H6iAxzQESslNr9zDOQ=;
        b=JgfjQEGAsdsw9VHqjd9cfSlxBQFZvfgFCGvliRQAemof7k+1BNaQznyvYd0s/4TbHq
         epFPJcbO21CUwdQ3Mm5pslrR+AShlMd4NyJu0+/v3qQxwIudjf6eKjW1noCUkVUG1636
         l7cnC44pF0aCPFbfR+dslWrUtsGe2O76l93tYBFFpOa/bl3e1MgWtRoCmq2YEq04m6+o
         40/06I/uddhHmgkcNkFkYE4naHevhs0mykVTmMoEliLcV9pwnTX/fsw9DWvHZiz89mxr
         CzxPgKvah7rQDITxGPjdy+xUvEQlVxljabfWkxk66Ij2MUmNxu+v1nAvwMGrg94qgh27
         wcPA==
X-Gm-Message-State: APjAAAV1mH9TqrIX7RZJSYetrOTqEA62v6+HiQSInccgDjyAYMDt5ig1
	LdVOmlnjvyU3hoQhU5M0sJh5O+C/k99Cl8Tq9y+UFA==
X-Google-Smtp-Source: APXvYqz01CRqRV0ZKEE1VvIGwwKTxW2/uSPOY69zp6ZxsDGHojkbREYW9Biz6FMIeN9w2FNx45LJJlyb3cbOtfyj3Rc=
X-Received: by 2002:aa7:8210:: with SMTP id k16mr7828428pfi.84.1572542325643;
 Thu, 31 Oct 2019 10:18:45 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com> <20191031164637.48901-14-samitolvanen@google.com>
In-Reply-To: <20191031164637.48901-14-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 31 Oct 2019 10:18:34 -0700
Message-ID: <CAKwvOd=kcPS1CU=AUjOPr7SAipPFhs-v_mXi=AbqW5Vp9XUaiw@mail.gmail.com>
Subject: Re: [PATCH v3 13/17] arm64: preserve x18 when CPU is suspended
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 31, 2019 at 9:47 AM <samitolvanen@google.com> wrote:
>
> Don't lose the current task's shadow stack when the CPU is suspended.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  arch/arm64/include/asm/suspend.h | 2 +-
>  arch/arm64/mm/proc.S             | 9 +++++++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
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
> index fdabf40a83c8..0e7c353c9dfd 100644
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
> @@ -73,6 +75,9 @@ alternative_endif
>         stp     x8, x9, [x0, #48]
>         stp     x10, x11, [x0, #64]
>         stp     x12, x13, [x0, #80]
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +       str     x18, [x0, #96]
> +#endif
>         ret
>  ENDPROC(cpu_do_suspend)
>
> @@ -89,6 +94,10 @@ ENTRY(cpu_do_resume)
>         ldp     x9, x10, [x0, #48]
>         ldp     x11, x12, [x0, #64]
>         ldp     x13, x14, [x0, #80]
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +       ldr     x18, [x0, #96]
> +       str     xzr, [x0, #96]

How come we zero out x0+#96, but not for other offsets? Is this str necessary?

> +#endif
>         msr     tpidr_el0, x2
>         msr     tpidrro_el0, x3
>         msr     contextidr_el1, x4
> --
> 2.24.0.rc0.303.g954a862665-goog
>


-- 
Thanks,
~Nick Desaulniers
