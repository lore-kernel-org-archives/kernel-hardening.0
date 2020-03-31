Return-Path: <SRS0=13Az=5Q=lists.openwall.com=kernel-hardening-return-18322-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C71C43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 09:56:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C5684207FF
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 09:56:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="AKb3dfTd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5684207FF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18322-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32627 invoked by uid 550); 31 Mar 2020 09:56:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32595 invoked from network); 31 Mar 2020 09:56:37 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=AKb3dfTd; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1585648584; bh=ksiUjkzPuWXMi/v1gCBPZyWOve3E6DsSOUfx5uRsxpA=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=AKb3dfTd3Oaxv2vF/0fvmlykVblUYS8gNiouQ8N/m3Wp29vhj7Kv43czJcjCeGFCN
	 4GIgSYC/trP2iCruuearrtAOp/gOVEdXVxvzfVI9+rdZEkg4zhG8pctMSqYZHyEmsH
	 GtsUTK8CJRuKrcCsoApBvGz50k0o2WvW9FqhHxA0=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v7 7/7] powerpc/32: use set_memory_attr()
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, ajd@linux.ibm.com, dja@axtens.net, npiggin@gmail.com,
 kernel-hardening@lists.openwall.com
References: <20200331044825.591653-1-ruscur@russell.cc>
 <20200331044825.591653-8-ruscur@russell.cc>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <e61a1f88-1ad6-ca26-790b-f036faacb790@c-s.fr>
Date: Tue, 31 Mar 2020 11:56:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200331044825.591653-8-ruscur@russell.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 31/03/2020 à 06:48, Russell Currey a écrit :
> From: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> Use set_memory_attr() instead of the PPC32 specific change_page_attr()
> 
> change_page_attr() was checking that the address was not mapped by
> blocks and was handling highmem, but that's unneeded because the
> affected pages can't be in highmem and block mapping verification
> is already done by the callers.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> ---
>   arch/powerpc/mm/pgtable_32.c | 95 ++++--------------------------------
>   1 file changed, 10 insertions(+), 85 deletions(-)
> 
> diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
> index 5fb90edd865e..3d92eaf3ee2f 100644
> --- a/arch/powerpc/mm/pgtable_32.c
> +++ b/arch/powerpc/mm/pgtable_32.c
> @@ -23,6 +23,7 @@
>   #include <linux/highmem.h>
>   #include <linux/memblock.h>
>   #include <linux/slab.h>
> +#include <linux/set_memory.h>
>   
>   #include <asm/pgtable.h>
>   #include <asm/pgalloc.h>
> @@ -121,99 +122,20 @@ void __init mapin_ram(void)
>   	}
>   }
>   
> -/* Scan the real Linux page tables and return a PTE pointer for
> - * a virtual address in a context.
> - * Returns true (1) if PTE was found, zero otherwise.  The pointer to
> - * the PTE pointer is unmodified if PTE is not found.
> - */
> -static int
> -get_pteptr(struct mm_struct *mm, unsigned long addr, pte_t **ptep, pmd_t **pmdp)


This will conflict, get_pteptr() is gone now, see 
https://github.com/linuxppc/linux/commit/2efc7c085f05870eda6f29ac71eeb83f3bd54415

Christophe



> -{
> -        pgd_t	*pgd;
> -	pud_t	*pud;
> -        pmd_t	*pmd;
> -        pte_t	*pte;
> -        int     retval = 0;
> -
> -        pgd = pgd_offset(mm, addr & PAGE_MASK);
> -        if (pgd) {
> -		pud = pud_offset(pgd, addr & PAGE_MASK);
> -		if (pud && pud_present(*pud)) {
> -			pmd = pmd_offset(pud, addr & PAGE_MASK);
> -			if (pmd_present(*pmd)) {
> -				pte = pte_offset_map(pmd, addr & PAGE_MASK);
> -				if (pte) {
> -					retval = 1;
> -					*ptep = pte;
> -					if (pmdp)
> -						*pmdp = pmd;
> -					/* XXX caller needs to do pte_unmap, yuck */
> -				}
> -			}
> -		}
> -        }
> -        return(retval);
> -}
> -
> -static int __change_page_attr_noflush(struct page *page, pgprot_t prot)
> -{
> -	pte_t *kpte;
> -	pmd_t *kpmd;
> -	unsigned long address;
> -
> -	BUG_ON(PageHighMem(page));
> -	address = (unsigned long)page_address(page);
> -
> -	if (v_block_mapped(address))
> -		return 0;
> -	if (!get_pteptr(&init_mm, address, &kpte, &kpmd))
> -		return -EINVAL;
> -	__set_pte_at(&init_mm, address, kpte, mk_pte(page, prot), 0);
> -	pte_unmap(kpte);
> -
> -	return 0;
> -}
> -
> -/*
> - * Change the page attributes of an page in the linear mapping.
> - *
> - * THIS DOES NOTHING WITH BAT MAPPINGS, DEBUG USE ONLY
> - */
> -static int change_page_attr(struct page *page, int numpages, pgprot_t prot)
> -{
> -	int i, err = 0;
> -	unsigned long flags;
> -	struct page *start = page;
> -
> -	local_irq_save(flags);
> -	for (i = 0; i < numpages; i++, page++) {
> -		err = __change_page_attr_noflush(page, prot);
> -		if (err)
> -			break;
> -	}
> -	wmb();
> -	local_irq_restore(flags);
> -	flush_tlb_kernel_range((unsigned long)page_address(start),
> -			       (unsigned long)page_address(page));
> -	return err;
> -}
> -
>   void mark_initmem_nx(void)
>   {
> -	struct page *page = virt_to_page(_sinittext);
>   	unsigned long numpages = PFN_UP((unsigned long)_einittext) -
>   				 PFN_DOWN((unsigned long)_sinittext);
>   
>   	if (v_block_mapped((unsigned long)_stext + 1))
>   		mmu_mark_initmem_nx();
>   	else
> -		change_page_attr(page, numpages, PAGE_KERNEL);
> +		set_memory_attr((unsigned long)_sinittext, numpages, PAGE_KERNEL);
>   }
>   
>   #ifdef CONFIG_STRICT_KERNEL_RWX
>   void mark_rodata_ro(void)
>   {
> -	struct page *page;
>   	unsigned long numpages;
>   
>   	if (v_block_mapped((unsigned long)_sinittext)) {
> @@ -222,20 +144,18 @@ void mark_rodata_ro(void)
>   		return;
>   	}
>   
> -	page = virt_to_page(_stext);
>   	numpages = PFN_UP((unsigned long)_etext) -
>   		   PFN_DOWN((unsigned long)_stext);
>   
> -	change_page_attr(page, numpages, PAGE_KERNEL_ROX);
> +	set_memory_attr((unsigned long)_stext, numpages, PAGE_KERNEL_ROX);
>   	/*
>   	 * mark .rodata as read only. Use __init_begin rather than __end_rodata
>   	 * to cover NOTES and EXCEPTION_TABLE.
>   	 */
> -	page = virt_to_page(__start_rodata);
>   	numpages = PFN_UP((unsigned long)__init_begin) -
>   		   PFN_DOWN((unsigned long)__start_rodata);
>   
> -	change_page_attr(page, numpages, PAGE_KERNEL_RO);
> +	set_memory_attr((unsigned long)__start_rodata, numpages, PAGE_KERNEL_RO);
>   
>   	// mark_initmem_nx() should have already run by now
>   	ptdump_check_wx();
> @@ -245,9 +165,14 @@ void mark_rodata_ro(void)
>   #ifdef CONFIG_DEBUG_PAGEALLOC
>   void __kernel_map_pages(struct page *page, int numpages, int enable)
>   {
> +	unsigned long addr = (unsigned long)page_address(page);
> +
>   	if (PageHighMem(page))
>   		return;
>   
> -	change_page_attr(page, numpages, enable ? PAGE_KERNEL : __pgprot(0));
> +	if (enable)
> +		set_memory_attr(addr, numpages, PAGE_KERNEL);
> +	else
> +		set_memory_attr(addr, numpages, __pgprot(0));
>   }
>   #endif /* CONFIG_DEBUG_PAGEALLOC */
> 
