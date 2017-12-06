MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20171206013657.GA479@jagdpanzerIV>
References: <1511921105-3647-1-git-send-email-me@tobin.cc> <1511921105-3647-5-git-send-email-me@tobin.cc>
 <CA+55aFxgGb13hqoNQ8bzFn4ENZM25PBSdi5pkFUBa5Hk+j-s3Q@mail.gmail.com>
 <324abe19f1ee4177911d2fc48899ac8a@AcuMS.aculab.com> <CAGXu5j+xUt+coLCKg9qeCrTzc7HEM7KP=1Z-xTiDXWSRYibJQg@mail.gmail.com>
 <c47f7659676246d6bbeb5230b952a5ad@AcuMS.aculab.com> <596c917e-3183-d80a-89d4-97e0eb5dc077@infradead.org>
 <CA+55aFw3AZtzf6KHS4desHJ3CajKs46VQxOi6-+0U8A4y0v6ug@mail.gmail.com> <20171206013657.GA479@jagdpanzerIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Dec 2017 17:59:16 -0800
Message-ID: <CA+55aFzMydq1TizkPOjZmRb_eKtHCk3w-xdO-Ce2jw9tu3bsGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH V11 4/5] vsprintf: add printk specifier %px
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, David Laight <David.Laight@aculab.com>, Kees Cook <keescook@chromium.org>, "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?Q?Radim_Krcm=C3=A1r?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 5, 2017 at 5:36 PM, Sergey Senozhatsky
<sergey.senozhatsky.work@gmail.com> wrote:
> I see some %p-s being used in _supposedly_ important output,
> like arch/x86/mm/fault.c
>
> show_fault_oops(struct pt_regs *regs, unsigned long error_code,
>                 unsigned long address)
> ...
>         printk(KERN_CONT " at %p\n", (void *) address);
>         printk(KERN_ALERT "IP: %pS\n", (void *)regs->ip);

So %pS isn't %p, and shows the symbolic name.

But yes, that "at %p" should definitely be %px.

In fact, it used to be a "%08lx" - and the value we print out is
"unsigned long - but then when we unified the 32- and 64-bit
architectures, using "%p" and a cast was a convenient way to unify the
32-bit %08lx and the 16-bit %016lx formats.

Will fix.

> a quick %p grep gives me the following list:
...
> or is it OK to show hashes instead of pgd or pmd pointers?

So my gut feel is that those printouts should probably just be
removed. They have some very old historical reasons: we've printed out
the page directory pointers (and followed the page tables) since at
least back in the 1.1.x days. This is from the 1.1.7 patch, back when
mm/memory.c was all about x86:

+       printk(KERN_ALERT "current->tss.cr3 = %08lx, %%cr3 = %08lx\n",
+               current->tss.cr3, user_esp);
+       user_esp = ((unsigned long *) user_esp)[address >> 22];
+       printk(KERN_ALERT "*pde = %08lx\n", user_esp);

so it's more historical than sensible, I think.

               Linus
