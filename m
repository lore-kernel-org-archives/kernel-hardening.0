MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20180311110543.pgcnrafloj5qbdjm@gmail.com>
References: <20180309200536.GA5670@beast> <20180309160719.154a3158e2d8ee56e43a918f@linux-foundation.org>
 <e8874944-f0b7-7a1f-26f3-446d7d7fcc38@infradead.org> <CANiq72k_vsTPMXvcfTNo+sjRoVMkihvRz-fzeXdcXvNEEeY-Pw@mail.gmail.com>
 <CAGXu5jLtKAUsoYemHZTrJqKEH9=BqwO_QXk=x3BPfCKqZ6DRYA@mail.gmail.com>
 <CA+55aFyLicYSe+R4yQ2Eu+P9m6qsRfso-HiK78Sw+-dPuZvAYg@mail.gmail.com>
 <CANiq72nwg3mMhWeE_bLKdQ5WP+0E+SxxvcuUF=Rn9a1MM+EapQ@mail.gmail.com>
 <CA+55aFw+guiiJ3OavrP-RpFV9NRAF4t=oj3-GDfSyuZ9zBRfdg@mail.gmail.com> <20180311110543.pgcnrafloj5qbdjm@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 11 Mar 2018 11:23:29 -0700
Message-ID: <CA+55aFykPUaZUjxf9qkWN-QhTH_fK=R4bXHBb-iKT1EaEh87uQ@mail.gmail.com>
Subject: Re: [PATCH v3] kernel.h: Skip single-eval logic on literals in min()/max()
Content-Type: text/plain; charset="UTF-8"
To: Ingo Molnar <mingo@kernel.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Mar 11, 2018 at 4:05 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> BTW., while I fully agree with everything you said, it's not entirely correct to
> claim that if a C compiler can generate VLA code it is necessarily able to parse
> and evaluate constant array sizes "just fine".
>
> Constant expressions are typically parsed very early on, at the preprocessing
> stage. They can be used with some preprocessor directives as well, such as '#if'
> (with some further limitations on their syntax).

Yes. But constant simplification and CSE etc is just a very
fundamental part of a compiler, and anybody who actually implements
VLA's would have to do it anyway.

So no, a message like

  warning: Array declaration is not a C90 constant expression,
resulting in VLA code generation

would be moronic. Only some completely mindless broken shit would do
"oh, it's not a parse-time constant, so it will be variable". The two
just do not follow AT ALL.

So the message might be about _possibly_ resulting in VLA code
generation, but honestly, at that point you should just add the
warning when you actually generate the code to do the stack
allocation.

Because at that point, you know whether it's variable or not.

And trust me, it won't be variable for things like (2,3), or even for
our "max()" thing with other odd builtins. Not unless the compiler
doesn't really support VLA at all (maybe some bolted-on crazy thing
that just turns a VLA at the front-end time into just an alloca), or
the user has explicitly asked to disable some fundamental optimization
phase.

               Linus
