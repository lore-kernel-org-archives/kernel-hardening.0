MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5j+4mEyhE6shkxWqY4AVQGcq2U7nzf4j_n2+CdW2t6CzqQ@mail.gmail.com>
References: <CAGXu5j+4mEyhE6shkxWqY4AVQGcq2U7nzf4j_n2+CdW2t6CzqQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Mar 2018 10:09:12 -0700
Message-ID: <CA+55aFykZL+cSBJjBBts7ebEFfyGPdMzTmLSxKnT_29=j942dA@mail.gmail.com>
Subject: Re: Fully initialized stack usage (was Re: [PATCH RFC v9 4/7]
 x86/entry: Erase kernel stack in syscall_trace_enter())
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, P J P <pjp@fedoraproject.org>, Florian Weimer <fweimer@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>, Daniel Micay <danielmicay@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 12, 2018 at 9:42 AM, Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, Feb 27, 2018 at 3:15 AM, P J P <ppandit@redhat.com> wrote:
>> Please see:
>>   -> https://gcc.gnu.org/ml/gcc-patches/2014-06/msg00615.html
>>
>> This experimental patch by Florian Weimer(CC'd) adds an option
>> '-finit-local-vars' to gcc(1) compiler. When a program(or kernel)
>> is built using this option, its automatic(local) variables are
>> initialised with zero(0). This could significantly reduce the kernel
>> information leakage issues.

Oh, I love that patch.

THAT is the kind of thing we should do. It's small, it's trivial, and
it's done early in the parsing stage, so later stages will almost
certainly end up optimizing things away.

The only complaint I have is that the Fortran front-end already has
(some of) that functionality, and calls it something else, and allows
you to specify more exactly what you want to clear.

Florian, are you aware of the Fortran flags?

  -finit-local-zero
  -finit-derived
  -finit-integer=n
  -finit-real=<zero|inf|-inf|nan|snan>
  -finit-logical=<true|false>
  -finit-character=n

they aren't perfect for C, but some of them do make sense at least
conceptually: things like being able to specify whether arrays and
structures should be initialized (-finit-derived is kind of relevant)
might make sense.

In the kernel we'd likely always do it unconditionally (apart from
optional per-function or per-declaration considerations) but I could
easily see some other projects saying "do it for scalars but not for
aggregate types". Because they might want the convenience, but not the
expense.

> Getting this implemented directly in the compiler would be preferred
> over a plugin. (Prototyping may be easier in the plugin, though.)

Absolutely.  I think it's better in gcc simply because I suspect a
number of other projects might use this flag too. A plugin is rather
cumbersome.

That said, the patch is literally right at the PLUGIN_FINISH_DECL, so
doing it as a plugin for older compiler versions, or for just testing,
might still be useful.

> Considerations:
>
> - the kernel needs a way to "opt out" of this for places where later
> functions will do the initialization. Something like
> __attribute__((no_automatic_variable_init)) ?

Yes, that's going to make it more palatable to some uses.

However, somebody who knows gcc needs to verify that it does the right
things when inlining happens.

And honestly, it would be better to make it per-variable, not per
function. That would fit the structure of that patch too, I think. It
iterates over variables anyway to generate the initialization.

> - initialization _must include structure padding_. Without this, we're
> only solving part of the exposure. Does -finit-local-vars do this?

Good point. It uses build_constructor() with an empty constructor, so
it *should* be 100% equivalent to

    struct xyz var = { };

if I understand correctly, but I'm not sure what that will do with padding.

> - Can we retain the uninitialized variable usage warning? (with an
> updated text; maybe "variable used without explicit initialization,
> using zero-initialization"?)

I think that fundamentally goes away, because all later phases see
fully initialized state.

               Linus
