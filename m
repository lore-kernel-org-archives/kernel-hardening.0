Date: Thu, 8 Mar 2018 14:18:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel.h: Skip single-eval logic on literals in
 min()/max()
Message-Id: <20180308141833.3fb57913bceae38f18db2bf1@linux-foundation.org>
In-Reply-To: <20180308214045.GA6787@beast>
References: <20180308214045.GA6787@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, rostedt@goodmis.org, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, linux-btrfs@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 8 Mar 2018 13:40:45 -0800 Kees Cook <keescook@chromium.org> wrote:

> When max() is used in stack array size calculations from literal values
> (e.g. "char foo[max(sizeof(struct1), sizeof(struct2))]", the compiler
> thinks this is a dynamic calculation due to the single-eval logic, which
> is not needed in the literal case. This change removes several accidental
> stack VLAs from an x86 allmodconfig build:
> 
> $ diff -u before.txt after.txt | grep ^-
> -drivers/input/touchscreen/cyttsp4_core.c:871:2: warning: ISO C90 forbids variable length array ‘ids’ [-Wvla]
> -fs/btrfs/tree-checker.c:344:4: warning: ISO C90 forbids variable length array ‘namebuf’ [-Wvla]
> -lib/vsprintf.c:747:2: warning: ISO C90 forbids variable length array ‘sym’ [-Wvla]
> -net/ipv4/proc.c:403:2: warning: ISO C90 forbids variable length array ‘buff’ [-Wvla]
> -net/ipv6/proc.c:198:2: warning: ISO C90 forbids variable length array ‘buff’ [-Wvla]
> -net/ipv6/proc.c:218:2: warning: ISO C90 forbids variable length array ‘buff64’ [-Wvla]
> 
> Based on an earlier patch from Josh Poimboeuf.
> 
> ...
>
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -787,37 +787,57 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
>   * strict type-checking.. See the
>   * "unnecessary" pointer comparison.
>   */
> -#define __min(t1, t2, min1, min2, x, y) ({		\
> +#define __single_eval_min(t1, t2, min1, min2, x, y) ({	\
>  	t1 min1 = (x);					\
>  	t2 min2 = (y);					\
>  	(void) (&min1 == &min2);			\
>  	min1 < min2 ? min1 : min2; })
>  
> +/*
> + * In the case of builtin constant values, there is no need to do the
> + * double-evaluation protection, so the raw comparison can be made.
> + * This allows min()/max() to be used in stack array allocations and
> + * avoid the compiler thinking it is a dynamic value leading to an
> + * accidental VLA.
> + */
> +#define __min(t1, t2, x, y)						\
> +	__builtin_choose_expr(__builtin_constant_p(x) &&		\
> +			      __builtin_constant_p(y) &&		\
> +			      __builtin_types_compatible_p(t1, t2),	\
> +			      (t1)(x) < (t2)(y) ? (t1)(x) : (t2)(y),	\
> +			      __single_eval_min(t1, t2,			\
> +						__UNIQUE_ID(max1_),	\
> +						__UNIQUE_ID(max2_),	\
> +						x, y))
> +

Holy crap.

I suppose gcc will one day be fixed and we won't need this.

Is there a good reason to convert min()?  Surely nobody will be using
min to dimension an array - always max?  Just for symmetry, I guess.
