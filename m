Return-Path: <SRS0=7gWg=AD=lists.openwall.com=kernel-hardening-return-19044-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE62C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 21:30:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 48A2C206D4
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 21:30:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PbXo+AAU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48A2C206D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19044-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12072 invoked by uid 550); 22 Jun 2020 21:30:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12028 invoked from network); 22 Jun 2020 21:30:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pLN2RaPddxRloDpN+pRwQoiNiSyh25YEOfza1Wb+VHE=;
        b=PbXo+AAUJ5jVd5yBXYTaqNpkqWjS+viBecyCQ4cn0lZ7K1T7oe9cXDqosUKpFoYZZu
         FtVG00wDnjPQEg/jKU5F5eqvyPGU1ZgCNOYpKqeywY4h2JUzArVp7p4RLYBb0oVl4kmj
         3ANK8t3QGcMtwG+m1ybJ7nlXfeTZQpbBr6POo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pLN2RaPddxRloDpN+pRwQoiNiSyh25YEOfza1Wb+VHE=;
        b=HO22JHFpGHp/jSRb9aZ67lR+1+wDrBnK1DdrmeroBvsxmks+fyLPJldyQakCt9tVj8
         Xxyfjxe7TowndFOX6g9EUKCQ7b1MiqVuqxXhv2HLOmbfrtEP7MlwITzOYIB0IGKvxX3f
         yaoazZKEpnBa5Ua+zVXAZy1gKIcek8bYmVY5YWgP3hORsNRMj+d3C+xuPaHyuuN6eXOr
         k5d9mxQ0/fg+Q3J1PoiRZUqDkC5ForruiATm/hqj3yHmVQzCxYrWXknsvDXDeHmg7EqW
         PTnCbSSsN1mv8ydQXzeE3f4wf4rj+QT63a/BWI5X1UIWVDkG32U5+fQVqKuEECtiK82H
         6zhA==
X-Gm-Message-State: AOAM531VwbyU27CSZNuCyDyTSGhb0g8NE4M6t4YrPiRkXPz/aPNoK0Xh
	ugFAscm6vqcnQABtuI0w42+MmA==
X-Google-Smtp-Source: ABdhPJw7w1NVvAhJYf89+YhAFuDDc20voExouq/QieTMXvtk2w4TSXX7wfv4gqLDVHJ1o0sg4pMirg==
X-Received: by 2002:a17:902:6908:: with SMTP id j8mr18923742plk.124.1592861419296;
        Mon, 22 Jun 2020 14:30:19 -0700 (PDT)
Date: Mon, 22 Jun 2020 14:30:17 -0700
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
Message-ID: <202006221426.CEEE0B8@keescook>
References: <20200622193146.2985288-1-keescook@chromium.org>
 <20200622193146.2985288-4-keescook@chromium.org>
 <CAG48ez0pRtMZs3Hc3R2+XGHRwt9nZAGZu6vDpPBMbE+Askr_+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0pRtMZs3Hc3R2+XGHRwt9nZAGZu6vDpPBMbE+Askr_+Q@mail.gmail.com>

On Mon, Jun 22, 2020 at 10:07:37PM +0200, Jann Horn wrote:
> On Mon, Jun 22, 2020 at 9:31 PM Kees Cook <keescook@chromium.org> wrote:
> > This provides the ability for architectures to enable kernel stack base
> > address offset randomization. This feature is controlled by the boot
> > param "randomize_kstack_offset=on/off", with its default value set by
> > CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT.
> [...]
> > +#define add_random_kstack_offset() do {                                        \
> > +       if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT, \
> > +                               &randomize_kstack_offset)) {            \
> > +               u32 offset = this_cpu_read(kstack_offset);              \
> > +               u8 *ptr = __builtin_alloca(offset & 0x3FF);             \
> > +               asm volatile("" : "=m"(*ptr));                          \
> > +       }                                                               \
> > +} while (0)
> 
> clang generates better code here if the mask is stack-aligned -
> otherwise it needs to round the stack pointer / the offset:

Interesting. I was hoping to avoid needing to know the architecture
stack alignment (leaving it up to the compiler).

> 
> $ cat alloca_align.c
> #include <alloca.h>
> void callee(void);
> 
> void alloca_blah(unsigned long rand) {
>   asm volatile(""::"r"(alloca(rand & MASK)));
>   callee();
> }
> $ clang -O3 -c -o alloca_align.o alloca_align.c -DMASK=0x3ff
> $ objdump -d alloca_align.o
> [...]
>    0: 55                    push   %rbp
>    1: 48 89 e5              mov    %rsp,%rbp
>    4: 81 e7 ff 03 00 00    and    $0x3ff,%edi
>    a: 83 c7 0f              add    $0xf,%edi
>    d: 83 e7 f0              and    $0xfffffff0,%edi
>   10: 48 89 e0              mov    %rsp,%rax
>   13: 48 29 f8              sub    %rdi,%rax
>   16: 48 89 c4              mov    %rax,%rsp
>   19: e8 00 00 00 00        callq  1e <alloca_blah+0x1e>
>   1e: 48 89 ec              mov    %rbp,%rsp
>   21: 5d                    pop    %rbp
>   22: c3                    retq
> $ clang -O3 -c -o alloca_align.o alloca_align.c -DMASK=0x3f0
> $ objdump -d alloca_align.o
> [...]
>    0: 55                    push   %rbp
>    1: 48 89 e5              mov    %rsp,%rbp
>    4: 48 89 e0              mov    %rsp,%rax
>    7: 81 e7 f0 03 00 00    and    $0x3f0,%edi
>    d: 48 29 f8              sub    %rdi,%rax
>   10: 48 89 c4              mov    %rax,%rsp
>   13: e8 00 00 00 00        callq  18 <alloca_blah+0x18>
>   18: 48 89 ec              mov    %rbp,%rsp
>   1b: 5d                    pop    %rbp
>   1c: c3                    retq
> $
> 
> (From a glance at the assembly, gcc seems to always assume that the
> length may be misaligned.)

Right -- this is why I didn't bother with it, since it didn't seem to
notice what I'd already done to the alloca() argument. (But from what I
could measure on cycle counts, the additional ALU didn't seem to really
make much difference ... it _would_ be nice to avoid it, of course.)

> Maybe this should be something along the lines of
> __builtin_alloca(offset & (0x3ff & ARCH_STACK_ALIGN_MASK)) (with
> appropriate definitions of the stack alignment mask depending on the
> architecture's choice of stack alignment for kernel code).

Is that explicitly selected anywhere in the kernel? I thought the
alignment was left up to the compiler (as in I've seen bugs fixed where
the kernel had to deal with the alignment choices the compiler was
making...)

-- 
Kees Cook
