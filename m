MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAK8P3a0bWWZbFW5AFag=vRKC=PbCbwaLNPNiyk1ziJk=fTe0nQ@mail.gmail.com>
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <1520107232-14111-5-git-send-email-alex.popov@linux.com> <b52a2cca-cb5c-d47f-131e-7db297f78958@linux.intel.com>
 <CAGXu5jLRpJ7ktij4TpaSG-RZLOou=RWyY_=jTMNE87+E4Xp2Ag@mail.gmail.com>
 <CA+55aFxEAYyrUkApo-dtZvxcYbvWBZJpUytjbm7e2wruTvbYjQ@mail.gmail.com>
 <CAGXu5j+-AjMKxOYDOpbmJ4X357JRGWViAOmqyqd6bu_w47mffw@mail.gmail.com>
 <20180306080855.phtgl2bzqm5hnthu@gmail.com> <CA+DvKQ+uQD0qyMvwqaRd_sMLBHE5q9pcfOQ+VknBW2==q0NJJA@mail.gmail.com>
 <CA+55aFwgmTaaA8QqMGm+VzRNbpKxDXbq2MtKyayyq8f+=PqWqA@mail.gmail.com>
 <CAKv+Gu_VaO39h8trgsNhU4JEVkdgoFWGoovBdmAL_YsHe7Nq1Q@mail.gmail.com>
 <CA+55aFxkzxhGaK=sp2CqM1YFEE=fL33wC1TR4KKqsRqPGto6yA@mail.gmail.com> <CAK8P3a0bWWZbFW5AFag=vRKC=PbCbwaLNPNiyk1ziJk=fTe0nQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Mar 2018 13:01:20 -0800
Message-ID: <CA+55aFxTdT11pxKL7oscN=2bu8wkiZbZgDfQd_Emqk1Z1Qqb7A@mail.gmail.com>
Subject: Re: [PATCH RFC v9 4/7] x86/entry: Erase kernel stack in syscall_trace_enter()
Content-Type: text/plain; charset="UTF-8"
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Daniel Micay <danielmicay@gmail.com>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 6, 2018 at 12:42 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> Forcing gcc to allocate a stack slot and zero-initialize it should
> find many bugs by adding valid warnings, but also add lots of
> false positives as well as prevent important optimizations in other
> places that are actually well-defined.

Oh, no, the "force gcc to allocate a stack slot" would be absolutely insane.

You should never do that. Anybody who does that should be shot.

But you don't have to force any stack allocation. You should just
initialize it to zero (*without* the stack allocation).

Then the optimization passes will just remove the initialization in
99.9% of all cases. Only very occasionally - when gcc cannot see it
being overwritten - would it remain. And those are exactly the cases
where you *want* it to remain.

Of course, it is possible that you can't just do that from a plugin.
But I can almost guarantee that it would be trivial to do as a gcc
switch if any gcc people wanted to do it. Just look at each scalar
auto variable, and if it doesn't have an initializer, just add one to
zero completely mindlessly.

As the crusaders said: "Kill them all and let the optimizer sort them out".

(Note: the "trivial to do" is about scalar values only. Non-scalar
values have more complexities, like struct padding issues etc).

>> If somebody has big arrays on the stack, that's often a problem
>> anyway. It may be common in non-kernel code, but kernel code is very
>> special.
>
> I can think of a few cases that are important, this one is well-known:
>
> int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
>                            fd_set __user *exp, struct timespec64 *end_time)
> {
>         ....
>         /* Allocate small arguments on the stack to save memory and be faster */
>         long stack_fds[SELECT_STACK_ALLOC/sizeof(long)];

Oh, I can well imagine things like this.

But they will be a handful, they will be seen in profiles, and they'd
be easy to mark. And then you can validate the ones you mark, instead
of worrying about all the ones you don't even know about.

> There is also the really scary code like:
>
> #define SKCIPHER_REQUEST_ON_STACK(name, tfm) \
>         char __##name##_desc[sizeof(struct skcipher_request) + \
>                 crypto_skcipher_reqsize(tfm)] CRYPTO_MINALIGN_ATTR; \
>         struct skcipher_request *name = (void *)__##name##_desc

The crypto stuff does disgusting things. It used to do VLA's in
structures too, that has morphed into using these crazy XYZ_ON_STACK()
defines.

They eventually need to fix their own crap at some point. It shouldn't
be something we care about from a design standpoint.

                 Linus
