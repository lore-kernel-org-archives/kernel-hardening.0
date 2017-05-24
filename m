MIME-Version: 1.0
In-Reply-To: <20170524155751.424-3-riel@redhat.com>
References: <20170524155751.424-1-riel@redhat.com> <20170524155751.424-3-riel@redhat.com>
From: Kees Cook <keescook@google.com>
Date: Wed, 24 May 2017 09:16:01 -0700
Message-ID: <CAGXu5jKQGiAcLe-6yWuqgZMQSFkO=zUR40G0=Th=qWxV+4Y+wA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 2/5] fork,random: use get_random_canary to set tsk->stack_canary
To: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Daniel Micay <danielmicay@gmail.com>, Ted Ts'o <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-sh <linux-sh@vger.kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 24, 2017 at 8:57 AM,  <riel@redhat.com> wrote:
> From: Rik van Riel <riel@redhat.com>
>
> Use the ascii-armor canary to prevent unterminated C string overflows
> from being able to successfully overwrite the canary, even if they
> somehow obtain the canary value.
>
> Inspired by execshield ascii-armor and Daniel Micay's linux-hardened tree.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  kernel/fork.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index aa1076c5e4a9..b3591e9250a8 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -560,7 +560,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
>         set_task_stack_end_magic(tsk);
>
>  #ifdef CONFIG_CC_STACKPROTECTOR
> -       tsk->stack_canary = get_random_long();
> +       tsk->stack_canary = get_random_canary();
>  #endif
>
>         /*
> --
> 2.9.3
>



-- 
Kees Cook
Pixel Security
