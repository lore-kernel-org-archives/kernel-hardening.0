MIME-Version: 1.0
References: <20181011185458.10186-1-kristen@linux.intel.com>
 <CALCETrVaZu2eq67ai0Oh=HWyZKg-OaoZx7yUT2AvStAhQ+rxyQ@mail.gmail.com>
 <CAGXu5jLWO1StCz2ejBPW-p4B5XHEKdCGvOi1JKrKxg5UFSa3Ag@mail.gmail.com> <CALCETrVG5=iqfohYxKSvAQx3DhzD95MhmDU3mU8+kCegps2cbw@mail.gmail.com>
In-Reply-To: <CALCETrVG5=iqfohYxKSvAQx3DhzD95MhmDU3mU8+kCegps2cbw@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 12 Oct 2018 00:11:19 +0200
Message-ID: <CAG48ez1TNd5eJCE=x6LeqGO3x2E1rn244xqc2ccnZ3wmeP05XA@mail.gmail.com>
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
Content-Type: text/plain; charset="UTF-8"
To: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, kristen@linux.intel.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 11, 2018 at 11:17 PM Andy Lutomirski <luto@kernel.org> wrote:
> On Thu, Oct 11, 2018 at 1:55 PM Kees Cook <keescook@chromium.org> wrote:
> > On Thu, Oct 11, 2018 at 1:48 PM, Andy Lutomirski <luto@kernel.org> wrote:
> > > On Thu, Oct 11, 2018 at 11:55 AM Kristen Carlson Accardi
> > > <kristen@linux.intel.com> wrote:
> > >>
> > >> This patch aims to make it harder to perform cache timing attacks on data
> > >> left behind by system calls. If we have an error returned from a syscall,
> > >> flush the L1 cache.
> > >>
> > >> It's important to note that this patch is not addressing any specific
> > >> exploit, nor is it intended to be a complete defense against anything.
> > >> It is intended to be a low cost way of eliminating some of side effects
> > >> of a failed system call.
> > >>
> > >> A performance test using sysbench on one hyperthread and a script which
> > >> attempts to repeatedly access files it does not have permission to access
> > >> on the other hyperthread found no significant performance impact.
> > >>
> > >> Suggested-by: Alan Cox <alan@linux.intel.com>
> > >> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> > >> ---
> > >>  arch/x86/Kconfig        |  9 +++++++++
> > >>  arch/x86/entry/common.c | 18 ++++++++++++++++++
> > >>  2 files changed, 27 insertions(+)
> > >>
> > >> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > >> index 1a0be022f91d..bde978eb3b4e 100644
> > >> --- a/arch/x86/Kconfig
> > >> +++ b/arch/x86/Kconfig
> > >> @@ -445,6 +445,15 @@ config RETPOLINE
> > >>           code are eliminated. Since this includes the syscall entry path,
> > >>           it is not entirely pointless.
> > >>
> > >> +config SYSCALL_FLUSH
> > >> +       bool "Clear L1 Cache on syscall errors"
> > >> +       default n
> > >> +       help
> > >> +         Selecting 'y' allows the L1 cache to be cleared upon return of
> > >> +         an error code from a syscall if the CPU supports "flush_l1d".
> > >> +         This may reduce the likelyhood of speculative execution style
> > >> +         attacks on syscalls.
> > >> +
> > >>  config INTEL_RDT
> > >>         bool "Intel Resource Director Technology support"
> > >>         default n
> > >> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
> > >> index 3b2490b81918..26de8ea71293 100644
> > >> --- a/arch/x86/entry/common.c
> > >> +++ b/arch/x86/entry/common.c
> > >> @@ -268,6 +268,20 @@ __visible inline void syscall_return_slowpath(struct pt_regs *regs)
> > >>         prepare_exit_to_usermode(regs);
> > >>  }
> > >>
> > >> +__visible inline void l1_cache_flush(struct pt_regs *regs)
> > >> +{
> > >> +       if (IS_ENABLED(CONFIG_SYSCALL_FLUSH) &&
> > >> +           static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
> > >> +               if (regs->ax == 0 || regs->ax == -EAGAIN ||
> > >> +                   regs->ax == -EEXIST || regs->ax == -ENOENT ||
> > >> +                   regs->ax == -EXDEV || regs->ax == -ETIMEDOUT ||
> > >> +                   regs->ax == -ENOTCONN || regs->ax == -EINPROGRESS)
> > >
> > > What about ax > 0?  (Or more generally, any ax outside the range of -1
> > > .. -4095 or whatever the error range is.)  As it stands, it looks like
> > > you'll flush on successful read(), write(), recv(), etc, and that
> > > could seriously hurt performance on real workloads.
> >
> > Seems like just changing this with "ax == 0" into "ax >= 0" would solve that?
>
> I can easily imagine that there are other errors for which performance
> matters.  EBUSY comes to mind.
>
> >
> > I think this looks like a good idea. It might be worth adding a
> > comment about the checks to explain why those errors are whitelisted.
> > It's a cheap and effective mitigation for "unknown future problems"
> > that doesn't degrade normal workloads.
>
> I still want to see two pieces of information before I ack a patch like this:
>
>  - How long does L1D_FLUSH take, roughly?

(Especially if L1D is dirty and you can't just wipe it all.)

>  - An example of a type of attack that would be mitigated.
>
> For the latter, I assume that the goal is to mitigate against attacks
> where a syscall speculatively loads something sensitive and then
> fails.  But, before it fails, it leaks the information it
> speculatively loaded, and that leak ended up in L1D but *not* in other
> cache levels.  And somehow the L1D can't be probed quickly enough in a
> parallel thread to meaningfully get the information out of L1D.

And the attacker can't delay the syscall return somehow, e.g. on a
fully-preemptible kernel by preempting the syscall, or by tarpitting a
userspace memory access in the error path.

> Or
> maybe it's trying to mitigate against the use of failing syscalls to
> get some sensitive data into L1D and then using something like L1TF to
> read it out.
>
> But this really needs to be clarified.  Alan said that a bunch of the
> "yet another Spectre variant" attacks would have been mitigated by
> this patch.  An explanation of *how* would be in order.
>
> And we should seriously consider putting this kind of thing under
> CONFIG_SPECULATIVE_MITIGATIONS or similar.  The idea being that it
> doesn't mitigate a clear known attack family.
