MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1486296850-16045-3-git-send-email-kpark3469@gmail.com>
References: <1486296850-16045-1-git-send-email-kpark3469@gmail.com>
 <1486296850-16045-2-git-send-email-kpark3469@gmail.com> <1486296850-16045-3-git-send-email-kpark3469@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 6 Feb 2017 14:22:15 -0800
Message-ID: <CAGXu5jLqsPR35kiH2r+DNWpiDayaN21FL6stsQu_kBZJEYcg+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 3/3] lkdtm: add tests for dynamic array in local stack
To: Keun-O Park <kpark3469@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 5, 2017 at 4:14 AM,  <kpark3469@gmail.com> wrote:
> From: Sahara <keun-o.park@darkmatter.ae>
>
> This seems an unusual case in kernel. But, when an array is
> dynamically created, this variable can be placed ahead of
> current frame pointer. This patch tests this dynamic array case.
>
> Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
> Reported-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> Suggested-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/misc/lkdtm_usercopy.c | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/misc/lkdtm_usercopy.c b/drivers/misc/lkdtm_usercopy.c
> index 1dd6114..898a323 100644
> --- a/drivers/misc/lkdtm_usercopy.c
> +++ b/drivers/misc/lkdtm_usercopy.c
> @@ -7,6 +7,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/mman.h>
>  #include <linux/uaccess.h>
> +#include <linux/random.h>
>  #include <asm/cacheflush.h>
>
>  /*
> @@ -33,7 +34,14 @@ static noinline unsigned char *trick_compiler(unsigned char *stack)
>
>  static noinline unsigned char *do_usercopy_stack_callee(int value)
>  {
> -       unsigned char buf[32];
> +       /*
> +        * buf[128] is big enough to put it in the position ahead of
> +        * check_stack_object()'s frame pointer. Because dynamically allocated
> +        * array can be placed between check_stack_object()'s frame pointer and
> +        * do_usercopy_stack()'s frame pointer, we need an object which exists
> +        * ahead of check_stack_object()'s frame pointer.
> +        */
> +       unsigned char buf[128];

I don't understand this change. Why does 32 -> 128 do anything when
it's the address of "buf" that is returned (i.e. the beginning of the
stack buffer).

When check_stack_object() walks the stack, I would expect to see:

[fp][lr][args][local vars][dynamic stack][fp][lr][args][local
vars][dynamic stack]...

Why is a special case needed?

e.g. x86 appears to pass this test correctly already. Maybe I'm not
understanding something about the arm64 stack layout?

>         int i;
>
>         /* Exercise stack to avoid everything living in registers. */
> @@ -49,6 +57,7 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
>         unsigned long user_addr;
>         unsigned char good_stack[32];
>         unsigned char *bad_stack;
> +       unsigned int array_size;
>         int i;
>
>         /* Exercise stack to avoid everything living in registers. */
> @@ -72,7 +81,9 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
>                 return;
>         }
>
> +       array_size = get_random_int() & 0x0f;

This can likely just be "array_size = unconst + 8;"

>         if (to_user) {
> +               unsigned char array[array_size];

This needs a blank line after it.

>                 pr_info("attempting good copy_to_user of local stack\n");
>                 if (copy_to_user((void __user *)user_addr, good_stack,
>                                  unconst + sizeof(good_stack))) {
> @@ -80,6 +91,13 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
>                         goto free_user;
>                 }
>
> +               pr_info("attempting good copy_to_user of callee stack\n");
> +               if (copy_to_user((void __user *)user_addr, array,
> +                                unconst + sizeof(array))) {
> +                       pr_warn("copy_to_user failed unexpectedly?!\n");
> +                       goto free_user;
> +               }
> +
>                 pr_info("attempting bad copy_to_user of distant stack\n");
>                 if (copy_to_user((void __user *)user_addr, bad_stack,
>                                  unconst + sizeof(good_stack))) {
> @@ -87,6 +105,7 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
>                         goto free_user;
>                 }
>         } else {
> +               unsigned char array[array_size];

Same needs-blank-line nit.

>                 /*
>                  * There isn't a safe way to not be protected by usercopy
>                  * if we're going to write to another thread's stack.
> @@ -101,6 +120,13 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
>                         goto free_user;
>                 }
>
> +               pr_info("attempting good copy_from_user of callee stack\n");
> +               if (copy_from_user(array, (void __user *)user_addr,
> +                                  unconst + sizeof(array))) {
> +                       pr_warn("copy_from_user failed unexpectedly?!\n");
> +                       goto free_user;
> +               }
> +
>                 pr_info("attempting bad copy_from_user of distant stack\n");
>                 if (copy_from_user(bad_stack, (void __user *)user_addr,
>                                    unconst + sizeof(good_stack))) {
> --
> 2.7.4
>

Thanks for working on this!

-Kees

-- 
Kees Cook
Pixel Security
