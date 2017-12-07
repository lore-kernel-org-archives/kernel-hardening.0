Date: Thu, 7 Dec 2017 16:12:04 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171207051204.GA2191@eros>
References: <1511921105-3647-5-git-send-email-me@tobin.cc>
 <CA+55aFxgGb13hqoNQ8bzFn4ENZM25PBSdi5pkFUBa5Hk+j-s3Q@mail.gmail.com>
 <324abe19f1ee4177911d2fc48899ac8a@AcuMS.aculab.com>
 <CAGXu5j+xUt+coLCKg9qeCrTzc7HEM7KP=1Z-xTiDXWSRYibJQg@mail.gmail.com>
 <c47f7659676246d6bbeb5230b952a5ad@AcuMS.aculab.com>
 <596c917e-3183-d80a-89d4-97e0eb5dc077@infradead.org>
 <CA+55aFw3AZtzf6KHS4desHJ3CajKs46VQxOi6-+0U8A4y0v6ug@mail.gmail.com>
 <20171206013657.GA479@jagdpanzerIV>
 <CA+55aFzMydq1TizkPOjZmRb_eKtHCk3w-xdO-Ce2jw9tu3bsGg@mail.gmail.com>
 <CAMuHMdUebiN16BA6qLO+Wv2LetdYgbmd8E_e74hQj52yEUwPOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUebiN16BA6qLO+Wv2LetdYgbmd8E_e74hQj52yEUwPOQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH V11 4/5] vsprintf: add printk specifier %px
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, David Laight <David.Laight@aculab.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?iso-8859-1?Q?Krcm=E1r?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 06, 2017 at 09:32:14AM +0100, Geert Uytterhoeven wrote:
> Hi Linus,
> 
> On Wed, Dec 6, 2017 at 2:59 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Tue, Dec 5, 2017 at 5:36 PM, Sergey Senozhatsky
> > <sergey.senozhatsky.work@gmail.com> wrote:
> >> I see some %p-s being used in _supposedly_ important output,
> >> like arch/x86/mm/fault.c
> >>
> >> show_fault_oops(struct pt_regs *regs, unsigned long error_code,
> >>                 unsigned long address)
> >> ...
> >>         printk(KERN_CONT " at %p\n", (void *) address);
> >>         printk(KERN_ALERT "IP: %pS\n", (void *)regs->ip);
> >
> > So %pS isn't %p, and shows the symbolic name.
> 
> If the symbolic name is available.
> Else it prints the non-hashed pointer value (FTR).

I'm trying to fix this :)

[RFC 0/3] kallsyms: don't leak address when printing symbol

thanks,
Tobin.
