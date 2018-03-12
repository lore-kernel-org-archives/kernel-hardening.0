MIME-Version: 1.0
In-Reply-To: <20180312082226.ciggxv37cgcazs3j@gmail.com>
References: <20180306080855.phtgl2bzqm5hnthu@gmail.com> <CA+DvKQ+uQD0qyMvwqaRd_sMLBHE5q9pcfOQ+VknBW2==q0NJJA@mail.gmail.com>
 <CA+55aFwgmTaaA8QqMGm+VzRNbpKxDXbq2MtKyayyq8f+=PqWqA@mail.gmail.com>
 <CAKv+Gu_VaO39h8trgsNhU4JEVkdgoFWGoovBdmAL_YsHe7Nq1Q@mail.gmail.com>
 <CA+55aFxkzxhGaK=sp2CqM1YFEE=fL33wC1TR4KKqsRqPGto6yA@mail.gmail.com>
 <CAK8P3a0bWWZbFW5AFag=vRKC=PbCbwaLNPNiyk1ziJk=fTe0nQ@mail.gmail.com>
 <CA+55aFxTdT11pxKL7oscN=2bu8wkiZbZgDfQd_Emqk1Z1Qqb7A@mail.gmail.com>
 <20180306163616.7e3b6e0e@vmware.local.home> <CA+55aFze-do7sAvg1=z=Yb4p8J2EJ5Eyr6MLdMbgQKwMrO5hxQ@mail.gmail.com>
 <CA+55aFyv4wDxLQDbzB14HgW8ddu-w2VFteh5JQ57Jkw46mCVAw@mail.gmail.com> <20180312082226.ciggxv37cgcazs3j@gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 12 Mar 2018 09:00:51 +0000
Message-ID: <CAKv+Gu-N8mZNu5b4X_+dv37R6gLKn-3EdX+xa40t2bB6fgVTZg@mail.gmail.com>
Subject: Re: [PATCH RFC v9 4/7] x86/entry: Erase kernel stack in syscall_trace_enter()
Content-Type: text/plain; charset="UTF-8"
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>, Daniel Micay <danielmicay@gmail.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 12 March 2018 at 08:22, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Tue, Mar 6, 2018 at 1:41 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>> >
>> > The warning would remain for the case where you don't enable this
>> > hardening feature, so it wouldn't go away.
>>
>> Side note: if in ten years we'd have a minimum gcc version that we
>> could  just unconditionally say "auto (scalars) initialize to zero",
>> then we'd just make that be the *semantics*, and the warning would
>> obviously simply not ever be an issue.
>
> Btw., I'd suggest we initialize aggregate types to zero as well, and then work
> from there by marking exceptions via attributes.
>

I'd argue that we need to move to struct assignment for constructors,
similar to how checkpatch recommends it over memcpy()/memset().

That way, the compiler can tell that such a variable is being
assigned, and so it can warn in the usual way when it notices a code
path that does not involve an initialization. At the same time, it
will warn about not returning a value if there is a code path in the
constructor that results in no initialization being performed.

It should also help the compiler optimize by keeping such variables
entirely in registers if the address is never taken otherwise.

> From what I've seen over 90% of 'tricky' initialization sequences either don't
> matter to performance, or are unnecessarily complicated.
>
> I.e. let's eliminate VLAs and let's also make the object initialization aspect of
> the C language reliably and broadly safe by default (via a GCC plugin) with no
> exceptions, and allow an opt-in mechanism for more fragile (but faster if coded
> correctly) constructs.
>
> Is it possible to implement this "safe automatic variable initialization" language
> feature via a GCC plugin robustly, while still keeping code generation sane? (i.e.
> no forced allocation of stack slots, etc.) It should be a superset of
> CONFIG_GCC_PLUGIN_STRUCTLEAK=y.
>

I think that should be feasible, yes.

It would be worth trying whether the current code can be simplified,
though: it currently takes care not to add such an initialization if
it can already spot one, but I wonder whether just blindly adding one
at the start and letting the compiler optimize it away again is safer.

> Plugin support is present in GCC version 4.5 and higher, correct? So if such a
> plugin is possible we could raise the minimum GCC version to support it
> unconditionally.
>

I think that would be reasonable, yes, but we should check across
architectures as well.
