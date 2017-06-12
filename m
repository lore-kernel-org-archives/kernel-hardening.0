MIME-Version: 1.0
In-Reply-To: <20170612152559.204034809@linuxfoundation.org>
References: <20170612152556.133240249@linuxfoundation.org> <20170612152559.204034809@linuxfoundation.org>
From: Jann Horn <jannh@google.com>
Date: Mon, 12 Jun 2017 17:41:34 +0200
Message-ID: <CAG48ez2eLfZLyhX2m9PaAOBY3As+vovkmr914u06Qd2Z240mgA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH 4.4 47/90] stackprotector: Increase the
 per-task stack canarys random range from 32 bits to 64 bits on 64-bit platforms
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>, Arjan van de Ven <arjan@linux.intel.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

AFAICS get_random_long() doesn't exist in 4.4 (except in
arch/x86/boot/compressed/aslr.c)? IIRC the same problem already
occured with another kernel version?

On Mon, Jun 12, 2017 at 5:25 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 4.4-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Daniel Micay <danielmicay@gmail.com>
>
> commit 5ea30e4e58040cfd6434c2f33dc3ea76e2c15b05 upstream.
>
> The stack canary is an 'unsigned long' and should be fully initialized to
> random data rather than only 32 bits of random data.
>
> Signed-off-by: Daniel Micay <danielmicay@gmail.com>
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> Cc: Arjan van Ven <arjan@linux.intel.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: kernel-hardening@lists.openwall.com
> Cc: stable@vger.kernel.org
> Link: http://lkml.kernel.org/r/20170504133209.3053-1-danielmicay@gmail.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  kernel/fork.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -368,7 +368,7 @@ static struct task_struct *dup_task_stru
>         set_task_stack_end_magic(tsk);
>
>  #ifdef CONFIG_CC_STACKPROTECTOR
> -       tsk->stack_canary = get_random_int();
> +       tsk->stack_canary = get_random_long();
>  #endif
>
>         /*
>
>
