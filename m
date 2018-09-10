MIME-Version: 1.0
References: <20180910191002.350195-1-kristen@linux.intel.com>
In-Reply-To: <20180910191002.350195-1-kristen@linux.intel.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 10 Sep 2018 22:32:53 +0200
Message-ID: <CAG48ez0Skq5SgVXh6SEYq1Jn=_yUvEeuJYNViEora5S2cXLtng@mail.gmail.com>
Subject: Re: [RFC PATCH] x86: entry: flush the cache if syscall error
Content-Type: text/plain; charset="UTF-8"
To: kristen@linux.intel.com
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 10, 2018 at 9:14 PM Kristen Carlson Accardi
<kristen@linux.intel.com> wrote:
> This patch aims to make it harder to perform cache timing attacks on data
> left behind by system calls. If we have an error returned from a syscall,
> flush the L1 cache.

What kind of performance impact does this have on a process that e.g.
attempts to access a large number of paths to which it has no access,
and what is the impact on the hyperthread?

(You may want to also CC the X86 maintainers (especially Andy
Lutomirski) and LKML on this series relatively early - people on the
kernel-hardening list tend to have a different focus compared to the
relevant maintainers, so there's some feedback that you'll probably
only get once you submit this to places other than the
kernel-hardening@ list.)

> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
>  arch/x86/Kconfig        |  8 ++++++++
>  arch/x86/entry/common.c | 20 ++++++++++++++++++++
>  2 files changed, 28 insertions(+)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index c5ff296bc5d1..8a67642ff9fe 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -445,6 +445,14 @@ config RETPOLINE
>           code are eliminated. Since this includes the syscall entry path,
>           it is not entirely pointless.
>
> +config SYSCALL_FLUSH
> +       bool "Clear L1 Cache on syscall errors"
> +       default y
> +       help
> +         Select to allow the L1 cache to be cleared upon return of
> +         an error code from a syscall. This will reduce the likelyhood of
> +         speculative execution style attacks on syscalls.

s/L1/L1D/ ?

>  config INTEL_RDT
>         bool "Intel Resource Director Technology support"
>         default n
> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
> index 3b2490b81918..77beff541013 100644
> --- a/arch/x86/entry/common.c
> +++ b/arch/x86/entry/common.c
> @@ -268,6 +268,22 @@ __visible inline void syscall_return_slowpath(struct pt_regs *regs)
>         prepare_exit_to_usermode(regs);
>  }
>
> +__visible inline void l1_cache_flush(struct pt_regs *regs)
> +{
> +       if (IS_ENABLED(CONFIG_SYSCALL_FLUSH)) {
> +               if (regs->ax == 0 || regs->ax == -EAGAIN ||
> +                   regs->ax == -EEXIST || regs->ax == -ENOENT ||
> +                   regs->ax == -EXDEV || regs->ax == -ETIMEDOUT ||
> +                   regs->ax == -ENOTCONN || regs->ax == -EINPROGRESS)
> +                       return;
> +
> +               if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {

Style nit: Maybe merge this condition into the first if() ?

> +                       wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
> +                       return;
> +               }
> +       }
> +}
> +
>  #ifdef CONFIG_X86_64
>  __visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
>  {
> @@ -290,6 +306,8 @@ __visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
>                 regs->ax = sys_call_table[nr](regs);
>         }
>
> +       l1_cache_flush(regs);
> +
>         syscall_return_slowpath(regs);
>  }
>  #endif
> @@ -338,6 +356,8 @@ static __always_inline void do_syscall_32_irqs_on(struct pt_regs *regs)
>  #endif /* CONFIG_IA32_EMULATION */
>         }
>
> +       l1_cache_flush(regs);
> +
>         syscall_return_slowpath(regs);
>  }
>
> --
> 2.14.4
>
