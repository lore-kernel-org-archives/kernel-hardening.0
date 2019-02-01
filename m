MIME-Version: 1.0
References: <20190131192533.34130-1-thgarnie@chromium.org> <20190131192533.34130-14-thgarnie@chromium.org>
 <20190201111532.3oszgzj4grdyej5q@kshutemo-mobl1>
In-Reply-To: <20190201111532.3oszgzj4grdyej5q@kshutemo-mobl1>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Fri, 1 Feb 2019 09:11:37 -0800
Message-ID: <CAJcbSZGa2=YLaFxqoZ79h1Gh794DPWpuCArSMirYVbHLYzBu5w@mail.gmail.com>
Subject: Re: [PATCH v6 13/27] x86/boot/64: Build head64.c as mcmodel large
 when PIE is enabled
Content-Type: text/plain; charset="UTF-8"
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, kristen@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>, Juergen Gross <jgross@suse.com>, Nayna Jain <nayna@linux.ibm.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Jan Kiszka <jan.kiszka@siemens.com>, Nick Desaulniers <ndesaulniers@google.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 1, 2019 at 3:15 AM Kirill A. Shutemov <kirill@shutemov.name> wrote:
>
> On Thu, Jan 31, 2019 at 11:24:20AM -0800, Thomas Garnier wrote:
> > The __startup_64 function assumes all symbols have relocated addresses
> > instead of the current boot virtual address. PIE generated code favor
> > relative addresses making all virtual and physical address math incorrect.
> > If PIE is enabled, build head64.c as mcmodel large instead to ensure absolute
> > references on all memory access. Add a global __force_order variable required
> > when using a large model with read_cr* functions.
> >
> > To build head64.c as mcmodel=large, disable the retpoline gcc flags.
> > This code is used at early boot and removed later, it doesn't need
> > retpoline mitigation.
> >
> > Position Independent Executable (PIE) support will allow to extend the
> > KASLR randomization range below 0xffffffff80000000.
> >
> > Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
> > ---
> >  arch/x86/kernel/Makefile | 6 ++++++
> >  arch/x86/kernel/head64.c | 3 +++
> >  2 files changed, 9 insertions(+)
> >
> > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > index 00b7e27bc2b7..1f98f52eab9f 100644
> > --- a/arch/x86/kernel/Makefile
> > +++ b/arch/x86/kernel/Makefile
> > @@ -22,6 +22,12 @@ CFLAGS_REMOVE_early_printk.o = -pg
> >  CFLAGS_REMOVE_head64.o = -pg
> >  endif
> >
> > +ifdef CONFIG_X86_PIE
> > +# Remove PIE and retpoline flags that are incompatible with mcmodel=large
> > +CFLAGS_REMOVE_head64.o += -fPIE -mindirect-branch=thunk-extern -mindirect-branch-register
> > +CFLAGS_head64.o = -mcmodel=large
> > +endif
> > +
> >  KASAN_SANITIZE_head$(BITS).o                         := n
> >  KASAN_SANITIZE_dumpstack.o                           := n
> >  KASAN_SANITIZE_dumpstack_$(BITS).o                   := n
> > diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> > index 16b1cbd3a61e..22e81275495b 100644
> > --- a/arch/x86/kernel/head64.c
> > +++ b/arch/x86/kernel/head64.c
> > @@ -63,6 +63,9 @@ EXPORT_SYMBOL(vmemmap_base);
> >
> >  #define __head       __section(.head.text)
> >
> > +/* Required for read_cr3 when building as PIE */
> > +unsigned long __force_order;
> > +
>
> I believe it only needed for GCC < 5. Newer GCC can eliminate the
> reference. See my comment in arch/x86/boot/compressed/pgtable_64.c.
>
> Maybe we should expand the comment here too?

Make sense, I will add a similar comment in the next iteration. Thanks
for pointing that out.

>
> --
>  Kirill A. Shutemov
