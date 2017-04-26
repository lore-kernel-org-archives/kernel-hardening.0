MIME-Version: 1.0
In-Reply-To: <20170426081229.6wnugrs7w3at4xry@gmail.com>
References: <20170410164420.64003-1-thgarnie@google.com> <20170425063305.hwjuxupa37rwe6zj@gmail.com>
 <CAJcbSZH7Y6iBy3T3iWyh_AaFJ+TidP7E9iQEuCbShQrcTKGoyw@mail.gmail.com> <20170426081229.6wnugrs7w3at4xry@gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 26 Apr 2017 07:09:14 -0700
Message-ID: <CAJcbSZGKknsc6YdwFjd-JHnXA0wjEpU7rCYjJCezQ7bwAxMn1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v7 1/4] syscalls: Restore address limit after a syscall
To: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, linux-arm-kernel@lists.infradead.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 26, 2017 at 1:12 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Thomas Garnier <thgarnie@google.com> wrote:
>
>> >> +#ifdef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>> >> +/*
>> >> + * This function is called when an architecture specific implementation detected
>> >> + * an invalid address limit. The generic user-mode state checker will finish on
>> >> + * the appropriate BUG_ON.
>> >> + */
>> >> +asmlinkage void address_limit_check_failed(void)
>> >> +{
>> >> +     verify_pre_usermode_state();
>> >> +     panic("address_limit_check_failed called with a valid user-mode state");
>> >
>> > It's very unconstructive to unconditionally panic the system, just because some
>> > kernel code leaked the address limit! Do a warn-once printout and kill the current
>> > task (i.e. don't continue execution), but don't crash everything else!
>>
>> The original change did not crash the kernel for this exact reason.
>> Through reviews, there was an overall agreement that the kernel should
>> not continue in this state.
>
> Ok, I guess we can try that - but the panic message is still pretty misleading:
>
>         panic("address_limit_check_failed called with a valid user-mode state");
>
> ... so it was called with a _valid_ user-mode state, and we crash due to something
> valid? Huh?

Yes the message is accurate but I agree that it is misleading and I
will improve it. The address_limit_check_failed function is called by
assembly code on different architectures once the state was detected
as invalid. Instead of crashing at different places, we redirect to
the generic handler (verify_pre_usermode_state) that will crash on the
appropriate BUG_ON line. The address_limit_check_failed function is
not supposed to comeback, the panic call is just a safe guard.

>
> ( Also, the style rule applies to kernel messages as well: function names should
>   be referred to as "function_name()". )

Will change.

>
> Thanks,
>
>         Ingo



-- 
Thomas
