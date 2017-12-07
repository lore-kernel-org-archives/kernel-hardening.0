Date: Thu, 7 Dec 2017 16:17:11 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171207051711.GB2191@eros>
References: <CA+55aFxgGb13hqoNQ8bzFn4ENZM25PBSdi5pkFUBa5Hk+j-s3Q@mail.gmail.com>
 <324abe19f1ee4177911d2fc48899ac8a@AcuMS.aculab.com>
 <CAGXu5j+xUt+coLCKg9qeCrTzc7HEM7KP=1Z-xTiDXWSRYibJQg@mail.gmail.com>
 <c47f7659676246d6bbeb5230b952a5ad@AcuMS.aculab.com>
 <596c917e-3183-d80a-89d4-97e0eb5dc077@infradead.org>
 <CA+55aFw3AZtzf6KHS4desHJ3CajKs46VQxOi6-+0U8A4y0v6ug@mail.gmail.com>
 <20171206013657.GA479@jagdpanzerIV>
 <CA+55aFzMydq1TizkPOjZmRb_eKtHCk3w-xdO-Ce2jw9tu3bsGg@mail.gmail.com>
 <CAMuHMdUebiN16BA6qLO+Wv2LetdYgbmd8E_e74hQj52yEUwPOQ@mail.gmail.com>
 <20171206084537.GA462@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171206084537.GA462@jagdpanzerIV>
Subject: [kernel-hardening] Re: [PATCH V11 4/5] vsprintf: add printk specifier %px
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Linus Torvalds <torvalds@linux-foundation.org>, Randy Dunlap <rdunlap@infradead.org>, David Laight <David.Laight@aculab.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?iso-8859-1?Q?Krcm=E1r?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 06, 2017 at 05:45:37PM +0900, Sergey Senozhatsky wrote:
> On (12/06/17 09:32), Geert Uytterhoeven wrote:
> [..]
> > >> show_fault_oops(struct pt_regs *regs, unsigned long error_code,
> > >>                 unsigned long address)
> > >> ...
> > >>         printk(KERN_CONT " at %p\n", (void *) address);
> > >>         printk(KERN_ALERT "IP: %pS\n", (void *)regs->ip);
> > >
> > > So %pS isn't %p, and shows the symbolic name.
> > 
> > If the symbolic name is available.
> > Else it prints the non-hashed pointer value (FTR).


Well, this

[RFC 0/3] kallsyms: don't leak address when printing symbol

_trys_ to fix that

> hm, indeed. and !CONFIG_KALLSYMS config turns %pS/%ps
> into special_hex_number().

But totally misses this :(

"<no-sym>" would be better returned when !CONFIG_KALLSYMS, right?

thanks,
Tobin.
