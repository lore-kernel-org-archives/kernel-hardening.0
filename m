Return-Path: <SRS0=q5Am=YL=lists.openwall.com=kernel-hardening-return-17059-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A55B7CA9EA9
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 21:23:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EC62C20679
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 21:23:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kmFuT5Kg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC62C20679
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17059-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5334 invoked by uid 550); 18 Oct 2019 21:23:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5303 invoked from network); 18 Oct 2019 21:23:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vIoI90AJcGtmRzHkaXHGdwrJxP2gbeW0bBXLDxZIi6o=;
        b=kmFuT5Kg6bHVBqvSrwwjd80o3NyLk9kXgyAEqkBiecWeSw5sIbx2razxWIcHpKmuCx
         bJO2L0Jt09AzB11Ioy48fJTW8FR+EMVEr0M9zHJAcwWGJOQg3HRcf2WrQ1l4SzEXAZq4
         n6Xg7mC6TZcE9jyt02zaa38SwNptcs9lLZ8G/gPn1z84v6FiEYb28HVQX/UzL1C7GhyF
         PAoEIeSihIs40ESqTd4Oi5iDvDNXP4+cR6jf/BkW9ReFPCWFW0DLQ4SlZLRQeGvSHN7n
         CoZ3rxSv+LnWUEqcGvtveotIJsaouPfkBE7vIksnyOAEvvP1q7/C1giHe26s6vQXFvJX
         liOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vIoI90AJcGtmRzHkaXHGdwrJxP2gbeW0bBXLDxZIi6o=;
        b=egPUayEP7KjyJITS5hykoen+xj2oEqcLMpH0PGjE7GXE4wxlrNpXwgKV48QB4Yi77r
         f4ot1lB00lPabrvJpr042REatiAcZzWg52k4nrlNiscYdFLJdx7oPP5zppDlybXD9rtV
         uXkupp8PMP1DoDglRu/nUVkbzQdA11cNQJd9YARg1q153hW2J5+9huq8Q1E4aVs4Q3zA
         kqPbCnvr1CQUiltX3Z4dx3xJ1fWtlv6Q+u1OGUHMb3Y2/SdgXcMDZmLJDr6CGUGgyPMI
         pt0cUk90nt1rEkXozPhyp7my2Pl5P0wygQ7JwnDXV9Bxss8MBVLu0qF6E8eIkuWEZ0pq
         A3dA==
X-Gm-Message-State: APjAAAV2nvg3kQK8va7PB3ZVLeS01BZTNDl6XzeiEk2q25c2PMe9TEqD
	jHXW1wCemYOxQn8kuweNU40no7Dyxqjd3I0unwhRLQ==
X-Google-Smtp-Source: APXvYqyiiPLOZOS1kQpsZ9qqN50RFADJX438WB0rEo22PxmnqtNJSl9IB/wB6WS07gKTHpmXSLKmBJieIge5XbhC8jY=
X-Received: by 2002:aa7:8210:: with SMTP id k16mr9015314pfi.84.1571433802129;
 Fri, 18 Oct 2019 14:23:22 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191018161033.261971-13-samitolvanen@google.com>
In-Reply-To: <20191018161033.261971-13-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 18 Oct 2019 14:23:10 -0700
Message-ID: <CAKwvOd=rU2cC7C3a=8D2WBEmS49YgR7=aCriE31JQx7ExfQZrg@mail.gmail.com>
Subject: Re: [PATCH 12/18] arm64: reserve x18 only with Shadow Call Stack
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 9:11 AM 'Sami Tolvanen' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
>
> Only reserve x18 with CONFIG_SHADOW_CALL_STACK. Note that all external
> kernel modules must also have x18 reserved if the kernel uses SCS.

Ah, ok.  The tradeoff for maintainers to consider, either:
1. one less GPR for ALL kernel code or
2. remember not to use x18 in inline as lest you potentially break SCS

This patch is 2 (the earlier patch was 1).  Maybe we don't write
enough inline asm that this will be hard to remember, and we do have
CI in Android to watch for this (on mainline, not sure about -next).

Either way,
Acked-by: Nick Desaulniers <ndesaulniers@google.com>

>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  arch/arm64/Makefile | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index 1c7b276bc7c5..ef76101201b2 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -55,7 +55,7 @@ endif
>
>  KBUILD_CFLAGS  += -mgeneral-regs-only $(lseinstr) $(brokengasinst)     \
>                    $(compat_vdso) $(cc_has_k_constraint)
> -KBUILD_CFLAGS  += -fno-asynchronous-unwind-tables -ffixed-x18
> +KBUILD_CFLAGS  += -fno-asynchronous-unwind-tables
>  KBUILD_CFLAGS  += $(call cc-disable-warning, psabi)
>  KBUILD_AFLAGS  += $(lseinstr) $(brokengasinst) $(compat_vdso)
>
> @@ -72,6 +72,10 @@ stack_protector_prepare: prepare0
>                                         include/generated/asm-offsets.h))
>  endif
>
> +ifeq ($(CONFIG_SHADOW_CALL_STACK), y)
> +KBUILD_CFLAGS  += -ffixed-x18
> +endif
> +
>  ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
>  KBUILD_CPPFLAGS        += -mbig-endian
>  CHECKFLAGS     += -D__AARCH64EB__
> --
> 2.23.0.866.gb869b98d4c-goog
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20191018161033.261971-13-samitolvanen%40google.com.



-- 
Thanks,
~Nick Desaulniers
