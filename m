MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <503224b776b9513885453756e44bab235221124e.1516644136.git.luto@kernel.org>
References: <503224b776b9513885453756e44bab235221124e.1516644136.git.luto@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 22 Jan 2018 10:55:32 -0800
Message-ID: <CA+55aFwcU_hHz+S9ZDphBDRQLw6pMsd+6Yp_=mQA8kTcmTzWcQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: Andy Lutomirski <luto@kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Cox <alan@linux.intel.com>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 22, 2018 at 10:04 AM, Andy Lutomirski <luto@kernel.org> wrote:
> The existing retpoline code carefully and awkwardly retpolinifies
> the SYSCALL64 slow path.  This stops the fast path from being
> particularly fast, and it's IMO rather messy.

I'm not convinced your patch isn't messier still.. It's certainly
subtle. I had to look at that ptregs stub generator thing twice.

Honestly, I'd rather get rid of the fast-path entirely. Compared to
all the PTI mess, it's not even noticeable.

And if we ever get CPU's that have this all fixed, we can re-visit
introducing the fastpath. But this is all very messy and it doesn't
seem worth it right now.

If we get rid of the fastpath, we can lay out the slow path slightly
better, and get rid of some of those jump-overs. And we'd get rid of
the ptregs hooks entirely.

So we can try to make the "slow" path better while at it, but I really
don't think it matters much now in the post-PTI era. Sadly.

                     Linus
