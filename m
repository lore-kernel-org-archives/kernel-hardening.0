Return-Path: <SRS0=p/8z=7Q=lists.openwall.com=kernel-hardening-return-18915-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D7DC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed,  3 Jun 2020 10:38:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DFF3920679
	for <kernel-hardening@archiver.kernel.org>; Wed,  3 Jun 2020 10:38:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFF3920679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=csgroup.eu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18915-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19814 invoked by uid 550); 3 Jun 2020 10:38:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29875 invoked from network); 3 Jun 2020 07:01:23 -0000
X-Virus-Scanned: Debian amavisd-new at c-s.fr
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH 2/5] powerpc/lib: Initialize a temporary mm for code
 patching
To: "Christopher M. Riedl" <cmr@informatik.wtf>,
 linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com
References: <20200603051912.23296-1-cmr@informatik.wtf>
 <20200603051912.23296-3-cmr@informatik.wtf>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <4ffced42-ee3a-841f-2d3f-34daec11b05b@csgroup.eu>
Date: Wed, 3 Jun 2020 09:01:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200603051912.23296-3-cmr@informatik.wtf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 03/06/2020 à 07:19, Christopher M. Riedl a écrit :
> When code patching a STRICT_KERNEL_RWX kernel the page containing the
> address to be patched is temporarily mapped with permissive memory
> protections. Currently, a per-cpu vmalloc patch area is used for this
> purpose. While the patch area is per-cpu, the temporary page mapping is
> inserted into the kernel page tables for the duration of the patching.
> The mapping is exposed to CPUs other than the patching CPU - this is
> undesirable from a hardening perspective.
> 
> Use the `poking_init` init hook to prepare a temporary mm and patching
> address. Initialize the temporary mm by copying the init mm. Choose a
> randomized patching address inside the temporary mm userspace address
> portion. The next patch uses the temporary mm and patching address for
> code patching.
> 
> Based on x86 implementation:
> 
> commit 4fc19708b165
> ("x86/alternatives: Initialize temporary mm for patching")
> 
> Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
> ---
>   arch/powerpc/lib/code-patching.c | 33 ++++++++++++++++++++++++++++++++
>   1 file changed, 33 insertions(+)
> 
> diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
> index 5ecf0d635a8d..599114f63b44 100644
> --- a/arch/powerpc/lib/code-patching.c
> +++ b/arch/powerpc/lib/code-patching.c
> @@ -11,6 +11,8 @@
>   #include <linux/cpuhotplug.h>
>   #include <linux/slab.h>
>   #include <linux/uaccess.h>
> +#include <linux/sched/task.h>
> +#include <linux/random.h>
>   
>   #include <asm/pgtable.h>
>   #include <asm/tlbflush.h>
> @@ -45,6 +47,37 @@ int raw_patch_instruction(struct ppc_inst *addr, struct ppc_inst instr)
>   }
>   
>   #ifdef CONFIG_STRICT_KERNEL_RWX
> +
> +static struct mm_struct *patching_mm __ro_after_init;
> +static unsigned long patching_addr __ro_after_init;
> +
> +void __init poking_init(void)
> +{
> +	spinlock_t *ptl; /* for protecting pte table */
> +	pte_t *ptep;
> +
> +	/*
> +	 * Some parts of the kernel (static keys for example) depend on
> +	 * successful code patching. Code patching under STRICT_KERNEL_RWX
> +	 * requires this setup - otherwise we cannot patch at all. We use
> +	 * BUG_ON() here and later since an early failure is preferred to
> +	 * buggy behavior and/or strange crashes later.
> +	 */
> +	patching_mm = copy_init_mm();
> +	BUG_ON(!patching_mm);
> +
> +	/*
> +	 * In hash we cannot go above DEFAULT_MAP_WINDOW easily.
> +	 * XXX: Do we want additional bits of entropy for radix?
> +	 */
> +	patching_addr = (get_random_long() & PAGE_MASK) %
> +		(DEFAULT_MAP_WINDOW - PAGE_SIZE);
> +
> +	ptep = get_locked_pte(patching_mm, patching_addr, &ptl);
> +	BUG_ON(!ptep);
> +	pte_unmap_unlock(ptep, ptl);

Is this needed ? What's the point in getting the pte to unmap it 
immediatly without doing anything with it ?

Christophe

> +}
> +
>   static DEFINE_PER_CPU(struct vm_struct *, text_poke_area);
>   
>   static int text_area_cpu_up(unsigned int cpu)
> 
