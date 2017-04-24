MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170410164420.64003-1-thgarnie@google.com>
References: <20170410164420.64003-1-thgarnie@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Apr 2017 16:57:34 -0700
Message-ID: <CAGXu5j+J67zC9tcncacHTDvXKMF3HZuPCivk-Uz4J6h-cEv-qQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v7 1/4] syscalls: Restore address limit after a syscall
To: Thomas Garnier <thgarnie@google.com>, Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 10, 2017 at 9:44 AM, Thomas Garnier <thgarnie@google.com> wrote:
> This patch ensures a syscall does not return to user-mode with a kernel
> address limit. If that happened, a process can corrupt kernel-mode
> memory and elevate privileges.
>
> For example, it would mitigation this bug:
>
> - https://bugs.chromium.org/p/project-zero/issues/detail?id=990
>
> The CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE option is also
> added so each architecture can optimize this change.
>
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> Tested-by: Kees Cook <keescook@chromium.org>

Ingo, I think this series is ready. Can you pull it? (And if not, what
should next steps be?)

-Kees

> ---
> Based on next-20170410
> ---
>  arch/s390/Kconfig        |  1 +
>  include/linux/syscalls.h | 26 +++++++++++++++++++++++++-
>  init/Kconfig             |  6 ++++++
>  kernel/sys.c             | 13 +++++++++++++
>  4 files changed, 45 insertions(+), 1 deletion(-)
>
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index d25435d94b6e..489a0cc6e46b 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -103,6 +103,7 @@ config S390
>         select ARCH_INLINE_WRITE_UNLOCK_BH
>         select ARCH_INLINE_WRITE_UNLOCK_IRQ
>         select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
> +       select ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>         select ARCH_SAVE_PAGE_KEYS if HIBERNATION
>         select ARCH_SUPPORTS_ATOMIC_RMW
>         select ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 980c3c9b06f8..801a7a74fe28 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -191,6 +191,27 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>         SYSCALL_METADATA(sname, x, __VA_ARGS__)                 \
>         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
>
> +
> +/*
> + * Called before coming back to user-mode. Returning to user-mode with an
> + * address limit different than USER_DS can allow to overwrite kernel memory.
> + */
> +static inline void verify_pre_usermode_state(void) {
> +       BUG_ON(!segment_eq(get_fs(), USER_DS));
> +}
> +
> +#ifndef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
> +#define __CHECK_USER_CALLER() \
> +       bool user_caller = segment_eq(get_fs(), USER_DS)
> +#define __VERIFY_PRE_USERMODE_STATE() \
> +       if (user_caller) verify_pre_usermode_state()
> +#else
> +#define __CHECK_USER_CALLER()
> +#define __VERIFY_PRE_USERMODE_STATE()
> +asmlinkage void address_limit_check_failed(void);
> +#endif
> +
> +
>  #define __PROTECT(...) asmlinkage_protect(__VA_ARGS__)
>  #define __SYSCALL_DEFINEx(x, name, ...)                                        \
>         asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))       \
> @@ -199,7 +220,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>         asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));      \
>         asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))       \
>         {                                                               \
> -               long ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));  \
> +               long ret;                                               \
> +               __CHECK_USER_CALLER();                                  \
> +               ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));       \
> +               __VERIFY_PRE_USERMODE_STATE();                          \
>                 __MAP(x,__SC_TEST,__VA_ARGS__);                         \
>                 __PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));       \
>                 return ret;                                             \
> diff --git a/init/Kconfig b/init/Kconfig
> index 7f7027817bce..e5fbd0becfa7 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1958,6 +1958,12 @@ config PROFILING
>  config TRACEPOINTS
>         bool
>
> +config ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
> +       bool
> +       help
> +         Disable the generic pre-usermode state verification. Allow each
> +         architecture to optimize how and when the verification is done.
> +
>  source "arch/Kconfig"
>
>  endmenu                # General setup
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 196c7134bee6..d30530ff8166 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2459,3 +2459,16 @@ COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
>         return 0;
>  }
>  #endif /* CONFIG_COMPAT */
> +
> +#ifdef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
> +/*
> + * This function is called when an architecture specific implementation detected
> + * an invalid address limit. The generic user-mode state checker will finish on
> + * the appropriate BUG_ON.
> + */
> +asmlinkage void address_limit_check_failed(void)
> +{
> +       verify_pre_usermode_state();
> +       panic("address_limit_check_failed called with a valid user-mode state");
> +}
> +#endif
> --
> 2.12.2.715.g7642488e1d-goog
>



-- 
Kees Cook
Pixel Security
