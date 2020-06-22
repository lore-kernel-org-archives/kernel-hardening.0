Return-Path: <SRS0=0SSR=AD=lists.openwall.com=kernel-hardening-return-19046-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB37C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 22:05:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BDE2220716
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 22:05:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Om+hyYPX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDE2220716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19046-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25876 invoked by uid 550); 22 Jun 2020 22:04:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25841 invoked from network); 22 Jun 2020 22:04:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tiLvWsLlWI5Mz8yJb26QV5MdQxD2Cn7z8TLlvShCGfU=;
        b=Om+hyYPXJ8zWabYbc6j0NJhRsYt8jMK2RZ8VkZvizn/0iWwTmfV5CpCspe1f49JHQW
         6gV2PbvOVcBmbS6Dkxhwac9tkJmvLeq9OhxwTB6IOmUuEIfpwzibKOjcJaaH8shijbHK
         ngd3RTBVPCWAn6skAEgoIsGV4+tetMcj/rxhM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tiLvWsLlWI5Mz8yJb26QV5MdQxD2Cn7z8TLlvShCGfU=;
        b=ovSQmgCeEmHohn+icVB+5odkkdpf64i3c5Rvy2WNZ3ImMIHCKb6XjnwL4Ltn9yFi0V
         XH8v7nhDZMJu32QA7rliqmZrcjOgO7ogcFfKLNKhI1wVaTFzXMSSqVio/24CZ8XDakqP
         g5tKsDUIXXzCo0MYzygiBbUTplVy5IcYbStvgpJCh8EmsWeV0FwMWzIeqRhUyBeK10+W
         PtJTv8xZq5YIxAD8F5Gnntey2Iw3cAGifR1uxnb/VlbWR4Cho12Ai6kHts6TYuImffhl
         qeF3kavRuP6AcG4dWChJcNmDhjdLPsKekUlQhlKttai2X923NEBID4it66LGmD9v2w3M
         dUAw==
X-Gm-Message-State: AOAM530D92adL7gao/BIBXlN60XlJ8+W4pBW0GXzOMnBda9JbPFLCcio
	d9FmQd2vda8S4roSgOmAtBtE/w==
X-Google-Smtp-Source: ABdhPJzYYstfMbj2bKl5qg6BjBnX7jxPh+vFVKET3pf6cfx1vakKGSEBc4Spw9TWrQtmJz0BX3mj8Q==
X-Received: by 2002:a17:902:8342:: with SMTP id z2mr21209390pln.300.1592863482442;
        Mon, 22 Jun 2020 15:04:42 -0700 (PDT)
Date: Mon, 22 Jun 2020 15:04:40 -0700
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux-MM <linux-mm@kvack.org>,
	kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/5] stack: Optionally randomize kernel stack offset
 each syscall
Message-ID: <202006221451.2E80C90FF7@keescook>
References: <20200622193146.2985288-1-keescook@chromium.org>
 <20200622193146.2985288-4-keescook@chromium.org>
 <CAG48ez0pRtMZs3Hc3R2+XGHRwt9nZAGZu6vDpPBMbE+Askr_+Q@mail.gmail.com>
 <202006221426.CEEE0B8@keescook>
 <CAG48ez1b_wMkQGj+z=dWSVctikzzw72V3SPexEPm3Aw8LrXGWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1b_wMkQGj+z=dWSVctikzzw72V3SPexEPm3Aw8LrXGWQ@mail.gmail.com>

On Mon, Jun 22, 2020 at 11:42:29PM +0200, Jann Horn wrote:
> No, at least on x86-64 and x86 Linux overrides the normal ABI. From
> arch/x86/Makefile:

Ah! Thanks for the pointer.

> 
> # For gcc stack alignment is specified with -mpreferred-stack-boundary,
> # clang has the option -mstack-alignment for that purpose.
> ifneq ($(call cc-option, -mpreferred-stack-boundary=4),)
>       cc_stack_align4 := -mpreferred-stack-boundary=2
>       cc_stack_align8 := -mpreferred-stack-boundary=3
> else ifneq ($(call cc-option, -mstack-alignment=16),)
>       cc_stack_align4 := -mstack-alignment=4
>       cc_stack_align8 := -mstack-alignment=8
> endif
> [...]
> ifeq ($(CONFIG_X86_32),y)
> [...]
>         # Align the stack to the register width instead of using the default
>         # alignment of 16 bytes. This reduces stack usage and the number of
>         # alignment instructions.
>         KBUILD_CFLAGS += $(call cc-option,$(cc_stack_align4))
> [...]
> else
> [...]
>         # By default gcc and clang use a stack alignment of 16 bytes for x86.
>         # However the standard kernel entry on x86-64 leaves the stack on an
>         # 8-byte boundary. If the compiler isn't informed about the actual
>         # alignment it will generate extra alignment instructions for the
>         # default alignment which keep the stack *mis*aligned.
>         # Furthermore an alignment to the register width reduces stack usage
>         # and the number of alignment instructions.
>         KBUILD_CFLAGS += $(call cc-option,$(cc_stack_align8))
> [...]
> endif

And it seems that only x86 does this. No other architecture specifies
-mpreferred-stack-boundary...

> Normal x86-64 ABI has 16-byte stack alignment; Linux kernel x86-64 ABI
> has 8-byte stack alignment.
> Similarly, the normal Linux 32-bit x86 ABI is 16-byte aligned;
> meanwhile Linux kernel x86 ABI has 4-byte stack alignment.
> 
> This is because userspace code wants the stack to be sufficiently
> aligned for fancy SSE instructions and such; the kernel, on the other
> hand, never uses those in normal code, and cares about stack usage and
> such very much.

This makes it nicer for Clang:


diff --git a/include/linux/randomize_kstack.h b/include/linux/randomize_kstack.h
index 1df0dc52cadc..f7e1f68fb50c 100644
--- a/include/linux/randomize_kstack.h
+++ b/include/linux/randomize_kstack.h
@@ -10,6 +10,14 @@ DECLARE_STATIC_KEY_MAYBE(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,
 			 randomize_kstack_offset);
 DECLARE_PER_CPU(u32, kstack_offset);
 
+#ifdef CONFIG_X86_64
+#define ARCH_STACK_ALIGN_MASK	~((1 << 8) - 1)
+#elif defined(CONFIG_X86_32)
+#define ARCH_STACK_ALIGN_MASK	~((1 << 4) - 1)
+#else
+#define ARCH_STACK_ALIGN_MASK	~(0)
+#endif
+
 /*
  * Do not use this anywhere else in the kernel. This is used here because
  * it provides an arch-agnostic way to grow the stack with correct
@@ -23,7 +31,8 @@ void *__builtin_alloca(size_t size);
 	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
 				&randomize_kstack_offset)) {		\
 		u32 offset = this_cpu_read(kstack_offset);		\
-		u8 *ptr = __builtin_alloca(offset & 0x3FF);		\
+		u8 *ptr = __builtin_alloca(offset & 0x3FF &		\
+					   ARCH_STACK_ALIGN_MASK);	\
 		asm volatile("" : "=m"(*ptr));				\
 	}								\
 } while (0)


But I don't like open-coding the x86-ony stack alignment... it should be
in Kconfig or something, I think?

-- 
Kees Cook
