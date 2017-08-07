MIME-Version: 1.0
In-Reply-To: <20170807203948.GA22298@beast>
References: <20170807203948.GA22298@beast>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 7 Aug 2017 22:27:39 +0100
Message-ID: <CAKv+Gu-DUk9xqzpWt_FNBzpbLhdi9Cc5vU5J-tZZ4b8wD87UTQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH] lkdtm: Test VMAP_STACK allocates
 leading/trailing guard pages
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Laura Abbott <labbott@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 7 August 2017 at 21:39, Kees Cook <keescook@chromium.org> wrote:
> Two new tests STACK_GUARD_PAGE_LEADING and STACK_GUARD_PAGE_TRAILING
> attempt to read the byte before and after, respectively, of the current
> stack frame, which should fault under VMAP_STACK.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> Do these tests both trip with the new arm64 VMAP_STACK code?

Probably not. On arm64, the registers are stacked by software at
exception entry,  and so we decrement the sp first by the size of the
register file, and if the resulting value overflows the stack, the
situation is handled as if the exception was caused by a faulting
stack access while it may be caused by something else in reality.
Since the act of handling the exception is guaranteed to overflow the
stack anyway, this does not really make a huge difference, and it
prevents the recursive fault from wiping the context that we need to
produce the diagnostics.

This means an illegal access right above the stack will go undetected.

> ---
>  drivers/misc/lkdtm.h      |  2 ++
>  drivers/misc/lkdtm_bugs.c | 30 ++++++++++++++++++++++++++++++
>  drivers/misc/lkdtm_core.c |  2 ++
>  3 files changed, 34 insertions(+)
>
> diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
> index 063f5d651076..3c8627ca5f42 100644
> --- a/drivers/misc/lkdtm.h
> +++ b/drivers/misc/lkdtm.h
> @@ -22,6 +22,8 @@ void lkdtm_HUNG_TASK(void);
>  void lkdtm_CORRUPT_LIST_ADD(void);
>  void lkdtm_CORRUPT_LIST_DEL(void);
>  void lkdtm_CORRUPT_USER_DS(void);
> +void lkdtm_STACK_GUARD_PAGE_LEADING(void);
> +void lkdtm_STACK_GUARD_PAGE_TRAILING(void);
>
>  /* lkdtm_heap.c */
>  void lkdtm_OVERWRITE_ALLOCATION(void);
> diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
> index ef3d06f901fc..041fe6e9532a 100644
> --- a/drivers/misc/lkdtm_bugs.c
> +++ b/drivers/misc/lkdtm_bugs.c
> @@ -8,6 +8,7 @@
>  #include <linux/list.h>
>  #include <linux/sched.h>
>  #include <linux/sched/signal.h>
> +#include <linux/sched/task_stack.h>
>  #include <linux/uaccess.h>
>
>  struct lkdtm_list {
> @@ -199,6 +200,7 @@ void lkdtm_CORRUPT_LIST_DEL(void)
>                 pr_err("list_del() corruption not detected!\n");
>  }
>
> +/* Test if unbalanced set_fs(KERNEL_DS)/set_fs(USER_DS) check exists. */
>  void lkdtm_CORRUPT_USER_DS(void)
>  {
>         pr_info("setting bad task size limit\n");
> @@ -207,3 +209,31 @@ void lkdtm_CORRUPT_USER_DS(void)
>         /* Make sure we do not keep running with a KERNEL_DS! */
>         force_sig(SIGKILL, current);
>  }
> +
> +/* Test that VMAP_STACK is actually allocating with a leading guard page */
> +void lkdtm_STACK_GUARD_PAGE_LEADING(void)
> +{
> +       const unsigned char *stack = task_stack_page(current);
> +       const unsigned char *ptr = stack - 1;
> +       volatile unsigned char byte;
> +
> +       pr_info("attempting bad read from page below current stack\n");
> +
> +       byte = *ptr;
> +
> +       pr_err("FAIL: accessed page before stack!\n");
> +}
> +
> +/* Test that VMAP_STACK is actually allocating with a trailing guard page */
> +void lkdtm_STACK_GUARD_PAGE_TRAILING(void)
> +{
> +       const unsigned char *stack = task_stack_page(current);
> +       const unsigned char *ptr = stack + THREAD_SIZE;
> +       volatile unsigned char byte;
> +
> +       pr_info("attempting bad read from page above current stack\n");
> +
> +       byte = *ptr;
> +
> +       pr_err("FAIL: accessed page after stack!\n");
> +}
> diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
> index 51decc07eeda..9e98d7ef5503 100644
> --- a/drivers/misc/lkdtm_core.c
> +++ b/drivers/misc/lkdtm_core.c
> @@ -201,6 +201,8 @@ struct crashtype crashtypes[] = {
>         CRASHTYPE(CORRUPT_LIST_DEL),
>         CRASHTYPE(CORRUPT_USER_DS),
>         CRASHTYPE(CORRUPT_STACK),
> +       CRASHTYPE(STACK_GUARD_PAGE_LEADING),
> +       CRASHTYPE(STACK_GUARD_PAGE_TRAILING),
>         CRASHTYPE(UNALIGNED_LOAD_STORE_WRITE),
>         CRASHTYPE(OVERWRITE_ALLOCATION),
>         CRASHTYPE(WRITE_AFTER_FREE),
> --
> 2.7.4
>
>
> --
> Kees Cook
> Pixel Security
