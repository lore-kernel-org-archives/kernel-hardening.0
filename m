MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20180306172927.7a975cee@vmware.local.home>
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <b52a2cca-cb5c-d47f-131e-7db297f78958@linux.intel.com> <CAGXu5jLRpJ7ktij4TpaSG-RZLOou=RWyY_=jTMNE87+E4Xp2Ag@mail.gmail.com>
 <CA+55aFxEAYyrUkApo-dtZvxcYbvWBZJpUytjbm7e2wruTvbYjQ@mail.gmail.com>
 <CAGXu5j+-AjMKxOYDOpbmJ4X357JRGWViAOmqyqd6bu_w47mffw@mail.gmail.com>
 <20180306080855.phtgl2bzqm5hnthu@gmail.com> <CA+DvKQ+uQD0qyMvwqaRd_sMLBHE5q9pcfOQ+VknBW2==q0NJJA@mail.gmail.com>
 <CA+55aFwgmTaaA8QqMGm+VzRNbpKxDXbq2MtKyayyq8f+=PqWqA@mail.gmail.com>
 <CAKv+Gu_VaO39h8trgsNhU4JEVkdgoFWGoovBdmAL_YsHe7Nq1Q@mail.gmail.com>
 <CA+55aFxkzxhGaK=sp2CqM1YFEE=fL33wC1TR4KKqsRqPGto6yA@mail.gmail.com>
 <CAK8P3a0bWWZbFW5AFag=vRKC=PbCbwaLNPNiyk1ziJk=fTe0nQ@mail.gmail.com>
 <CA+55aFxTdT11pxKL7oscN=2bu8wkiZbZgDfQd_Emqk1Z1Qqb7A@mail.gmail.com>
 <20180306163616.7e3b6e0e@vmware.local.home> <CA+55aFze-do7sAvg1=z=Yb4p8J2EJ5Eyr6MLdMbgQKwMrO5hxQ@mail.gmail.com>
 <CA+55aFyv4wDxLQDbzB14HgW8ddu-w2VFteh5JQ57Jkw46mCVAw@mail.gmail.com> <20180306172927.7a975cee@vmware.local.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Mar 2018 14:41:55 -0800
Message-ID: <CA+55aFyuQZ-cYxPeGF2VJu2GjzznQTua6sVBi4+CFdUi+=+Ajw@mail.gmail.com>
Subject: Re: [PATCH RFC v9 4/7] x86/entry: Erase kernel stack in syscall_trace_enter()
Content-Type: text/plain; charset="UTF-8"
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Daniel Micay <danielmicay@gmail.com>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 6, 2018 at 2:29 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Yeah but I would argue that static variables are different.

Not really.

You're basically saying "I'd like my language to have intrinsic
undefined behavior, so that when I hit a bug that might trigger that
undefined behavior I get a warning":.

Do such bugs happen? Sure. But _other_ bugs happen all the time, and
the ONLY real reason you are so adamant about _that_ particular
warning, is that "undefined behavior" is such a serious problem.

Think about that for a second.

Make the serious problem go away, and the warning MAKES NO SENSE.

Do you want a compiler to warn you when you write code like this:

    double area(double radius)
    {
         return radius*2*pi;
    }

just because it's obviously buggy shit?

And do you *really* expect a compiler warning for that kind of
obviously buggy shit?

I bet you don't.

And if you don't, why do you expect a compiler warning for

  int g(int c)
  {
         int i = 0;
         if (c)
                 i = 1;
         return i;
  }

which is *literally* what your example would have been had just C been
specified to avoid unnecessary undefined behavior?

Seriously. Look at that example, and tell me that gcc should warn
about it. I can imagine the warning ("warning: function 'g()' is
stupidly written, just use !!c").

But nobody sane really would expect a compiler to warn about it. Once
a compiler is that smart, you wouldn't write code for it, you'd just
ask it to generate code from a description.

Guys, everybody agrees that C isn't a safe language.

Do you think that lack of safety is a _good_ thing?

Do you realize that most of the lack of safety is almost directly
about flexibility, simplicity, and good code generation?

But what if I told you that some of the lack of safety doesn't
actually add to flexibility, simplicity, _or_ good code generation?
Wouldn't you say "we don't want it to be unsafe" then?

I'm literally telling you that lack of variable initialization is
almost purely a bad thing. C would be a safer language, with less
undefined behavior, if it just made the initialization of automatic
variables be something you cannot avoid.

For scalars in particular, there is basically no downside. Aggregate
types really are much less black-and-white.

                 Linus
