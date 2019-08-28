Return-Path: <SRS0=cyFB=WY=lists.openwall.com=kernel-hardening-return-16813-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D636FC3A5A1
	for <kernel-hardening@archiver.kernel.org>; Wed, 28 Aug 2019 13:54:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E00CD22CED
	for <kernel-hardening@archiver.kernel.org>; Wed, 28 Aug 2019 13:54:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="ZQWMq8Ck"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E00CD22CED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16813-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24077 invoked by uid 550); 28 Aug 2019 13:54:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24045 invoked from network); 28 Aug 2019 13:54:36 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=ZQWMq8Ck; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1567000463; bh=evGdDhmtcmpDnSsk3iceD1vmrWqXPGo+SIfjTrzR0kU=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=ZQWMq8Ck/WAqYTiDY444GgfjNhOdOAdeFIUH8PVZqCCmXdA1CpzJV2htjUdYfKObO
	 GMFVNBDqMIolPq2H7T4eJWKyYRhTfYYtqsRo1HGaH/Ay6SyqGpGqjykLf7Y9wUomMt
	 Eu60nO5DW39QHF45ZjbWkaZGxSMQx41tWaRFg60Y=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v2] powerpc/mm: Implement STRICT_MODULE_RWX
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: kernel-hardening@lists.openwall.com
References: <20190614055013.21014-1-ruscur@russell.cc>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <6bf5e5e3-1dfe-05fe-d736-7c846b8ac6f6@c-s.fr>
Date: Wed, 28 Aug 2019 15:54:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190614055013.21014-1-ruscur@russell.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit

Any plan to getting this applied soon ?

Christophe

Le 14/06/2019 à 07:50, Russell Currey a écrit :
> Strict module RWX is just like strict kernel RWX, but for modules - so
> loadable modules aren't marked both writable and executable at the same
> time.  This is handled by the generic code in kernel/module.c, and
> simply requires the architecture to implement the set_memory() set of
> functions, declared with ARCH_HAS_SET_MEMORY.
> 
> There's nothing other than these functions required to turn
> ARCH_HAS_STRICT_MODULE_RWX on, so turn that on too.
> 
> With STRICT_MODULE_RWX enabled, there are as many W+X pages at runtime
> as there are with CONFIG_MODULES=n (none), so in Russel's testing it works
> well on both Hash and Radix book3s64.
> 
> There's a TODO in the code for also applying the page permission changes
> to the backing pages in the linear mapping: this is pretty simple for
> Radix and (seemingly) a lot harder for Hash, so I've left it for now
> since there's still a notable security benefit for the patch as-is.
> 
> Technically can be enabled without STRICT_KERNEL_RWX, but
> that doesn't gets you a whole lot, so we should leave it off by default
> until we can get STRICT_KERNEL_RWX to the point where it's enabled by
> default.
> 
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> ---
> Changes from v1 (sent by Christophe):
>   - return if VM_FLUSH_RESET_PERMS is set
> 
>   arch/powerpc/Kconfig                  |  2 +
>   arch/powerpc/include/asm/set_memory.h | 32 ++++++++++
>   arch/powerpc/mm/Makefile              |  2 +-
>   arch/powerpc/mm/pageattr.c            | 85 +++++++++++++++++++++++++++
>   4 files changed, 120 insertions(+), 1 deletion(-)
>   create mode 100644 arch/powerpc/include/asm/set_memory.h
>   create mode 100644 arch/powerpc/mm/pageattr.c
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 8c1c636308c8..3d98240ce965 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -131,7 +131,9 @@ config PPC
>   	select ARCH_HAS_PTE_SPECIAL
>   	select ARCH_HAS_MEMBARRIER_CALLBACKS
>   	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC64
> +	select ARCH_HAS_SET_MEMORY
>   	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !RELOCATABLE && !HIBERNATION)
> +	select ARCH_HAS_STRICT_MODULE_RWX	if PPC_BOOK3S_64 || PPC32
>   	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
>   	select ARCH_HAS_UACCESS_FLUSHCACHE	if PPC64
>   	select ARCH_HAS_UBSAN_SANITIZE_ALL
> diff --git a/arch/powerpc/include/asm/set_memory.h b/arch/powerpc/include/asm/set_memory.h
> new file mode 100644
> index 000000000000..4b9683f3b3dd
> --- /dev/null
> +++ b/arch/powerpc/include/asm/set_memory.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +#ifndef _ASM_POWERPC_SET_MEMORY_H
> +#define _ASM_POWERPC_SET_MEMORY_H
> +
> +#define SET_MEMORY_RO	1
> +#define SET_MEMORY_RW	2
> +#define SET_MEMORY_NX	3
> +#define SET_MEMORY_X	4
> +
> +int change_memory(unsigned long addr, int numpages, int action);
> +
> +static inline int set_memory_ro(unsigned long addr, int numpages)
> +{
> +	return change_memory(addr, numpages, SET_MEMORY_RO);
> +}
> +
> +static inline int set_memory_rw(unsigned long addr, int numpages)
> +{
> +	return change_memory(addr, numpages, SET_MEMORY_RW);
> +}
> +
> +static inline int set_memory_nx(unsigned long addr, int numpages)
> +{
> +	return change_memory(addr, numpages, SET_MEMORY_NX);
> +}
> +
> +static inline int set_memory_x(unsigned long addr, int numpages)
> +{
> +	return change_memory(addr, numpages, SET_MEMORY_X);
> +}
> +
> +#endif
> diff --git a/arch/powerpc/mm/Makefile b/arch/powerpc/mm/Makefile
> index 0f499db315d6..b683d1c311b3 100644
> --- a/arch/powerpc/mm/Makefile
> +++ b/arch/powerpc/mm/Makefile
> @@ -7,7 +7,7 @@ ccflags-$(CONFIG_PPC64)	:= $(NO_MINIMAL_TOC)
>   
>   obj-y				:= fault.o mem.o pgtable.o mmap.o \
>   				   init_$(BITS).o pgtable_$(BITS).o \
> -				   pgtable-frag.o \
> +				   pgtable-frag.o pageattr.o \
>   				   init-common.o mmu_context.o drmem.o
>   obj-$(CONFIG_PPC_MMU_NOHASH)	+= nohash/
>   obj-$(CONFIG_PPC_BOOK3S_32)	+= book3s32/
> diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
> new file mode 100644
> index 000000000000..41baf92f632b
> --- /dev/null
> +++ b/arch/powerpc/mm/pageattr.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +
> +/*
> + * Page attribute and set_memory routines
> + *
> + * Derived from the arm64 implementation.
> + *
> + * Author: Russell Currey <ruscur@russell.cc>
> + *
> + * Copyright 2019, IBM Corporation.
> + *
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/set_memory.h>
> +#include <linux/vmalloc.h>
> +
> +#include <asm/mmu.h>
> +#include <asm/page.h>
> +#include <asm/pgtable.h>
> +
> +static int change_page_ro(pte_t *ptep, pgtable_t token, unsigned long addr, void *data)
> +{
> +	set_pte_at(&init_mm, addr, ptep, pte_wrprotect(READ_ONCE(*ptep)));
> +	return 0;
> +}
> +
> +static int change_page_rw(pte_t *ptep, pgtable_t token, unsigned long addr, void *data)
> +{
> +	set_pte_at(&init_mm, addr, ptep, pte_mkwrite(READ_ONCE(*ptep)));
> +	return 0;
> +}
> +
> +static int change_page_nx(pte_t *ptep, pgtable_t token, unsigned long addr, void *data)
> +{
> +	set_pte_at(&init_mm, addr, ptep, pte_exprotect(READ_ONCE(*ptep)));
> +	return 0;
> +}
> +
> +static int change_page_x(pte_t *ptep, pgtable_t token, unsigned long addr, void *data)
> +{
> +	set_pte_at(&init_mm, addr, ptep, pte_mkexec(READ_ONCE(*ptep)));
> +	return 0;
> +}
> +
> +int change_memory(unsigned long addr, int numpages, int action)
> +{
> +	unsigned long size = numpages * PAGE_SIZE;
> +	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
> +	unsigned long end = start + size;
> +	struct vm_struct *area;
> +	int ret;
> +
> +	if (!numpages)
> +		return 0;
> +
> +	// only operate on VM areas for now
> +	area = find_vm_area((void *)addr);
> +	if (!area || end > (unsigned long)area->addr + area->size ||
> +	    !(area->flags & VM_ALLOC) || (area->flags & VM_FLUSH_RESET_PERMS))
> +		return -EINVAL;
> +
> +	// TODO: also apply change to the backing pages in the linear mapping
> +
> +	switch (action) {
> +	case SET_MEMORY_RO:
> +		ret = apply_to_page_range(&init_mm, start, size, change_page_ro, NULL);
> +		break;
> +	case SET_MEMORY_RW:
> +		ret = apply_to_page_range(&init_mm, start, size, change_page_rw, NULL);
> +		break;
> +	case SET_MEMORY_NX:
> +		ret = apply_to_page_range(&init_mm, start, size, change_page_nx, NULL);
> +		break;
> +	case SET_MEMORY_X:
> +		ret = apply_to_page_range(&init_mm, start, size, change_page_x, NULL);
> +		break;
> +	default:
> +		WARN_ON(true);
> +		return -EINVAL;
> +	}
> +
> +	flush_tlb_kernel_range(start, end);
> +	return ret;
> +}
> 
