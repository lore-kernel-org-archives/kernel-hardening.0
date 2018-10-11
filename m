Message-ID: <1539288950.3566.11.camel@linux.intel.com>
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
From: Kristen C Accardi <kristen@linux.intel.com>
Date: Thu, 11 Oct 2018 13:15:50 -0700
In-Reply-To: <CALCETrW5sNz-TO8w8e+7d1oD_CmnUX_txnBuKe2+wM7qFaK64A@mail.gmail.com>
References: <20181011185458.10186-1-kristen@linux.intel.com>
	 <CALCETrW5sNz-TO8w8e+7d1oD_CmnUX_txnBuKe2+wM7qFaK64A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Andy Lutomirski <luto@kernel.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2018-10-11 at 12:25 -0700, Andy Lutomirski wrote:
> On Thu, Oct 11, 2018 at 11:55 AM Kristen Carlson Accardi
> <kristen@linux.intel.com> wrote:
> > 
> > This patch aims to make it harder to perform cache timing attacks
> > on data
> > left behind by system calls. If we have an error returned from a
> > syscall,
> > flush the L1 cache.
> > 
> > It's important to note that this patch is not addressing any
> > specific
> > exploit, nor is it intended to be a complete defense against
> > anything.
> > It is intended to be a low cost way of eliminating some of side
> > effects
> > of a failed system call.
> > 
> > A performance test using sysbench on one hyperthread and a script
> > which
> > attempts to repeatedly access files it does not have permission to
> > access
> > on the other hyperthread found no significant performance impact.
> > 
> > +__visible inline void l1_cache_flush(struct pt_regs *regs)
> > +{
> > +       if (IS_ENABLED(CONFIG_SYSCALL_FLUSH) &&
> > +           static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
> > +               if (regs->ax == 0 || regs->ax == -EAGAIN ||
> > +                   regs->ax == -EEXIST || regs->ax == -ENOENT ||
> > +                   regs->ax == -EXDEV || regs->ax == -ETIMEDOUT ||
> > +                   regs->ax == -ENOTCONN || regs->ax ==
> > -EINPROGRESS)
> > +                       return;
> > +
> > +               wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
> > +       }
> > +}
> 
> Ugh.
> 
> What exactly is this trying to protect against?  And how many cycles
> should we expect L1D_FLUSH to take?

As I mentioned in the commit message, this is not addressing any
specific exploit. It is removing any side effects from a failed system
call in the L1 cache.

> 
> ISTM that, if we have a situation where the L1D can be read by user
> code, we lose, via hyperthreading, successful syscalls, /dev/random,
> and may other vectors.  This seems like a small mitigation at a
> rather
> large cost.

I pinned an evil task to one hyperthread that just caused L1 flushes by
issuing failed system calls. On the other hyperthread, I ran a
performance benchmark (sysbench). I did not see any difference between
the baseline and the kernel with the patch applied. Is there a more
appropriate test you'd be interested in seeing the results of? I'd be
happy to design a different test.
