MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5j+JiYcsdaC4V9+SmUM2SKW1yRHr18d74G5SM_sSrQm=Nw@mail.gmail.com>
References: <20180308214045.GA6787@beast> <CA+55aFyf-ajRzW2sUwFrrMOAu5UyuOk5L8g9xfkr4VuJeWjV9w@mail.gmail.com>
 <CAGXu5j+JiYcsdaC4V9+SmUM2SKW1yRHr18d74G5SM_sSrQm=Nw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Mar 2018 17:35:15 -0800
Message-ID: <CA+55aFxXb8JhpELWcFJnQMYy6sTyndwdNpCLFUznA9ML7-oL_Q@mail.gmail.com>
Subject: Re: [PATCH] kernel.h: Skip single-eval logic on literals in min()/max()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 8, 2018 at 4:45 PM, Kees Cook <keescook@chromium.org> wrote:
>
> Rasmus mentioned this too. What I said there was that I was shy to
> make that change, since we already can't mix that kind of thing with
> the existing min()/max() implementation. The existing min()/max() is
> already extremely strict, so there are no instances of this in the
> tree.

Yes, but I also didn't want to add any new cases in case people add
new min/max() users.

But:

> If I explicitly add one, I see this with or without the patch:
>
> In file included from drivers/misc/lkdtm.h:7:0,
>                  from drivers/misc/lkdtm_core.c:33:
> drivers/misc/lkdtm_core.c: In function =E2=80=98lkdtm_module_exit=E2=80=
=99:
> ./include/linux/kernel.h:809:16: warning: comparison of distinct
> pointer types lacks a cast

Oh, ok, in that case, just drop the __builtin_types_compatible_p()
entirely. It's not adding anything.

I was expecting the non-chosen expression in __builtin_choose_expr()
to not cause type warnings. I'm actually surprised it does. Type games
is why __builtin_choose_expr() tends to exist in the first place.

> So are you saying you _want_ the type enforcement weakened here, or
> that I should just not use __builtin_types_compatible_p()?

I don't want to weaken the type enforcement, and I _thought_ you had
done that __builtin_types_compatible_p() to keep it in place.

But if that's not why you did it, then why was it there at all? If the
type warning shows through even if it's in the other expression, then
just a


#define __min(t1, t2, x, y)                             \
        __builtin_choose_expr(                          \
                __builtin_constant_p(x) &               \
                __builtin_constant_p(y),                \
                (t1)(x) < (t2)(y) ? (t1)(x) : (t2)(y),  \
                __single_eval_min(t1, t2,               \
   ...

would seem to be sufficient?

Because logically, the only thing that matters is that x and y don't
have any side effects and can be evaluated twice, and
"__builtin_constant_p()" is already a much stronger version of that.

Hmm? The __builtin_types_compatible_p() just doesn't seem to matter
for the only thing I thought it was there for.

                  Linus
