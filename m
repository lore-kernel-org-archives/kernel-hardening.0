MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20180306175211.5584cc28@vmware.local.home>
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <CA+55aFxEAYyrUkApo-dtZvxcYbvWBZJpUytjbm7e2wruTvbYjQ@mail.gmail.com>
 <CAGXu5j+-AjMKxOYDOpbmJ4X357JRGWViAOmqyqd6bu_w47mffw@mail.gmail.com>
 <20180306080855.phtgl2bzqm5hnthu@gmail.com> <CA+DvKQ+uQD0qyMvwqaRd_sMLBHE5q9pcfOQ+VknBW2==q0NJJA@mail.gmail.com>
 <CA+55aFwgmTaaA8QqMGm+VzRNbpKxDXbq2MtKyayyq8f+=PqWqA@mail.gmail.com>
 <CAKv+Gu_VaO39h8trgsNhU4JEVkdgoFWGoovBdmAL_YsHe7Nq1Q@mail.gmail.com>
 <CA+55aFxkzxhGaK=sp2CqM1YFEE=fL33wC1TR4KKqsRqPGto6yA@mail.gmail.com>
 <CAK8P3a0bWWZbFW5AFag=vRKC=PbCbwaLNPNiyk1ziJk=fTe0nQ@mail.gmail.com>
 <CA+55aFxTdT11pxKL7oscN=2bu8wkiZbZgDfQd_Emqk1Z1Qqb7A@mail.gmail.com>
 <20180306163616.7e3b6e0e@vmware.local.home> <CA+55aFze-do7sAvg1=z=Yb4p8J2EJ5Eyr6MLdMbgQKwMrO5hxQ@mail.gmail.com>
 <CA+55aFyv4wDxLQDbzB14HgW8ddu-w2VFteh5JQ57Jkw46mCVAw@mail.gmail.com>
 <20180306172927.7a975cee@vmware.local.home> <CA+55aFyuQZ-cYxPeGF2VJu2GjzznQTua6sVBi4+CFdUi+=+Ajw@mail.gmail.com>
 <20180306175211.5584cc28@vmware.local.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Mar 2018 15:09:30 -0800
Message-ID: <CA+55aFzcNfSKc2uU5=okU_g0utnYKoeOueJb5enoP78mqMBZPQ@mail.gmail.com>
Subject: Re: [PATCH RFC v9 4/7] x86/entry: Erase kernel stack in syscall_trace_enter()
Content-Type: text/plain; charset="UTF-8"
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Daniel Micay <danielmicay@gmail.com>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 6, 2018 at 2:52 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I get your point. Basically you are saying that the language should
> have forced all local variables to be initialized to zero in the spec,
> and the compiler is free to optimize that initialization out if the
> variable is always initialized first.

Exactly.

> Just like it would optimize the below.
>
> int g(int c)
> {
>         int i = 0;
>
>         if (c < 10)
>                 i = 1;
>         else
>                 i = 2;
>         return i;
> };
>
> There's no reason to initialize i to zero because it will never return
> zero. But what you are saying is to make that implicit by just
> declaring 'i'.

Yes.

And at the same time, it is certainly true that a compiler cannot
*always* remove the unnecessary initialization.

But with any half-way modern compiler, all the _normal_ cases would be
no-brainers, and the case where the compiler couldn't do so really is
code that almost certainly wants that initialization anyway, because a
_human_ generally wouldn't see that it's initialized either.

The obvious counter-example is literally

> int g(int c)
> {
>         int i = 0;
>
>         initialize_variable(&i);
>
>         if (c < 10)

where a *human* can tell that "hey, that initialization to zero is
pointless, because 'i' is clearly being initialized by that
'initialize_variable()' function call".

But the compiler often cannot see that "obvious" initialization, and
would have to spend the extra instruction to actually do that zero
initialization.

So I'm not saying that it would always be entirely free to just have
the safe default.

But in the context of the kernel, I think that we can probably agree
that "oops, we've had exactly the kind of bug where a function
_didn't_ end up initializing the variable every time even though to a
human obviously thought it did" actually has happened.

Now, as mentioned, aggregate types are different.

They are _less_ different for the kernel than they are for user
programs (because we have to be careful about aggregate types on the
stack anyway just for stack size reasons), but they do have more
issues with the implicit initializers.

For aggregate types, initializers are obviously more expensive to
begin with, and the "initialize by passing a reference to an external
function" is much more common too. So there's a double hit.

At the same time, aggregate types are obviously where we tend to have
most problems, and I really think we should strive to avoid even
medium-sized aggregate types in the kernel anyway.

Which is why I'm much more willing to take a hit on those kinds of
things (that I think should be rare), than add things like "let's just
clear the stack after every system call" kinds of things.

But I do agree that for aggregate types, we almost certainly do want
to have some way to flag "this is explicitly not initialized".

Instead, right now, we're in the reverse situation, where we have to
add explicit initializers.

I think we'd be in a better situation if the *default* semantics was
the safe and well-defined behavior, and we'd have to do extra things
to get the undefined uninitialized behavior for when we know better,
and we really really care.

              Linus
