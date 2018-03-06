MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFxpzgQiJg8XyQTH-hDHd7A0jRAtOJ8b6krrvNDQX96Vrw@mail.gmail.com>
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <1520107232-14111-5-git-send-email-alex.popov@linux.com> <b52a2cca-cb5c-d47f-131e-7db297f78958@linux.intel.com>
 <CAGXu5jLRpJ7ktij4TpaSG-RZLOou=RWyY_=jTMNE87+E4Xp2Ag@mail.gmail.com>
 <CA+55aFxEAYyrUkApo-dtZvxcYbvWBZJpUytjbm7e2wruTvbYjQ@mail.gmail.com>
 <CAGXu5j+-AjMKxOYDOpbmJ4X357JRGWViAOmqyqd6bu_w47mffw@mail.gmail.com> <CA+55aFxpzgQiJg8XyQTH-hDHd7A0jRAtOJ8b6krrvNDQX96Vrw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 5 Mar 2018 16:56:55 -0800
Message-ID: <CAGXu5jJaTR25zZp5sGqc6m3nv3AunYhEZhxtB_JuP2WFbv_pfg@mail.gmail.com>
Subject: Re: [PATCH RFC v9 4/7] x86/entry: Erase kernel stack in syscall_trace_enter()
Content-Type: text/plain; charset="UTF-8"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 5, 2018 at 1:40 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> This "mindlessly clear stack after use" is stupid.

In defense of the series, it's hardly "mindless". :) The primary
feature is that it has run-time tracking of stack depth to clear only
the minimum needed portion of the stack.

> There are smart things we can do, and it's not just about "find the
> problems" like KASAN, but also "avoid undefined behavior".
>
> I absolutely detest undefined compiler behavior. We should fix it. One
> of the biggest mistakes C ever did was to have "undefined" in the
> standard, and we already obviously limit that kind of broken behavior
> with -fwrapv and -fno-strict-alias.

And -fno-delete-null-pointer-checks, and and and.... :P

What we've done, traditionally, has always been two pronged: fix the
kernel source and fix the compiler. Our kernel fixes have been short
term (fixing specific instances where we notice a problem), with the
compiler fix becoming the global solution down the road once everyone
has that version of the compiler. This leaves a defense gap for bugs
we haven't found yet (which are actually present, whether _we_ know
about them or not :P).

The recent discussions on minimum compiler version underscore the fact
that people move forward on compilers _very_ slowly. I've been trying
to add a third prong (with many of these kinds of defenses), where we
can address the gap. The first two prongs remain: fix the specific
cases as they're uncovered (e.g. by KASan), and fix the global problem
with the compiler (I recently detailed[1] four specific features I
wanted to see from compilers on this front last week). Then the added
third prong is: provide wide coverage _now_ for those that don't have
a fixed compiler (especially when no such fix even exists right now)
to catch all the cases we haven't found yet.

> This is more of the *smart* kind of behavior - I'm also perfectly
> willing to say that automatic variables should just always initialize
> to zero, exactly the same way static variables do.
>
> And it doesn't necessarily generate any worse code.

I agree, though some performance-sensitive subsystem (e.g. networking)
get very defensive about an always-on stack initialization[2]. No
matter what happens with this kind of automatic initialization, I
suspect it's going to have to stay a build-time option to let some
people opt-out of it.

> Honestly, with clearing of automatic variables, what stack leaks
> really exists in practice that this all would help against?

As we both know, we have very different ideas about what "in practice"
means for security flaws. :) So, yes, while auto-init gets us coverage
for a large portion of stack content leak bugs, it's still temporally
different from clearing the stack on exit. For example, a stack read
flaw with a negative index can read out the prior syscall's deeper
stack contents. Stack-clearing also reduces the lifetime of stack
contents (e.g. in the case of cross-thread reads from another process,
the time for the race to read the stack is longer). While these are
certainly more rare cases, they do exist, and I've seen much weirder
attacks.

Another case is that this series provides actual stack probing to
detect VLA abuse. This is less of an issue now with VMAP_STACK, and
I've had VLA removal on the long-term goal list for the kernel for a
while now, but the probing does work...

I would love to see (and am already pursuing) auto-init (see [1]
again), but this series does provide additional coverage, and it does
it today.

-Kees

[1] http://www.openwall.com/lists/kernel-hardening/2018/02/27/41
[2] Both these cases, and so many more, are solved with the byref
initialization plugin, but have been NAKed by -net:
     https://lkml.org/lkml/2013/4/9/641
     https://lkml.org/lkml/2017/10/31/699

-- 
Kees Cook
Pixel Security
