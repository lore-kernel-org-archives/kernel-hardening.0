Return-Path: <SRS0=Cph0=YL=lists.openwall.com=kernel-hardening-return-17043-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8423CA9EA9
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 17:13:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2BDE721925
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 17:13:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b3XVK3oU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BDE721925
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17043-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24247 invoked by uid 550); 18 Oct 2019 17:13:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24229 invoked from network); 18 Oct 2019 17:13:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hDou5Z7AnxlXNsw3EcpY942CX+9awGJrPWvG/Uzq/u0=;
        b=b3XVK3oUecv8zhJLi8wBDU7dsrLDXf1OhUshJUWrVsOCyqSXhdbO23VgWxMa1R1urV
         O3E1ni9xUlU5exVU2VN35NKkne1rfv/1j3PKa/bWhKm2DIro7eXxLtItOmaC3XOEVOA9
         ZLv/TVDdBvoFM3TfTMn3ONMlD7GUkxnZaMFWTTyGh44WPUx0cpIo6kEG+IVNJg1lrwBL
         WL9jGxsuEWtxSL3cJ9QRV9f3OdnQ5+aRdNlpTr9CoWQjI8f2G640+Y7wNI2i7oNG2Rsy
         O6DYbrPat+1p7BnU+R03ZNEIzhlMSWVKzCr2Ut84sHvq/7dPn/M9sIfCLCn29vsJ4VLN
         Awew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hDou5Z7AnxlXNsw3EcpY942CX+9awGJrPWvG/Uzq/u0=;
        b=SL5j5OQVpUcF5AaJgc/VMNt91X+KYo8K2Il9PIcBHrHkiYdjEn8G0vApuGr8SapZa2
         GPXWMWEZK4ANRc5VW3G+PTTwaJ5j7iaTjrynNokMaNzLf/KJwG48hUMEf4T4NGFK1keZ
         hNzrqzyKJDTPT+RuBLYtzd+eiaoPu6xNz1WjLiaUDGWyyGw0TdLX1jRKKP9lI7d+kOPk
         HgvRUT/NlCDic6txbDWEEajK0uvbdxhZIaH7kWahQMfpxhb4bw8Yqelm8xiPi1ZspmqP
         qybE8lhbPzSs1VC8GneJFP1Ph6vNLu/oQNcmTT2zuvRXdKCj25EObi0GRWeioLh1ThR5
         +YCQ==
X-Gm-Message-State: APjAAAXJ8bELh3+ZwUFJ0DvAb+0GP+JwTdgjzjj7y4qGN+Rf/vf15yUw
	AGQaYfdnGKLcEoikuFLYHxWTl0Eq0YJhZnSdarfkpw==
X-Google-Smtp-Source: APXvYqzk63aLcaDtSLDQmaTKnKA/9Iqjg+1oUYrcegXtjis3ArS3MzocA0YvPnHL7bljLig2r8OQsin0dsxx/YoQ1HQ=
X-Received: by 2002:a05:6830:10cc:: with SMTP id z12mr8713226oto.110.1571418798907;
 Fri, 18 Oct 2019 10:13:18 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191018161033.261971-19-samitolvanen@google.com>
In-Reply-To: <20191018161033.261971-19-samitolvanen@google.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 18 Oct 2019 19:12:52 +0200
Message-ID: <CAG48ez2Z8=0__eoQ+Ekp=EApawZXR4ec_xd2TVPQExLoyMwtRQ@mail.gmail.com>
Subject: Re: [PATCH 18/18] arm64: implement Shadow Call Stack
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-arm-kernel@lists.infradead.org, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 6:16 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> This change implements shadow stack switching, initial SCS set-up,
> and interrupt shadow stacks for arm64.
[...]
> +static inline void scs_save(struct task_struct *tsk)
> +{
> +       void *s;
> +
> +       asm volatile("mov %0, x18" : "=r" (s));
> +       task_set_scs(tsk, s);
> +}
> +
> +static inline void scs_load(struct task_struct *tsk)
> +{
> +       asm volatile("mov x18, %0" : : "r" (task_scs(tsk)));
> +       task_set_scs(tsk, NULL);
> +}

These things should probably be __always_inline or something like
that? If the compiler decides not to inline them (e.g. when called
from scs_thread_switch()), stuff will blow up, right?

> +static inline void scs_thread_switch(struct task_struct *prev,
> +                                    struct task_struct *next)
> +{
> +       scs_save(prev);
> +       scs_load(next);
> +
> +       if (unlikely(scs_corrupted(prev)))
> +               panic("corrupted shadow stack detected inside scheduler\n");
> +}
[...]
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +DECLARE_PER_CPU(unsigned long *, irq_shadow_call_stack_ptr);
> +#endif

If an attacker has a leak of some random function pointer to find the
ASLR base address, they'll know where irq_shadow_call_stack_ptr is.
With an arbitrary read (to read
irq_shadow_call_stack_ptr[sched_getcpu()]) followed by an arbitrary
write, they'd be able to overwrite the shadow stack. Or with just an
arbitrary write without a read, they could change
irq_shadow_call_stack_ptr[sched_getcpu()] to point elsewhere. This is
different from the intended protection level according to
<https://clang.llvm.org/docs/ShadowCallStack.html#security>, which
talks about "a runtime that avoids exposing the address of the shadow
call stack to attackers that can read arbitrary memory". Of course,
that's extremely hard to implement in the context of the kernel, where
you can see all the memory management data structures and all physical
memory.

You might want to write something in the cover letter about what the
benefits of this mechanism compared to STACKPROTECTOR are in the
context of the kernel, including a specific description of which types
of attacker capabilities this is supposed to defend against.
