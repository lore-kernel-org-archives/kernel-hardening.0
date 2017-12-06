Date: Wed, 6 Dec 2017 11:15:53 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Message-ID: <20171206021553.GC479@jagdpanzerIV>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
 <1511921105-3647-5-git-send-email-me@tobin.cc>
 <CA+55aFxgGb13hqoNQ8bzFn4ENZM25PBSdi5pkFUBa5Hk+j-s3Q@mail.gmail.com>
 <324abe19f1ee4177911d2fc48899ac8a@AcuMS.aculab.com>
 <CAGXu5j+xUt+coLCKg9qeCrTzc7HEM7KP=1Z-xTiDXWSRYibJQg@mail.gmail.com>
 <c47f7659676246d6bbeb5230b952a5ad@AcuMS.aculab.com>
 <596c917e-3183-d80a-89d4-97e0eb5dc077@infradead.org>
 <CA+55aFw3AZtzf6KHS4desHJ3CajKs46VQxOi6-+0U8A4y0v6ug@mail.gmail.com>
 <20171206013657.GA479@jagdpanzerIV>
 <CA+55aFzMydq1TizkPOjZmRb_eKtHCk3w-xdO-Ce2jw9tu3bsGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzMydq1TizkPOjZmRb_eKtHCk3w-xdO-Ce2jw9tu3bsGg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH V11 4/5] vsprintf: add printk specifier %px
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, David Laight <David.Laight@aculab.com>, Kees Cook <keescook@chromium.org>, "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?iso-8859-1?Q?Krcm=E1r?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On (12/05/17 17:59), Linus Torvalds wrote:
[..]
> On Tue, Dec 5, 2017 at 5:36 PM, Sergey Senozhatsky
> <sergey.senozhatsky.work@gmail.com> wrote:
> > I see some %p-s being used in _supposedly_ important output,
> > like arch/x86/mm/fault.c
> >
> > show_fault_oops(struct pt_regs *regs, unsigned long error_code,
> >                 unsigned long address)
> > ...
> >         printk(KERN_CONT " at %p\n", (void *) address);
> >         printk(KERN_ALERT "IP: %pS\n", (void *)regs->ip);
> 
> So %pS isn't %p, and shows the symbolic name.

sure, agreed. by "some %p-s being used" I meant the grep result,
not just x86 show_fault_oops().


> But yes, that "at %p" should definitely be %px.

more %p grepping [filtering out all `%ps %pf %pb' variants] gives
a huge number of print outs that potentially can be broken now

arch/x86/kernel/kprobes/core.c:		printk(KERN_WARNING "Unrecoverable kprobe detected at %p.\n",
arch/x86/kernel/kprobes/core.c:			       "current sp %p does not match saved sp %p\n",
arch/x86/kernel/kprobes/core.c:			printk(KERN_ERR "Saved registers for jprobe %p\n", jp);

arch/x86/kernel/head_32.S:	.asciz "Unknown interrupt or fault at: %p %p %p\n"
arch/x86/kernel/irq_32.c:	printk(KERN_DEBUG "CPU %u irqstacks, hard=%p soft=%p\n",

arch/x86/kernel/smpboot.c:	pr_debug("Stack at about %p\n", &cpuid);
arch/x86/kernel/traps.c:	printk(KERN_EMERG "BUG: stack guard page was hit at %p (stack is %p..%p)\n",


so I'm not in position to suggest the removal of those print outs or to
decide if those are important at all, just saying that that "I'm confused
by pointer values and can't debug" might be more likely that we thought.


> So my gut feel is that those printouts should probably just be
> removed. They have some very old historical reasons: we've printed out
> the page directory pointers (and followed the page tables) since at
> least back in the 1.1.x days. This is from the 1.1.7 patch, back when
> mm/memory.c was all about x86:

I see, thanks.

	-ss
