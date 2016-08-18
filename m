Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 18 Aug 2016 12:59:22 +0800
From: Baoquan He <bhe@redhat.com>
Message-ID: <20160818045922.GA23981@x1.redhat.com>
References: <1471452462-42560-1-git-send-email-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471452462-42560-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] Re: [PATCH v1] kexec/arch/i386: Add support for KASLR memory
 randomization
To: Thomas Garnier <thgarnie@google.com>
Cc: kexec@lists.infradead.org, horms@verge.net.au, keescook@chromium.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 08/17/16 at 09:47am, Thomas Garnier wrote:
> Multiple changes were made on KASLR (right now in linux-next). One of
> them is randomizing the virtual address of the physical mapping, vmalloc
> and vmemmap memory sections. It breaks kdump ability to read physical
> memory.
> 
> This change identifies if KASLR memories randomization is used by
> checking if the page_offset_base variable exists. It search for the
> correct PAGE_OFFSET value by looking at the loaded memory section and
> find the lowest aligned on PUD (the randomization level).
> 
> Related commits on linux-next:
>  - 0483e1fa6e09d4948272680f691dccb1edb9677f: Base for randomization
>  - 021182e52fe01c1f7b126f97fd6ba048dc4234fd: Enable for PAGE_OFFSET

Seems above two commits have been inside Linus's tree, while vmemmap
not yet.

> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
>  kexec/arch/i386/crashdump-x86.c | 29 ++++++++++++++++++++++-------
>  1 file changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/kexec/arch/i386/crashdump-x86.c b/kexec/arch/i386/crashdump-x86.c
> index bbc0f35..ab833d4 100644
> --- a/kexec/arch/i386/crashdump-x86.c
> +++ b/kexec/arch/i386/crashdump-x86.c
> @@ -102,11 +102,10 @@ static int get_kernel_paddr(struct kexec_info *UNUSED(info),
>  	return -1;
>  }
>  
> -/* Retrieve kernel _stext symbol virtual address from /proc/kallsyms */
> -static unsigned long long get_kernel_stext_sym(void)
> +/* Retrieve kernel symbol virtual address from /proc/kallsyms */
> +static unsigned long long get_kernel_sym(const char *symbol)
>  {
>  	const char *kallsyms = "/proc/kallsyms";
> -	const char *stext = "_stext";
>  	char sym[128];
>  	char line[128];
>  	FILE *fp;
> @@ -122,13 +121,13 @@ static unsigned long long get_kernel_stext_sym(void)
>  	while(fgets(line, sizeof(line), fp) != NULL) {
>  		if (sscanf(line, "%Lx %c %s", &vaddr, &type, sym) != 3)
>  			continue;
> -		if (strcmp(sym, stext) == 0) {
> -			dbgprintf("kernel symbol %s vaddr = %16llx\n", stext, vaddr);
> +		if (strcmp(sym, symbol) == 0) {
> +			dbgprintf("kernel symbol %s vaddr = %16llx\n", symbol, vaddr);
>  			return vaddr;
>  		}
>  	}
>  
> -	fprintf(stderr, "Cannot get kernel %s symbol address\n", stext);
> +	fprintf(stderr, "Cannot get kernel %s symbol address\n", symbol);
>  	return 0;
>  }
>  
> @@ -151,6 +150,8 @@ static int get_kernel_vaddr_and_size(struct kexec_info *UNUSED(info),
>  	off_t size;
>  	uint32_t elf_flags = 0;
>  	uint64_t stext_sym;
> +	const unsigned long long pud_mask = ~((1 << 30) - 1);
> +	unsigned long long vaddr, lowest_vaddr = 0;
>  
>  	if (elf_info->machine != EM_X86_64)
>  		return 0;
> @@ -180,9 +181,23 @@ static int get_kernel_vaddr_and_size(struct kexec_info *UNUSED(info),
>  
>  	end_phdr = &ehdr.e_phdr[ehdr.e_phnum];
>  
> +	/* Search for the real PAGE_OFFSET when KASLR memory randomization
> +	 * is enabled */

Yeah, this is necessary. That would be great if it can be put into
get_kernel_page_offset. But then it need parse kcore elf file again,
seems no better way.

> +	if (get_kernel_sym("page_offset_base") != 0) {
> +		for(phdr = ehdr.e_phdr; phdr != end_phdr; phdr++) {
> +			if (phdr->p_type == PT_LOAD) {
> +				vaddr = phdr->p_vaddr & pud_mask;
> +				if (lowest_vaddr == 0 || lowest_vaddr > vaddr)
> +					lowest_vaddr = vaddr;
> +			}
> +		}
> +		if (lowest_vaddr != 0)
> +			elf_info->page_offset = lowest_vaddr;
> +	}
> +
>  	/* Traverse through the Elf headers and find the region where
>  	 * _stext symbol is located in. That's where kernel is mapped */
> -	stext_sym = get_kernel_stext_sym();
> +	stext_sym = get_kernel_sym("_stext");
>  	for(phdr = ehdr.e_phdr; stext_sym && phdr != end_phdr; phdr++) {
>  		if (phdr->p_type == PT_LOAD) {
>  			unsigned long long saddr = phdr->p_vaddr;
> -- 
> 2.8.0.rc3.226.g39d4020
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
