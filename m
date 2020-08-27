Return-Path: <SRS0=u6Ac=CF=lists.openwall.com=kernel-hardening-return-19699-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F1FC433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 14:16:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 371B32177B
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 14:16:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e6F7i1e7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 371B32177B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19699-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18399 invoked by uid 550); 27 Aug 2020 14:16:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18364 invoked from network); 27 Aug 2020 14:16:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=US45omOiVls6z8M2uEdlSDLBnxMw0pLsZXx7H6iAa+E=;
        b=e6F7i1e7uCRbycdWn6MY+mc8EyXK0bF3SfRFHGipkwdUQ7k3vr2T03zttLLOiad2d2
         skRT64vhWrKyTHt5lgT9fHNkbO5DUsisLmNszsUGALJnncb1yDJoI+C6bu9oUbGlw6T+
         umSe8Hg8wBn95ZS7r6FQHoWV8ut13Co7zGXGAHZx5U/c1cCGgFHB5PqBcWVHZHdJ5QXT
         nBzcu4qG4GKGNNPZCeKpJ3UD1mBz4rGr1THv5yarvxgkNoFLIQFIJAcM/ME3Jhpnsz5X
         wgRXTKULn8plDLfBdv+wb2HuGRfvGTTRiREaS2rSqVxisjvwXNU4Ip+0ZH9ONnGizQp4
         xpfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=US45omOiVls6z8M2uEdlSDLBnxMw0pLsZXx7H6iAa+E=;
        b=TmT0rK60qVVFp+X1xOyx7OBV4rZOKRKqlNcDjH7lxQBiQhHgLL66J83L+oujJPtEwX
         LQrbJ9bdwdYUuPsxqsjggTNg+u8NXowfRfeFfA+8Sgu/U+DwaNizJJOppx3yShSvOker
         yMeseLHWoZUXud0RsxqbAF7cPeHF++yOupIiife/1Abx0lWA39nWJodBT6X5t/97lkCZ
         NjdDw2oUrc1uyCVyT+9qy37lfxd7d3ifLNIsKmGnxz7Pljzt8lzHQOaEWbhS+kbcJyKs
         RuxfZhZWkTsXsRkkkn1pppIZUoULKdWvUTZ+s8WJS3JeMieULAVxUJHUC7xVvCrGEt+d
         8XwQ==
X-Gm-Message-State: AOAM532HIDV8qM5S2HTKvKNVLiOynWZ9h/kTvgSF5KZvsQvDBtdaJ1L3
	bVz2vWMHpoZuOrTRROImkUe9OakzjMYACmJBkPqPILnYT7s=
X-Google-Smtp-Source: ABdhPJwwzdS05p3Md8eBJAAbVD2Ab/UK7O9WHzCaXcEnh7sDm7yiIvYkYueu32foh4A/22ryhCL0Jnl3dJg9J7TWDx4=
X-Received: by 2002:a05:651c:543:: with SMTP id q3mr9581431ljp.145.1598537767712;
 Thu, 27 Aug 2020 07:16:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200827052659.24922-1-cmr@codefail.de> <20200827052659.24922-5-cmr@codefail.de>
In-Reply-To: <20200827052659.24922-5-cmr@codefail.de>
From: Jann Horn <jannh@google.com>
Date: Thu, 27 Aug 2020 16:15:41 +0200
Message-ID: <CAG48ez1W7FcDPAnqQ7TpSnKy--vaQm_f5prsZXRxcybzGg0tpg@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] powerpc: Introduce temporary mm
To: "Christopher M. Riedl" <cmr@codefail.de>
Cc: linuxppc-dev@lists.ozlabs.org, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 27, 2020 at 7:24 AM Christopher M. Riedl <cmr@codefail.de> wrote:
> x86 supports the notion of a temporary mm which restricts access to
> temporary PTEs to a single CPU. A temporary mm is useful for situations
> where a CPU needs to perform sensitive operations (such as patching a
> STRICT_KERNEL_RWX kernel) requiring temporary mappings without exposing
> said mappings to other CPUs. A side benefit is that other CPU TLBs do
> not need to be flushed when the temporary mm is torn down.
>
> Mappings in the temporary mm can be set in the userspace portion of the
> address-space.
[...]
> diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
[...]
> @@ -44,6 +45,70 @@ int raw_patch_instruction(struct ppc_inst *addr, struct ppc_inst instr)
>  }
>
>  #ifdef CONFIG_STRICT_KERNEL_RWX
> +
> +struct temp_mm {
> +       struct mm_struct *temp;
> +       struct mm_struct *prev;
> +       bool is_kernel_thread;
> +       struct arch_hw_breakpoint brk[HBP_NUM_MAX];
> +};
> +
> +static inline void init_temp_mm(struct temp_mm *temp_mm, struct mm_struct *mm)
> +{
> +       temp_mm->temp = mm;
> +       temp_mm->prev = NULL;
> +       temp_mm->is_kernel_thread = false;
> +       memset(&temp_mm->brk, 0, sizeof(temp_mm->brk));
> +}
> +
> +static inline void use_temporary_mm(struct temp_mm *temp_mm)
> +{
> +       lockdep_assert_irqs_disabled();
> +
> +       temp_mm->is_kernel_thread = current->mm == NULL;

(That's a somewhat misleading variable name - kernel threads can have
a non-NULL ->mm, too.)

> +       if (temp_mm->is_kernel_thread)
> +               temp_mm->prev = current->active_mm;
> +       else
> +               temp_mm->prev = current->mm;

Why the branch? Shouldn't current->active_mm work in both cases?


> +       /*
> +        * Hash requires a non-NULL current->mm to allocate a userspace address
> +        * when handling a page fault. Does not appear to hurt in Radix either.
> +        */
> +       current->mm = temp_mm->temp;

This looks dangerous to me. There are various places that attempt to
find all userspace tasks that use a given mm by iterating through all
tasks on the system and comparing each task's ->mm pointer to
current's. Things like current_is_single_threaded() as part of various
security checks, mm_update_next_owner(), zap_threads(), and so on. So
if this is reachable from userspace task context (which I think it
is?), I don't think we're allowed to switch out the ->mm pointer here.


> +       switch_mm_irqs_off(NULL, temp_mm->temp, current);

switch_mm_irqs_off() calls switch_mmu_context(), which in the nohash
implementation increments next->context.active and decrements
prev->context.active if prev is non-NULL, right? So this would
increase temp_mm->temp->context.active...

> +       if (ppc_breakpoint_available()) {
> +               struct arch_hw_breakpoint null_brk = {0};
> +               int i = 0;
> +
> +               for (; i < nr_wp_slots(); ++i) {
> +                       __get_breakpoint(i, &temp_mm->brk[i]);
> +                       if (temp_mm->brk[i].type != 0)
> +                               __set_breakpoint(i, &null_brk);
> +               }
> +       }
> +}
> +
> +static inline void unuse_temporary_mm(struct temp_mm *temp_mm)
> +{
> +       lockdep_assert_irqs_disabled();
> +
> +       if (temp_mm->is_kernel_thread)
> +               current->mm = NULL;
> +       else
> +               current->mm = temp_mm->prev;
> +       switch_mm_irqs_off(NULL, temp_mm->prev, current);

... whereas this would increase temp_mm->prev->context.active. As far
as I can tell, that'll mean that both the original mm and the patching
mm will have their .active counts permanently too high after
use_temporary_mm()+unuse_temporary_mm()?

> +       if (ppc_breakpoint_available()) {
> +               int i = 0;
> +
> +               for (; i < nr_wp_slots(); ++i)
> +                       if (temp_mm->brk[i].type != 0)
> +                               __set_breakpoint(i, &temp_mm->brk[i]);
> +       }
> +}
