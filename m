MIME-Version: 1.0
In-Reply-To: <20170425062324.pdpi5v7ypobw74ki@gmail.com>
References: <20170410164420.64003-1-thgarnie@google.com> <CAGXu5j+J67zC9tcncacHTDvXKMF3HZuPCivk-Uz4J6h-cEv-qQ@mail.gmail.com>
 <20170425062324.pdpi5v7ypobw74ki@gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 25 Apr 2017 07:12:56 -0700
Message-ID: <CAJcbSZGY3JmZankf+d6=gfg9gBWUoVUkWLDnCzaC81scPm+uBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v7 1/4] syscalls: Restore address limit after a syscall
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 24, 2017 at 11:23 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> On Mon, Apr 10, 2017 at 9:44 AM, Thomas Garnier <thgarnie@google.com> wrote:
>> > This patch ensures a syscall does not return to user-mode with a kernel
>> > address limit. If that happened, a process can corrupt kernel-mode
>> > memory and elevate privileges.
>> >
>> > For example, it would mitigation this bug:
>> >
>> > - https://bugs.chromium.org/p/project-zero/issues/detail?id=990
>> >
>> > The CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE option is also
>> > added so each architecture can optimize this change.
>> >
>> > Signed-off-by: Thomas Garnier <thgarnie@google.com>
>> > Tested-by: Kees Cook <keescook@chromium.org>
>>
>> Ingo, I think this series is ready. Can you pull it? (And if not, what
>> should next steps be?)
>
> I have some feedback for other patches in this series, plus for this one as well:
>
>> > +/*
>> > + * Called before coming back to user-mode. Returning to user-mode with an
>> > + * address limit different than USER_DS can allow to overwrite kernel memory.
>> > + */
>> > +static inline void verify_pre_usermode_state(void) {
>> > +       BUG_ON(!segment_eq(get_fs(), USER_DS));
>> > +}
>
> That's not standard kernel coding style.
>
> Also, patch titles should start with a verb - 75% of the series doesn't.

Will fix both.

>
>> > +#ifndef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>> > +#define __CHECK_USER_CALLER() \
>> > +       bool user_caller = segment_eq(get_fs(), USER_DS)
>> > +#define __VERIFY_PRE_USERMODE_STATE() \
>> > +       if (user_caller) verify_pre_usermode_state()
>> > +#else
>> > +#define __CHECK_USER_CALLER()
>> > +#define __VERIFY_PRE_USERMODE_STATE()
>> > +asmlinkage void address_limit_check_failed(void);
>> > +#endif
>
>> > +#ifdef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>
> That Kconfig name is way too long.
>
> Plus please don't put logical operations into Kconfig names.
>
>> > +/*
>> > + * This function is called when an architecture specific implementation detected
>> > + * an invalid address limit. The generic user-mode state checker will finish on
>> > + * the appropriate BUG_ON.
>> > + */
>> > +asmlinkage void address_limit_check_failed(void)
>> > +{
>> > +       verify_pre_usermode_state();
>> > +       panic("address_limit_check_failed called with a valid user-mode state");
>> > +}
>> > +#endif
>
> Awful naming all around:
>
>         verify_pre_usermode_state()
>         address_limit_check_failed()
>
> Both names start with very common names that makes one read these again and again.
> (And yes, there's lots of bad names in the kernel, but we should not follow bad
> examples.)
>
> Best practice for such functionality is to use a common prefix that is both easy
> to recognize and easy to skip. For example we could use 'addr_limit_check' as the
> prefix:
>
>         addr_limit_check_failed()
>         addr_limit_check_syscall()
>
> No need to over-specify it that it's a "pre" check - it's obvious from existing
> implementation and should be documented in the function itself for new
> implementations.
>
> Harmonize the Kconfig namespace to the common prefix as well, i.e. use something
> like:
>
>         CONFIG_ADDR_LIMIT_CHECK
>
> No need to add 'ARCH' I think - an architecture that enables this should get it
> unconditionally.
>
> etc.
>
> It's all cobbled together I'm afraid and will need more iterations.

Make sense. Thanks for the feedback.

>
> Thanks,
>
>         Ingo



-- 
Thomas
