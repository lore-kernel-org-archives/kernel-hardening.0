Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 11 Mar 2018 12:05:43 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3] kernel.h: Skip single-eval logic on literals in
 min()/max()
Message-ID: <20180311110543.pgcnrafloj5qbdjm@gmail.com>
References: <20180309200536.GA5670@beast>
 <20180309160719.154a3158e2d8ee56e43a918f@linux-foundation.org>
 <e8874944-f0b7-7a1f-26f3-446d7d7fcc38@infradead.org>
 <CANiq72k_vsTPMXvcfTNo+sjRoVMkihvRz-fzeXdcXvNEEeY-Pw@mail.gmail.com>
 <CAGXu5jLtKAUsoYemHZTrJqKEH9=BqwO_QXk=x3BPfCKqZ6DRYA@mail.gmail.com>
 <CA+55aFyLicYSe+R4yQ2Eu+P9m6qsRfso-HiK78Sw+-dPuZvAYg@mail.gmail.com>
 <CANiq72nwg3mMhWeE_bLKdQ5WP+0E+SxxvcuUF=Rn9a1MM+EapQ@mail.gmail.com>
 <CA+55aFw+guiiJ3OavrP-RpFV9NRAF4t=oj3-GDfSyuZ9zBRfdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFw+guiiJ3OavrP-RpFV9NRAF4t=oj3-GDfSyuZ9zBRfdg@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So an error message like
> 
>    warning: ISO C90 requires array sizes to be constant-expressions
> 
> would be technically correct and useful from a portability angle. It
> tells you when you're doing something non-portable, and should be
> automatically enabled with "-ansi -pedantic", for example.
> 
> So what's misleading is actually the name of the warning and the
> message, not that it happens. The warning isn't about "variable
> length", it's literally about the rules for what a
> "constant-expression" is.
> 
> And in C, the expression (2,3) has a constant _value_ (namely 3), but
> it isn't a constant-expression as specified by the language.
> 
> Now, the thing is that once you actually do variable length arrays,
> those old front-end rules make no sense any more (outside of the "give
> portability warnings" thing).
> 
> Because once you do variable length arrays, you obviously _parse_
> everything just fine, and you're doing to evaluate much more complex
> expressions than some limited constant-expression rule.

BTW., while I fully agree with everything you said, it's not entirely correct to 
claim that if a C compiler can generate VLA code it is necessarily able to parse 
and evaluate constant array sizes "just fine".

Constant expressions are typically parsed very early on, at the preprocessing 
stage. They can be used with some preprocessor directives as well, such as '#if' 
(with some further limitations on their syntax).

If VLA support is implemented in a later stage, and results in heavy-handed code 
generation that will technically work for constant value expressions as well but 
results in suboptimal code, then a warning should probably be emitted - and it 
wouldn't be pedantic.

The existing warning is still very misleading:

  warning: ISO C90 forbids variable length array ‘array’ [-Wvla]

... and if my above theory is correct then I think a better warning would be 
something like:

  warning: Array declaration is not a C90 constant expression, resulting in VLA code generation

... and note that in this specific case it's not misleading to talk about VLAs in 
the warning text, because the array size, even if it's constant value, results in 
VLA code generation.

I don't know whether GCC has such a limitation, but a quick experiment with GCC 
7.2 suggests that a (2,3) array size expression results in a lot more code being 
generated than with a constant expression.

Thanks,

	Ingo
