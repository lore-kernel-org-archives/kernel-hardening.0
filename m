MIME-Version: 1.0
In-Reply-To: <1532603461-21415-1-git-send-email-alex.popov@linux.com>
References: <f638e0a5-74eb-f973-5bcf-55cb8ec78db9@linux.com> <1532603461-21415-1-git-send-email-alex.popov@linux.com>
From: Kees Cook <keescook@google.com>
Date: Thu, 26 Jul 2018 09:08:08 -0700
Message-ID: <CAGXu5jJAxK-yJWKx0S6_v6rXH2xVKQ8zxdXJmKuwqMqi5YFnTg@mail.gmail.com>
Subject: Re: [PATCH v14 7/7] stackleak: Allow runtime disabling of kernel
 stack erasing
Content-Type: text/plain; charset="UTF-8"
To: Alexander Popov <alex.popov@linux.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 26, 2018 at 4:11 AM, Alexander Popov <alex.popov@linux.com> wrote:
> Introduce CONFIG_STACKLEAK_RUNTIME_DISABLE option, which provides
> 'stack_erasing' sysctl. It can be used in runtime to control kernel
> stack erasing for kernels built with CONFIG_GCC_PLUGIN_STACKLEAK.
>
> Suggested-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Alexander Popov <alex.popov@linux.com>
> ---
>  Documentation/sysctl/kernel.txt | 18 ++++++++++++++++++
>  include/linux/stackleak.h       |  6 ++++++
>  kernel/stackleak.c              | 38 ++++++++++++++++++++++++++++++++++++++
>  kernel/sysctl.c                 | 15 ++++++++++++++-
>  scripts/gcc-plugins/Kconfig     |  8 ++++++++
>  5 files changed, 84 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index eded671d..1feae79 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -87,6 +87,7 @@ show up in /proc/sys/kernel:
>  - shmmni
>  - softlockup_all_cpu_backtrace
>  - soft_watchdog
> +- stack_erasing

I like the renaming to avoid the double-negative. ("disable bypassing"
is not as clear as "feature enabled or not")

>  - stop-a                      [ SPARC only ]
>  - sysrq                       ==> Documentation/admin-guide/sysrq.rst
>  - sysctl_writes_strict
> @@ -962,6 +963,23 @@ detect a hard lockup condition.
>
>  ==============================================================
>
> +stack_erasing
> +
> +This parameter can be used to control kernel stack erasing at the end
> +of syscalls for kernels built with CONFIG_GCC_PLUGIN_STACKLEAK.
> +
> +That erasing reduces the information which kernel stack leak bugs
> +can reveal and blocks some uninitialized stack variable attacks.
> +The tradeoff is the performance impact: on a single CPU system kernel
> +compilation sees a 1% slowdown, other systems and workloads may vary.
> +
> +  0: kernel stack erasing is disabled, STACKLEAK_METRICS are not updated.
> +
> +  1: kernel stack erasing is enabled (default), it is performed before
> +     returning to the userspace at the end of syscalls.
> +
> +==============================================================
> +
>  tainted:
>
>  Non-zero if the kernel has been tainted. Numeric values, which can be
> diff --git a/include/linux/stackleak.h b/include/linux/stackleak.h
> index b911b97..3d5c327 100644
> --- a/include/linux/stackleak.h
> +++ b/include/linux/stackleak.h
> @@ -22,6 +22,12 @@ static inline void stackleak_task_init(struct task_struct *t)
>         t->prev_lowest_stack = t->lowest_stack;
>  # endif
>  }
> +
> +#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
> +int stack_erasing_sysctl(struct ctl_table *table, int write,
> +                       void __user *buffer, size_t *lenp, loff_t *ppos);
> +#endif
> +
>  #else /* !CONFIG_GCC_PLUGIN_STACKLEAK */
>  static inline void stackleak_task_init(struct task_struct *t) { }
>  #endif
> diff --git a/kernel/stackleak.c b/kernel/stackleak.c
> index f5c4111..2d21372 100644
> --- a/kernel/stackleak.c
> +++ b/kernel/stackleak.c
> @@ -14,6 +14,41 @@
>
>  #include <linux/stackleak.h>
>
> +#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
> +#include <linux/jump_label.h>
> +#include <linux/sysctl.h>
> +
> +static DEFINE_STATIC_KEY_FALSE(stack_erasing_bypass);
> +
> +int stack_erasing_sysctl(struct ctl_table *table, int write,
> +                       void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +       int ret = 0;
> +       int state = !static_branch_unlikely(&stack_erasing_bypass);
> +       int prev_state = state;
> +
> +       table->data = &state;
> +       table->maxlen = sizeof(int);
> +       ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
> +       state = !!state;
> +       if (ret || !write || state == prev_state)
> +               return ret;
> +
> +       if (state)
> +               static_branch_disable(&stack_erasing_bypass);
> +       else
> +               static_branch_enable(&stack_erasing_bypass);
> +
> +       pr_warn("stackleak: kernel stack erasing is %s\n",
> +                                       state ? "enabled" : "disabled");

Looks good to me. I've updated the patch for -next.

> +       return ret;
> +}
> +
> +#define skip_erasing() static_branch_unlikely(&stack_erasing_bypass)
> +#else
> +#define skip_erasing() false
> +#endif /* CONFIG_STACKLEAK_RUNTIME_DISABLE */
> +
>  asmlinkage void stackleak_erase(void)
>  {
>         /* It would be nice not to have 'kstack_ptr' and 'boundary' on stack */
> @@ -22,6 +57,9 @@ asmlinkage void stackleak_erase(void)
>         unsigned int poison_count = 0;
>         const unsigned int depth = STACKLEAK_SEARCH_DEPTH / sizeof(unsigned long);
>
> +       if (skip_erasing())
> +               return;
> +
>         /* Search for the poison value in the kernel stack */
>         while (kstack_ptr > boundary && poison_count <= depth) {
>                 if (*(unsigned long *)kstack_ptr == STACKLEAK_POISON)

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
