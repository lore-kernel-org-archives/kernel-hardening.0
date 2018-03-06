MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jJaTR25zZp5sGqc6m3nv3AunYhEZhxtB_JuP2WFbv_pfg@mail.gmail.com>
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <1520107232-14111-5-git-send-email-alex.popov@linux.com> <b52a2cca-cb5c-d47f-131e-7db297f78958@linux.intel.com>
 <CAGXu5jLRpJ7ktij4TpaSG-RZLOou=RWyY_=jTMNE87+E4Xp2Ag@mail.gmail.com>
 <CA+55aFxEAYyrUkApo-dtZvxcYbvWBZJpUytjbm7e2wruTvbYjQ@mail.gmail.com>
 <CAGXu5j+-AjMKxOYDOpbmJ4X357JRGWViAOmqyqd6bu_w47mffw@mail.gmail.com>
 <CA+55aFxpzgQiJg8XyQTH-hDHd7A0jRAtOJ8b6krrvNDQX96Vrw@mail.gmail.com> <CAGXu5jJaTR25zZp5sGqc6m3nv3AunYhEZhxtB_JuP2WFbv_pfg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Mar 2018 20:30:28 -0800
Message-ID: <CA+55aFyknMsiT3efAeOyf32O2NJjD9vt0XxtAegFVmmn+pvxgA@mail.gmail.com>
Subject: Re: [PATCH RFC v9 4/7] x86/entry: Erase kernel stack in syscall_trace_enter()
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 5, 2018 at 4:56 PM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Mar 5, 2018 at 1:40 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>  and we already obviously limit that kind of broken behavior
>> with -fwrapv and -fno-strict-alias.
>
> And -fno-delete-null-pointer-checks, and and and.... :P

Indeed.

> The recent discussions on minimum compiler version underscore the fact
> that people move forward on compilers _very_ slowly.

Yes.

At the same time, things like that are kind of like a config option
for hardening - it's not like everybody absolutely needs to have the
compiler support, but people who want it can.

Sure, it limits us in some ways (ie we can't just say "we _depend_ on
automatic variables being zero"), but as long as it's not a huge
maintenance burden, it probably doesn't much matter.


>> And it doesn't necessarily generate any worse code.
>
> I agree, though some performance-sensitive subsystem (e.g. networking)
> get very defensive about an always-on stack initialization[2]. No
> matter what happens with this kind of automatic initialization, I
> suspect it's going to have to stay a build-time option to let some
> people opt-out of it.

I do think that having some way of marking "this variable really
doesn't need zeroing" would be fine.

Then peope'd *think* about the fact that you're passing an actual
uninitialized piece of memory around, and people could be careful with
them.

And the places that would actually want that should show up like a
sore thumb in a profile. And if they don't, then clearly the zeroing
can't be much of an issue, can it?

> Another case is that this series provides actual stack probing to
> detect VLA abuse. This is less of an issue now with VMAP_STACK, and
> I've had VLA removal on the long-term goal list for the kernel for a
> while now, but the probing does work...

I was actually hoping that the clang people would get rid of those,
but they only seemed to care about VLA's in structures, not about them
in general ;(

I detest VLA's, we really shouldn't use them. I'm sorry we have any.

              Linus
