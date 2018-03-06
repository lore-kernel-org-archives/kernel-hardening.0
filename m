MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAK8P3a0ko9E91jok0fSnwQ__vO8nzBpmki768t_-Z9MhZ_f-JQ@mail.gmail.com>
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <1520107232-14111-5-git-send-email-alex.popov@linux.com> <b52a2cca-cb5c-d47f-131e-7db297f78958@linux.intel.com>
 <CAGXu5jLRpJ7ktij4TpaSG-RZLOou=RWyY_=jTMNE87+E4Xp2Ag@mail.gmail.com>
 <CA+55aFxEAYyrUkApo-dtZvxcYbvWBZJpUytjbm7e2wruTvbYjQ@mail.gmail.com>
 <CAGXu5j+-AjMKxOYDOpbmJ4X357JRGWViAOmqyqd6bu_w47mffw@mail.gmail.com>
 <20180306080855.phtgl2bzqm5hnthu@gmail.com> <CA+DvKQ+uQD0qyMvwqaRd_sMLBHE5q9pcfOQ+VknBW2==q0NJJA@mail.gmail.com>
 <CA+55aFwgmTaaA8QqMGm+VzRNbpKxDXbq2MtKyayyq8f+=PqWqA@mail.gmail.com>
 <CAKv+Gu_VaO39h8trgsNhU4JEVkdgoFWGoovBdmAL_YsHe7Nq1Q@mail.gmail.com>
 <CA+55aFxkzxhGaK=sp2CqM1YFEE=fL33wC1TR4KKqsRqPGto6yA@mail.gmail.com>
 <CAK8P3a0bWWZbFW5AFag=vRKC=PbCbwaLNPNiyk1ziJk=fTe0nQ@mail.gmail.com>
 <CA+55aFxTdT11pxKL7oscN=2bu8wkiZbZgDfQd_Emqk1Z1Qqb7A@mail.gmail.com>
 <20180306163616.7e3b6e0e@vmware.local.home> <CAK8P3a0ko9E91jok0fSnwQ__vO8nzBpmki768t_-Z9MhZ_f-JQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Mar 2018 14:19:21 -0800
Message-ID: <CA+55aFybrMeMDEW6bO6XkLVzvgaz9bzTM7CMFxxwHnwD4bcebg@mail.gmail.com>
Subject: Re: [PATCH RFC v9 4/7] x86/entry: Erase kernel stack in syscall_trace_enter()
Content-Type: text/plain; charset="UTF-8"
To: Arnd Bergmann <arnd@arndb.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Daniel Micay <danielmicay@gmail.com>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 6, 2018 at 1:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> I don't really understand it myself, but I do understand that
> the gcc developers think this is a hard problem to solve.

Depending on the internal representation, things that look absolutely
trivially obvious to humans may not actually be all that trivial at
all.

In particular, the only sane modern IR for a compiler is based on SSA
(single static assignment), and in that form, the example code is
actually very obvious: the variable 'i' is assigned to exactly once,
and has the value 1, so *OBVIOUSLY* the value of 'i' is 1 at each use.

It's really so obvious that sparse does exactly the same. If you use
the sparse "test-linearize" program, you will see that test program
result in

  g:
  .L0:
      <entry-point>
      ret.32      $1

because it is very obvious to the optimizer that 'i' is 1.

In fact, to get anything else, you almost _have_ to initialize 'i' to
"UNDEFINED" in the compiler. At that point the SSA representation says
'i' has two sources, one undefined and one '1', and all the SSA
optimizations and simplifications just DTRT automatically.

But it literally involves adding that initialization.

This is actually one reason I think the C "automatic variables are
undefined" behavior is wrong. It made sense historically, but in an
SSA world, it actually ends up not even helping.

You might as well just initialize the damn things to zero, avoiding an
undefined case and just be done with it, and make that part of the
language definition. It would just be consistent with static variables
anyway, so it would actually clean up the language conceptually too.

Of course, within the confines of C _history_, that didn't make sense.
SSA became a thing two decades after C had been invented, and it took
even longer for it to become the de-facto standard IR for any sane
optimization.

Honestly, that whole "local variable might be used uninitialized" is
just a historical accident, and is not some fundamentally good
warning. It's _only_ a valid warning due to a language mis-feature.

                     Linus
