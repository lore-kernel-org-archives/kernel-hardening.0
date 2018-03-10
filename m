MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20180309160719.154a3158e2d8ee56e43a918f@linux-foundation.org>
References: <20180309200536.GA5670@beast> <20180309160719.154a3158e2d8ee56e43a918f@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Mar 2018 16:28:51 -0800
Message-ID: <CA+55aFw9hWz1-YFVoHEiXDjqb9q7dz=rQVXr7YLkMuVLvbwaOg@mail.gmail.com>
Subject: Re: [PATCH v3] kernel.h: Skip single-eval logic on literals in min()/max()
Content-Type: text/plain; charset="UTF-8"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 9, 2018 at 4:07 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> A brief poke failed to reveal a workaround - gcc-4.4.4 doesn't appear
> to know that __builtin_constant_p(x) is a constant.  Or something.

LOL.

I suspect it might be that it wants to evaluate
__builtin_choose_expr() at an earlier stage than it evaluates
__builtin_constant_p(), so it's not that it doesn't know that
__builtin_constant_p() is a constant, it just might not know it *yet*.

Maybe.

Side note, if it's not that, but just the "complex" expression that
has the logical 'and' etc, maybe the code could just use

  __builtin_constant_p((x)+(y))

or something.

But yeah:

> Sigh.  Wasn't there some talk about modernizing our toolchain
> requirements?

Maybe it's just time to give up on 4.4.  We wanted 4.5 for "asm goto",
and once we upgrade to 4.5 I think Arnd said that no distro actually
ships it, so we might as well go to 4.6.

So maybe this is just the excuse to finally make that official, if
there is no clever workaround any more.

                    Linus
