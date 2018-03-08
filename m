Date: Thu, 8 Mar 2018 12:49:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] Remove accidental VLA usage
Message-Id: <20180308124913.858b2693a14c25d6dcc66b4a@linux-foundation.org>
In-Reply-To: <20180308150236.5tysfbm3xdouii5n@treble>
References: <1520479847-39174-1-git-send-email-keescook@chromium.org>
	<20180308150236.5tysfbm3xdouii5n@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, corbet@lwn.net, gustavo@embeddedor.com, rostedt@goodmis.org, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, "Tobin C. Harding" <me@tobin.cc>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, linux-btrfs@vger.kernel.org, netdev@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 8 Mar 2018 09:02:36 -0600 Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> On Wed, Mar 07, 2018 at 07:30:44PM -0800, Kees Cook wrote:
> > This series adds SIMPLE_MAX() to be used in places where a stack array
> > is actually fixed, but the compiler still warns about VLA usage due to
> > confusion caused by the safety checks in the max() macro.
> > 
> > I'm sending these via -mm since that's where I've introduced SIMPLE_MAX(),
> > and they should all have no operational differences.
> 
> What if we instead simplify the max() macro's type checking so that GCC
> can more easily fold the array size constants?  The below patch seems to
> work:
> 
> -/*
> - * min()/max()/clamp() macros that also do
> - * strict type-checking.. See the
> - * "unnecessary" pointer comparison.
> - */
> -#define __min(t1, t2, min1, min2, x, y) ({		\
> -	t1 min1 = (x);					\
> -	t2 min2 = (y);					\
> -	(void) (&min1 == &min2);			\
> -	min1 < min2 ? min1 : min2; })
> +extern long __error_incompatible_types_in_min_macro;
> +extern long __error_incompatible_types_in_max_macro;
> +
> +#define __min(t1, t2, x, y)						\
> +	__builtin_choose_expr(__builtin_types_compatible_p(t1, t2),	\
> +			      (t1)(x) < (t2)(y) ? (t1)(x) : (t2)(y),	\
> +			      (t1)__error_incompatible_types_in_min_macro)

This will move the error detection from compile-time to link-time. 
That's tolerable I guess, but a bit sad and should be flagged in the
changelog at least.
