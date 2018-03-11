Date: Mon, 12 Mar 2018 09:46:16 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH v3] kernel.h: Skip single-eval logic on literals in
 min()/max()
Message-ID: <20180311224616.GJ16734@eros>
References: <20180309200536.GA5670@beast>
 <CA+55aFy82Drgu2xm1GWaDz2Jyj5QBx3dW4AatXzmCx-b1YET5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy82Drgu2xm1GWaDz2Jyj5QBx3dW4AatXzmCx-b1YET5Q@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 09, 2018 at 01:10:30PM -0800, Linus Torvalds wrote:
> On Fri, Mar 9, 2018 at 12:05 PM, Kees Cook <keescook@chromium.org> wrote:
> > When max() is used in stack array size calculations from literal values
> > (e.g. "char foo[max(sizeof(struct1), sizeof(struct2))]", the compiler
> > thinks this is a dynamic calculation due to the single-eval logic, which
> > is not needed in the literal case. This change removes several accidental
> > stack VLAs from an x86 allmodconfig build:
> 
> Ok, looks good.
> 
> I just have a couple of questions about applying it.
> 
> In particular, if this will help people working on getting rid of
> VLA's in the short term, I can apply it directly. But if people who
> are looking at it (anybody else than Kees?) don't much care, then this
> might be a 4.17 thing or at least "random -mm queue"?

It's easy enough to work on the other VLA removals without basing on
this, no rush.


thanks,
Tobin.
