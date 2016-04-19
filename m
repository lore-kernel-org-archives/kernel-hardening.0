Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 19 Apr 2016 16:27:41 +0200
From: Joerg Roedel <jroedel@suse.de>
Message-ID: <20160419142741.GI3886@suse.de>
References: <1460757793-59020-1-git-send-email-thgarnie@google.com>
 <1460757793-59020-4-git-send-email-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1460757793-59020-4-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] Re: [RFC v1 3/4] x86, boot: Implement ASLR for kernel memory
 sections (x86_64)
To: Thomas Garnier <thgarnie@google.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Seth Jennings <sjennings@variantweb.net>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gthelen@google.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Thomas,

On Fri, Apr 15, 2016 at 03:03:12PM -0700, Thomas Garnier wrote:
> +/*
> + * Create PGD aligned trampoline table to allow real mode initialization
> + * of additional CPUs. Consume only 1 additonal low memory page.
> + */
> +void __meminit kaslr_trampoline_init(unsigned long page_size_mask)
> +{
> +	unsigned long addr, next, end;
> +	pgd_t *pgd;
> +	pud_t *pud_page, *tr_pud_page;
> +	int i;
> +
> +	if (!kaslr_enabled()) {
> +		trampoline_pgd_entry = init_level4_pgt[pgd_index(PAGE_OFFSET)];
> +		return;
> +	}
> +
> +	tr_pud_page = alloc_low_page();
> +	set_pgd(&trampoline_pgd_entry, __pgd(_PAGE_TABLE | __pa(tr_pud_page)));
> +
> +	addr = 0;
> +	end = ISA_END_ADDRESS;
> +	pgd = pgd_offset_k((unsigned long)__va(addr));
> +	pud_page = (pud_t *) pgd_page_vaddr(*pgd);
> +
> +	for (i = pud_index(addr); i < PTRS_PER_PUD; i++, addr = next) {
> +		pud_t *pud, *tr_pud;
> +		pmd_t *pmd;
> +
> +		tr_pud = tr_pud_page + pud_index(addr);
> +		pud = pud_page + pud_index((unsigned long)__va(addr));
> +		next = (addr & PUD_MASK) + PUD_SIZE;
> +
> +		if (addr >= end || !pud_val(*pud)) {
> +			if (!after_bootmem &&
> +			    !e820_any_mapped(addr & PUD_MASK, next, E820_RAM) &&
> +			    !e820_any_mapped(addr & PUD_MASK, next,
> +					    E820_RESERVED_KERN))
> +				set_pud(tr_pud, __pud(0));
> +			continue;
> +		}
> +
> +		if (page_size_mask & (1<<PG_LEVEL_1G)) {
> +			set_pte((pte_t *)tr_pud,
> +				pfn_pte((__pa(addr) & PUD_MASK) >> PAGE_SHIFT,

Hmm, why do you treat addr as virtual here, before it was a physical
address, no?

> +					PAGE_KERNEL_LARGE));
> +			continue;
> +		}

Why do you need to check these two cases above, can't you just copy the
pud-entries like done below? The direct mapping should already take care
of unmapped regions and 1gb pages.

> +		pmd = pmd_offset(pud, 0);
> +		set_pud(tr_pud, __pud(_PAGE_TABLE | __pa(pmd)));
> +	}
> +}


	Joerg
