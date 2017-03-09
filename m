MIME-Version: 1.0
In-Reply-To: <20170309120955.GA6320@leverpostej>
References: <20170309012456.5631-1-thgarnie@google.com> <20170309120955.GA6320@leverpostej>
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 9 Mar 2017 07:52:30 -0800
Message-ID: <CAJcbSZHY5Et+EqjbQPx4KfgAiaYCo29vFfSbX2Aj=BZBg8i0Gg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/4] syscalls: Restore address limit after a syscall
To: Mark Rutland <mark.rutland@arm.com>
Cc: David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Frederic Weisbecker <fweisbec@gmail.com>, Stephen Smalley <sds@tycho.nsa.gov>, Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@suse.com>, Christian Borntraeger <borntraeger@de.ibm.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, He Chen <he.chen@linux.intel.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Pratyush Anand <panand@redhat.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andre Przywara <andre.przywara@arm.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, linux-arm-kernel@lists.infradead.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 9, 2017 at 4:09 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,
>
> On Wed, Mar 08, 2017 at 05:24:53PM -0800, Thomas Garnier wrote:
>> This patch ensures a syscall does not return to user-mode with a kernel
>> address limit. If that happened, a process can corrupt kernel-mode
>> memory and elevate privileges.
>>
>> For example, it would mitigation this bug:
>>
>> - https://bugs.chromium.org/p/project-zero/issues/detail?id=990
>>
>> If the CONFIG_BUG_ON_DATA_CORRUPTION option is enabled, an incorrect
>> state will result in a BUG_ON.
>>
>> The CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE option is also
>> added so each architecture can optimize this change.
>
>> +#ifndef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>> +static inline bool has_user_ds(void) {
>> +     bool ret = segment_eq(get_fs(), USER_DS);
>> +     // Prevent re-ordering the call
>> +     barrier();
>
> What ordering are we trying to ensure, that isn't otherwise given?
>
> We expect get_fs() and set_fs() to be ordered w.r.t. each other and
> w.r.t. uaccess uses, or we'd need barriers all over the place.
>
> Given that, I can't see why we need a barrier here. So this needs a
> better comment, at least.
>

I was half sure of that so that's why I added the barrier. If it is
not needed then I can remove it. Thanks!

>> +     return ret;
>> +}
>> +#else
>> +static inline bool has_user_ds(void) {
>> +     return false;
>> +}
>> +#endif
>
> It would be simpler to wrap the call entirely, e.g. have:
>
> #ifdef CONFIG_WHATEVER
> static inline void verify_pre_usermode_state(void)
> {
>         if (segment_eq(get_fs(), USER_DS))
>                 __verify_pre_usermode_state();
> }
> #else
> static inline void verify_pre_usermode_state(void) { }
> #endif
>
>> @@ -199,7 +215,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>>       asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));      \
>>       asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))       \
>>       {                                                               \
>> +             bool user_caller = has_user_ds();                       \
>>               long ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));  \
>> +             if (user_caller)                                        \
>> +                     verify_pre_usermode_state();                    \
>
> ... then we can unconditionally use verify_pre_usermode_state() here ...

Not sure I understood that point. The goal is to see if get_fs was
changed, that's why I check before the syscall and I want to ensure
the call is not shuffled after the syscall, therefore the original
barrier.

>
>>               __MAP(x,__SC_TEST,__VA_ARGS__);                         \
>>               __PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));       \
>>               return ret;                                             \
>
> [...]
>
>> +/* Called before coming back to user-mode */
>> +asmlinkage void verify_pre_usermode_state(void)
>
> ... and we just prepend a couple of underscores here.
>
>> +{
>> +     if (CHECK_DATA_CORRUPTION(!segment_eq(get_fs(), USER_DS),
>> +                               "incorrect get_fs() on user-mode return"))
>> +             set_fs(USER_DS);
>> +}
>
> Thanks,
> Mark.



-- 
Thomas
