Date: Wed, 6 Dec 2017 10:36:57 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Message-ID: <20171206013657.GA479@jagdpanzerIV>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
 <1511921105-3647-5-git-send-email-me@tobin.cc>
 <CA+55aFxgGb13hqoNQ8bzFn4ENZM25PBSdi5pkFUBa5Hk+j-s3Q@mail.gmail.com>
 <324abe19f1ee4177911d2fc48899ac8a@AcuMS.aculab.com>
 <CAGXu5j+xUt+coLCKg9qeCrTzc7HEM7KP=1Z-xTiDXWSRYibJQg@mail.gmail.com>
 <c47f7659676246d6bbeb5230b952a5ad@AcuMS.aculab.com>
 <596c917e-3183-d80a-89d4-97e0eb5dc077@infradead.org>
 <CA+55aFw3AZtzf6KHS4desHJ3CajKs46VQxOi6-+0U8A4y0v6ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw3AZtzf6KHS4desHJ3CajKs46VQxOi6-+0U8A4y0v6ug@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH V11 4/5] vsprintf: add printk specifier %px
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, David Laight <David.Laight@aculab.com>, Kees Cook <keescook@chromium.org>, "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?iso-8859-1?Q?Krcm=E1r?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hello,

On (12/05/17 13:22), Linus Torvalds wrote:
[..]
> It's not like those hex numbers were really helping people anyway.
> We've turned off most of them on x86 oops reports long ago (and
> entirely independently of the pointer hashing). Having stared at a lot
> of oopses in my time, the only hex numbers that tend to be really
> relevant are (a) the register contents (which aren't %p anyway), and
> things like the faulting address (which is not, and never has been, %p
> on x86, but might be on some other architecture).

I see some %p-s being used in _supposedly_ important output,
like arch/x86/mm/fault.c

show_fault_oops(struct pt_regs *regs, unsigned long error_code,
		unsigned long address)
...
	printk(KERN_CONT " at %p\n", (void *) address);
	printk(KERN_ALERT "IP: %pS\n", (void *)regs->ip);


a quick %p grep gives me the following list:

arch/arm/mm/fault.c:    pr_alert("pgd = %p\n", mm->pgd);
arch/arm64/mm/fault.c:  pr_alert("%s pgtable: %luk pages, %u-bit VAs, pgd = %p\n",
arch/arm64/mm/fault.c:          pr_info_ratelimited("%s[%d]: %s exception: pc=%p sp=%p\n",
arch/m68k/mm/fault.c:   pr_debug("send_fault_sig: %p,%d,%d\n", siginfo.si_addr,
arch/m68k/mm/fault.c:           pr_cont(" at virtual address %p\n", siginfo.si_addr);
arch/m68k/mm/fault.c:   pr_debug("do page fault:\nregs->sr=%#x, regs->pc=%#lx, address=%#lx, %ld, %p\n",
arch/microblaze/mm/fault.c:             pr_emerg("Page fault in user mode with faulthandler_disabled(), mm = %p\n",
arch/mn10300/mm/fault.c:        printk(KERN_DEBUG "pgd entry %p: %016Lx\n",
arch/mn10300/mm/fault.c:        printk(KERN_DEBUG "pmd entry %p: %016Lx\n",
arch/mn10300/mm/fault.c:        printk(KERN_DEBUG "pte entry %p: %016Lx\n",
arch/mn10300/mm/fault.c:        printk(KERN_DEBUG "--- do_page_fault(%p,%s:%04lx,%08lx)\n",
arch/powerpc/mm/fault.c:                                           " mm=%p\n",
arch/sh/mm/fault.c:     printk(KERN_ALERT "pgd = %p\n", pgd);
arch/unicore32/mm/fault.c:      printk(KERN_ALERT "pgd = %p\n", mm->pgd);
arch/x86/mm/fault.c:    printk(KERN_CONT " at %p\n", (void *) address);
arch/x86/mm/fault.c:    printk(KERN_ALERT "IP: %pS\n", (void *)regs->ip);
arch/x86/mm/fault.c:    printk("%s%s[%d]: segfault at %lx ip %p sp %p error %lx",


or is it OK to show hashes instead of pgd or pmd pointers?

	-ss
