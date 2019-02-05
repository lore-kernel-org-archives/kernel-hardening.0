Date: Tue, 5 Feb 2019 10:58:53 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 06/20] x86/alternative: use temporary mm for text
 poking
Message-ID: <20190205095853.GJ21801@zn.tnic>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-7-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190129003422.9328-7-rick.p.edgecombe@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Nadav Amit <namit@vmware.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 28, 2019 at 04:34:08PM -0800, Rick Edgecombe wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> text_poke() can potentially compromise the security as it sets temporary

s/the //

> PTEs in the fixmap. These PTEs might be used to rewrite the kernel code
> from other cores accidentally or maliciously, if an attacker gains the
> ability to write onto kernel memory.

Eww, sneaky. That would be a really nasty attack.

> Moreover, since remote TLBs are not flushed after the temporary PTEs are
> removed, the time-window in which the code is writable is not limited if
> the fixmap PTEs - maliciously or accidentally - are cached in the TLB.
> To address these potential security hazards, we use a temporary mm for
> patching the code.
> 
> Finally, text_poke() is also not conservative enough when mapping pages,
> as it always tries to map 2 pages, even when a single one is sufficient.
> So try to be more conservative, and do not map more than needed.
> 
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/include/asm/fixmap.h |   2 -
>  arch/x86/kernel/alternative.c | 106 +++++++++++++++++++++++++++-------
>  arch/x86/xen/mmu_pv.c         |   2 -
>  3 files changed, 84 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
> index 50ba74a34a37..9da8cccdf3fb 100644
> --- a/arch/x86/include/asm/fixmap.h
> +++ b/arch/x86/include/asm/fixmap.h
> @@ -103,8 +103,6 @@ enum fixed_addresses {
>  #ifdef CONFIG_PARAVIRT
>  	FIX_PARAVIRT_BOOTMAP,
>  #endif
> -	FIX_TEXT_POKE1,	/* reserve 2 pages for text_poke() */
> -	FIX_TEXT_POKE0, /* first page is last, because allocation is backward */

Two fixmap slots less - good riddance. :)

>  #ifdef	CONFIG_X86_INTEL_MID
>  	FIX_LNW_VRTC,
>  #endif
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index ae05fbb50171..76d482a2b716 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -11,6 +11,7 @@
>  #include <linux/stop_machine.h>
>  #include <linux/slab.h>
>  #include <linux/kdebug.h>
> +#include <linux/mmu_context.h>
>  #include <asm/text-patching.h>
>  #include <asm/alternative.h>
>  #include <asm/sections.h>
> @@ -683,41 +684,102 @@ __ro_after_init unsigned long poking_addr;
>  
>  static void *__text_poke(void *addr, const void *opcode, size_t len)
>  {
> +	bool cross_page_boundary = offset_in_page(addr) + len > PAGE_SIZE;
> +	temporary_mm_state_t prev;
> +	struct page *pages[2] = {NULL};
>  	unsigned long flags;
> -	char *vaddr;
> -	struct page *pages[2];
> -	int i;
> +	pte_t pte, *ptep;
> +	spinlock_t *ptl;
> +	pgprot_t prot;
>  
>  	/*
> -	 * While boot memory allocator is runnig we cannot use struct
> -	 * pages as they are not yet initialized.
> +	 * While boot memory allocator is running we cannot use struct pages as
> +	 * they are not yet initialized.
>  	 */
>  	BUG_ON(!after_bootmem);
>  
>  	if (!core_kernel_text((unsigned long)addr)) {
>  		pages[0] = vmalloc_to_page(addr);
> -		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
> +		if (cross_page_boundary)
> +			pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
>  	} else {
>  		pages[0] = virt_to_page(addr);
>  		WARN_ON(!PageReserved(pages[0]));
> -		pages[1] = virt_to_page(addr + PAGE_SIZE);
> +		if (cross_page_boundary)
> +			pages[1] = virt_to_page(addr + PAGE_SIZE);
>  	}
> -	BUG_ON(!pages[0]);
> +	BUG_ON(!pages[0] || (cross_page_boundary && !pages[1]));

checkpatch fires a lot for this patchset and I think we should tone down
the BUG_ON() use.

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#116: FILE: arch/x86/kernel/alternative.c:711:
+       BUG_ON(!pages[0] || (cross_page_boundary && !pages[1]));

While the below BUG_ON makes sense, this here could be a WARN_ON or so.

Which begs the next question: AFAICT, nothing looks at text_poke*()'s
retval. So why are we even bothering returning something?

> +
>  	local_irq_save(flags);
> -	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
> -	if (pages[1])
> -		set_fixmap(FIX_TEXT_POKE1, page_to_phys(pages[1]));
> -	vaddr = (char *)fix_to_virt(FIX_TEXT_POKE0);
> -	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
> -	clear_fixmap(FIX_TEXT_POKE0);
> -	if (pages[1])
> -		clear_fixmap(FIX_TEXT_POKE1);
> -	local_flush_tlb();
> -	sync_core();
> -	/* Could also do a CLFLUSH here to speed up CPU recovery; but
> -	   that causes hangs on some VIA CPUs. */
> -	for (i = 0; i < len; i++)
> -		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
> +
> +	/*
> +	 * The lock is not really needed, but this allows to avoid open-coding.
> +	 */
> +	ptep = get_locked_pte(poking_mm, poking_addr, &ptl);
> +
> +	/*
> +	 * This must not fail; preallocated in poking_init().
> +	 */
> +	VM_BUG_ON(!ptep);
> +
> +	/*
> +	 * flush_tlb_mm_range() would be called when the poking_mm is not
> +	 * loaded. When PCID is in use, the flush would be deferred to the time
> +	 * the poking_mm is loaded again. Set the PTE as non-global to prevent
> +	 * it from being used when we are done.
> +	 */
> +	prot = __pgprot(pgprot_val(PAGE_KERNEL) & ~_PAGE_GLOBAL);

So

				_KERNPG_TABLE | _PAGE_NX

as this is pagetable page, AFAICT.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
