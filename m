MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20180312155524.b421f07d7f08f24c57bd1887@linux-foundation.org>
References: <20180309200536.GA5670@beast> <20180309160719.154a3158e2d8ee56e43a918f@linux-foundation.org>
 <CA+55aFw9hWz1-YFVoHEiXDjqb9q7dz=rQVXr7YLkMuVLvbwaOg@mail.gmail.com>
 <20180309163241.a421e216999bd0b1f43a64c2@linux-foundation.org>
 <CA+55aFwbO2vUsjWzAwB6SZ65RM4r3P0+2JvyMHn=ry0CgWCBgA@mail.gmail.com>
 <CAGXu5j+D=zs8AMb969dhH05GmKPuBxKPcAs89KfKzVf47faL1g@mail.gmail.com> <20180312155524.b421f07d7f08f24c57bd1887@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Mar 2018 16:57:59 -0700
Message-ID: <CA+55aFwK7W0SsaP5eR+2TxOj-j_Mu_E11fRw2Gk8ptV71ebvww@mail.gmail.com>
Subject: Re: [PATCH v3] kernel.h: Skip single-eval logic on literals in min()/max()
Content-Type: text/plain; charset="UTF-8"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 12, 2018 at 3:55 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Replacing the __builtin_choose_expr() with ?: works of course.

Hmm. That sounds like the right thing to do. We were so myopically
staring at the __builtin_choose_expr() problem that we overlooked the
obvious solution.

Using __builtin_constant_p() together with a ?: is in fact our common
pattern, so that should be fine. The only real reason to use
__builtin_choose_expr() is if you want to get the *type* to vary
depending on which side you choose, but that's not an issue for
min/max.

> What will be the runtime effects?

There should be none. Gcc will turn the conditional for the ?: into a
constant, and DTRT.

              Linus
