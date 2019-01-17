MIME-Version: 1.0
References: <20190117003259.23141-1-rick.p.edgecombe@intel.com>
 <20190117003259.23141-7-rick.p.edgecombe@intel.com> <CALCETrUMAsXoZogEJg7ssv0CO56vzBV2C7VotmWcwNM7iH9Wqw@mail.gmail.com>
In-Reply-To: <CALCETrUMAsXoZogEJg7ssv0CO56vzBV2C7VotmWcwNM7iH9Wqw@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 17 Jan 2019 12:47:37 -0800
Message-ID: <CALCETrXQ6uxzB3JvO14sEyMA21RcWCbwicL4nUdPBG8KAunxwg@mail.gmail.com>
Subject: Re: [PATCH 06/17] x86/alternative: use temporary mm for text poking
Content-Type: text/plain; charset="UTF-8"
To: Andy Lutomirski <luto@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Nadav Amit <namit@vmware.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 17, 2019 at 12:27 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Wed, Jan 16, 2019 at 4:33 PM Rick Edgecombe
> <rick.p.edgecombe@intel.com> wrote:
> >
> > From: Nadav Amit <namit@vmware.com>
> >
> > text_poke() can potentially compromise the security as it sets temporary
> > PTEs in the fixmap. These PTEs might be used to rewrite the kernel code
> > from other cores accidentally or maliciously, if an attacker gains the
> > ability to write onto kernel memory.
>
> i think this may be sufficient, but barely.
>
> > +       pte_clear(poking_mm, poking_addr, ptep);
> > +
> > +       /*
> > +        * __flush_tlb_one_user() performs a redundant TLB flush when PTI is on,
> > +        * as it also flushes the corresponding "user" address spaces, which
> > +        * does not exist.
> > +        *
> > +        * Poking, however, is already very inefficient since it does not try to
> > +        * batch updates, so we ignore this problem for the time being.
> > +        *
> > +        * Since the PTEs do not exist in other kernel address-spaces, we do
> > +        * not use __flush_tlb_one_kernel(), which when PTI is on would cause
> > +        * more unwarranted TLB flushes.
> > +        *
> > +        * There is a slight anomaly here: the PTE is a supervisor-only and
> > +        * (potentially) global and we use __flush_tlb_one_user() but this
> > +        * should be fine.
> > +        */
> > +       __flush_tlb_one_user(poking_addr);
> > +       if (cross_page_boundary) {
> > +               pte_clear(poking_mm, poking_addr + PAGE_SIZE, ptep + 1);
> > +               __flush_tlb_one_user(poking_addr + PAGE_SIZE);
> > +       }
>
> In principle, another CPU could still have the old translation.  Your
> mutex probably makes this impossible, but it makes me nervous.
> Ideally you'd use flush_tlb_mm_range(), but I guess you can't do that
> with IRQs off.  Hmm.  I think you should add an inc_mm_tlb_gen() here.
> Arguably, if you did that, you could omit the flushes, but maybe
> that's silly.
>
> If we start getting new users of use_temporary_mm(), we should give
> some serious thought to the SMP semantics.
>
> Also, you're using PAGE_KERNEL.  Please tell me that the global bit
> isn't set in there.
>

Much better solution: do unuse_temporary_mm() and *then*
flush_tlb_mm_range().  This is entirely non-sketchy and should be just
about optimal, too.

--Andy
