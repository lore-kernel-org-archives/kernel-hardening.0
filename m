MIME-Version: 1.0
In-Reply-To: <CA+55aFydRUyNWz5M2nWWMsLk5dW5JjRRNcFjP62yecAJ_bSDpQ@mail.gmail.com>
References: <CA+55aFyONQeyHit6LcQz_JM5+C9pr61fcWFSpdn=7K_2mZN+oA@mail.gmail.com>
 <CALCETrVUY9p9jMNhuBgM3mWATsr1Fc_ZWc=bjidBkLw7bq5Vdg@mail.gmail.com>
 <CA+55aFwUn7+WiHxL7PBWxNrGB0--HETqUjdRwxi+DkMvCP_CaA@mail.gmail.com>
 <CALCETrV1JHK1ovjjD1vbs08K1an6tq6nbRoAj9uyrY2GUYJJBA@mail.gmail.com>
 <CA+55aFzTXVRPo7OBPMo2OB26GisY8-dg6NaC8ackVJgS9M0+4w@mail.gmail.com>
 <CALCETrU42C1S3nvSuLuamXtp2-s1xBG3q5cSNVOfGThncHxBZA@mail.gmail.com>
 <b8ea504729db4073abf82ebd5d8a53c6@AcuMS.aculab.com> <1516976647.5438.6.camel@linux.intel.com>
 <CALCETrXaARjGa+fCmxDDYNQCgv0ZSm+DaUFoXFmRxU9J245HxQ@mail.gmail.com>
 <CA+55aFzr_tvdjsq1B+N1zrprNe-qfwo0At+r8uKiS=BGN_92vQ@mail.gmail.com>
 <20180126180722.GA13338@ZenIV.linux.org.uk> <CA+55aFydRUyNWz5M2nWWMsLk5dW5JjRRNcFjP62yecAJ_bSDpQ@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 26 Jan 2018 10:23:23 -0800
Message-ID: <CALCETrU9t1TO_Y7tmHnq0Qqrpmm3bBJzaAbPBV0vmtEvo28JCw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Alan Cox <alan@linux.intel.com>, David Laight <David.Laight@aculab.com>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 26, 2018 at 10:13 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jan 26, 2018 at 10:07 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> Umm...  What about other architectures?  Or do you want SYSCALL_DEFINE...
>> to be per-arch?  I wonder how much would that "go through pt_regs" hurt
>> on something like sparc...
>
> No, but I just talked to Will Deacon about register clearing on entry,
> and so I suspect that arm64 might want something similar too.
>
> So I think some opt-in for letting architectures add their own
> function would be good. Because it wouldn't be all architectures, but
> it probably _would_ be more than just x86.
>
> You need to add architecture-specific "load argX from ptregs" macros anyway.

I mocked that up, and it's straightforward.  I ended up with something like:

#define __ARCH_SYSCALL_ARGS(n, ...) (regs->di, ...)

(obviously modified so it actually compiles.)

The issue is that doing it this way gives us, effectively:

long sys_foo(int a, int b)
{
  body here;
}

long SyS_foo(const struct pt_regs *regs)
{
  return sys_foo(regs->di, regs->si);
}

whereas what we want is *static* long sys_foo(...).  So I could split
the macros into:

DEFINE_SYSCALL2(foo, ....)

and

DEFINE_EXTERN_SYSCALL2(foo, ...)

or I could just fix up all the code that expects calling sys_foo()
across files to work.

My mockup patch doesn't actually work because of compat crap, but
that's manageable.

--Andy
