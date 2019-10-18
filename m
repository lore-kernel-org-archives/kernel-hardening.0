Return-Path: <SRS0=vBhF=YL=lists.openwall.com=kernel-hardening-return-17039-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DBBCA9EA9
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 16:43:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 122E421835
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 16:43:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a4KqHH64"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 122E421835
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17039-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11540 invoked by uid 550); 18 Oct 2019 16:43:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11516 invoked from network); 18 Oct 2019 16:43:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=itPDN3uOMullCrqvdWp4VHOtEiVy99lUJjyxqObTixM=;
        b=a4KqHH64Syi3Jkb+d0eVgCpN+31SnDYFhDKhObeeBYgIxsVpB28MK9tNghzsFxuX+N
         VbAKU58UasFmej23pHOk0QrDLH7oKDm4M3dk3bgCtTUWOgQmltwfMriaPvVLpxp3C0pC
         kYoPXPqJx0ajXSrYjPEgK8592+nVdo/5DSLpSz/Itc5Br1qMc82P+2UjLLk4LyZ199qw
         YdBPa6JePJa0Fd7+ocz3Fs2qom1i2u3DIw3HjxianaEOsPf5x+/L3CFK6vBNgDV9SqT3
         pgNBOC5FZlvErDViSZm4W/P+hr6vWNgjySr+vmQ1yyL5jifp07AxbcGC3bkxHitLbGMK
         lX4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=itPDN3uOMullCrqvdWp4VHOtEiVy99lUJjyxqObTixM=;
        b=qeKTIFDs2BmlKXy0Bw6YA50i0cJi/uSECQL3et2fOpfuG5PwAiwW1L/sK0V17hX9p+
         IIIoOqs1FMrwy6OjaB5PQVy8rJP8cdEST09vp70UKCwzN4UjeThvHOiig51Gkh3f8oUs
         2v/autCa8BO9rEtWUvOtGViD/wY6WZNvK4M5lBNexQ+2qWX4rQ5oxNSQkfnn+R5dBf/S
         B7sUVN5jCRBm45wQtwWJXpckJkVdca2H4ZeZ35heHjhzIvimqgw15oSjJ+1HH2VixCRs
         20pgnG1oqoc09rLdV8P7GEGsQbR5nVuZuhumceuVeYwmsmYuSjvM9AzT6nc5Au8vDjD8
         E2zA==
X-Gm-Message-State: APjAAAUP5CwTuhToF3Xzl5UbiHV2wv923KJFwFdACEHfW3b9e8+PNoY3
	ospZ+SEoWCMHUaiptjOLCheUtN0oMqpbMmN1m/I8yw==
X-Google-Smtp-Source: APXvYqxjABHlLirt3mzHAGsgLEpxUZMPZex/FsD7C0vJFW62s876ojGzoWlX6A4J5FwacSy764TFAtK8KXx4Wiz+QQw=
X-Received: by 2002:a17:902:9b83:: with SMTP id y3mr10710877plp.179.1571417011191;
 Fri, 18 Oct 2019 09:43:31 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191018161033.261971-2-samitolvanen@google.com>
In-Reply-To: <20191018161033.261971-2-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 18 Oct 2019 09:43:20 -0700
Message-ID: <CAKwvOd=rspmzW+v=nG=07H5XZ2OPWVbhDusYEe3k5+mZ79JvwA@mail.gmail.com>
Subject: Re: [PATCH 01/18] arm64: mm: don't use x18 in idmap_kpti_install_ng_mappings
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, kernel-hardening@lists.openwall.com, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 9:10 AM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> idmap_kpti_install_ng_mappings uses x18 as a temporary register, which
> will result in a conflict when x18 is reserved. Use x16 and x17 instead
> where needed.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

TIL about .req/.unreq.  Seems like a nice way of marking "variable"
lifetime.  Technically, only `pte` needed to be moved to reuse
{w|x}16, but moving most the unreqs together is nicer than splitting
them apart. The usage all looks correct to me.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  arch/arm64/mm/proc.S | 63 ++++++++++++++++++++++----------------------
>  1 file changed, 32 insertions(+), 31 deletions(-)
>
> diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> index a1e0592d1fbc..fdabf40a83c8 100644
> --- a/arch/arm64/mm/proc.S
> +++ b/arch/arm64/mm/proc.S
> @@ -250,15 +250,15 @@ ENTRY(idmap_kpti_install_ng_mappings)
>         /* We're the boot CPU. Wait for the others to catch up */
>         sevl
>  1:     wfe
> -       ldaxr   w18, [flag_ptr]
> -       eor     w18, w18, num_cpus
> -       cbnz    w18, 1b
> +       ldaxr   w17, [flag_ptr]
> +       eor     w17, w17, num_cpus
> +       cbnz    w17, 1b
>
>         /* We need to walk swapper, so turn off the MMU. */
>         pre_disable_mmu_workaround
> -       mrs     x18, sctlr_el1
> -       bic     x18, x18, #SCTLR_ELx_M
> -       msr     sctlr_el1, x18
> +       mrs     x17, sctlr_el1
> +       bic     x17, x17, #SCTLR_ELx_M
> +       msr     sctlr_el1, x17
>         isb
>
>         /* Everybody is enjoying the idmap, so we can rewrite swapper. */
> @@ -281,9 +281,9 @@ skip_pgd:
>         isb
>
>         /* We're done: fire up the MMU again */
> -       mrs     x18, sctlr_el1
> -       orr     x18, x18, #SCTLR_ELx_M
> -       msr     sctlr_el1, x18
> +       mrs     x17, sctlr_el1
> +       orr     x17, x17, #SCTLR_ELx_M
> +       msr     sctlr_el1, x17
>         isb
>
>         /*
> @@ -353,46 +353,47 @@ skip_pte:
>         b.ne    do_pte
>         b       next_pmd
>
> +       .unreq  cpu
> +       .unreq  num_cpus
> +       .unreq  swapper_pa
> +       .unreq  cur_pgdp
> +       .unreq  end_pgdp
> +       .unreq  pgd
> +       .unreq  cur_pudp
> +       .unreq  end_pudp
> +       .unreq  pud
> +       .unreq  cur_pmdp
> +       .unreq  end_pmdp
> +       .unreq  pmd
> +       .unreq  cur_ptep
> +       .unreq  end_ptep
> +       .unreq  pte
> +
>         /* Secondary CPUs end up here */
>  __idmap_kpti_secondary:
>         /* Uninstall swapper before surgery begins */
> -       __idmap_cpu_set_reserved_ttbr1 x18, x17
> +       __idmap_cpu_set_reserved_ttbr1 x16, x17
>
>         /* Increment the flag to let the boot CPU we're ready */
> -1:     ldxr    w18, [flag_ptr]
> -       add     w18, w18, #1
> -       stxr    w17, w18, [flag_ptr]
> +1:     ldxr    w16, [flag_ptr]
> +       add     w16, w16, #1
> +       stxr    w17, w16, [flag_ptr]
>         cbnz    w17, 1b
>
>         /* Wait for the boot CPU to finish messing around with swapper */
>         sevl
>  1:     wfe
> -       ldxr    w18, [flag_ptr]
> -       cbnz    w18, 1b
> +       ldxr    w16, [flag_ptr]
> +       cbnz    w16, 1b
>
>         /* All done, act like nothing happened */
> -       offset_ttbr1 swapper_ttb, x18
> +       offset_ttbr1 swapper_ttb, x16
>         msr     ttbr1_el1, swapper_ttb
>         isb
>         ret
>
> -       .unreq  cpu
> -       .unreq  num_cpus
> -       .unreq  swapper_pa
>         .unreq  swapper_ttb
>         .unreq  flag_ptr
> -       .unreq  cur_pgdp
> -       .unreq  end_pgdp
> -       .unreq  pgd
> -       .unreq  cur_pudp
> -       .unreq  end_pudp
> -       .unreq  pud
> -       .unreq  cur_pmdp
> -       .unreq  end_pmdp
> -       .unreq  pmd
> -       .unreq  cur_ptep
> -       .unreq  end_ptep
> -       .unreq  pte
>  ENDPROC(idmap_kpti_install_ng_mappings)
>         .popsection
>  #endif
> --
> 2.23.0.866.gb869b98d4c-goog
>


-- 
Thanks,
~Nick Desaulniers
