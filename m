Date: Wed, 6 Dec 2017 07:44:02 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171205204402.GD11064@eros>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
 <1511921105-3647-4-git-send-email-me@tobin.cc>
 <CAMuHMdVZWUHNEbfO7OCPQV5Q3bA41c6VpwqfvT37ZEV9AR8chw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVZWUHNEbfO7OCPQV5Q3bA41c6VpwqfvT37ZEV9AR8chw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH V11 3/5] printk: hash addresses printed with %p
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 05, 2017 at 09:20:57PM +0100, Geert Uytterhoeven wrote:
> Hi Tobin,
> 
> On Wed, Nov 29, 2017 at 3:05 AM, Tobin C. Harding <me@tobin.cc> wrote:
> > Currently there exist approximately 14 000 places in the kernel where
> > addresses are being printed using an unadorned %p. This potentially
> > leaks sensitive information regarding the Kernel layout in memory. Many
> > of these calls are stale, instead of fixing every call lets hash the
> > address by default before printing. This will of course break some
> > users, forcing code printing needed addresses to be updated.
> >
> > Code that _really_ needs the address will soon be able to use the new
> > printk specifier %px to print the address.
> 
> > --- a/lib/vsprintf.c
> > +++ b/lib/vsprintf.c
> 
> > +/* Maps a pointer to a 32 bit unique identifier. */
> > +static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
> > +{
> > +       unsigned long hashval;
> > +       const int default_width = 2 * sizeof(ptr);
> > +
> > +       if (unlikely(!have_filled_random_ptr_key)) {
> > +               spec.field_width = default_width;
> > +               /* string length must be less than default_width */
> > +               return string(buf, end, "(ptrval)", spec);
> > +       }
> > +
> > +#ifdef CONFIG_64BIT
> > +       hashval = (unsigned long)siphash_1u64((u64)ptr, &ptr_key);
> > +       /*
> > +        * Mask off the first 32 bits, this makes explicit that we have
> > +        * modified the address (and 32 bits is plenty for a unique ID).
> > +        */
> > +       hashval = hashval & 0xffffffff;
> > +#else
> > +       hashval = (unsigned long)siphash_1u32((u32)ptr, &ptr_key);
> > +#endif
> 
> Would it make sense to keep the 3 lowest bits of the address?
> 
> Currently printed pointers no longer have any correlation with the actual
> alignment in memory of the object, which is a typical cause of a class of bugs.

We'd have to keep the lowest 4 since we are printing in hex, right? This
is easy enough to add. I wasn't the architect behind the hashing but I
can do up a patch and see if anyone who knows crypto objects.

thanks,
Tobin.
