Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 31 Aug 2016 17:41:57 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160831164119.GA6633@leverpostej>
References: <alpine.DEB.2.10.1608272058090.3363@hadrien>
 <1472325098.26978.14.camel@perches.com>
 <alpine.DEB.2.10.1608281509480.3321@hadrien>
 <CAGXu5jKZrHEZqyby-Gjrx=wjjCPw-kmkYBcW--+J5Y3w5QwNbg@mail.gmail.com>
 <20160831100848.GB4783@leverpostej>
 <CAGXu5jLUunTNw8LoNQdSoP2NU=SxzKDmXExEBeg-vSeOxk4iYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLUunTNw8LoNQdSoP2NU=SxzKDmXExEBeg-vSeOxk4iYA@mail.gmail.com>
Subject: [kernel-hardening] Re: constification and cocci / kernel build test robot ?
To: Kees Cook <keescook@chromium.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Joe Perches <joe@perches.com>, Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Glenn Wurster <gwurster@blackberry.com>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

On Wed, Aug 31, 2016 at 10:44:28AM -0400, Kees Cook wrote:
> On Wed, Aug 31, 2016 at 6:08 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Tue, Aug 30, 2016 at 02:50:36PM -0400, Kees Cook wrote:
> >> The structures that should get the greatest level of attention are
> >> those that contain function pointers. The "constify" gcc plugin from
> >> PaX/Grsecurity does this, but it uses a big hammer: it moves all of
> >> them const even if they receive assignment. To handle this, there is
> >> the concept of an open/close method to gain temporary access to the
> >> structure. For example:
> >>
> >> drivers/cdrom/cdrom.c:
> >>
> >> int register_cdrom(...) {
> >>         ...
> >>         if (!cdo->generic_packet) {
> >>                 pax_open_kernel();
> >>                 const_cast(cdo->generic_packet) = cdrom_dummy_generic_packet;
> >>                 pax_close_kernel();
> >>         }
> >>
> >> (The "const_cast" here is just a macro to convince gcc it's only to
> >> write to a const value, so really it should maybe be called
> >> "unconst_cast", but whatever...)
> >
> > Just to check, are they actually marked as const, or some pseudo-const
> > like __ro_after_init?
> 
> The plugin marks them actually const, so the const_cast() is needed to
> "forget" that marking and treat it as a normal variable. (And PaX Team
> noted that this is the name used in C++ already.)

>From having a look around, my understanding is that with C++ this is
only valid if the underlying object is not const (i.e. it's only valid
to remove constness from a pointer or reference which had itself added
constness to a non-const object).

I see that GCC is happy to constant-fold function pointers in const
objects it has visibility of; example below. Making the objects
themselves const is bound to lead to fragility (e.g. static inline
functions in a header behaving differently from related functions in
another file).

Have I misunderstood something?

Note: For the below I manually fixed up the symbol resolution in ret_a,
as by default objdump misleadingly reports <intfunc> rather than <a>.

---->8----
[mark@leverpostej:~]% cat const-test.c                                         
int intfunc(int arg) 
{
        return arg;
}

struct foo {
        int (*func)(int arg);
};

struct foo a = {
        .func = intfunc,
};

const struct foo b = {
        .func = intfunc,
};

extern const struct foo c;

int ret_a(int val)
{
        return a.func(val);
}

int ret_b(int val)
{
        return b.func(val);
}

int ret_c(int val)
{
        return c.func(val);
}
[mark@leverpostej:~]% uselinaro 15.08 aarch64-linux-gnu-gcc -O3 -c const-test.c 
[mark@leverpostej:~]% uselinaro 15.08 aarch64-linux-gnu-objdump -d const-test.o 

const-test.o:     file format elf64-littleaarch64


Disassembly of section .text:

0000000000000000 <intfunc>:
   0:   d65f03c0        ret
   4:   d503201f        nop

0000000000000008 <ret_a>:
   8:   90000001        adrp    x1, 0 <a>
   c:   f9400021        ldr     x1, [x1]
  10:   d61f0020        br      x1
  14:   d503201f        nop

0000000000000018 <ret_b>:
  18:   d65f03c0        ret
  1c:   d503201f        nop

0000000000000020 <ret_c>:
  20:   90000001        adrp    x1, 0 <c>
  24:   f9400021        ldr     x1, [x1]
  28:   d61f0020        br      x1
  2c:   d503201f        nop
---->8----

> > I can imagine a number of issues with casting a real const away (e.g. if
> > the compiler decides to cache the value in a register and decides since
> > it is const it need not hazard with a memory clobber).
> 
> AFAIK, this hasn't caused problems. PaX Team may be able to speak more
> to this...

Per the above, and assuming that I haven't missed something, I cannot
see how this can be safe, even if it happens to have worked so far.

Hopefully I'm just being thick, and someone can correct me. :)

[...]

> >> This makes sure there aren't races with other CPUs to write things,
> >> and that it's harder to use for an attack since with the "make
> >> writable" code is always followed by a "make read-only" action (i.e.
> >> not separate functions that could be used as a trivial ROP gadget).
> >
> > FWIW, on that front we may want to look into reworking the fixmap code.
> > For at least arm, arm64, microblaze, and powerpc, __set_fixmap is a C
> > function that might offer a trivial ROP gadget for creating a RW
> > mapping.
> >
> > Other architectures have that as a static inline in a header, which
> > ensures that it's folded into callers, making it less trivial to reuse.
> 
> Even with the inlining, it's just making things slightly harder, since
> there is still a memory write happening, so a careful setup before
> calling it can still be used as a ROP gadget.

Sure. Hence "less trivial". ;)

If it's not likely to be a noticeable improvement, I'm happy to leave
that as-is. I just thought it was worth mentioning.

Thanks,
Mark.
