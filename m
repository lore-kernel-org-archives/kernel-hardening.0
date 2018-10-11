MIME-Version: 1.0
References: <20181011185458.10186-1-kristen@linux.intel.com>
 <CALCETrVaZu2eq67ai0Oh=HWyZKg-OaoZx7yUT2AvStAhQ+rxyQ@mail.gmail.com> <CAGXu5jLWO1StCz2ejBPW-p4B5XHEKdCGvOi1JKrKxg5UFSa3Ag@mail.gmail.com>
In-Reply-To: <CAGXu5jLWO1StCz2ejBPW-p4B5XHEKdCGvOi1JKrKxg5UFSa3Ag@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 11 Oct 2018 23:42:46 +0200
Message-ID: <CAG48ez0P7dq+j7gy0dbbS8aLOPC-M3rsbNPuHwXHAMh_bfSQgw@mail.gmail.com>
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, kristen@linux.intel.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 11, 2018 at 10:56 PM Kees Cook <keescook@chromium.org> wrote:
> On Thu, Oct 11, 2018 at 1:48 PM, Andy Lutomirski <luto@kernel.org> wrote:
> > On Thu, Oct 11, 2018 at 11:55 AM Kristen Carlson Accardi
> > <kristen@linux.intel.com> wrote:
> >>
> >> This patch aims to make it harder to perform cache timing attacks on data
> >> left behind by system calls. If we have an error returned from a syscall,
> >> flush the L1 cache.
> >>
> >> It's important to note that this patch is not addressing any specific
> >> exploit, nor is it intended to be a complete defense against anything.
> >> It is intended to be a low cost way of eliminating some of side effects
> >> of a failed system call.
> >>
> >> A performance test using sysbench on one hyperthread and a script which
> >> attempts to repeatedly access files it does not have permission to access
> >> on the other hyperthread found no significant performance impact.
> >>
> >> Suggested-by: Alan Cox <alan@linux.intel.com>
> >> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> >> ---
> >>  arch/x86/Kconfig        |  9 +++++++++
> >>  arch/x86/entry/common.c | 18 ++++++++++++++++++
> >>  2 files changed, 27 insertions(+)
> >>
> >> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> >> index 1a0be022f91d..bde978eb3b4e 100644
> >> --- a/arch/x86/Kconfig
> >> +++ b/arch/x86/Kconfig
> >> @@ -445,6 +445,15 @@ config RETPOLINE
> >>           code are eliminated. Since this includes the syscall entry path,
> >>           it is not entirely pointless.
> >>
> >> +config SYSCALL_FLUSH
> >> +       bool "Clear L1 Cache on syscall errors"
> >> +       default n
> >> +       help
> >> +         Selecting 'y' allows the L1 cache to be cleared upon return of
> >> +         an error code from a syscall if the CPU supports "flush_l1d".
> >> +         This may reduce the likelyhood of speculative execution style
> >> +         attacks on syscalls.
> >> +
> >>  config INTEL_RDT
> >>         bool "Intel Resource Director Technology support"
> >>         default n
> >> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
> >> index 3b2490b81918..26de8ea71293 100644
> >> --- a/arch/x86/entry/common.c
> >> +++ b/arch/x86/entry/common.c
> >> @@ -268,6 +268,20 @@ __visible inline void syscall_return_slowpath(struct pt_regs *regs)
> >>         prepare_exit_to_usermode(regs);
> >>  }
> >>
> >> +__visible inline void l1_cache_flush(struct pt_regs *regs)
> >> +{
> >> +       if (IS_ENABLED(CONFIG_SYSCALL_FLUSH) &&
> >> +           static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
> >> +               if (regs->ax == 0 || regs->ax == -EAGAIN ||
> >> +                   regs->ax == -EEXIST || regs->ax == -ENOENT ||
> >> +                   regs->ax == -EXDEV || regs->ax == -ETIMEDOUT ||
> >> +                   regs->ax == -ENOTCONN || regs->ax == -EINPROGRESS)
> >
> > What about ax > 0?  (Or more generally, any ax outside the range of -1
> > .. -4095 or whatever the error range is.)  As it stands, it looks like
> > you'll flush on successful read(), write(), recv(), etc, and that
> > could seriously hurt performance on real workloads.
>
> Seems like just changing this with "ax == 0" into "ax >= 0" would solve that?

As spender points out on twitter
(https://twitter.com/grsecurity/status/1050497259937370118 - thanks,
spender!), struct pt_regs stores register values as "unsigned long",
and so you'll need to use something like IS_ERR_VALUE().
