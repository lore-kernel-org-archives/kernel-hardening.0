Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 26 Apr 2017 10:12:29 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170426081229.6wnugrs7w3at4xry@gmail.com>
References: <20170410164420.64003-1-thgarnie@google.com>
 <20170425063305.hwjuxupa37rwe6zj@gmail.com>
 <CAJcbSZH7Y6iBy3T3iWyh_AaFJ+TidP7E9iQEuCbShQrcTKGoyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJcbSZH7Y6iBy3T3iWyh_AaFJ+TidP7E9iQEuCbShQrcTKGoyw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v7 1/4] syscalls: Restore address limit after a syscall
To: Thomas Garnier <thgarnie@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, linux-arm-kernel@lists.infradead.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Thomas Garnier <thgarnie@google.com> wrote:

> >> +#ifdef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
> >> +/*
> >> + * This function is called when an architecture specific implementation detected
> >> + * an invalid address limit. The generic user-mode state checker will finish on
> >> + * the appropriate BUG_ON.
> >> + */
> >> +asmlinkage void address_limit_check_failed(void)
> >> +{
> >> +     verify_pre_usermode_state();
> >> +     panic("address_limit_check_failed called with a valid user-mode state");
> >
> > It's very unconstructive to unconditionally panic the system, just because some
> > kernel code leaked the address limit! Do a warn-once printout and kill the current
> > task (i.e. don't continue execution), but don't crash everything else!
> 
> The original change did not crash the kernel for this exact reason.
> Through reviews, there was an overall agreement that the kernel should
> not continue in this state.

Ok, I guess we can try that - but the panic message is still pretty misleading:

	panic("address_limit_check_failed called with a valid user-mode state");

... so it was called with a _valid_ user-mode state, and we crash due to something 
valid? Huh?

( Also, the style rule applies to kernel messages as well: function names should 
  be referred to as "function_name()". )

Thanks,

	Ingo
