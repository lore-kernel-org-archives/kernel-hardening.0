MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CALCETrU9t1TO_Y7tmHnq0Qqrpmm3bBJzaAbPBV0vmtEvo28JCw@mail.gmail.com>
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
 <CALCETrU9t1TO_Y7tmHnq0Qqrpmm3bBJzaAbPBV0vmtEvo28JCw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Jan 2018 10:54:21 -0800
Message-ID: <CA+55aFyNbPaezQpsi+Wx1KZkeWSehoEWatN43A8ZmCtKn03vuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: Andy Lutomirski <luto@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alan Cox <alan@linux.intel.com>, David Laight <David.Laight@aculab.com>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 26, 2018 at 10:23 AM, Andy Lutomirski <luto@kernel.org> wrote:
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
> whereas what we want is *static* long sys_foo(...).

How about just marking 'sys_foo()' as being always_inline (but still
not static)? Because the case that _matters_ is that SyS_foo(), thing
when this is enabled.

Sure, you'll get two copies of the code (one in SyS_foo(), the other
being the callable-from C 'sys_foo()' that is exported and almost
never used). But that seems a fairly small price to pay. We could
leave it for later to try to get rid of the unused copies entirely.

             Linus
