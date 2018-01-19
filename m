MIME-Version: 1.0
In-Reply-To: <20180119181833.GA1878@arm.com>
References: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151632010687.21271.12004432287640499992.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAG48ez0Y97-gyzWBmcVbUyLuzUG42To=Mm8PAKuzWma6XbFmew@mail.gmail.com>
 <y2afu71pwob.fsf@offog.org> <CAPcyv4iEZMkU-K14vTcFSjAy=12QHPJjMGc8Uu7xUVakHfqOyQ@mail.gmail.com>
 <20180119181833.GA1878@arm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 19 Jan 2018 10:26:13 -0800
Message-ID: <CAPcyv4hGjqv1bS_=h8VauHSfkyj0b8HLm69AzoTsf_GfnRA-Pg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v4 02/10] asm/nospec, array_ptr:
 sanitize speculative array de-references
To: Will Deacon <will.deacon@arm.com>
Cc: Adam Sampson <ats@offog.org>, Jann Horn <jannh@google.com>, kernel list <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, the arch/x86 maintainers <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>, Alexei Starovoitov <ast@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 19, 2018 at 10:18 AM, Will Deacon <will.deacon@arm.com> wrote:
>
> On Fri, Jan 19, 2018 at 10:12:47AM -0800, Dan Williams wrote:
> > [ adding Alexei back to the cc ]
> >
> > On Fri, Jan 19, 2018 at 9:48 AM, Adam Sampson <ats@offog.org> wrote:
> > > Jann Horn <jannh@google.com> writes:
> > >
> > >>> +/*
> > >>> + * If idx is negative or if idx > size then bit 63 is set in the mask,
> > >>> + * and the value of ~(-1L) is zero. When the mask is zero, bounds check
> > >>> + * failed, array_ptr will return NULL.
> > >>> + */
> > >>> +#ifndef array_ptr_mask
> > >>> +static inline unsigned long array_ptr_mask(unsigned long idx,
> > >>> unsigned long sz)
> > >>> +{
> > >>> +       return ~(long)(idx | (sz - 1 - idx)) >> (BITS_PER_LONG - 1);
> > >>> +}
> > >>> +#endif
> > >>
> > >> Nit: Maybe add a comment saying that this is equivalent to
> > >> "return ((long)idx >= 0 && idx < sz) ? ULONG_MAX : 0"?
> > >
> > > That's only true when sz < LONG_MAX, which is documented below but not
> > > here; it's also different from the asm version, which doesn't do the idx
> > > <= LONG_MAX check. So making the constraint explicit would be a good idea.
> > >
> > > From a bit of experimentation, when the top bit of sz is set, this
> > > expression, the C version and the assembler version all have different
> > > behaviour. For example, with 32-bit unsigned long:
> > >
> > > index=00000000 size=80000001: expr=ffffffff c=00000000 asm=ffffffff
> > > index=80000000 size=80000001: expr=00000000 c=00000000 asm=ffffffff
> > > index=00000000 size=a0000000: expr=ffffffff c=00000000 asm=ffffffff
> > > index=00000001 size=a0000000: expr=ffffffff c=00000000 asm=ffffffff
> > > index=fffffffe size=ffffffff: expr=00000000 c=00000000 asm=ffffffff
> > >
> > > It may be worth noting that:
> > >
> > >      return 0 - ((long) (idx < sz));
> > >
> > > causes GCC, on ia32 and amd64, to generate exactly the same cmp/sbb
> > > sequence as in Linus's asm. Are there architectures where this form
> > > would allow speculation?
> >
> > We're operating on the assumption that compilers will not try to
> > introduce branches where they don't exist in the code, so if this is
> > producing identical assembly I think we should go with it and drop the
> > x86 array_ptr_mask.
>
> Branches, perhaps, but this could easily be compiled to a conditional
> select (CSEL) instruction on arm64 and that wouldn't be safe without a
> CSDB. Of course, we can do our own thing in assembly to prevent that, but
> it would mean that the generic C implementation would not be robust for us.
>

Ah, ok good to know. Likely if the current version doesn't produce a
conditional instruction on ARM perhaps it also won't do that on other
architectures, so it is safer.
