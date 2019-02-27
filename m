MIME-Version: 1.0
References: <20190226233647.28547-1-keescook@chromium.org> <20190226233647.28547-2-keescook@chromium.org>
 <20190227104407.GA18804@openwall.com>
In-Reply-To: <20190227104407.GA18804@openwall.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 27 Feb 2019 11:45:03 -0800
Message-ID: <CAGXu5j+vBURRz2aUafmOY9nJ56Sr-YonvhE8OGJ+6QkOQe5ePQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86/asm: Pin sensitive CR0 bits
Content-Type: text/plain; charset="UTF-8"
To: Solar Designer <solar@openwall.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 27, 2019 at 2:44 AM Solar Designer <solar@openwall.com> wrote:
>
> On Tue, Feb 26, 2019 at 03:36:45PM -0800, Kees Cook wrote:
> >  static inline void native_write_cr0(unsigned long val)
> >  {
> > -     asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
> > +     bool warn = false;
> > +
> > +again:
> > +     val |= X86_CR0_WP;
> > +     /*
> > +      * In order to have the compiler not optimize away the check
> > +      * in the WARN_ONCE(), mark "val" as being also an output ("+r")
>
> This comment is now slightly out of date: the check is no longer "in the
> WARN_ONCE()".  Ditto about the comment for CR4.

Ah yes, good point. I will adjust and send a v2 series.

>
> > +      * by this asm() block so it will perform an explicit check, as
> > +      * if it were "volatile".
> > +      */
> > +     asm volatile("mov %0,%%cr0": "+r" (val) : "m" (__force_order) : );
> > +     /*
> > +      * If the MOV above was used directly as a ROP gadget we can
> > +      * notice the lack of pinned bits in "val" and start the function
> > +      * from the beginning to gain the WP bit for sure. And do it
> > +      * without first taking the exception for a WARN().
> > +      */
> > +     if ((val & X86_CR0_WP) != X86_CR0_WP) {
> > +             warn = true;
> > +             goto again;
> > +     }
> > +     WARN_ONCE(warn, "Attempt to unpin X86_CR0_WP, cr0 bypass attack?!\n");
> >  }
>
> Alexander

-- 
Kees Cook
