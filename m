Date: Tue, 28 Nov 2017 12:43:43 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171128014343.GR17858@eros>
References: <1511826058-2563-1-git-send-email-me@tobin.cc>
 <CAGXu5jJfppOKj6pD7-ETSqqPOL1hBDQ31ZXj1damJmC4qTqvvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJfppOKj6pD7-ETSqqPOL1hBDQ31ZXj1damJmC4qTqvvw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 0/5] add printk specifier %px, unique identifier
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 04:57:18PM -0800, Kees Cook wrote:
> On Mon, Nov 27, 2017 at 3:40 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > Linus,
> >
> > I know you are bored of this patch set already and this pits your vast
> > experience against my eight months kernel dev experience ;)
> >
> > I humbly maintain that hashing %p and suggesting people use %x
> > _correctly_ isn't a WIN solution.
> >
> > Please don't go easy on me because I'm new, if I'm out of line - say
> > so.
> >
> > This set is based on the following assumptions.
> >
> > 1. We now have leaking_addresses.pl illuminating leaking addresses.
> > 2. We have no _clear_ strategy for fixing leaks once found.
> > 3. We do not have a proposed non opt-in solution.
> > 4. There is a distinct use case for this specifier.
> >
> > Patch 1: Corrects the docs for %pK.
> >
> > Patch 2: Refactors %pK code out of pointer() into helper function.
> >
> > Patch 3: Adds specifier %px, small 'x' was chosen because the hashed hex
> >          value is printed in lower case.
> >
> > Patch 4/5: Provides example usage of new specifier.
> >
> > The hashing code is based on the work done hashing %p during 4.14 dev
> > cycle.
> >
> > Finally, with this patch set in place, we have the added benefit that
> > newbies (me) can quietly go around the kernel 'sweeping up' after
> > leaking addresses. This as apposed to using a hammer and hashing all
> > %p. And if this is deemed too little and too slow we can always search
> > and replace '%p' with '%px'.
> 
> How does this opt-in to %px help? We'll still have %p everywhere. :(
> Why not invert this? %p is hashed and %px is the old %p? Then we can
> move %x users to %px.

This is a really nice twist, I don't know why it hasn't come up
before. For the record it

- Plugs a bunch of potential current leaks.
- Is on by default (*not* opt-in).
- Is easy to use (%p if you don't care, %px if you _really_ want the address).
- Reduces risk of future developers creating grep hell by using %x

(- makes Linus happy because it does everything he has suggested except
promote use of %x)

> I'd still like to see a default-on solution for this class of leaks...

I'll re-spin this tomorrow and see if we can't stop bothering everyone
with it :)

thanks,
Tobin.
