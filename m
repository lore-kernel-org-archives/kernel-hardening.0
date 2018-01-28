MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20180128202128.GI13338@ZenIV.linux.org.uk>
References: <cover.1517164461.git.luto@kernel.org> <4dd5a4d0f6b694f17eaf64c80c36a2560993b9ea.1517164461.git.luto@kernel.org>
 <CA+55aFxbE6p+3kMumsTfh_E=fR=bteKi4d6WLGaFeBP8JBv_eg@mail.gmail.com> <20180128202128.GI13338@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Jan 2018 12:42:24 -0800
Message-ID: <CA+55aFzScvPkO0JN_OReKMoyRC5KRbn_8bmWKkxVdi9m_X+cgQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 3/3] syscalls: Add a bit of documentation to __SYSCALL_DEFINE
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 28, 2018 at 12:21 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> ... and have more of that logics arch-dependent than one might expect;
> it's *not* just "split each 64bit argument into a pair of 32bit ones,
> combine in the body".

Right. The paired registers tend to have special arch-specific rules,
making this particularly painful.

I suspect that the best solution (and here "best" doesn't mean
"pretty", but doable) is to rely on some of the limits we have:

In particular, we don't want to convert all architectures to the
ptregs approach _anyway_, so we need to have a model where the
architecture sets up some config option.

End result: we don't have to handle the generic case, we just have to
have a way for an architecture to set up for this. And for a _first_
implementation, we can simply just limit things to x86-64 (and then
maybe arm64) which don't even have this issue.

Longer-term, the other thing that helps us is that we have already
limited our calling convention to a maximum of six registers (NOTE!
Not six _arguments_).

So even when we want to handle the 32-bit case, the combinatorial
space is at least fairly limited, and we can make the compiler notice
them (ie the ptregs accessor case can simply be made to error out if
you try to access a 64-bit type from one single register).

End result: we will need the per-architecture macros that access
arguments from the 'struct ptregs', so we'll have some macro for
"argument1(ptregs)".

The 64-bit argument for 32-bit case would end up having to have a few
more of those architecture-specific oddities. So not just
"argument1(ptregs)", but "argument2_32_64(ptregs)" or something that
says "get me argument 2, when the first argument is 32-bit and I want
a 64-bit one".

So _if_ a 32-bit architecture wants this, such an architecture would
probably have to implement 10-20 of those odd special cases. They'll
be ugly and nasty and have little sanity to them, but they'd be simple
one-liners.

So hacky. But not necessarily even needed (I really don't think the
kind of people who care about paranoid security are going to run
32-bit kernels), and if people want to, not _complicated_, just
annoying.

                    Linus
