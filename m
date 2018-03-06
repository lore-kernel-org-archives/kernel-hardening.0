MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAK8P3a12YVBK6rtXwubW-0W3XwEbF+BU21MN1Fx8OrA4-2S7vw@mail.gmail.com>
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
 <CAK8P3a3BA2BueHOuOiszEzkBtA80QDdo3wgX+62=KXCdi9wScQ@mail.gmail.com>
 <CA+55aFxeJ-6JB-DeZavyzeAYrcdjM=5tMM5dMxvNgT5WJLfQMQ@mail.gmail.com> <CAK8P3a12YVBK6rtXwubW-0W3XwEbF+BU21MN1Fx8OrA4-2S7vw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Mar 2018 14:24:53 -0800
Message-ID: <CA+55aFy-imLQ9WeA880qR_DqKTpCiH2-3ou6_NScBGOKGE=-fQ@mail.gmail.com>
Subject: Re: [PATCH RFC v9 4/7] x86/entry: Erase kernel stack in syscall_trace_enter()
Content-Type: text/plain; charset="UTF-8"
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Daniel Micay <danielmicay@gmail.com>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 6, 2018 at 2:09 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Mar 6, 2018 at 10:29 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Yes, it can obviously generate some extra code for the "pass pointer
>> to uninitialized scalar around to be initialized", where it can now
>> make that stack slot be initialized to zero - so it can generate extra
>> code. But disabling an optimization?
>>
>> What did you have in mind?
>
> The type of optimization that causes my earlier example

That's not a  valid "optimization". It doesn't make correct code run
faster. It just makes incorrect code result in incorrect results.

See my previous email about _why_ it does it, but the point remains:
the "optimization" is not actually an optimization. It's just "garbage
in, garbage out". Speed doesn't matter for garbage.

In fact, see my explanation for _why_ that optimization happens to
understand why adding an iniitializer doesn't make it go slower, but
simply makes ie well-defined and thus makes the optimization go away.

Really, only stupid compiler people think it's an "optimization" to
take advantage of undefined behavior. Sure, garbage code generation
can run faster, but that's not "optimization".

We want to very much avoid those kinds of people, and those kinds of
optimizations. It's very much why we disable strict aliasing etc -
because the whole optimization is purely based on taking advantage of
undefined behavior.

It's shit. Don't call it anything else. Getting rid of that
optimization is a *good* thing, not a bad thing.

                 Linus
