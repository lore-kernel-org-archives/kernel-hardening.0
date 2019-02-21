MIME-Version: 1.0
References: <20190220180934.GA46255@beast> <20190220184859.GA6429@openwall.com>
 <CAGXu5jLB=so4r169pq1KF3Kyfh2Kw_t6ZXGavpzVO2sg3=D1tw@mail.gmail.com> <20190221130645.GA8281@openwall.com>
In-Reply-To: <20190221130645.GA8281@openwall.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 21 Feb 2019 08:11:08 -0800
Message-ID: <CAGXu5jJ46whob0-DE1_dydRtoNAN0Lw7EUsnNvNyQzwt_g9iEg@mail.gmail.com>
Subject: Re: [PATCH v2] x86/asm: Pin sensitive CR4 bits
Content-Type: text/plain; charset="UTF-8"
To: Solar Designer <solar@openwall.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jann Horn <jannh@google.com>, Dominik Brodowski <linux@dominikbrodowski.net>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 21, 2019 at 5:06 AM Solar Designer <solar@openwall.com> wrote:
>
> On Wed, Feb 20, 2019 at 01:20:58PM -0800, Kees Cook wrote:
> > On Wed, Feb 20, 2019 at 10:49 AM Solar Designer <solar@openwall.com> wrote:
> > >
> > > On Wed, Feb 20, 2019 at 10:09:34AM -0800, Kees Cook wrote:
> > > > +     if (WARN_ONCE((val & cr4_pin) != cr4_pin, "cr4 bypass attempt?!\n"))
> > > > +             goto again;
> > >
> > > I think "goto again" is too mild a response given that it occurs after a
> > > successful write of a non-pinned value to CR4.  I think it'd allow some
> > > exploits to eventually win the race: make their desired use of whatever
> > > functionality SMEP, etc. would have prevented - which may be just a few
> > > instructions they need to run - before the CR4 value is reverted after
> > > "goto again".  I think it's one of those cases where a kernel panic
> > > would be more appropriate.
> >
> > It will not land upstream with a BUG() or panic(). Linus has
> > explicitly stated that none of this work can do that until it has
> > "baked" in the kernel for a couple years.
>
> OK.
>
> > In his defense, anyone sufficiently paranoid can already raise the
> > priority of a WARN() into a panic via sysctl kernel.panic_on_warn (and
> > kernel.panic_on_oops).
>
> I think there are too many uses of WARN() for anyone sane to enable
> that in production, whereas it'd have made sense to enable it for the
> few security-related uses.

Yeah, that's been my thinking too. I've been thinking about this for a
while trying to decide if we need something between WARN and BUG, but
I can't make up my mind. ;)

> > > Also, WARN_ONCE possibly introduces a delay sufficient to realistically
> > > win this race on the first try.  If we choose to warn, we should do it
> > > after having reverted the CR4 value, not before.
> >
> > Isn't cr4 CPU-local though?
>
> Good point.  I don't know.  If CR4 is per hardware thread, then the race
> would require an interrupt and would be much harder to win.
>
> > Couldn't we turn off interrupts to stop the race?
>
> This won't help.  An attack would skip the code that disables interrupts
> and land right on the MOV instruction.

Oh duh, yeah. ;)

I think v2 is good enough given the constraints we've got.

Thanks for looking at it!

-- 
Kees Cook
