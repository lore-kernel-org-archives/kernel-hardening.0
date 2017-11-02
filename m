From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Thu, 2 Nov 2017 13:43:24 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC563F4B8075@ORSMSX115.amr.corp.intel.com>
References: <1508986436-31966-1-git-send-email-me@tobin.cc>
 <20171027133301.GA612@tigerII.localdomain> <20171031233533.GD3585@eros>
 <20171102082344.GC655@jagdpanzerIV> <20171102101449.GG7499@eros>
In-Reply-To: <20171102101449.GG7499@eros>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH V8 0/2] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>



> -----Original Message-----
> From: Tobin C. Harding [mailto:me@tobin.cc]
> Sent: Thursday, November 2, 2017 3:15 AM
> To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>; kernel-
> hardening@lists.openwall.com; Jason A. Donenfeld <Jason@zx2c4.com>;
> Theodore Ts'o <tytso@mit.edu>; Linus Torvalds <torvalds@linux-
> foundation.org>; Kees Cook <keescook@chromium.org>; Paolo Bonzini
> <pbonzini@redhat.com>; Tycho Andersen <tycho@docker.com>; Roberts,
> William C <william.c.roberts@intel.com>; Tejun Heo <tj@kernel.org>; Jorda=
n
> Glover <Golden_Miller83@protonmail.ch>; Greg KH
> <gregkh@linuxfoundation.org>; Petr Mladek <pmladek@suse.com>; Joe
> Perches <joe@perches.com>; Ian Campbell <ijc@hellion.org.uk>; Catalin Mar=
inas
> <catalin.marinas@arm.com>; Will Deacon <wilal.deacon@arm.com>; Steven
> Rostedt <rostedt@goodmis.org>; Chris Fries <cfries@google.com>; Dave
> Weinstein <olorin@google.com>; Daniel Micay <danielmicay@gmail.com>; Djal=
al
> Harouni <tixxdz@gmail.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V8 0/2] printk: hash addresses printed with %p
>=20
> On Thu, Nov 02, 2017 at 05:23:44PM +0900, Sergey Senozhatsky wrote:
> > On (11/01/17 10:35), Tobin C. Harding wrote:
> > [..]
> > > Yes. The question has been raised will we be here again in 6 years
> > > time trying to fix all the uses of %x. And there are already 29K
> > > uses of %[xX] in tree, which of these are leaking addresses? This is =
why Linus'
> > > has commented that really effort should be directed at finding the
> > > leaks as they happen (in procfs, sysfs, dmesg) instead of fixing
> > > this in the code.
> >
> > got it. thanks.
> >
> > > So far I haven't been able to come up with any meaningful way to do
> > > this on 32 bit machines. There is a patch adding a script to catch
> > > leaks on 64 bit machines in flight.
> >
> > who is expected to run that script?
>=20
> If one person runs it and finds one leaking address, I'd say it wast wort=
h writing. If
> a bunch of people with different set ups run it and we find a bunch of le=
aking
> addresses, WIN!

I wonder if the 0 day testing robot could run it....

>=20
> Your comment did give me the idea of adding some output to the command
> offering an email address to send suspicious output for those who do not =
wish to
> investigate it further. I can put my email address if there is not a bett=
er option.
>=20
> > BTW, can BPF/eBPF printk addresses?
>=20
> I know absolutely zero about BPF/eBPF. I guess now is a good time to lear=
n.
>=20
> > > This patch needs to be a small part of a continued effort to stop
> > > the leaks if we want to have any hope of stopping them.
> > >
> > > If you have any suggestions on dealing with %x please do say. We
> > > have code changes, compiler warnings, and checkpatch - none of which
> > > immediately seem great.
> >
> > hm... just a huge pile of if's
> >
> > 	if (is_vmalloc_addr(addr))
> > 		do_hashing(addr);
> > 	else if (__module_address(addr))
> > 		do_hashing(addr);
> > 	else if (is_kernel(addr) || is_kernel_inittext(addr))
> > 	...
> >
> > but that's going to be really messy and "iffy".
>=20
> This is the only suggestion we have so far.
>=20
> thanks,
> Tobin.
