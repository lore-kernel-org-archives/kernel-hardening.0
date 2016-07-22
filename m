Reply-To: kernel-hardening@lists.openwall.com
From: Mike Krinkin <krinkin.m.u@gmail.com>
Date: Fri, 22 Jul 2016 13:18:40 +0300
Message-Id: <1469182720-6207-1-git-send-email-krinkin.m.u@gmail.com>
In-Reply-To: <4b028b92-81f3-362f-c5be-b7a35cedf5ee@kernel.org>
References: <4b028b92-81f3-362f-c5be-b7a35cedf5ee@kernel.org>
Subject: Re: [kernel-hardening] [PATCH v5 03/32] x86/cpa: In populate_pgd, don't set the pgd entry until it's populated
To: luto@kernel.org, Valdis.Kletnieks@vt.edu, kernel-hardening@lists.openwall.com
Cc: linux-arch@vger.kernel.org, bp@alien8.de, nadav.amit@gmail.com, keescook@chromium.org, brgerst@gmail.com, torvalds@linux-foundation.org, jpoimboe@redhat.com, jann@thejh.net, heiko.carstens@de.ibm.com, Mike Krinkin <krinkin.m.u@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi, the patch solves problem for me, but i have one question below

> --Andy
> From 6589ddf69a1369e1ecb95f0af489d90b980e256e Mon Sep 17 00:00:00 2001
> Message-Id: <6589ddf69a1369e1ecb95f0af489d90b980e256e.1469165371.git.luto@kernel.org>
> From: Andy Lutomirski <luto@kernel.org>
> Date: Thu, 21 Jul 2016 22:22:02 -0700
> Subject: [PATCH] x86/mm: Fix populate_pgd()
> 
> I make an obvious error in populate_pgd() -- it would fail to correctly
> populate the page tables when it allocated a new pud page.
> 
> Fixes: 360cb4d15567 ("x86/mm/cpa: In populate_pgd(), don't set the PGD entry until it's populated")
> Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  arch/x86/mm/pageattr.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 26c93c6e04a0..5ee7d1c794a4 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -984,8 +984,8 @@ static int populate_pmd(struct cpa_data *cpa,
>  	return num_pages;
>  }
>  
> -static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
> -			pgprot_t pgprot)
> +static int populate_pud(struct cpa_data *cpa, unsigned long start,
> +			pud_t *pud_page, pgprot_t pgprot)
>  {
>  	pud_t *pud;
>  	unsigned long end;
> @@ -1006,7 +1006,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
>  		cur_pages = (pre_end - start) >> PAGE_SHIFT;
>  		cur_pages = min_t(int, (int)cpa->numpages, cur_pages);
>  
> -		pud = pud_offset(pgd, start);
> +		pud = pud_page + pud_index(start);
>  
>  		/*
>  		 * Need a PMD page?
> @@ -1027,7 +1027,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
>  	if (cpa->numpages == cur_pages)
>  		return cur_pages;
>  
> -	pud = pud_offset(pgd, start);
> +	pud = pud_page + pud_index(start);
>  	pud_pgprot = pgprot_4k_2_large(pgprot);
>  
>  	/*
> @@ -1047,7 +1047,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
>  	if (start < end) {
>  		int tmp;
>  
> -		pud = pud_offset(pgd, start);
> +		pud = pud_page + pud_index(start);
>  		if (pud_none(*pud))
>  			if (alloc_pmd_page(pud))
>  				return -1;
> @@ -1069,7 +1069,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
>  static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
>  {
>  	pgprot_t pgprot = __pgprot(_KERNPG_TABLE);
> -	pud_t *pud = NULL;	/* shut up gcc */
> +	pud_t *pud_page = NULL;	/* shut up gcc */
>  	pgd_t *pgd_entry;
>  	int ret;
>  
> @@ -1079,25 +1079,27 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
>  	 * Allocate a PUD page and hand it down for mapping.
>  	 */
>  	if (pgd_none(*pgd_entry)) {
> -		pud = (pud_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
> -		if (!pud)
> +		pud_page = (pud_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
> +		if (!pud_page)
>  			return -1;
>  	}
>  
>  	pgprot_val(pgprot) &= ~pgprot_val(cpa->mask_clr);
>  	pgprot_val(pgprot) |=  pgprot_val(cpa->mask_set);
>  
> -	ret = populate_pud(cpa, addr, pgd_entry, pgprot);
> +	ret = populate_pud(cpa, addr,
> +			   pud_page ?: (pud_t *)pgd_page_vaddr(*pgd_entry),
> +			   pgprot);
>  	if (ret < 0) {
> -		if (pud)
> -			free_page((unsigned long)pud);
> +		if (pud_page)
> +			free_page((unsigned long)pud_page);
>  		unmap_pud_range(pgd_entry, addr,
>  				addr + (cpa->numpages << PAGE_SHIFT));

is it safe to call unmap_pud_range on pgd_entry if it's empty (pgd_none returned true)?

>  		return ret;
>  	}
>  
> -	if (pud)
> -		set_pgd(pgd_entry, __pgd(__pa(pud) | _KERNPG_TABLE));
> +	if (pud_page)
> +		set_pgd(pgd_entry, __pgd(__pa(pud_page) | _KERNPG_TABLE));
>  
>  	cpa->numpages = ret;
>  	return 0;
> -- 
> 2.7.4
