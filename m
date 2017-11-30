From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 30 Nov 2017 10:23:44 +0000
Message-ID: <28ab447e24684c58a5e03af44edd6d5a@AcuMS.aculab.com>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
 <20171129152040.ed5b28c198093de8968aac9b@linux-foundation.org>
In-Reply-To: <20171129152040.ed5b28c198093de8968aac9b@linux-foundation.org>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH V11 0/5] hash addresses printed with %p
To: 'Andrew Morton' <akpm@linux-foundation.org>, "Tobin C. Harding" <me@tobin.cc>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo
 Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan
 Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?iso-8859-2?Q?Radim_Krcm=E1r?= <rkrcmar@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Network
 Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry
 Vyukov <dvyukov@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Andrew Morton
> Sent: 29 November 2017 23:21
> >
> > The added advantage of hashing %p is that security is now opt-out, if
> > you _really_ want the address you have to work a little harder and use
> > %px.

You need a system-wide opt-out that prints the actual values.
Otherwise developers will use something else to print addresses and
the code will remain in the released drivers.

> > The idea for creating the printk specifier %px to print the actual
> > address was suggested by Kees Cook (see below for email threads by
> > subject).
>=20
> Maybe I'm being thick, but...  if we're rendering these addresses
> unusable by hashing them, why not just print something like
> "<obscured>" in their place?  That loses the uniqueness thing but I
> wonder how valuable that is in practice?

My worry is that is you get a kernel 'oops' print with actual register
values you have no easy way of tying an address or address+offset to
the corresponding hash(address) printed elsewhere.

	David
