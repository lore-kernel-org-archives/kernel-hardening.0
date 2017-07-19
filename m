Date: Wed, 19 Jul 2017 20:10:21 +0800
From: Baoquan He <bhe@redhat.com>
Message-ID: <20170719121021.GE2344@x1>
References: <20170718223333.110371-1-thgarnie@google.com>
 <20170718223333.110371-23-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170718223333.110371-23-thgarnie@google.com>
Subject: [kernel-hardening] Re: [RFC 22/22] x86/kaslr: Add option to extend KASLR range from 1GB
 to 3GB
To: Thomas Garnier <thgarnie@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Daniel Micay <danielmicay@gmail.com>, x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 07/18/17 at 03:33pm, Thomas Garnier wrote:

>  quiet_cmd_relocs = RELOCS  $@
>        cmd_relocs = $(CMD_RELOCS) $< > $@;$(CMD_RELOCS) --abs-relocs $<
>  $(obj)/vmlinux.relocs: vmlinux FORCE
> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> index a0838ab929f2..0a0c80ab1842 100644
> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -170,10 +170,18 @@ void __puthex(unsigned long value)
>  }
>  
>  #if CONFIG_X86_NEED_RELOCS
> +
> +/* Large randomization go lower than -2G and use large relocation table */
> +#ifdef CONFIG_RANDOMIZE_BASE_LARGE
> +typedef long rel_t;
> +#else
> +typedef int rel_t;
> +#endif
> +
>  static void handle_relocations(void *output, unsigned long output_len,
>  			       unsigned long virt_addr)
>  {
> -	int *reloc;
> +	rel_t *reloc;
>  	unsigned long delta, map, ptr;
>  	unsigned long min_addr = (unsigned long)output;
>  	unsigned long max_addr = min_addr + (VO___bss_start - VO__text);
> diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
> index 3f5f08b010d0..6b65f846dd64 100644
> --- a/arch/x86/include/asm/page_64_types.h
> +++ b/arch/x86/include/asm/page_64_types.h
> @@ -48,7 +48,11 @@
>  #define __PAGE_OFFSET           __PAGE_OFFSET_BASE
>  #endif /* CONFIG_RANDOMIZE_MEMORY */
>  
> +#ifdef CONFIG_RANDOMIZE_BASE_LARGE
> +#define __START_KERNEL_map	_AC(0xffffffff00000000, UL)
> +#else
>  #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
> +#endif /* CONFIG_RANDOMIZE_BASE_LARGE */
>  
>  /* See Documentation/x86/x86_64/mm.txt for a description of the memory map. */
>  #ifdef CONFIG_X86_5LEVEL
> @@ -65,9 +69,14 @@
>   * 512MiB by default, leaving 1.5GiB for modules once the page tables
>   * are fully set up. If kernel ASLR is configured, it can extend the
>   * kernel page table mapping, reducing the size of the modules area.
> + * On PIE, we relocate the binary 2G lower so add this extra space.
>   */
>  #if defined(CONFIG_RANDOMIZE_BASE)
> +#ifdef CONFIG_RANDOMIZE_BASE_LARGE
> +#define KERNEL_IMAGE_SIZE	(_AC(3, UL) * 1024 * 1024 * 1024)
> +#else
>  #define KERNEL_IMAGE_SIZE	(1024 * 1024 * 1024)
> +#endif
>  #else
>  #define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
>  #endif
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index 4103e90ff128..235c3f7b46c7 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -39,6 +39,7 @@ static unsigned int __initdata next_early_pgt;
>  pmdval_t early_pmd_flags = __PAGE_KERNEL_LARGE & ~(_PAGE_GLOBAL | _PAGE_NX);
>  
>  #define __head	__section(.head.text)
> +#define pud_count(x)   (((x + (PUD_SIZE - 1)) & ~(PUD_SIZE - 1)) >> PUD_SHIFT)
>  
>  static void __head *fixup_pointer(void *ptr, unsigned long physaddr)
>  {
> @@ -54,6 +55,8 @@ unsigned long _text_offset = (unsigned long)(_text - __START_KERNEL_map);
>  void __head notrace __startup_64(unsigned long physaddr)
>  {
>  	unsigned long load_delta, *p;
> +	unsigned long level3_kernel_start, level3_kernel_count;
> +	unsigned long level3_fixmap_start;
>  	pgdval_t *pgd;
>  	p4dval_t *p4d;
>  	pudval_t *pud;
> @@ -74,6 +77,11 @@ void __head notrace __startup_64(unsigned long physaddr)
>  	if (load_delta & ~PMD_PAGE_MASK)
>  		for (;;);
>  
> +	/* Look at the randomization spread to adapt page table used */
> +	level3_kernel_start = pud_index(__START_KERNEL_map);
> +	level3_kernel_count = pud_count(KERNEL_IMAGE_SIZE);
> +	level3_fixmap_start = level3_kernel_start + level3_kernel_count;
> +
>  	/* Fixup the physical addresses in the page table */
>  
>  	pgd = fixup_pointer(&early_top_pgt, physaddr);
> @@ -85,8 +93,9 @@ void __head notrace __startup_64(unsigned long physaddr)
>  	}
>  
>  	pud = fixup_pointer(&level3_kernel_pgt, physaddr);
> -	pud[510] += load_delta;
> -	pud[511] += load_delta;
> +	for (i = 0; i < level3_kernel_count; i++)
> +		pud[level3_kernel_start + i] += load_delta;
> +	pud[level3_fixmap_start] += load_delta;
>  
>  	pmd = fixup_pointer(level2_fixmap_pgt, physaddr);
>  	pmd[506] += load_delta;
> @@ -137,7 +146,7 @@ void __head notrace __startup_64(unsigned long physaddr)
>  	 */
>  
>  	pmd = fixup_pointer(level2_kernel_pgt, physaddr);
> -	for (i = 0; i < PTRS_PER_PMD; i++) {
> +	for (i = 0; i < PTRS_PER_PMD * level3_kernel_count; i++) {
>  		if (pmd[i] & _PAGE_PRESENT)
>  			pmd[i] += load_delta;

Wow, this is dangerous. Three pud entries of level3_kernel_pgt all point
to level2_kernel_pgt, it's out of bound of level2_kernel_pgt and
overwrite the next data.

And if only use one page for level2_kernel_pgt, and kernel is randomized
to cross the pud entry of -4G to -1G, it won't work well.

>  	}
> @@ -268,7 +277,8 @@ asmlinkage __visible void __init x86_64_start_kernel(char * real_mode_data)
>  	 */
>  	BUILD_BUG_ON(MODULES_VADDR < __START_KERNEL_map);
>  	BUILD_BUG_ON(MODULES_VADDR - __START_KERNEL_map < KERNEL_IMAGE_SIZE);
> -	BUILD_BUG_ON(MODULES_LEN + KERNEL_IMAGE_SIZE > 2*PUD_SIZE);
> +	BUILD_BUG_ON(!IS_ENABLED(CONFIG_RANDOMIZE_BASE_LARGE) &&
> +		     MODULES_LEN + KERNEL_IMAGE_SIZE > 2*PUD_SIZE);
>  	BUILD_BUG_ON((__START_KERNEL_map & ~PMD_MASK) != 0);
>  	BUILD_BUG_ON((MODULES_VADDR & ~PMD_MASK) != 0);
>  	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 4d0a7e68bfe8..e8b2d6706eca 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -39,11 +39,15 @@
>  
>  #define p4d_index(x)	(((x) >> P4D_SHIFT) & (PTRS_PER_P4D-1))
>  #define pud_index(x)	(((x) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
> +#define pud_count(x)   (((x + (PUD_SIZE - 1)) & ~(PUD_SIZE - 1)) >> PUD_SHIFT)
>  
>  PGD_PAGE_OFFSET = pgd_index(__PAGE_OFFSET_BASE)
>  PGD_START_KERNEL = pgd_index(__START_KERNEL_map)
>  L3_START_KERNEL = pud_index(__START_KERNEL_map)
>  
> +/* Adapt page table L3 space based on range of randomization */
> +L3_KERNEL_ENTRY_COUNT = pud_count(KERNEL_IMAGE_SIZE)
> +
>  	.text
>  	__HEAD
>  	.code64
> @@ -396,7 +400,12 @@ NEXT_PAGE(level4_kernel_pgt)
>  NEXT_PAGE(level3_kernel_pgt)
>  	.fill	L3_START_KERNEL,8,0
>  	/* (2^48-(2*1024*1024*1024)-((2^39)*511))/(2^30) = 510 */
> -	.quad	level2_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
> +	i = 0
> +	.rept	L3_KERNEL_ENTRY_COUNT
> +	.quad	level2_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE \
> +		+ PAGE_SIZE*i
> +	i = i + 1
> +	.endr
>  	.quad	level2_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
>  
>  NEXT_PAGE(level2_kernel_pgt)
> -- 
> 2.13.2.932.g7449e964c-goog
> 
