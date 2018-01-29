Date: Mon, 29 Jan 2018 13:19:42 +0000
From: Will Deacon <will.deacon@arm.com>
Message-ID: <20180129131942.GC25549@arm.com>
References: <CALCETrV1JHK1ovjjD1vbs08K1an6tq6nbRoAj9uyrY2GUYJJBA@mail.gmail.com>
 <CA+55aFzTXVRPo7OBPMo2OB26GisY8-dg6NaC8ackVJgS9M0+4w@mail.gmail.com>
 <CALCETrU42C1S3nvSuLuamXtp2-s1xBG3q5cSNVOfGThncHxBZA@mail.gmail.com>
 <b8ea504729db4073abf82ebd5d8a53c6@AcuMS.aculab.com>
 <1516976647.5438.6.camel@linux.intel.com>
 <CALCETrXaARjGa+fCmxDDYNQCgv0ZSm+DaUFoXFmRxU9J245HxQ@mail.gmail.com>
 <CA+55aFzr_tvdjsq1B+N1zrprNe-qfwo0At+r8uKiS=BGN_92vQ@mail.gmail.com>
 <20180126180722.GA13338@ZenIV.linux.org.uk>
 <CA+55aFydRUyNWz5M2nWWMsLk5dW5JjRRNcFjP62yecAJ_bSDpQ@mail.gmail.com>
 <CALCETrU9t1TO_Y7tmHnq0Qqrpmm3bBJzaAbPBV0vmtEvo28JCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU9t1TO_Y7tmHnq0Qqrpmm3bBJzaAbPBV0vmtEvo28JCw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alan Cox <alan@linux.intel.com>, David Laight <David.Laight@aculab.com>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Andy,

On Fri, Jan 26, 2018 at 10:23:23AM -0800, Andy Lutomirski wrote:
> On Fri, Jan 26, 2018 at 10:13 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Fri, Jan 26, 2018 at 10:07 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >>
> >> Umm...  What about other architectures?  Or do you want SYSCALL_DEFINE...
> >> to be per-arch?  I wonder how much would that "go through pt_regs" hurt
> >> on something like sparc...
> >
> > No, but I just talked to Will Deacon about register clearing on entry,
> > and so I suspect that arm64 might want something similar too.
> >
> > So I think some opt-in for letting architectures add their own
> > function would be good. Because it wouldn't be all architectures, but
> > it probably _would_ be more than just x86.
> >
> > You need to add architecture-specific "load argX from ptregs" macros anyway.
> 
> I mocked that up, and it's straightforward.  I ended up with something like:
> 
> #define __ARCH_SYSCALL_ARGS(n, ...) (regs->di, ...)
> 
> (obviously modified so it actually compiles.)
> 
> The issue is that doing it this way gives us, effectively:
> 
> long sys_foo(int a, int b)
> {
>   body here;
> }
> 
> long SyS_foo(const struct pt_regs *regs)
> {
>   return sys_foo(regs->di, regs->si);
> }
> 
> whereas what we want is *static* long sys_foo(...).  So I could split
> the macros into:
> 
> DEFINE_SYSCALL2(foo, ....)
> 
> and
> 
> DEFINE_EXTERN_SYSCALL2(foo, ...)
> 
> or I could just fix up all the code that expects calling sys_foo()
> across files to work.

Another issue with this style of macro definition exists on architectures
where the calling convention needs you to carry state around depending on
how you packed the previous parameters. For example, on 32-bit ARM, 64-bit
values are passed in adjacent pairs of registers but the low numbered
register needs to be even. This is what stopped me from trying to use
existing helpers such as syscall_get_arguments to unpack the pt_regs
and it generally means that anything that says "get me argument n" is going
to require constructing arguments 0..n-1 first.

To do this properly I think we'll either need to pass back the size and
current register offset to the arch code, or just allow the thing to be
overridden per syscall (the case above isn't especially frequent).

Will
