Return-Path: <SRS0=C7U2=Y4=lists.openwall.com=kernel-hardening-return-17274-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A84CA9EB5
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 18:25:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7826E20869
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 18:25:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DDqpEeTe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7826E20869
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17274-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20415 invoked by uid 550); 4 Nov 2019 18:25:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20391 invoked from network); 4 Nov 2019 18:25:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wt2wTLQmxuTdMREEhAUzUopx1z+7npE/zcGOwaeBYN0=;
        b=DDqpEeTelp0KBAryLFhu0seN089G4kwryRW1DYK2wQrlbIi7CRZsh9v2rcHQEPNl6J
         BBj2NRR2Pk1HlvbuSVjDZIuO5wVpct/qrEFvtbSEy6x4C/TVeLKcEZpKnWq2cs6UPc/M
         l7AgZnDwg4JIqG/CsJuuCNB9U1+Pn6+/Myvlpdne5Wi8ejUqBS+ZbHgKuK0h9LlQ/9U9
         vzflZtZYP33BApxQ0ZnwHc47l2lV6Z24PHrJlAKr48TzpPfeXaXAEYeAe6OnXza1Qus0
         lUbnCrKgtbRLcXOh4dTgIClkyiJiSPQUSNXlnm00vzIZKxY6NiiDXTVHK7IRRgPyZIPf
         8rLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wt2wTLQmxuTdMREEhAUzUopx1z+7npE/zcGOwaeBYN0=;
        b=QAU92z4/SALTQF1tYgWmcQW6gDEwiAkuUDCApc//YYwO52XOFp1syVJu5a/N3IJkAp
         QCh8SEhky3BaEcGaoT300WoHi7tDUBF5HIo1TWcdH2xrnofWGq3YItMQwqAWmHgj5XMm
         X8ChSxgvesfgSyjplixLkXOXsrOwgmCq0ZmwmkiQPsCZ4l83A3Z1RvrYKCywSkJpoml5
         RCusa0OPI2nytMzaO6tgoGpsuW4QFYoPE/YCEn57Z11q/SeFDepaicrKZ3B/+1mbJh/a
         l8FJuPpU1RRCtr1QJwSOMKadHjdrjiwZ4V1jT/kBoVzDoudsiVeU1pnO/57My7LwcpN0
         Hk9g==
X-Gm-Message-State: APjAAAVoW5RWvjtFUO8GHeMT+bcZoca6lQxjcACVeTKg334TbMCj8CCb
	EOWoAjZ7CVpvIrSdyTrF9qDh+1Zi4Lbr6ftavNTUbA==
X-Google-Smtp-Source: APXvYqxQ+BbqVGy/ZlafGenaa87R0O4QfL/HHG42BUFGVSDt18L0htIGyWtjiK0hi3VHdQ62vQ0H7BnCJt/j4lp4Ang=
X-Received: by 2002:a67:e951:: with SMTP id p17mr10322928vso.112.1572891936159;
 Mon, 04 Nov 2019 10:25:36 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com> <20191101221150.116536-6-samitolvanen@google.com>
 <20191104123126.GC45140@lakrids.cambridge.arm.com>
In-Reply-To: <20191104123126.GC45140@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 4 Nov 2019 10:25:24 -0800
Message-ID: <CABCJKudAiafvGk60oOjcZwcSHV69vGYZYpHaDD9HRgAuEx4jBw@mail.gmail.com>
Subject: Re: [PATCH v4 05/17] add support for Clang's Shadow Call Stack (SCS)
To: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 4, 2019 at 4:31 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > +/*
> > + * In testing, 1 KiB shadow stack size (i.e. 128 stack frames on a 64-bit
> > + * architecture) provided ~40% safety margin on stack usage while keeping
> > + * memory allocation overhead reasonable.
> > + */
> > +#define SCS_SIZE     1024
>
> To make it easier to reason about type promotion rules (and avoid that
> we accidentaly mask out high bits when using this to generate a mask),
> can we please make this 1024UL?

Sure.

> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -6013,6 +6013,8 @@ void init_idle(struct task_struct *idle, int cpu)
> >       raw_spin_lock_irqsave(&idle->pi_lock, flags);
> >       raw_spin_lock(&rq->lock);
> >
> > +     scs_task_reset(idle);
>
> Could we please do this next to the kasan_unpoison_task_stack() call,
> Either just before, or just after?
>
> They're boot addressing the same issue where previously live stack is
> being reused, and in general I'd expect them to occur at the same time
> (though I understand idle will be a bit different).

Good point, I'll move this.

> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -58,6 +58,7 @@
> >  #include <linux/profile.h>
> >  #include <linux/psi.h>
> >  #include <linux/rcupdate_wait.h>
> > +#include <linux/scs.h>
> >  #include <linux/security.h>
> >  #include <linux/stop_machine.h>
> >  #include <linux/suspend.h>
>
> This include looks extraneous.

I added this to sched.h, because most of the includes used in
kernel/sched appear to be there, but I can move this to
kernel/sched/core.c instead.

> > +static inline void *__scs_base(struct task_struct *tsk)
> > +{
> > +     /*
> > +      * We allow architectures to use the shadow_call_stack field in
> > +      * struct thread_info to store the current shadow stack pointer
> > +      * during context switches.
> > +      *
> > +      * This allows the implementation to also clear the field when
> > +      * the task is active to avoid keeping pointers to the current
> > +      * task's shadow stack in memory. This can make it harder for an
> > +      * attacker to locate the shadow stack, but also requires us to
> > +      * compute the base address when needed.
> > +      *
> > +      * We assume the stack is aligned to SCS_SIZE.
> > +      */
>
> How about:
>
>         /*
>          * To minimize risk the of exposure, architectures may clear a
>          * task's thread_info::shadow_call_stack while that task is
>          * running, and only save/restore the active shadow call stack
>          * pointer when the usual register may be clobbered (e.g. across
>          * context switches).
>          *
>          * The shadow call stack is aligned to SCS_SIZE, and grows
>          * upwards, so we can mask out the low bits to extract the base
>          * when the task is not running.
>          */
>
> ... which I think makes the lifetime and constraints a bit clearer.

Sounds good to me, thanks.

> > +     return (void *)((uintptr_t)task_scs(tsk) & ~(SCS_SIZE - 1));
>
> We usually use unsigned long ratehr than uintptr_t. Could we please use
> that for consistency?
>
> The kernel relies on sizeof(unsigned long) == sizeof(void *) tree-wide,
> so that doesn't cause issues for us here.
>
> Similarly, as suggested above, it would be easier to reason about this
> knowing that SCS_SIZE is an unsigned long. While IIUC we'd get sign
> extension here when it's promoted, giving the definition a UL suffix
> minimizes the scope for error.

OK, I'll switch to unsigned long.

> > +/* Keep a cache of shadow stacks */
> > +#define SCS_CACHE_SIZE 2
>
> How about:
>
> /* Matches NR_CACHED_STACKS for VMAP_STACK */
> #define NR_CACHED_SCS 2
>
> ... which explains where the number came from, and avoids confusion that
> the SIZE is a byte size rather than number of elements.

Agreed, that sounds better.

> > +static void scs_free(void *s)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < SCS_CACHE_SIZE; i++)
> > +             if (this_cpu_cmpxchg(scs_cache[i], 0, s) == 0)
> > +                     return;
>
> Here we should compare to NULL rather than 0.

Ack.

> > +void __init scs_init(void)
> > +{
> > +     cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "scs:scs_cache", NULL,
> > +             scs_cleanup);
>
> We probably want to do something if this call fails. It looks like we'd
> only leak two pages (and we'd be able to use them if/when that CPU is
> brought back online. A WARN_ON() is probably fine.

fork_init() in kernel/fork.c lets this fail quietly, but adding a
WARN_ON seems fine.

I will include these changes in v5.

Sami
