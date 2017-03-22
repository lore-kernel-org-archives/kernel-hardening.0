MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1488827386-87193-6-git-send-email-keescook@chromium.org>
References: <1488827386-87193-1-git-send-email-keescook@chromium.org> <1488827386-87193-6-git-send-email-keescook@chromium.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 22 Mar 2017 12:29:24 -0700
Message-ID: <CAGXu5jJv7ipL+Ang+AWeoUEYapjTH3sKUuSZFKWQWyTSmswwWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 5/6] notifiers: Use CHECK_DATA_CORRUPTION() on checks
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Olof Johansson <olof@lixom.net>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 6, 2017 at 11:09 AM, Kees Cook <keescook@chromium.org> wrote:
> When performing notifier function pointer sanity checking, allow
> CONFIG_BUG_ON_DATA_CORRUPTION to upgrade from a WARN to a BUG.
> Additionally enables CONFIG_DEBUG_NOTIFIERS when selecting
> CONFIG_BUG_ON_DATA_CORRUPTION.

Any feedback on this change? By default, this retains the existing
WARN behavior...

-Kees

>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/notifier.c | 5 +++--
>  lib/Kconfig.debug | 3 ++-
>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/notifier.c b/kernel/notifier.c
> index 6196af8a8223..58cc14958d92 100644
> --- a/kernel/notifier.c
> +++ b/kernel/notifier.c
> @@ -84,8 +84,9 @@ static int notifier_call_chain(struct notifier_block **nl,
>                 next_nb = rcu_dereference_raw(nb->next);
>
>  #ifdef CONFIG_DEBUG_NOTIFIERS
> -               if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
> -                       WARN(1, "Invalid notifier called!");
> +               if (CHECK_DATA_CORRUPTION(
> +                               !func_ptr_is_kernel_text(nb->notifier_call),
> +                               "Invalid notifier called!")) {
>                         nb = next_nb;
>                         continue;
>                 }
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 42c61cfe7d19..70e9f2c1bb30 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1277,7 +1277,7 @@ config DEBUG_SG
>
>  config DEBUG_NOTIFIERS
>         bool "Debug notifier call chains"
> -       depends on DEBUG_KERNEL
> +       depends on DEBUG_KERNEL || BUG_ON_DATA_CORRUPTION
>         help
>           Enable this to turn on sanity checking for notifier call chains.
>           This is most useful for kernel developers to make sure that
> @@ -1995,6 +1995,7 @@ config BUG_ON_DATA_CORRUPTION
>         bool "Trigger a BUG when data corruption is detected"
>         select DEBUG_CREDENTIALS
>         select DEBUG_LIST
> +       select DEBUG_NOTIFIERS
>         select DEBUG_SG
>         help
>           This option enables several inexpensive data corruption checks.
> --
> 2.7.4
>



-- 
Kees Cook
Pixel Security
