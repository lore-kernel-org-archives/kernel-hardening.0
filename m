Return-Path: <SRS0=lXfB=AD=lists.openwall.com=kernel-hardening-return-19045-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA459C433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 21:43:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0B94E2075A
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 21:43:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r0DY4x7U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B94E2075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19045-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30633 invoked by uid 550); 22 Jun 2020 21:43:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30595 invoked from network); 22 Jun 2020 21:43:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hqlIISzIW03YTIn+IXU1UUFP1CW/3V82KQ6IEM7geR0=;
        b=r0DY4x7UzAHeQZoPjhdk2r7pUPSknDOTxdrF8KRA6OcukEX8mWdDnLdR3yjOmhmYne
         awFznm+XAuVdZ8nE7fsaNZTS1wAUeh7i57IpVG26eXFZkxYzszfpbgcx540TIfBtqUxz
         jWj0jxYPt5QA1TkKbSgVYMEmu9O3VtX8jX/MQX2RxhHfmX+1vSoKqkDhGmta17TKAE+W
         Tz9H/ZKMG20/IjU7PAhFoNhzdL6w+2gQjVYB2/IvVWij44sCiBqZ0hoplQQpqpk/pj2v
         AMJmLfDkaluen4kFMVCQ3DOYqq8mmJw9gJ/6V5SI15bUKMy8pTZRWR6BZUMmvhf/CzUc
         Mr9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hqlIISzIW03YTIn+IXU1UUFP1CW/3V82KQ6IEM7geR0=;
        b=pFq4P2WQrGDjRO0sgmdopgVZz3nGGEzMLKU/wTqy5uRMCseWbp45/4M6AOjFiqXh88
         mGjoCJPBn61U3ZfPcDcbjsOWuDumz8QFAa705+7gPfP5DzozXIS3hPbW4tLiyai310tX
         W9459nZ9oFowS87yvNEvvl01M5Hdb+IosTlcy6IwRAWAdRnoMigjtnm0GZ8/3IT2MaNg
         7SXCM08Ucp3LdLtDPb5ceGH8TFz71DowQ4LrFOFUdSvM+V7HtFTKg4eLFksl3VGxLXER
         Ao5rRvRX6Z0qla13/fOJlbWEjKcKs9+ec5jPSQ30fM1DR0mtmFEP3NIUb2DH5VmnHoZv
         C6sA==
X-Gm-Message-State: AOAM532FepEjW+M/WEcLR9SU19MV8/KVJGKXZP9vA/93hLHmljY+/xCk
	zrJrAXgZUlrxNWE0f/Zc0S25ySCeL+n2UgiNffcfXw==
X-Google-Smtp-Source: ABdhPJxLOcc9zOfFkNQLHUw25KEy+AUpLGEG1pTH0THPNaOezrQbLYNPLk7zcaTh0H/YpTzAa5EnWEvIE9AHELkuuu8=
X-Received: by 2002:a19:8b8a:: with SMTP id n132mr10747294lfd.45.1592862175484;
 Mon, 22 Jun 2020 14:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200622193146.2985288-1-keescook@chromium.org>
 <20200622193146.2985288-4-keescook@chromium.org> <CAG48ez0pRtMZs3Hc3R2+XGHRwt9nZAGZu6vDpPBMbE+Askr_+Q@mail.gmail.com>
 <202006221426.CEEE0B8@keescook>
In-Reply-To: <202006221426.CEEE0B8@keescook>
From: Jann Horn <jannh@google.com>
Date: Mon, 22 Jun 2020 23:42:29 +0200
Message-ID: <CAG48ez1b_wMkQGj+z=dWSVctikzzw72V3SPexEPm3Aw8LrXGWQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] stack: Optionally randomize kernel stack offset
 each syscall
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova <elena.reshetova@intel.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Potapenko <glider@google.com>, 
	Alexander Popov <alex.popov@linux.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 22, 2020 at 11:30 PM Kees Cook <keescook@chromium.org> wrote:
> On Mon, Jun 22, 2020 at 10:07:37PM +0200, Jann Horn wrote:
> > On Mon, Jun 22, 2020 at 9:31 PM Kees Cook <keescook@chromium.org> wrote:
> > > This provides the ability for architectures to enable kernel stack base
> > > address offset randomization. This feature is controlled by the boot
> > > param "randomize_kstack_offset=on/off", with its default value set by
> > > CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT.
> > [...]
> > > +#define add_random_kstack_offset() do {                                        \
> > > +       if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT, \
> > > +                               &randomize_kstack_offset)) {            \
> > > +               u32 offset = this_cpu_read(kstack_offset);              \
> > > +               u8 *ptr = __builtin_alloca(offset & 0x3FF);             \
> > > +               asm volatile("" : "=m"(*ptr));                          \
> > > +       }                                                               \
> > > +} while (0)
> >
> > clang generates better code here if the mask is stack-aligned -
> > otherwise it needs to round the stack pointer / the offset:
[...]
> > Maybe this should be something along the lines of
> > __builtin_alloca(offset & (0x3ff & ARCH_STACK_ALIGN_MASK)) (with
> > appropriate definitions of the stack alignment mask depending on the
> > architecture's choice of stack alignment for kernel code).
>
> Is that explicitly selected anywhere in the kernel? I thought the
> alignment was left up to the compiler (as in I've seen bugs fixed where
> the kernel had to deal with the alignment choices the compiler was
> making...)

No, at least on x86-64 and x86 Linux overrides the normal ABI. From
arch/x86/Makefile:

# For gcc stack alignment is specified with -mpreferred-stack-boundary,
# clang has the option -mstack-alignment for that purpose.
ifneq ($(call cc-option, -mpreferred-stack-boundary=4),)
      cc_stack_align4 := -mpreferred-stack-boundary=2
      cc_stack_align8 := -mpreferred-stack-boundary=3
else ifneq ($(call cc-option, -mstack-alignment=16),)
      cc_stack_align4 := -mstack-alignment=4
      cc_stack_align8 := -mstack-alignment=8
endif
[...]
ifeq ($(CONFIG_X86_32),y)
[...]
        # Align the stack to the register width instead of using the default
        # alignment of 16 bytes. This reduces stack usage and the number of
        # alignment instructions.
        KBUILD_CFLAGS += $(call cc-option,$(cc_stack_align4))
[...]
else
[...]
        # By default gcc and clang use a stack alignment of 16 bytes for x86.
        # However the standard kernel entry on x86-64 leaves the stack on an
        # 8-byte boundary. If the compiler isn't informed about the actual
        # alignment it will generate extra alignment instructions for the
        # default alignment which keep the stack *mis*aligned.
        # Furthermore an alignment to the register width reduces stack usage
        # and the number of alignment instructions.
        KBUILD_CFLAGS += $(call cc-option,$(cc_stack_align8))
[...]
endif

Normal x86-64 ABI has 16-byte stack alignment; Linux kernel x86-64 ABI
has 8-byte stack alignment.
Similarly, the normal Linux 32-bit x86 ABI is 16-byte aligned;
meanwhile Linux kernel x86 ABI has 4-byte stack alignment.

This is because userspace code wants the stack to be sufficiently
aligned for fancy SSE instructions and such; the kernel, on the other
hand, never uses those in normal code, and cares about stack usage and
such very much.
