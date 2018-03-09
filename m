MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20180309200536.GA5670@beast>
References: <20180309200536.GA5670@beast>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Mar 2018 13:10:30 -0800
Message-ID: <CA+55aFy82Drgu2xm1GWaDz2Jyj5QBx3dW4AatXzmCx-b1YET5Q@mail.gmail.com>
Subject: Re: [PATCH v3] kernel.h: Skip single-eval logic on literals in min()/max()
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 9, 2018 at 12:05 PM, Kees Cook <keescook@chromium.org> wrote:
> When max() is used in stack array size calculations from literal values
> (e.g. "char foo[max(sizeof(struct1), sizeof(struct2))]", the compiler
> thinks this is a dynamic calculation due to the single-eval logic, which
> is not needed in the literal case. This change removes several accidental
> stack VLAs from an x86 allmodconfig build:

Ok, looks good.

I just have a couple of questions about applying it.

In particular, if this will help people working on getting rid of
VLA's in the short term, I can apply it directly. But if people who
are looking at it (anybody else than Kees?) don't much care, then this
might be a 4.17 thing or at least "random -mm queue"?

The other unrelated reaction I had to this was that "we're passing
those types down very deep, even though nobody _cares_ about them all
that much at that deep level".

Honestly, the only case that really cares is the very top level, and
the rest could just take the properly cast versions.

For example, "max_t/min_t" really don't care at all, since they - by
definition - just take the single specified type.

So I'm wondering if we should just drop the types from __max/__min
(and everything they call) entirely, and instead do

    #define __check_type(x,y) ((void)((typeof(x)*)1==(typeof(y)*)1))
    #define min(x,y)   (__check_type(x,y),__min(x,y))
    #define max(x,y)   (__check_type(x,y),__max(x,y))

    #define min_t(t,x,y) __min((t)(x),(t)(y))
    #define max_t(t,x,y) __max((t)(x),(t)(y))

and then __min/__max and friends are much simpler (and can just assume
that the type is already fine, and the casting has been done).

This is technically entirely independent of this VLA cleanup thing,
but the "passing the types around unnecessarily" just becomes more
obvious when there's now another level of macros, _and_ it's a more
complex expression too.

Yes, yes, the __single_eval_xyz() functions still end up wanting the
types for the declaration of the new single-evaluation variables, but
the 'typeof' pattern is the standard pattern, so

#define __single_eval_max(max1, max2, x, y) ({  \
        typeof (x) max1 = (x);                  \
        typeof (y) max2 = (y);                  \
        max1 > max2 ? max1 : max2; })

actually looks more natural to me than passing the two types in as
arguments to the macro.

(That form also is amenable to things like "__auto_type" etc simplifications).

Side note: do we *really* need the unique variable names? That's what
makes those things _really_ illegible. I thgink it's done just for a
sparse warning that we should probably ignore. It's off by default
anyway exactly because it doesn't work that well due to nested macro
expansions like this.

There is very real value to keeping our odd macros legible, I feel.
Even when they are complicated by issues like this, it would be good
to keep them as simple as possible.

Comments?

                Linus
