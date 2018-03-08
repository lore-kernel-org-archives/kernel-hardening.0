MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20180308214045.GA6787@beast>
References: <20180308214045.GA6787@beast>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Mar 2018 15:48:10 -0800
Message-ID: <CA+55aFyf-ajRzW2sUwFrrMOAu5UyuOk5L8g9xfkr4VuJeWjV9w@mail.gmail.com>
Subject: Re: [PATCH] kernel.h: Skip single-eval logic on literals in min()/max()
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 8, 2018 at 1:40 PM, Kees Cook <keescook@chromium.org> wrote:
> +#define __min(t1, t2, x, y)                                            \
> +       __builtin_choose_expr(__builtin_constant_p(x) &&                \
> +                             __builtin_constant_p(y) &&                \
> +                             __builtin_types_compatible_p(t1, t2),     \
> +                             (t1)(x) < (t2)(y) ? (t1)(x) : (t2)(y),    \

I understand why you use __builtin_types_compatible_p(), but please don't.

It will mean that trivial constants like "5" and "sizeof(x)" won't
simplify, because they have different types.

The ?: will give the right combined type anyway, and if you want the
type comparison warning, just add a comma-expression with something
like like

   (t1 *)1 == (t2 *)1

to get the type compatibility warning.

Yeah, yeah, maybe none of the VLA cases triggered that, but it seems
silly to not just get that obvious constant case right.

Hmm?

              Linus
