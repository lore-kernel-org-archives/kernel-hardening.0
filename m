Date: Thu, 30 Nov 2017 10:34:37 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171129233437.GP6217@eros>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
 <20171129152040.ed5b28c198093de8968aac9b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171129152040.ed5b28c198093de8968aac9b@linux-foundation.org>
Subject: [kernel-hardening] Re: [PATCH V11 0/5] hash addresses printed with %p
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 29, 2017 at 03:20:40PM -0800, Andrew Morton wrote:
> On Wed, 29 Nov 2017 13:05:00 +1100 "Tobin C. Harding" <me@tobin.cc> wrote:
> 
> > Currently there exist approximately 14 000 places in the Kernel where
> > addresses are being printed using an unadorned %p. This potentially
> > leaks sensitive information regarding the Kernel layout in memory. Many
> > of these calls are stale, instead of fixing every call lets hash the
> > address by default before printing. This will of course break some
> > users, forcing code printing needed addresses to be updated. We can add
> > a printk specifier for this purpose (%px) to give developers a clear
> > upgrade path for breakages caused by applying this patch set.
> > 
> > The added advantage of hashing %p is that security is now opt-out, if
> > you _really_ want the address you have to work a little harder and use
> > %px.
> > 
> > The idea for creating the printk specifier %px to print the actual
> > address was suggested by Kees Cook (see below for email threads by
> > subject).
> 
> Maybe I'm being thick, but...  if we're rendering these addresses
> unusable by hashing them, why not just print something like
> "<obscured>" in their place?  That loses the uniqueness thing but I
> wonder how valuable that is in practice?

The discussion on this has been fragmented over _at least_ 5 patch sets
with totally different subjects. And I only just added you to the CC
list, my apologies if this is a bit confusing.

Consensus was that if we provide a unique identifier (the hashed
address) then this is useful for debugging (i.e differentiating between
structs when you have a list of them).

The first 32 bits (on 64 bit machines) were zeroed out because

1. they are unnecessary in achieving the aim.
2. it reduces noise.
3. makes explicit some funny business was going on.

And bonus points, hopefully we don't break userland tools that parse
addresses if the format is still the same.

thanks,
Tobin.
