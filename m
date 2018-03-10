MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CANiq72nwg3mMhWeE_bLKdQ5WP+0E+SxxvcuUF=Rn9a1MM+EapQ@mail.gmail.com>
References: <20180309200536.GA5670@beast> <20180309160719.154a3158e2d8ee56e43a918f@linux-foundation.org>
 <e8874944-f0b7-7a1f-26f3-446d7d7fcc38@infradead.org> <CANiq72k_vsTPMXvcfTNo+sjRoVMkihvRz-fzeXdcXvNEEeY-Pw@mail.gmail.com>
 <CAGXu5jLtKAUsoYemHZTrJqKEH9=BqwO_QXk=x3BPfCKqZ6DRYA@mail.gmail.com>
 <CA+55aFyLicYSe+R4yQ2Eu+P9m6qsRfso-HiK78Sw+-dPuZvAYg@mail.gmail.com> <CANiq72nwg3mMhWeE_bLKdQ5WP+0E+SxxvcuUF=Rn9a1MM+EapQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 10 Mar 2018 09:51:19 -0800
Message-ID: <CA+55aFw+guiiJ3OavrP-RpFV9NRAF4t=oj3-GDfSyuZ9zBRfdg@mail.gmail.com>
Subject: Re: [PATCH v3] kernel.h: Skip single-eval logic on literals in min()/max()
Content-Type: text/plain; charset="UTF-8"
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2018 at 9:34 AM, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> So the warning is probably implemented to just trigger whenever VLAs
> are used but the given standard does not allow them, for all
> languages. The problem is why the ISO C90 frontend is not giving an
> error for using invalid syntax for array sizes to begin with?

So in *historical* context - when a compiler didn't do variable length
arrays at all - the original semantics of C "constant expressions"
actually make a ton of sense.

You can basically think of a constant expression as something that can
be (historically) handled by the front-end without any real
complexity, and no optimization phases - just evaluating a simple
parse tree with purely compile-time constants.

So there's a good and perfectly valid reason for why C limits certain
expressions to just a very particular subset. It's not just array
sizes, it's  case statements etc too. And those are very much part of
the C standard.

So an error message like

   warning: ISO C90 requires array sizes to be constant-expressions

would be technically correct and useful from a portability angle. It
tells you when you're doing something non-portable, and should be
automatically enabled with "-ansi -pedantic", for example.

So what's misleading is actually the name of the warning and the
message, not that it happens. The warning isn't about "variable
length", it's literally about the rules for what a
"constant-expression" is.

And in C, the expression (2,3) has a constant _value_ (namely 3), but
it isn't a constant-expression as specified by the language.

Now, the thing is that once you actually do variable length arrays,
those old front-end rules make no sense any more (outside of the "give
portability warnings" thing).

Because once you do variable length arrays, you obviously _parse_
everything just fine, and you're doing to evaluate much more complex
expressions than some limited constant-expression rule.

And at that point it would make a whole lot more sense to add a *new*
warning that basically says "I have to generate code for a
variable-sized array", if you actually talk about VLA's.

But that's clearly not what gcc actually did.

So the problem really is that -Wvla doesn't actually warn about VLA's,
but about something technically completely different.

And that's why those stupid syntactic issues with min/max matter. It's
not whether the end result is a compile-time constant or not, it's
about completely different issues, like whether there is a
comma-expression in it.

              Linus
