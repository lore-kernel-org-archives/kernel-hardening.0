Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1475476886-26232-13-git-send-email-elena.reshetova@intel.com>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com> <1475476886-26232-13-git-send-email-elena.reshetova@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 3 Oct 2016 14:29:09 -0700
Message-ID: <CAGXu5jJ074oQwAHAWLbUSiJvsL+qoYsV-L1HcVfpC587-NEJVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC PATCH 12/13] x86: x86 implementation for HARDENED_ATOMIC
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

The commit subject doesn't need the second "x86", I think.

On Sun, Oct 2, 2016 at 11:41 PM, Elena Reshetova
<elena.reshetova@intel.com> wrote:
> This adds x86-specific code in order to support
> HARDENED_ATOMIC feature. When overflow is detected
> in atomic_t or atomic_long_t types, the counter is
> decremented back by one (to keep it at INT_MAX or
> LONG_MAX) and issue is reported using BUG().
> The side effect is that in both legitimate and
> non-legitimate cases a counter cannot wrap.
>
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: David Windsor <dwindsor@gmail.com>
> ---
>  arch/x86/Kconfig                   |   1 +
>  arch/x86/include/asm/atomic.h      | 274 +++++++++++++++++++++++++++++++++++--
>  arch/x86/include/asm/atomic64_32.h | 157 ++++++++++++++++++++-
>  arch/x86/include/asm/atomic64_64.h | 166 +++++++++++++++++++++-
>  arch/x86/include/asm/bitops.h      |   8 +-
>  arch/x86/include/asm/cmpxchg.h     |  39 ++++++
>  arch/x86/include/asm/local.h       |  89 +++++++++++-
>  arch/x86/include/asm/preempt.h     |   2 +-
>  arch/x86/include/asm/rmwcc.h       |  82 +++++++++--
>  arch/x86/include/asm/rwsem.h       |  50 +++++++
>  arch/x86/kernel/traps.c            |   6 +
>  arch/x86/lib/atomic64_386_32.S     | 135 ++++++++++++++++++
>  arch/x86/lib/atomic64_cx8_32.S     |  78 ++++++++++-
>  13 files changed, 1042 insertions(+), 45 deletions(-)
> [...]
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index bd4e3d4..ad814ee 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -191,6 +191,12 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
>                         tsk->thread.trap_nr = trapnr;
>                         die(str, regs, error_code);
>                 }
> +
> +#ifdef CONFIG_HARDENED_ATOMIC
> +               if (trapnr == X86_TRAP_OF)
> +                       hardened_atomic_refcount_overflow(regs);
> +#endif

With hardened_atomic_refcount_overflow() defined as a no-op without
HARDENED_ATOMIC, this #ifdef can go away.

> +
>                 return 0;
>         }
>
> [...]

-Kees

-- 
Kees Cook
Nexus Security
