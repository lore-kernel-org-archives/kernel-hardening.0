Date: Tue, 18 Jun 2019 14:24:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 3/3] x86/asm: Pin sensitive CR0 bits
Message-ID: <20190618122430.GF3419@hirez.programming.kicks-ass.net>
References: <20190618045503.39105-1-keescook@chromium.org>
 <20190618045503.39105-4-keescook@chromium.org>
 <CAG48ez37iY3pfTWn4wiqdt7zdkSPpOcvz3gtwjTWAYz9qKbBNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez37iY3pfTWn4wiqdt7zdkSPpOcvz3gtwjTWAYz9qKbBNA@mail.gmail.com>
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, the arch/x86 maintainers <x86@kernel.org>, Dave Hansen <dave.hansen@intel.com>, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 18, 2019 at 11:38:02AM +0200, Jann Horn wrote:
> On Tue, Jun 18, 2019 at 6:55 AM Kees Cook <keescook@chromium.org> wrote:
> > With sensitive CR4 bits pinned now, it's possible that the WP bit for
> > CR0 might become a target as well. Following the same reasoning for
> > the CR4 pinning, this pins CR0's WP bit (but this can be done with a
> > static value).
> >
> > Suggested-by: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  arch/x86/include/asm/special_insns.h | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
> > index c8c8143ab27b..b2e84d113f2a 100644
> > --- a/arch/x86/include/asm/special_insns.h
> > +++ b/arch/x86/include/asm/special_insns.h
> > @@ -31,7 +31,20 @@ static inline unsigned long native_read_cr0(void)
> >
> >  static inline void native_write_cr0(unsigned long val)
> >  {
> 
> So, assuming a legitimate call to native_write_cr0(), we come in here...
> 
> > -       asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
> > +       unsigned long bits_missing = 0;

^^^

> > +
> > +set_register:
> > +       asm volatile("mov %0,%%cr0": "+r" (val), "+m" (__force_order));
> 
> ... here we've updated CR0...
> 
> > +       if (static_branch_likely(&cr_pinning)) {
> 
> ... this branch is taken, since cr_pinning is set to true after boot...
> 
> > +               if (unlikely((val & X86_CR0_WP) != X86_CR0_WP)) {
> 
> ... this branch isn't taken, because a legitimate update preserves the WP bit...
> 
> > +                       bits_missing = X86_CR0_WP;

^^^

> > +                       val |= bits_missing;
> > +                       goto set_register;
> > +               }
> > +               /* Warn after we've set the missing bits. */
> > +               WARN_ONCE(bits_missing, "CR0 WP bit went missing!?\n");
> 
> ... and we reach this WARN_ONCE()? Am I missing something, or does
> every legitimate CR0 write after early boot now trigger a warning?

bits_missing will be 0 and WARN will not be issued.

> > +       }
> >  }
