MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAMzpN2h5_4yMQaKhvLw+eNuifVafpqRPcwzq81O4KvYGrcXFKg@mail.gmail.com>
References: <503224b776b9513885453756e44bab235221124e.1516644136.git.luto@kernel.org>
 <CA+55aFwcU_hHz+S9ZDphBDRQLw6pMsd+6Yp_=mQA8kTcmTzWcQ@mail.gmail.com>
 <CA+55aFyONQeyHit6LcQz_JM5+C9pr61fcWFSpdn=7K_2mZN+oA@mail.gmail.com>
 <CA+55aFxMDAaQ-d3ktWCjcob8OQARcE=OWFXNJtQnW62rF-XY0g@mail.gmail.com> <CAMzpN2h5_4yMQaKhvLw+eNuifVafpqRPcwzq81O4KvYGrcXFKg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Jan 2018 12:54:49 -0800
Message-ID: <CA+55aFy7YA_Zw-uY2JACL_jqGuXMeycSvJVSZdNEFPCyQV2xWg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: Brian Gerst <brgerst@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Cox <alan@linux.intel.com>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 25, 2018 at 12:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
>
> Another extra step the slow path does is checking to see if ptregs is
> safe for SYSRET.  I think that can be mitigated by moving the check to
> the places that do modify ptregs (ptrace, sigreturn, and exec) which
> would set a flag to force return with IRET if the modified regs do not
> satisfy the criteria for SYSRET.

I tried to do some profiling, and none of that shows up for me.

That said, what _also_ doesn't show up is the actual page table switch
on entry. And that seems to be because the per-pcu trampoline code
isn't captures by perf (or at least not shown). Oh well.

What _does_ show up a bit is this in prepare_exit_to_usermode():

#ifdef CONFIG_COMPAT
        /*
         * Compat syscalls set TS_COMPAT.  Make sure we clear it before
         * returning to user mode.  We need to clear it *after* signal
         * handling, because syscall restart has a fixup for compat
         * syscalls.  The fixup is exercised by the ptrace_syscall_32
         * selftest.
         *
         * We also need to clear TS_REGS_POKED_I386: the 32-bit tracer
         * special case only applies after poking regs and before the
         * very next return to user mode.
         */
        current->thread.status &= ~(TS_COMPAT|TS_I386_REGS_POKED);
#endif

and I think the problem there is that it is unnecessarily dirtying
that cacheline. Afaik, those bits are already clear 99.999% of the
time.

So things would be better if that 'status' would be in the thread-info
(to keep cachelines close to the other stuff we already touch) and the
code should have something like

        if (unlikely(ti->status & (TS_COMPAT|TS_I386_REGS_POKED)))

or whatever.

There might be other similar small tuning issues going on.

So there is room for improvement there in the slow path.

                Linus
