Reply-To: kernel-hardening@lists.openwall.com
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Tue, 02 Aug 2016 02:36:25 +0200
Message-ID: <2005875.PA9bTzjxie@vostro.rjw.lan>
In-Reply-To: <1470071280-78706-2-git-send-email-thgarnie@google.com>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com> <1470071280-78706-2-git-send-email-thgarnie@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Subject: [kernel-hardening] Re: [PATCH v1 1/2] x86/power/64: Support unaligned addresses for temporary mapping
To: Thomas Garnier <thgarnie@google.com>, Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Pavel Machek <pavel@ucw.cz>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Monday, August 01, 2016 10:07:59 AM Thomas Garnier wrote:
> Correctly setup the temporary mapping for hibernation. Previous
> implementation assumed the address was aligned on the PGD level. With
> KASLR memory randomization enabled, the address is randomized on the PUD
> level. This change supports unaligned address up to PMD.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

This code is shared with kexec AFAICS, so it likely is better to push it
through tip rather than through the PM tree.

> ---
>  arch/x86/mm/ident_map.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/mm/ident_map.c b/arch/x86/mm/ident_map.c
> index ec21796..ea1ebf1 100644
> --- a/arch/x86/mm/ident_map.c
> +++ b/arch/x86/mm/ident_map.c
> @@ -3,15 +3,16 @@
>   * included by both the compressed kernel and the regular kernel.
>   */
>  
> -static void ident_pmd_init(unsigned long pmd_flag, pmd_t *pmd_page,
> +static void ident_pmd_init(struct x86_mapping_info *info, pmd_t *pmd_page,
>  			   unsigned long addr, unsigned long end)
>  {
> -	addr &= PMD_MASK;
> -	for (; addr < end; addr += PMD_SIZE) {
> -		pmd_t *pmd = pmd_page + pmd_index(addr);
> +	int off = info->kernel_mapping ? pmd_index(__PAGE_OFFSET) : 0;
> +
> +	for (addr &= PMD_MASK; addr < end; addr += PMD_SIZE) {
> +		pmd_t *pmd = pmd_page + pmd_index(addr) + off;
>  
>  		if (!pmd_present(*pmd))
> -			set_pmd(pmd, __pmd(addr | pmd_flag));
> +			set_pmd(pmd, __pmd(addr | info->pmd_flag));
>  	}
>  }
>  
> @@ -19,9 +20,10 @@ static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
>  			  unsigned long addr, unsigned long end)
>  {
>  	unsigned long next;
> +	int off = info->kernel_mapping ? pud_index(__PAGE_OFFSET) : 0;
>  
>  	for (; addr < end; addr = next) {
> -		pud_t *pud = pud_page + pud_index(addr);
> +		pud_t *pud = pud_page + pud_index(addr) + off;
>  		pmd_t *pmd;
>  
>  		next = (addr & PUD_MASK) + PUD_SIZE;
> @@ -30,13 +32,13 @@ static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
>  
>  		if (pud_present(*pud)) {
>  			pmd = pmd_offset(pud, 0);
> -			ident_pmd_init(info->pmd_flag, pmd, addr, next);
> +			ident_pmd_init(info, pmd, addr, next);
>  			continue;
>  		}
>  		pmd = (pmd_t *)info->alloc_pgt_page(info->context);
>  		if (!pmd)
>  			return -ENOMEM;
> -		ident_pmd_init(info->pmd_flag, pmd, addr, next);
> +		ident_pmd_init(info, pmd, addr, next);
>  		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
>  	}
>  
> 
