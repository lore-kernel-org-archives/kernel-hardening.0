MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180308150236.5tysfbm3xdouii5n@treble>
References: <1520479847-39174-1-git-send-email-keescook@chromium.org> <20180308150236.5tysfbm3xdouii5n@treble>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 8 Mar 2018 10:02:01 -0800
Message-ID: <CAGXu5jL=93keuGEjNaLYHM-hc1EeaaW2SmnnW5ja=SH1jPJwGw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Remove accidental VLA usage
Content-Type: text/plain; charset="UTF-8"
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, "Tobin C. Harding" <me@tobin.cc>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 8, 2018 at 7:02 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> On Wed, Mar 07, 2018 at 07:30:44PM -0800, Kees Cook wrote:
>> This series adds SIMPLE_MAX() to be used in places where a stack array
>> is actually fixed, but the compiler still warns about VLA usage due to
>> confusion caused by the safety checks in the max() macro.
>>
>> I'm sending these via -mm since that's where I've introduced SIMPLE_MAX(),
>> and they should all have no operational differences.
>
> What if we instead simplify the max() macro's type checking so that GCC
> can more easily fold the array size constants?  The below patch seems to
> work:

Oooooh magic! Very nice. I couldn't figure out how to do this when I
stared at it. Yes, let me respin. (I assume I can add your S-o-b?)

-Kees

>
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 3fd291503576..ec863726da29 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -782,42 +782,32 @@ ftrace_vprintk(const char *fmt, va_list ap)
>  static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
>  #endif /* CONFIG_TRACING */
>
> -/*
> - * min()/max()/clamp() macros that also do
> - * strict type-checking.. See the
> - * "unnecessary" pointer comparison.
> - */
> -#define __min(t1, t2, min1, min2, x, y) ({             \
> -       t1 min1 = (x);                                  \
> -       t2 min2 = (y);                                  \
> -       (void) (&min1 == &min2);                        \
> -       min1 < min2 ? min1 : min2; })
> +extern long __error_incompatible_types_in_min_macro;
> +extern long __error_incompatible_types_in_max_macro;
> +
> +#define __min(t1, t2, x, y)                                            \
> +       __builtin_choose_expr(__builtin_types_compatible_p(t1, t2),     \
> +                             (t1)(x) < (t2)(y) ? (t1)(x) : (t2)(y),    \
> +                             (t1)__error_incompatible_types_in_min_macro)
>
>  /**
>   * min - return minimum of two values of the same or compatible types
>   * @x: first value
>   * @y: second value
>   */
> -#define min(x, y)                                      \
> -       __min(typeof(x), typeof(y),                     \
> -             __UNIQUE_ID(min1_), __UNIQUE_ID(min2_),   \
> -             x, y)
> +#define min(x, y) __min(typeof(x), typeof(y), x, y)                    \
>
> -#define __max(t1, t2, max1, max2, x, y) ({             \
> -       t1 max1 = (x);                                  \
> -       t2 max2 = (y);                                  \
> -       (void) (&max1 == &max2);                        \
> -       max1 > max2 ? max1 : max2; })
> +#define __max(t1, t2, x, y)                                            \
> +       __builtin_choose_expr(__builtin_types_compatible_p(t1, t2),     \
> +                             (t1)(x) > (t2)(y) ? (t1)(x) : (t2)(y),    \
> +                             (t1)__error_incompatible_types_in_max_macro)
>
>  /**
>   * max - return maximum of two values of the same or compatible types
>   * @x: first value
>   * @y: second value
>   */
> -#define max(x, y)                                      \
> -       __max(typeof(x), typeof(y),                     \
> -             __UNIQUE_ID(max1_), __UNIQUE_ID(max2_),   \
> -             x, y)
> +#define max(x, y) __max(typeof(x), typeof(y), x, y)
>
>  /**
>   * min3 - return minimum of three values
> @@ -869,10 +859,7 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
>   * @x: first value
>   * @y: second value
>   */
> -#define min_t(type, x, y)                              \
> -       __min(type, type,                               \
> -             __UNIQUE_ID(min1_), __UNIQUE_ID(min2_),   \
> -             x, y)
> +#define min_t(type, x, y) __min(type, type, x, y)
>
>  /**
>   * max_t - return maximum of two values, using the specified type
> @@ -880,10 +867,7 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
>   * @x: first value
>   * @y: second value
>   */
> -#define max_t(type, x, y)                              \
> -       __max(type, type,                               \
> -             __UNIQUE_ID(min1_), __UNIQUE_ID(min2_),   \
> -             x, y)
> +#define max_t(type, x, y) __max(type, type, x, y)                              \
>
>  /**
>   * clamp_t - return a value clamped to a given range using a given type



-- 
Kees Cook
Pixel Security
