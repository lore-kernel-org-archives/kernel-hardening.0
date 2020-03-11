Return-Path: <SRS0=pOcg=44=lists.openwall.com=kernel-hardening-return-18121-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB575C10F25
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Mar 2020 06:04:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1F50D208C4
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Mar 2020 06:04:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="TTk96AoC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F50D208C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18121-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1512 invoked by uid 550); 11 Mar 2020 06:03:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1480 invoked from network); 11 Mar 2020 06:03:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=z8609wnYeWM4sQs0oWODebpUweUOgM1KYQF7Uwz5+vI=;
        b=TTk96AoCDK6lTwmIwZ4oCfX2igI5LUohyL86QuLe143nSMzxX+4nSFmPWoEyslljR9
         U+TSVIvp1Wy4GmqSMKP89TU0/V9g6AflTCwCdV6zEgskUbRWL0O3mHq9wiKE3mUOihAN
         bGBy76nHD9rqzaYASuCE/DkiLnPDumm6CeXiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=z8609wnYeWM4sQs0oWODebpUweUOgM1KYQF7Uwz5+vI=;
        b=JTadXShAVS6bx9yRfx85piXDnOgn1REgHSw1hvVRDIUJHP2UzB1P9CcGE87yS14fT3
         v51XgvuvY2OYSn7EhkDvvyLsPPA8TqTlsY83a5568AKlxe0939nUHKn/D7ecyfEeI0WC
         3eztUEJNj44w2xArhA+KOpx7L5/FZ5UtDgaOzIxYv8KPy/qPLhEMN9MjBf1KjnWIKuPE
         +DnXbBdRHtbl42zrv5aviqhXGWtym+P+/ad5/TGJBc4vBjss9dHHIvoSmeHWm1oGoNwv
         YFyi/6/1Ej227RViN3mTnjJZi+Why3zHSXUDjR95VtqHKcsgmTzFf9I42EuO/t8Rlbd2
         JW/Q==
X-Gm-Message-State: ANhLgQ2bxOj10pfNHWzT1eQ4Uedh3YI2NxWOvt5KbPlFci267sm5Vt22
	wIcglhrQsGMWyMJUqv1cBnfS1A==
X-Google-Smtp-Source: ADFU+vtg3jbcIVzZD3g1wFbmGSMoSJ7n6V1O7TzNEnL65b6AC/9l6n1n5U9ubMLhpS80zmw/PimItw==
X-Received: by 2002:a17:90a:37c6:: with SMTP id v64mr1811528pjb.20.1583906626109;
        Tue, 10 Mar 2020 23:03:46 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>, christophe.leroy@c-s.fr, joel@jms.id.au, mpe@ellerman.id.au, ajd@linux.ibm.com, npiggin@gmail.com, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 1/7] powerpc/mm: Implement set_memory() routines
In-Reply-To: <20200310010338.21205-2-ruscur@russell.cc>
References: <20200310010338.21205-1-ruscur@russell.cc> <20200310010338.21205-2-ruscur@russell.cc>
Date: Wed, 11 Mar 2020 17:03:41 +1100
Message-ID: <87imjbpgw2.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain

Russell Currey <ruscur@russell.cc> writes:

> The set_memory_{ro/rw/nx/x}() functions are required for STRICT_MODULE_RWX,
> and are generally useful primitives to have.  This implementation is
> designed to be completely generic across powerpc's many MMUs.
>
> It's possible that this could be optimised to be faster for specific
> MMUs, but the focus is on having a generic and safe implementation for
> now.
>
> This implementation does not handle cases where the caller is attempting
> to change the mapping of the page it is executing from, or if another
> CPU is concurrently using the page being altered.  These cases likely
> shouldn't happen, but a more complex implementation with MMU-specific code
> could safely handle them, so that is left as a TODO for now.
>
> These functions do nothing if STRICT_KERNEL_RWX is not enabled.
>
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> ---
> v6: Merge patch 8/8 from v5, handling RWX not being enabled.
>     Add note to change_page_attr() in case it's ever made non-static
> ---
>  arch/powerpc/Kconfig                  |  1 +
>  arch/powerpc/include/asm/set_memory.h | 32 +++++++++++
>  arch/powerpc/mm/Makefile              |  2 +-
>  arch/powerpc/mm/pageattr.c            | 79 +++++++++++++++++++++++++++
>  4 files changed, 113 insertions(+), 1 deletion(-)
>  create mode 100644 arch/powerpc/include/asm/set_memory.h
>  create mode 100644 arch/powerpc/mm/pageattr.c
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 497b7d0b2d7e..bd074246e34e 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -129,6 +129,7 @@ config PPC
>  	select ARCH_HAS_PTE_SPECIAL
>  	select ARCH_HAS_MEMBARRIER_CALLBACKS
>  	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
> +	select ARCH_HAS_SET_MEMORY
>  	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !HIBERNATION)
>  	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
>  	select ARCH_HAS_UACCESS_FLUSHCACHE
> diff --git a/arch/powerpc/include/asm/set_memory.h b/arch/powerpc/include/asm/set_memory.h
> new file mode 100644
> index 000000000000..64011ea444b4
> --- /dev/null
> +++ b/arch/powerpc/include/asm/set_memory.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_POWERPC_SET_MEMORY_H
> +#define _ASM_POWERPC_SET_MEMORY_H
> +
> +#define SET_MEMORY_RO	0
> +#define SET_MEMORY_RW	1
> +#define SET_MEMORY_NX	2
> +#define SET_MEMORY_X	3
> +
> +int change_memory_attr(unsigned long addr, int numpages, long action);
> +
> +static inline int set_memory_ro(unsigned long addr, int numpages)
> +{
> +	return change_memory_attr(addr, numpages, SET_MEMORY_RO);
> +}
> +
> +static inline int set_memory_rw(unsigned long addr, int numpages)
> +{
> +	return change_memory_attr(addr, numpages, SET_MEMORY_RW);
> +}
> +
> +static inline int set_memory_nx(unsigned long addr, int numpages)
> +{
> +	return change_memory_attr(addr, numpages, SET_MEMORY_NX);
> +}
> +
> +static inline int set_memory_x(unsigned long addr, int numpages)
> +{
> +	return change_memory_attr(addr, numpages, SET_MEMORY_X);
> +}
> +
> +#endif
> diff --git a/arch/powerpc/mm/Makefile b/arch/powerpc/mm/Makefile
> index 5e147986400d..a998fdac52f9 100644
> --- a/arch/powerpc/mm/Makefile
> +++ b/arch/powerpc/mm/Makefile
> @@ -5,7 +5,7 @@
>  
>  ccflags-$(CONFIG_PPC64)	:= $(NO_MINIMAL_TOC)
>  
> -obj-y				:= fault.o mem.o pgtable.o mmap.o \
> +obj-y				:= fault.o mem.o pgtable.o mmap.o pageattr.o \
>  				   init_$(BITS).o pgtable_$(BITS).o \
>  				   pgtable-frag.o ioremap.o ioremap_$(BITS).o \
>  				   init-common.o mmu_context.o drmem.o
> diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
> new file mode 100644
> index 000000000000..748fa56d9db0
> --- /dev/null
> +++ b/arch/powerpc/mm/pageattr.c
> @@ -0,0 +1,79 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * MMU-generic set_memory implementation for powerpc
> + *
> + * Copyright 2019, IBM Corporation.
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/set_memory.h>
> +
> +#include <asm/mmu.h>
> +#include <asm/page.h>
> +#include <asm/pgtable.h>
> +
> +
> +/*
> + * Updates the attributes of a page in three steps:
> + *
> + * 1. invalidate the page table entry
> + * 2. flush the TLB
> + * 3. install the new entry with the updated attributes
> + *
> + * This is unsafe if the caller is attempting to change the mapping of the
> + * page it is executing from, or if another CPU is concurrently using the
> + * page being altered.
> + *
> + * TODO make the implementation resistant to this.
> + *
> + * NOTE: can be dangerous to call without STRICT_KERNEL_RWX
> + */
> +static int change_page_attr(pte_t *ptep, unsigned long addr, void *data)
> +{
> +	long action = (long)data;
> +	pte_t pte;
> +
> +	spin_lock(&init_mm.page_table_lock);
> +
> +	/* invalidate the PTE so it's safe to modify */
> +	pte = ptep_get_and_clear(&init_mm, addr, ptep);
> +	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
> +
> +	/* modify the PTE bits as desired, then apply */
> +	switch (action) {
> +	case SET_MEMORY_RO:
> +		pte = pte_wrprotect(pte);
> +		break;
> +	case SET_MEMORY_RW:
> +		pte = pte_mkwrite(pte);
> +		break;
> +	case SET_MEMORY_NX:
> +		pte = pte_exprotect(pte);
> +		break;
> +	case SET_MEMORY_X:
> +		pte = pte_mkexec(pte);
> +		break;
> +	default:
> +		break;

Should this have a WARN_ON_ONCE to let you know you're doing something
that doesn't work? I know it's only ever called by things in this file,
but still... Anyway it's very minor and I'm not fussed either way.

> +	}
> +
> +	set_pte_at(&init_mm, addr, ptep, pte);
> +	spin_unlock(&init_mm.page_table_lock);

Initially I thought: shouldn't you put the PTL lock/unlock in the outer
function? Then I remembered that apply_to_page_range can potentially
allocate new page table entries which would deadlock if you held the
lock.

Speaking of which - apply_to_page_range will create new pte entries if
you apply it over an address range that isn't filled in. That doesn't
really make sense here - should you use apply_to_existing_page_range
instead?

You _might_ be able to move the PTL lock if you use
apply_to_existing_page_range but I'm not completely sure if that's safe
or if the speed boost is worth it. You could check mm/memory.c if you
wanted.

> +
> +	return 0;
> +}
> +
> +int change_memory_attr(unsigned long addr, int numpages, long action)
> +{
> +	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
> +	unsigned long sz = numpages * PAGE_SIZE;
> +
> +	if (!IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
> +		return 0;
> +
> +	if (!numpages)
> +		return 0;

What happens if numpages is negative? Doesn't the guard need to check
for that rather than just for zero?

With those caveats, and noting that I've been focused only on:
 - lock/unlock paths
 - integer arithmetic
 - stuff about apply_page_range semantics
this patch is:

Reviewed-by: Daniel Axtens <dja@axtens.net>

Regards,
Daniel

> +
> +	return apply_to_page_range(&init_mm, start, sz, change_page_attr, (void *)action);
> +}
> -- 
> 2.25.1
