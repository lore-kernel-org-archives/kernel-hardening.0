Date: Thu, 8 Mar 2018 12:21:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 1/3] vsprintf: Remove accidental VLA usage
In-Reply-To: <49e6b509-d1e7-5916-ecb8-6bde026fde1e@rasmusvillemoes.dk>
Message-ID: <alpine.DEB.2.21.1803081211230.8662@nanos.tec.linutronix.de>
References: <1520479847-39174-1-git-send-email-keescook@chromium.org> <1520479847-39174-2-git-send-email-keescook@chromium.org> <49e6b509-d1e7-5916-ecb8-6bde026fde1e@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, corbet@lwn.net, gustavo@embeddedor.com, rostedt@goodmis.org, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, "Tobin C. Harding" <me@tobin.cc>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, linux-btrfs@vger.kernel.org, netdev@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 8 Mar 2018, Rasmus Villemoes wrote:
> On 2018-03-08 04:30, Kees Cook wrote:
> >  /**
> > + * SIMPLE_MAX - return maximum of two values without any type checking
> > + * @x: first value
> > + * @y: second value
> > + *
> > + * This should only be used in stack array sizes, since the type-checking
> > + * from max() confuses the compiler into thinking a VLA is being used.
> > + */
> > +#define SIMPLE_MAX(x, y)	((size_t)(x) > (size_t)(y) ? (size_t)(x) \
> > +							   : (size_t)(y))
> 
> This will be abused at some point, leading to the usual double
> evaluation etc. etc. problems. The name is also too long (and in general
> we should avoid adjectives like "simple", "safe", people reading the
> code won't know what is simple or safe about it). I think this should work
> 
> #define MAX(x, y) (__builtin_choose_expr((x) > (y), x, y))
> 
> That forces (x)>(y) to be a compile-time constant, so x and y must also
> be; hence there can be no side effects. The MIN version of this could
> replace the custom __const_min in fs/file.c, and probably other places
> as well.
> 
> I tested that this at least works in the vsprintf case, -Wvla no longer
> complains. fs/file.c also compiles with the MIN version of this.
> 
> I suppose MIN and MAX will collide with other uses in the tree. Hmm.

Make it CONST_MAX() or something like that which makes it entirely clear.

Thanks,

	tglx
