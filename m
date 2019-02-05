Date: Tue, 5 Feb 2019 12:31:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 06/20] x86/alternative: use temporary mm for text
 poking
Message-ID: <20190205113146.GP17528@hirez.programming.kicks-ass.net>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-7-rick.p.edgecombe@intel.com>
 <20190205095853.GJ21801@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205095853.GJ21801@zn.tnic>
To: Borislav Petkov <bp@alien8.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Nadav Amit <namit@vmware.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 05, 2019 at 10:58:53AM +0100, Borislav Petkov wrote:
> > @@ -683,41 +684,102 @@ __ro_after_init unsigned long poking_addr;
> >  
> >  static void *__text_poke(void *addr, const void *opcode, size_t len)
> >  {
> > +	bool cross_page_boundary = offset_in_page(addr) + len > PAGE_SIZE;
> > +	temporary_mm_state_t prev;
> > +	struct page *pages[2] = {NULL};
> >  	unsigned long flags;
> > -	char *vaddr;
> > -	struct page *pages[2];
> > -	int i;
> > +	pte_t pte, *ptep;
> > +	spinlock_t *ptl;
> > +	pgprot_t prot;
> >  
> >  	/*
> > -	 * While boot memory allocator is runnig we cannot use struct
> > -	 * pages as they are not yet initialized.
> > +	 * While boot memory allocator is running we cannot use struct pages as
> > +	 * they are not yet initialized.
> >  	 */
> >  	BUG_ON(!after_bootmem);
> >  
> >  	if (!core_kernel_text((unsigned long)addr)) {
> >  		pages[0] = vmalloc_to_page(addr);
> > -		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
> > +		if (cross_page_boundary)
> > +			pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
> >  	} else {
> >  		pages[0] = virt_to_page(addr);
> >  		WARN_ON(!PageReserved(pages[0]));
> > -		pages[1] = virt_to_page(addr + PAGE_SIZE);
> > +		if (cross_page_boundary)
> > +			pages[1] = virt_to_page(addr + PAGE_SIZE);
> >  	}
> > -	BUG_ON(!pages[0]);
> > +	BUG_ON(!pages[0] || (cross_page_boundary && !pages[1]));
> 
> checkpatch fires a lot for this patchset and I think we should tone down
> the BUG_ON() use.

I've been pushing for BUG_ON() in this patch set; sod checkpatch.

Maybe not this BUG_ON in particular, but a number of them introduced
here are really situations where we can't do anything sane.

This BUG_ON() in particular is the choice between corrupted text or an
instantly dead machine; what would you do?

In general, text_poke() cannot fail:

 - suppose changing a single jump label requires poking multiple sites
   (not uncommon), we fail halfway through and then have to undo the
   first pokes, but those pokes fail again.

 - this then leaves us no way forward and no way back, we've got
   inconsistent text state -> FAIL.

So even an 'early' fail (like here) doesn't work in the rollback
scenario if you combine them.

So while in general I agree with BUG_ON() being undesirable, I think
liberal sprinking in text_poke() is fine; you really _REALLY_ want this
to work or fail loudly. Text corruption is just painful.
