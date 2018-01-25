MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFyONQeyHit6LcQz_JM5+C9pr61fcWFSpdn=7K_2mZN+oA@mail.gmail.com>
References: <503224b776b9513885453756e44bab235221124e.1516644136.git.luto@kernel.org>
 <CA+55aFwcU_hHz+S9ZDphBDRQLw6pMsd+6Yp_=mQA8kTcmTzWcQ@mail.gmail.com> <CA+55aFyONQeyHit6LcQz_JM5+C9pr61fcWFSpdn=7K_2mZN+oA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Jan 2018 11:16:27 -0800
Message-ID: <CA+55aFxMDAaQ-d3ktWCjcob8OQARcE=OWFXNJtQnW62rF-XY0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: Andy Lutomirski <luto@kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Cox <alan@linux.intel.com>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 25, 2018 at 10:48 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So the biggest impact of this is the extra register saves

Actually, the other noticeable part is the reloading of the argument
registers from ptregs. Together with just the extra level of
'call/ret' and the stack setup, I'm guessing we're talking maybe 20
cycles or so.

So there's the extra register saves, and simply the fact that the
fastpath had a flatter calling structure.

It still feels worth it. And if we do decide that we want to do the
register clearing on kernel entry for some paranoid mode, we'd pretty
much have to do this anyway.

                 Linus
