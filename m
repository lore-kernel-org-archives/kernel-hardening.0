Date: Fri, 12 Oct 2018 01:43:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
In-Reply-To: <1539293003.3566.15.camel@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1810120116090.1457@nanos.tec.linutronix.de>
References: <20181011185458.10186-1-kristen@linux.intel.com>  <CALCETrVaZu2eq67ai0Oh=HWyZKg-OaoZx7yUT2AvStAhQ+rxyQ@mail.gmail.com>  <CAGXu5jLWO1StCz2ejBPW-p4B5XHEKdCGvOi1JKrKxg5UFSa3Ag@mail.gmail.com> <1539293003.3566.15.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kristen C Accardi <kristen@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 11 Oct 2018, Kristen C Accardi wrote:
> On Thu, 2018-10-11 at 13:55 -0700, Kees Cook wrote:
> > I think this looks like a good idea. It might be worth adding a
> > comment about the checks to explain why those errors are whitelisted.
> > It's a cheap and effective mitigation for "unknown future problems"
> > that doesn't degrade normal workloads.
> > 
> > > > +                       return;
> > > > +
> > > > +               wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
> > 
> > What about CPUs without FLUSH_L1D? Could it be done manually with a
> > memcpy or something?
> 
> It could - my original implementation (pre l1d_flush msr) did, but it
> did come with some additional cost in that I allocated per-cpu memory
> to keep a 32K buffer around that I could memcpy. It also sacrificed
> completeness for simplicity by not taking into account cases where L1
> was not 32K. As far as I know this msr is pretty widely deployed, even
> on older hardware.

You don't need that per cpu thing, really. We have both the MSR flush and
the software fallback in KVM vmx_l1d_flush(). The performance impact is
pretty much the same between the MSR flush and the software fallback.

Vs. deployment of the MSR. I'm not sure how wide this is supported on older
CPUs as there have been limitations on microcode patch space, but I can't
find the support matrix right now. Thanks Intel for reshuffling the webpage
every other week!

Thanks,

	tglx
