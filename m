Return-Path: <SRS0=aFXX=VF=lists.openwall.com=kernel-hardening-return-16382-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TRACKER_ID autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA244C606C1
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 15:23:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F18CC204EC
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 15:23:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F18CC204EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16382-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19681 invoked by uid 550); 8 Jul 2019 15:22:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17819 invoked from network); 8 Jul 2019 14:54:29 -0000
X-Mailer: emacs 26.2 (via feedmail 11-beta-1 I)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2] powerpc/mm: Implement STRICT_MODULE_RWX
In-Reply-To: <20190614055013.21014-1-ruscur@russell.cc>
References: <20190614055013.21014-1-ruscur@russell.cc>
Date: Mon, 08 Jul 2019 20:24:08 +0530
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
x-cbid: 19070814-4275-0000-0000-0000034A3B3A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070814-4276-0000-0000-0000385A6307
Message-Id: <87y318wp9r.fsf@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080186

Russell Currey <ruscur@russell.cc> writes:

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
>  - return if VM_FLUSH_RESET_PERMS is set
>
>  arch/powerpc/Kconfig                  |  2 +
>  arch/powerpc/include/asm/set_memory.h | 32 ++++++++++
>  arch/powerpc/mm/Makefile              |  2 +-
>  arch/powerpc/mm/pageattr.c            | 85 +++++++++++++++++++++++++++
>  4 files changed, 120 insertions(+), 1 deletion(-)
>  create mode 100644 arch/powerpc/include/asm/set_memory.h
>  create mode 100644 arch/powerpc/mm/pageattr.c
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 8c1c636308c8..3d98240ce965 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -131,7 +131,9 @@ config PPC
>  	select ARCH_HAS_PTE_SPECIAL
>  	select ARCH_HAS_MEMBARRIER_CALLBACKS
>  	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC64
> +	select ARCH_HAS_SET_MEMORY
>  	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !RELOCATABLE && !HIBERNATION)
> +	select ARCH_HAS_STRICT_MODULE_RWX	if PPC_BOOK3S_64 || PPC32
>  	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
>  	select ARCH_HAS_UACCESS_FLUSHCACHE	if PPC64
>  	select ARCH_HAS_UBSAN_SANITIZE_ALL
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
>  obj-y				:= fault.o mem.o pgtable.o mmap.o \
>  				   init_$(BITS).o pgtable_$(BITS).o \
> -				   pgtable-frag.o \
> +				   pgtable-frag.o pageattr.o \
>  				   init-common.o mmu_context.o drmem.o
>  obj-$(CONFIG_PPC_MMU_NOHASH)	+= nohash/
>  obj-$(CONFIG_PPC_BOOK3S_32)	+= book3s32/
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

We can't use set_pte_at when updating a valid pte entry. This should have
triggered 

	/*
	 * Make sure hardware valid bit is not set. We don't do
	 * tlb flush for this update.
	 */
	VM_WARN_ON(pte_hw_valid(*ptep) && !pte_protnone(*ptep));

The details are explained as part of

56eecdb912b536a4fa97fb5bfe5a940a54d79be6

-aneesh

