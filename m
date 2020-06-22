Return-Path: <SRS0=KQIV=AD=lists.openwall.com=kernel-hardening-return-19040-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CCEC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 20:08:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7609D20776
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 20:08:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jxiFrV3w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7609D20776
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19040-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4036 invoked by uid 550); 22 Jun 2020 20:08:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3996 invoked from network); 22 Jun 2020 20:08:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O1iewzZxKxZsHCFE1IpIKZAcHdEXX0k0VhJhMjCxJRk=;
        b=jxiFrV3w0j5aLn+vYERXrsFANe18BmkW8WhpfbwrqvZCR3QlASLHN+s0dvUKCC7S0Z
         HHlQLoUjWeB77nDpLPWTX2cD+NqKKStkAUVgrU+ZbFo1WfJUCp3PbvnavLvRJJfywm9B
         PS8KIdxPs6dMefugAy/F3KfgHucAWcr7w9gXuUdcHllmvBB4qZe8A4Bp1EsirM9H8PWJ
         v3uvp+OkmO1pC5tsQ4XX81pf9YCj8Gokg9OWfBfubRYEyWUdvxonrCWsPW+wes77jqgR
         h6ape1nNvKoIrkpKbq7TDwpAj4bHv9zDGppyQfT3YxAm8q0kqdPmVMD48RqJ0ih/c0dw
         +hLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O1iewzZxKxZsHCFE1IpIKZAcHdEXX0k0VhJhMjCxJRk=;
        b=h2ioPrChHWdWTHfT6gXy41HcFSEHewYiKnNhcWGlEJoi/0NRMeUsB/DdOTqsQMiwpC
         klSBc0BVDB3qOVFmSKjTznHsATyfm4yqJsMyqUT7laY8D+tok26QfYcvFnV6rz9pPiT7
         1giGWkJG9Ywn+YcYFrWmGC904guyierIYo15jsrNG0YHXpOGNCgqVSZrBIb0M57Yw4Ub
         9Al5VkNAxwcGgVvNstdD5Zw40XooeE41bJJ3t7H+NNjxm2LD1vlgHo2mANk7s0TlN5q3
         7j00wt3UZ+eTNmZlWzxo9camNTsGtBuCVqKypztTJ8M5h5nTWJFUNfz/bnBv2nAedUwV
         Yphw==
X-Gm-Message-State: AOAM532AQtsthniXT4AtC0zoRomjSl92bPh7B5+IshZS29SiapsbYOTU
	V0T76XYbVZQWJh0E2Vh/I8V722fdbQzb1lVQWhIa/w==
X-Google-Smtp-Source: ABdhPJy5dWzQBSNi9Zt/usqkY9agJUTDidKHpdWxCl7nmtqE+I17wPTUgLZYCHA4VjDO1Von9AZ6ddnuU6GBJyOUNKU=
X-Received: by 2002:a2e:9a44:: with SMTP id k4mr9089871ljj.139.1592856483831;
 Mon, 22 Jun 2020 13:08:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200622193146.2985288-1-keescook@chromium.org> <20200622193146.2985288-4-keescook@chromium.org>
In-Reply-To: <20200622193146.2985288-4-keescook@chromium.org>
From: Jann Horn <jannh@google.com>
Date: Mon, 22 Jun 2020 22:07:37 +0200
Message-ID: <CAG48ez0pRtMZs3Hc3R2+XGHRwt9nZAGZu6vDpPBMbE+Askr_+Q@mail.gmail.com>
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

On Mon, Jun 22, 2020 at 9:31 PM Kees Cook <keescook@chromium.org> wrote:
> This provides the ability for architectures to enable kernel stack base
> address offset randomization. This feature is controlled by the boot
> param "randomize_kstack_offset=on/off", with its default value set by
> CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT.
[...]
> +#define add_random_kstack_offset() do {                                        \
> +       if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT, \
> +                               &randomize_kstack_offset)) {            \
> +               u32 offset = this_cpu_read(kstack_offset);              \
> +               u8 *ptr = __builtin_alloca(offset & 0x3FF);             \
> +               asm volatile("" : "=m"(*ptr));                          \
> +       }                                                               \
> +} while (0)

clang generates better code here if the mask is stack-aligned -
otherwise it needs to round the stack pointer / the offset:

$ cat alloca_align.c
#include <alloca.h>
void callee(void);

void alloca_blah(unsigned long rand) {
  asm volatile(""::"r"(alloca(rand & MASK)));
  callee();
}
$ clang -O3 -c -o alloca_align.o alloca_align.c -DMASK=0x3ff
$ objdump -d alloca_align.o
[...]
   0: 55                    push   %rbp
   1: 48 89 e5              mov    %rsp,%rbp
   4: 81 e7 ff 03 00 00    and    $0x3ff,%edi
   a: 83 c7 0f              add    $0xf,%edi
   d: 83 e7 f0              and    $0xfffffff0,%edi
  10: 48 89 e0              mov    %rsp,%rax
  13: 48 29 f8              sub    %rdi,%rax
  16: 48 89 c4              mov    %rax,%rsp
  19: e8 00 00 00 00        callq  1e <alloca_blah+0x1e>
  1e: 48 89 ec              mov    %rbp,%rsp
  21: 5d                    pop    %rbp
  22: c3                    retq
$ clang -O3 -c -o alloca_align.o alloca_align.c -DMASK=0x3f0
$ objdump -d alloca_align.o
[...]
   0: 55                    push   %rbp
   1: 48 89 e5              mov    %rsp,%rbp
   4: 48 89 e0              mov    %rsp,%rax
   7: 81 e7 f0 03 00 00    and    $0x3f0,%edi
   d: 48 29 f8              sub    %rdi,%rax
  10: 48 89 c4              mov    %rax,%rsp
  13: e8 00 00 00 00        callq  18 <alloca_blah+0x18>
  18: 48 89 ec              mov    %rbp,%rsp
  1b: 5d                    pop    %rbp
  1c: c3                    retq
$

(From a glance at the assembly, gcc seems to always assume that the
length may be misaligned.)

Maybe this should be something along the lines of
__builtin_alloca(offset & (0x3ff & ARCH_STACK_ALIGN_MASK)) (with
appropriate definitions of the stack alignment mask depending on the
architecture's choice of stack alignment for kernel code).
