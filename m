MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180326120321.GD4129@hirez.programming.kicks-ass.net>
References: <1497905801-69164-1-git-send-email-keescook@chromium.org>
 <1497905801-69164-2-git-send-email-keescook@chromium.org> <20180326115246.GA4147@hirez.programming.kicks-ass.net>
 <20180326120321.GD4129@hirez.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 26 Mar 2018 10:43:22 -0700
Message-ID: <CAGXu5jLGdhYm5=7ZhzZ2gO_iFatmOp5Mb51_UygUciHwkAxHSg@mail.gmail.com>
Subject: Re: [PATCH 1/4] task_struct: Allow randomized layout
Content-Type: text/plain; charset="UTF-8"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 26, 2018 at 5:03 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Mar 26, 2018 at 01:52:46PM +0200, Peter Zijlstra wrote:
>
>> That now looks like:
>>
>> struct task_struct {
>>         struct thread_info         thread_info;          /*     0    16 */
>>         volatile long int          state;                /*    16     8 */
>>
>>         /* XXX 40 bytes hole, try to pack */
>>
>>         /* --- cacheline 1 boundary (64 bytes) --- */
>>         struct {
>>                 void *             stack;                /*    64     8 */
>>                 atomic_t           usage;                /*    72     4 */
>>                 unsigned int       flags;                /*    76     4 */
>>                 unsigned int       ptrace;               /*    80     4 */
>>                 struct llist_node  wake_entry;           /*    88     8 */
>>
>>
>> Can we please undo this crap?
>
> The below gets rid of that nonsense.
>
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index e2c7f4369eff..767cf74d61f7 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -242,6 +242,15 @@
>  #if defined(RANDSTRUCT_PLUGIN) && !defined(__CHECKER__)
>  #define __randomize_layout __attribute__((randomize_layout))
>  #define __no_randomize_layout __attribute__((no_randomize_layout))
> +/*
> + * RANDSTRUCT_PLUGIN wants to use an anonymous struct, but it is only
> + * possible since GCC 4.6. To provide as much build testing coverage
> + * as possible, this is used for all GCC 4.6+ builds, and not just on
> + * RANDSTRUCT_PLUGIN builds.
> + */
> +#define randomized_struct_fields_start struct {
> +#define randomized_struct_fields_end   } __randomize_layout;
> +
>  #endif
>
>  #endif /* GCC_VERSION >= 40500 */
> @@ -256,15 +265,6 @@
>   */
>  #define __visible      __attribute__((externally_visible))
>
> -/*
> - * RANDSTRUCT_PLUGIN wants to use an anonymous struct, but it is only
> - * possible since GCC 4.6. To provide as much build testing coverage
> - * as possible, this is used for all GCC 4.6+ builds, and not just on
> - * RANDSTRUCT_PLUGIN builds.
> - */
> -#define randomized_struct_fields_start struct {
> -#define randomized_struct_fields_end   } __randomize_layout;
> -
>  #endif /* GCC_VERSION >= 40600 */
>
>

This is fine by me, though obviously the comment would need to be updated. :)

-Kees

-- 
Kees Cook
Pixel Security
