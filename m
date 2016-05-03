Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 3 May 2016 18:05:30 +0800
From: Baoquan He <bhe@redhat.com>
Message-ID: <20160503100530.GC3287@x1.redhat.com>
References: <1462225276-106993-1-git-send-email-thgarnie@google.com>
 <1462225276-106993-3-git-send-email-thgarnie@google.com>
 <5727CD69.7040901@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5727CD69.7040901@linux.intel.com>
Subject: [kernel-hardening] Re: [PATCH v2 2/4] x86, boot: PUD VA support for physical mapping
 (x86_64)
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Garnier <thgarnie@google.com>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gthelen@google.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 05/02/16 at 02:58pm, Dave Hansen wrote:
> On 05/02/2016 02:41 PM, Thomas Garnier wrote:
> > Minor change that allows early boot physical mapping of PUD level virtual
> > addresses. This change prepares usage of different virtual addresses for
> > KASLR memory randomization. It has no impact on default usage.
> ...
> > diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> > index 89d9747..6adfbce 100644
> > --- a/arch/x86/mm/init_64.c
> > +++ b/arch/x86/mm/init_64.c
> > @@ -526,10 +526,10 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
> >  {
> >  	unsigned long pages = 0, next;
> >  	unsigned long last_map_addr = end;
> > -	int i = pud_index(addr);
> > +	int i = pud_index((unsigned long)__va(addr));
> >  
> >  	for (; i < PTRS_PER_PUD; i++, addr = next) {
> > -		pud_t *pud = pud_page + pud_index(addr);
> > +		pud_t *pud = pud_page + pud_index((unsigned long)__va(addr));
> >  		pmd_t *pmd;
> >  		pgprot_t prot = PAGE_KERNEL;
> 
> pud_index() is supposed to take a virtual address.  We were passing a
> physical address in here, and it all just worked because PAGE_OFFSET is
> PUD-aligned.  Now that you are moving PAGE_OFFSET around a bit and not
> PUD-aligning it, this breaks.  Right?

Yes. Acutally here code is tricky since PAGE_OFFSET is PUD-aligned or
. Usually we setup memory mapping with physical addr and the
corresponding virtual addr, here for less parameter we only pass in
physical addr. X86 people need to make it clear about this. Of course
explaining it in patch log is also helpful.

I have a tiny concern about phys_pmd_init(), both phys_pud_init and
phys_pte_init name 2nd parameter as 'addr', phys_pmd_init use 'address'.
If this can be changed to make them look consistent completist would
have a good sleep from now on.

Thanks
Baoquan
