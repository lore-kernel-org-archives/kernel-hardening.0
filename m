MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <596c917e-3183-d80a-89d4-97e0eb5dc077@infradead.org>
References: <1511921105-3647-1-git-send-email-me@tobin.cc> <1511921105-3647-5-git-send-email-me@tobin.cc>
 <CA+55aFxgGb13hqoNQ8bzFn4ENZM25PBSdi5pkFUBa5Hk+j-s3Q@mail.gmail.com>
 <324abe19f1ee4177911d2fc48899ac8a@AcuMS.aculab.com> <CAGXu5j+xUt+coLCKg9qeCrTzc7HEM7KP=1Z-xTiDXWSRYibJQg@mail.gmail.com>
 <c47f7659676246d6bbeb5230b952a5ad@AcuMS.aculab.com> <596c917e-3183-d80a-89d4-97e0eb5dc077@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Dec 2017 13:22:47 -0800
Message-ID: <CA+55aFw3AZtzf6KHS4desHJ3CajKs46VQxOi6-+0U8A4y0v6ug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH V11 4/5] vsprintf: add printk specifier %px
To: Randy Dunlap <rdunlap@infradead.org>
Cc: David Laight <David.Laight@aculab.com>, Kees Cook <keescook@chromium.org>, "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?Q?Radim_Krcm=C3=A1r?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 5, 2017 at 1:08 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>
> This kind of option (with default hashed) is what I was just thinking of
> after having seen a few unhelpful traces.  But then the knob might not be
> changed in time for the traces either. :(

.. I really dislike the idea of such a knob.

First off, the traces I've seen that had the new %p behavior, the
hashing didn't actually matter AT ALL. The only values that were
hashed were values that weren't actually useful for debugging the
oops.

Secondly, the notion that "we want a unhashed knob for debugging" is
exactly the wrong kind of mentality. 99% of all bug reports happen in
the wild - not on developer boxes. So by default, those bug reports
had better happen with hashing enabled, or it's all entirely
pointless.

If you have an oops that happens on your own box due to code that
you're writing yourself (and expect to debug yourself), then honestly,
the hashing is going to be the least of your issues. If you can't find
out the bug under those circumstances, and you're confused by the tiny
detail of hashing, you're doing something wrong.

So the case that matters is when an oops comes from some outside
source that won't have turned the knob off anyway.

So no. We're not adding a knob. It is fundamentally pointless.

It's not like those hex numbers were really helping people anyway.
We've turned off most of them on x86 oops reports long ago (and
entirely independently of the pointer hashing). Having stared at a lot
of oopses in my time, the only hex numbers that tend to be really
relevant are (a) the register contents (which aren't %p anyway), and
things like the faulting address (which is not, and never has been, %p
on x86, but might be on some other architecture).

Honestly, the next time anybody says "hashing makes debugging harder",
I'm going to require some actual proof of an actual oops where it
mattered that a particular value was hashed.

Not hand-waving.

Not "it surprised and confused me" because it looked different. You'll
get used to it.

So an actual "this was critical information that mattered for this
particular bug, and it was missing due to the hashing of this
particular value and debugging was harder in actual reality due to
that".

Because the actual example I have seen so far, not only didn't the
hashing matter AT ALL, most of the _unhashed_ values shouldn't have
been there either, and were due to arm still printing stuff that
shouldn't have been printed at all and just made the oops more complex
and harder to read and report.

            Linus
