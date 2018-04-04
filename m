MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1519899591-29761-4-git-send-email-kpark3469@gmail.com>
References: <1519899591-29761-1-git-send-email-kpark3469@gmail.com>
 <1519899591-29761-2-git-send-email-kpark3469@gmail.com> <1519899591-29761-3-git-send-email-kpark3469@gmail.com>
 <1519899591-29761-4-git-send-email-kpark3469@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 4 Apr 2018 15:57:34 -0700
Message-ID: <CAGXu5j+DW-qpFwCxN0dgsNLn35940SX+n0nJTceNfRzRrswU+A@mail.gmail.com>
Subject: Re: [PATCH 3/4] arm64: usercopy: consider dynamic array stack variable
Content-Type: text/plain; charset="UTF-8"
To: Keun-O Park <kpark3469@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, James Morse <james.morse@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 1, 2018 at 2:19 AM,  <kpark3469@gmail.com> wrote:
> From: Sahara <keun-o.park@darkmatter.ae>
>
> When an array is dynamically declared, the array may be placed
> at next frame. If this variable is used for usercopy, then it
> will cause an Oops because the current check code does not allow
> this exceptional case.
>
>  low -----------------------------------------------------> high
>  [__check_object_size fp][lr][args][local vars][caller_fp][lr]
>                              ^----------------^
>                      dynamically allocated stack variable of
>                      caller frame copies are allowed within here
>
>  < example code snippet >
>  array_size = get_random_int() & 0x0f;
>  if (to_user) {
>          unsigned char array[array_size];
>          if (copy_to_user((void __user *)user_addr, array,
>                           unconst + sizeof(array))) {

And once we have -Wvla in the build[1] by default we can revert this
and ignore the VLA case, yes?

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

[1] https://lkml.org/lkml/2018/3/7/621

>
> Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
> ---
>  arch/arm64/kernel/stacktrace.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 6d37fad..75a8f20 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -162,8 +162,13 @@ int arch_within_stack_frames(const void *stack,
>          * Skip 4 non-inlined frames: <fake frame>,
>          * arch_within_stack_frames(), check_stack_object() and
>          * __check_object_size().
> +        *
> +        * From Akashi's report, an object may be placed between next caller's
> +        * frame, when the object is created as dynamic array.
> +        * Setting the discard_frames to 3 is proper to catch this exceptional
> +        * case.
>          */
> -       arg.discard_frames = 4;
> +       arg.discard_frames = 3;
>
>         walk_stackframe(current, &frame, check_frame, &arg);
>
> --
> 2.7.4
>



-- 
Kees Cook
Pixel Security
