MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFxXb8JhpELWcFJnQMYy6sTyndwdNpCLFUznA9ML7-oL_Q@mail.gmail.com>
References: <20180308214045.GA6787@beast> <CA+55aFyf-ajRzW2sUwFrrMOAu5UyuOk5L8g9xfkr4VuJeWjV9w@mail.gmail.com>
 <CAGXu5j+JiYcsdaC4V9+SmUM2SKW1yRHr18d74G5SM_sSrQm=Nw@mail.gmail.com> <CA+55aFxXb8JhpELWcFJnQMYy6sTyndwdNpCLFUznA9ML7-oL_Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 8 Mar 2018 17:46:42 -0800
Message-ID: <CAGXu5jJG9JL_3=rgqS+_B-FEumwa4qZkL6YA=KKxaMe-ugz0Rg@mail.gmail.com>
Subject: Re: [PATCH] kernel.h: Skip single-eval logic on literals in min()/max()
Content-Type: text/plain; charset="UTF-8"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 8, 2018 at 5:35 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I don't want to weaken the type enforcement, and I _thought_ you had
> done that __builtin_types_compatible_p() to keep it in place.

I thought so too (that originally came from Josh), but on removal, I
was surprised that the checking was retained. :)

> But if that's not why you did it, then why was it there at all? If the
> type warning shows through even if it's in the other expression, then
> just a
>
>
> #define __min(t1, t2, x, y)                             \
>         __builtin_choose_expr(                          \
>                 __builtin_constant_p(x) &               \
>                 __builtin_constant_p(y),                \
>                 (t1)(x) < (t2)(y) ? (t1)(x) : (t2)(y),  \
>                 __single_eval_min(t1, t2,               \
>    ...
>
> would seem to be sufficient?
>
> Because logically, the only thing that matters is that x and y don't
> have any side effects and can be evaluated twice, and
> "__builtin_constant_p()" is already a much stronger version of that.
>
> Hmm? The __builtin_types_compatible_p() just doesn't seem to matter
> for the only thing I thought it was there for.

Yup, agreed. I'll drop it.

-Kees

-- 
Kees Cook
Pixel Security
