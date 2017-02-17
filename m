MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170216182917.19637-4-james.morse@arm.com>
References: <20170216182917.19637-1-james.morse@arm.com> <20170216182917.19637-4-james.morse@arm.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 16 Feb 2017 16:44:04 -0800
Message-ID: <CAGXu5jJJ72w+uGKf90DR-uY6VTOVF3QKV9_1bLUsucs_zg4uAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 3/3] arm64/uaccess: Add hardened usercopy check for bad
 stack accesses
To: James Morse <james.morse@arm.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 16, 2017 at 10:29 AM, James Morse <james.morse@arm.com> wrote:
> lkdtm tests copy_{to,from}_user() by trying to copy an address range
> on the stack that isn't yet part of a stack frame.
>
> By the time the stack walker is invoked to check that the object being
> copied doesn't overlap stack frame, the invalid range is part of a valid
> stack frame. Discarding a constant number of frames is fragile as different
> compiler versions may make different inline choices.
>
> Instead, add a check that the object isn't between the current stack
> pointer and the end of the stack. Add this early enough that it should
> be inlined into the caller.
>
> CC: Sahara <keun-o.park@darkmatter.ae>
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  arch/arm64/include/asm/uaccess.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> index 46da3ea638bb..d3494840a61c 100644
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h
> @@ -356,6 +356,22 @@ do {                                                                       \
>                 -EFAULT;                                                \
>  })
>
> +static inline void check_obj_in_unused_stack(const void *obj, unsigned long len)
> +{
> +       unsigned long stack = (unsigned long)task_stack_page(current);
> +
> +       if (__builtin_constant_p(len) || !IS_ENABLED(CONFIG_HARDENED_USERCOPY) || !len)
> +               return;
> +
> +       /*
> +        * If current_stack_pointer is on the task stack, obj must not lie
> +        * between current_stack_pointer and the last stack address.
> +        */
> +       if ((current_stack_pointer & ~(THREAD_SIZE-1)) == stack)
> +               BUG_ON(stack <= (unsigned long)obj &&
> +                      (unsigned long)obj < current_stack_pointer);
> +}

It seems like this would be a valid test on all architecture, yes? I
wonder if this could be reworked so we don't have a special case for
ARM here...

-Kees

-- 
Kees Cook
Pixel Security
