Return-Path: <SRS0=CI3a=BQ=lists.openwall.com=kernel-hardening-return-19563-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8D4C433E1
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Aug 2020 01:27:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 38F622173E
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Aug 2020 01:27:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="JVrhm/RJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38F622173E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19563-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3985 invoked by uid 550); 6 Aug 2020 01:27:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3945 invoked from network); 6 Aug 2020 01:27:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=DuDsgb65jk4kM2QKtIcboGNZ4XnXjsLei0jhdfgm7I8=;
        b=JVrhm/RJlNTG1NWPza2dQZr9Xi30R017lzKrVsOpyLhddn5aaWR4VI5KEYKCX6Fy6Z
         QFjTcd5DEo1+jJNFpTv5BFvCVyvjFw/LDC3fUCTe2c1of3XCTUaRj9Q/KJJ6mTIxrcMu
         iLFztksVOvNcFMsdX0PK2ZsvGjzWJQjvmnwEI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DuDsgb65jk4kM2QKtIcboGNZ4XnXjsLei0jhdfgm7I8=;
        b=TGKbpGMBlL2VbMzMwGRrG2zM7/DhAa0K4OGM8sHIxFu/pVHPVlfCGrm/m1CbRjCi3n
         +372owbmoBQGGMRPLbPwawiuc1GiEUsefYQ/dNbIXCTjGI5s7xBEESFGDCvtCJM4VZkZ
         /32oWRbi8iaQAvaUCroQpHI0Y8g4FZvndOw6cU83aUr3S71yP6sfoayLQ/+mr96wiaF+
         tJa5uTbXrrbAMSx53yrstGReymklxyiIIm9V7g5YpueOEYJrCZ3BtZcmdgKDlrbvN9ln
         toFpxbZZT63ElDQ7ig4df2hOIU20Cx6Upc2CK8WUprunQj6u3ESG6VXk6WblRyhfbGsb
         LpiA==
X-Gm-Message-State: AOAM533Oi3OxN1QxmCKToI6P5vqWBPr/2a6Rlr9wrQvJUcZxJe9FJp/u
	NA4NygA3NY9CQDp+PNW5C8DAhA==
X-Google-Smtp-Source: ABdhPJzpaODOKaK9mM77lcsaN9J7+FL/2GndCh5/hjyd1GVGbqvkDAvBzL1BVhx5eCGGJl+3MhV6/A==
X-Received: by 2002:a17:902:8c8a:: with SMTP id t10mr5587875plo.112.1596677254340;
        Wed, 05 Aug 2020 18:27:34 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: "Christopher M. Riedl" <cmr@informatik.wtf>, linuxppc-dev@lists.ozlabs.org
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2 1/5] powerpc/mm: Introduce temporary mm
In-Reply-To: <20200709040316.12789-2-cmr@informatik.wtf>
References: <20200709040316.12789-1-cmr@informatik.wtf> <20200709040316.12789-2-cmr@informatik.wtf>
Date: Thu, 06 Aug 2020 11:27:30 +1000
Message-ID: <87o8noo96l.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain

Hi Chris,
  
>  void __set_breakpoint(int nr, struct arch_hw_breakpoint *brk);
> +void __get_breakpoint(int nr, struct arch_hw_breakpoint *brk);
>  bool ppc_breakpoint_available(void);
>  #ifdef CONFIG_PPC_ADV_DEBUG_REGS
>  extern void do_send_trap(struct pt_regs *regs, unsigned long address,
> diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerpc/include/asm/mmu_context.h
> index 1a474f6b1992..9269c7c7b04e 100644
> --- a/arch/powerpc/include/asm/mmu_context.h
> +++ b/arch/powerpc/include/asm/mmu_context.h
> @@ -10,6 +10,7 @@
>  #include <asm/mmu.h>	
>  #include <asm/cputable.h>
>  #include <asm/cputhreads.h>
> +#include <asm/debug.h>
>  
>  /*
>   * Most if the context management is out of line
> @@ -300,5 +301,68 @@ static inline int arch_dup_mmap(struct mm_struct *oldmm,
>  	return 0;
>  }
>  
> +struct temp_mm {
> +	struct mm_struct *temp;
> +	struct mm_struct *prev;
> +	bool is_kernel_thread;
> +	struct arch_hw_breakpoint brk[HBP_NUM_MAX];
> +};

This is on the nitpicky end, but I wonder if this should be named
temp_mm, or should be labelled something else to capture its broader
purpose as a context for code patching? I'm thinking that a store of
breakpoints is perhaps unusual in a memory-managment structure?

I don't have a better suggestion off the top of my head and I'm happy
for you to leave it, I just wanted to flag it as a possible way we could
be clearer.

> +
> +static inline void init_temp_mm(struct temp_mm *temp_mm, struct mm_struct *mm)
> +{
> +	temp_mm->temp = mm;
> +	temp_mm->prev = NULL;
> +	temp_mm->is_kernel_thread = false;
> +	memset(&temp_mm->brk, 0, sizeof(temp_mm->brk));
> +}
> +
> +static inline void use_temporary_mm(struct temp_mm *temp_mm)
> +{
> +	lockdep_assert_irqs_disabled();
> +
> +	temp_mm->is_kernel_thread = current->mm == NULL;
> +	if (temp_mm->is_kernel_thread)
> +		temp_mm->prev = current->active_mm;

You don't seem to restore active_mm below. I don't know what active_mm
does, so I don't know if this is a problem.

> +	else
> +		temp_mm->prev = current->mm;
> +
> +	/*
> +	 * Hash requires a non-NULL current->mm to allocate a userspace address
> +	 * when handling a page fault. Does not appear to hurt in Radix either.
> +	 */
> +	current->mm = temp_mm->temp;
> +	switch_mm_irqs_off(NULL, temp_mm->temp, current);
> +
> +	if (ppc_breakpoint_available()) {

I wondered if this could be changed during a text-patching operation.
AIUI, it potentially can on a P9 via "dawr_enable_dangerous" in debugfs.

I don't know if that's a problem. My concern is that you could turn off
breakpoints, call 'use_temporary_mm', then turn them back on again
before 'unuse_temporary_mm' and get a breakpoint while that can access
the temporary mm. Is there something else that makes that safe?
disabling IRQs maybe?

> +		struct arch_hw_breakpoint null_brk = {0};
> +		int i = 0;
> +
> +		for (; i < nr_wp_slots(); ++i) {

super nitpicky, and I'm not sure if this is actually documented, but I'd
usually see this written as:

for (i = 0; i < nr_wp_slots(); i++) {

Not sure if there's any reason that it _shouldn't_ be written the way
you've written it (and I do like initialising the variable when it's
defined!), I'm just not used to it. (Likewise with the unuse function.)

> +			__get_breakpoint(i, &temp_mm->brk[i]);
> +			if (temp_mm->brk[i].type != 0)
> +				__set_breakpoint(i, &null_brk);
> +		}
> +	}
> +}
> +

Kind regards,
Daniel

> +static inline void unuse_temporary_mm(struct temp_mm *temp_mm)
> +{
> +	lockdep_assert_irqs_disabled();
> +
> +	if (temp_mm->is_kernel_thread)
> +		current->mm = NULL;
> +	else
> +		current->mm = temp_mm->prev;
> +	switch_mm_irqs_off(NULL, temp_mm->prev, current);
> +
> +	if (ppc_breakpoint_available()) {
> +		int i = 0;
> +
> +		for (; i < nr_wp_slots(); ++i)
> +			if (temp_mm->brk[i].type != 0)
> +				__set_breakpoint(i, &temp_mm->brk[i]);
> +	}
> +}
> +
>  #endif /* __KERNEL__ */
>  #endif /* __ASM_POWERPC_MMU_CONTEXT_H */
> diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
> index 4650b9bb217f..b6c123bf5edd 100644
> --- a/arch/powerpc/kernel/process.c
> +++ b/arch/powerpc/kernel/process.c
> @@ -824,6 +824,11 @@ static inline int set_breakpoint_8xx(struct arch_hw_breakpoint *brk)
>  	return 0;
>  }
>  
> +void __get_breakpoint(int nr, struct arch_hw_breakpoint *brk)
> +{
> +	memcpy(brk, this_cpu_ptr(&current_brk[nr]), sizeof(*brk));
> +}
> +
>  void __set_breakpoint(int nr, struct arch_hw_breakpoint *brk)
>  {
>  	memcpy(this_cpu_ptr(&current_brk[nr]), brk, sizeof(*brk));
> -- 
> 2.27.0
