Subject: Re: [PATCH 0/3] Remove accidental VLA usage
References: <1520479847-39174-1-git-send-email-keescook@chromium.org>
 <20180308150236.5tysfbm3xdouii5n@treble>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <78428dec-270e-5d74-0160-83feb5c0ff02@rasmusvillemoes.dk>
Date: Thu, 8 Mar 2018 20:57:16 +0100
MIME-Version: 1.0
In-Reply-To: <20180308150236.5tysfbm3xdouii5n@treble>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Josh Poimboeuf <jpoimboe@redhat.com>, Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, corbet@lwn.net, gustavo@embeddedor.com, rostedt@goodmis.org, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, "Tobin C. Harding" <me@tobin.cc>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, linux-btrfs@vger.kernel.org, netdev@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2018-03-08 16:02, Josh Poimboeuf wrote:
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
> 

> +extern long __error_incompatible_types_in_min_macro;
> +extern long __error_incompatible_types_in_max_macro;
> +
> +#define __min(t1, t2, x, y)						\
> +	__builtin_choose_expr(__builtin_types_compatible_p(t1, t2),	\
> +			      (t1)(x) < (t2)(y) ? (t1)(x) : (t2)(y),	\
> +			      (t1)__error_incompatible_types_in_min_macro)
>  
>  /**
>   * min - return minimum of two values of the same or compatible types
>   * @x: first value
>   * @y: second value
>   */
> -#define min(x, y)					\
> -	__min(typeof(x), typeof(y),			\
> -	      __UNIQUE_ID(min1_), __UNIQUE_ID(min2_),	\
> -	      x, y)
> +#define min(x, y) __min(typeof(x), typeof(y), x, y)			\
>  

But this introduces the the-chosen-one-of-x-and-y-gets-evaluated-twice
problem. Maybe we don't care? But until we get a
__builtin_assert_this_has_no_side_effects() I think that's a little
dangerous.

Rasmus
