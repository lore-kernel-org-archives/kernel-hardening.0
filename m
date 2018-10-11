Date: Fri, 12 Oct 2018 00:33:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
In-Reply-To: <CAGXu5jLWO1StCz2ejBPW-p4B5XHEKdCGvOi1JKrKxg5UFSa3Ag@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1810120030530.1457@nanos.tec.linutronix.de>
References: <20181011185458.10186-1-kristen@linux.intel.com> <CALCETrVaZu2eq67ai0Oh=HWyZKg-OaoZx7yUT2AvStAhQ+rxyQ@mail.gmail.com> <CAGXu5jLWO1StCz2ejBPW-p4B5XHEKdCGvOi1JKrKxg5UFSa3Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 11 Oct 2018, Kees Cook wrote:
> On Thu, Oct 11, 2018 at 1:48 PM, Andy Lutomirski <luto@kernel.org> wrote:
> > On Thu, Oct 11, 2018 at 11:55 AM Kristen Carlson Accardi
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
> 
> I think this looks like a good idea. It might be worth adding a
> comment about the checks to explain why those errors are whitelisted.
> It's a cheap and effective mitigation for "unknown future problems"
> that doesn't degrade normal workloads.

pt_regs->ax is unsigned long, so you want to check this with IS_ERR_VALUE()
first.

               if (!IS_ERR_VALUE(regs->ax))
		        return;

and then you really want to have something smarter than a gazillion of
whitelisted error value checks, which effectively compile into a gazillion
conditonal branches.

Thanks,

	tglx
