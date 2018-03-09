MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFy82Drgu2xm1GWaDz2Jyj5QBx3dW4AatXzmCx-b1YET5Q@mail.gmail.com>
References: <20180309200536.GA5670@beast> <CA+55aFy82Drgu2xm1GWaDz2Jyj5QBx3dW4AatXzmCx-b1YET5Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 9 Mar 2018 13:47:06 -0800
Message-ID: <CAGXu5jLbfvKYbtnzbrgtmh5qQV8KzPUh0-rV5Xtz+nUH-rCGyw@mail.gmail.com>
Subject: Re: [PATCH v3] kernel.h: Skip single-eval logic on literals in min()/max()
Content-Type: text/plain; charset="UTF-8"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 9, 2018 at 1:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Mar 9, 2018 at 12:05 PM, Kees Cook <keescook@chromium.org> wrote:
>> When max() is used in stack array size calculations from literal values
>> (e.g. "char foo[max(sizeof(struct1), sizeof(struct2))]", the compiler
>> thinks this is a dynamic calculation due to the single-eval logic, which
>> is not needed in the literal case. This change removes several accidental
>> stack VLAs from an x86 allmodconfig build:
>
> Ok, looks good.
>
> I just have a couple of questions about applying it.
>
> In particular, if this will help people working on getting rid of
> VLA's in the short term, I can apply it directly.

AFAIK, all the VLAs effected by max() are fixed with this patch. i.e.
no other VLA work I'm aware of depends on this (famous last words).

> But if people who are looking at it (anybody else than Kees?)

FWIW, I've seen at least 6 other people helping out now with VLA clean
up patches. Whee. :)

> don't much care, then this
> might be a 4.17 thing or at least "random -mm queue"?

Andrew has this (v2) queued in -mm for 4.17. I didn't view VLA clean
up (or this macro change) as urgent by any means.

> #define __single_eval_max(max1, max2, x, y) ({  \
>         typeof (x) max1 = (x);                  \
>         typeof (y) max2 = (y);                  \
>         max1 > max2 ? max1 : max2; })
>
> actually looks more natural to me than passing the two types in as
> arguments to the macro.

I (obviously) didn't design this macro originally, but my take on this
was that it's safer to keep the type check together with the
comparison so that it is never possible for someone to run off and use
__single_eval_max() directly and accidentally bypass the type check.
While it does look silly from the max_t()/min_t() perspective, it just
seems more defensive.

> (That form also is amenable to things like "__auto_type" etc simplifications).

Agreed, I think that's the biggest reason to lift the types. However,
since we're still not actually doing anything with the types (i.e.
this change doesn't weaken the type checking), I would think it would
be orthogonal. While it would be nice to resolve differing types
sanely, there doesn't appear to be a driving reason to make this
change. The example case of max(5, sizeof(thing)) doesn't currently
exist in the code and I don't see how making min()/max() _less_ strict
would be generically useful (in fact, it has proven useful to have
strict type checking).

> Side note: do we *really* need the unique variable names? That's what
> makes those things _really_ illegible. I thgink it's done just for a
> sparse warning that we should probably ignore. It's off by default
> anyway exactly because it doesn't work that well due to nested macro
> expansions like this.

That I'm not sure about. I'd be fine to remove them; I left them in
place because it seemed quite intentional. :)

> There is very real value to keeping our odd macros legible, I feel.
> Even when they are complicated by issues like this, it would be good
> to keep them as simple as possible.
>
> Comments?

I'm open to whatever! I'm just glad this gets to kill a handful of
"accidental" stack VLAs. :)

-Kees

-- 
Kees Cook
Pixel Security<div class="gmail_extra"><br><div class="gmail_quote">On
Fri, Mar 9, 2018 at 1:10 PM, Linus Torvalds <span dir="ltr">&lt;<a
href="mailto:torvalds@linux-foundation.org"
target="_blank">torvalds@linux-foundation.org</a>&gt;</span>
wrote:<br><blockquote class="gmail_quote" style="margin:0 0 0
.8ex;border-left:1px #ccc solid;padding-left:1ex"><span class="">On
Fri, Mar 9, 2018 at 12:05 PM, Kees Cook &lt;<a
href="mailto:keescook@chromium.org">keescook@chromium.org</a>&gt;
wrote:<br>
&gt; When max() is used in stack array size calculations from literal values<br>
&gt; (e.g. "char foo[max(sizeof(struct1), sizeof(struct2))]", the compiler<br>
&gt; thinks this is a dynamic calculation due to the single-eval
logic, which<br>
&gt; is not needed in the literal case. This change removes several
accidental<br>
&gt; stack VLAs from an x86 allmodconfig build:<br>
<br>
</span>Ok, looks good.<br>
<br>
I just have a couple of questions about applying it.<br>
<br>
In particular, if this will help people working on getting rid of<br>
VLA's in the short term, I can apply it directly. But if people who<br>
are looking at it (anybody else than Kees?) don't much care, then this<br>
might be a 4.17 thing or at least "random -mm queue"?<br>
<br>
The other unrelated reaction I had to this was that "we're passing<br>
those types down very deep, even though nobody _cares_ about them all<br>
that much at that deep level".<br>
<br>
Honestly, the only case that really cares is the very top level, and<br>
the rest could just take the properly cast versions.<br>
<br>
For example, "max_t/min_t" really don't care at all, since they - by<br>
definition - just take the single specified type.<br>
<br>
So I'm wondering if we should just drop the types from __max/__min<br>
(and everything they call) entirely, and instead do<br>
<br>
&nbsp; &nbsp; #define __check_type(x,y)
((void)((typeof(x)*)1==(<wbr>typeof(y)*)1))<br>
&nbsp; &nbsp; #define min(x,y)&nbsp; &nbsp;(__check_type(x,y),__min(x,y))<br>
&nbsp; &nbsp; #define max(x,y)&nbsp; &nbsp;(__check_type(x,y),__max(x,y))<br>
<br>
&nbsp; &nbsp; #define min_t(t,x,y) __min((t)(x),(t)(y))<br>
&nbsp; &nbsp; #define max_t(t,x,y) __max((t)(x),(t)(y))<br>
<br>
and then __min/__max and friends are much simpler (and can just assume<br>
that the type is already fine, and the casting has been done).<br>
<br>
This is technically entirely independent of this VLA cleanup thing,<br>
but the "passing the types around unnecessarily" just becomes more<br>
obvious when there's now another level of macros, _and_ it's a more<br>
complex expression too.<br>
<br>
Yes, yes, the __single_eval_xyz() functions still end up wanting the<br>
types for the declaration of the new single-evaluation variables, but<br>
the 'typeof' pattern is the standard pattern, so<br>
<br>
#define __single_eval_max(max1, max2, x, y) ({&nbsp; \<br>
&nbsp; &nbsp; &nbsp; &nbsp; typeof (x) max1 = (x);&nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; \<br>
&nbsp; &nbsp; &nbsp; &nbsp; typeof (y) max2 = (y);&nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; \<br>
<span class="">&nbsp; &nbsp; &nbsp; &nbsp; max1 &gt; max2 ? max1 : max2; })<br>
<br>
</span>actually looks more natural to me than passing the two types in as<br>
arguments to the macro.<br>
<br>
(That form also is amenable to things like "__auto_type" etc
simplifications).<br>
<br>
Side note: do we *really* need the unique variable names? That's what<br>
makes those things _really_ illegible. I thgink it's done just for a<br>
sparse warning that we should probably ignore. It's off by default<br>
anyway exactly because it doesn't work that well due to nested macro<br>
expansions like this.<br>
<br>
There is very real value to keeping our odd macros legible, I feel.<br>
Even when they are complicated by issues like this, it would be good<br>
to keep them as simple as possible.<br>
<br>
Comments?<br>
<span class="HOEnZb"><font color="#888888"><br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Linus<br>
</font></span></blockquote></div><br><br clear="all"><div><br></div>--
<br><div class="gmail_signature" data-smartmail="gmail_signature">Kees
Cook<br>Pixel Security</div>
</div>
