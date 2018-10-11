MIME-Version: 1.0
References: <20181011185458.10186-1-kristen@linux.intel.com>
In-Reply-To: <20181011185458.10186-1-kristen@linux.intel.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 11 Oct 2018 12:25:18 -0700
Message-ID: <CALCETrW5sNz-TO8w8e+7d1oD_CmnUX_txnBuKe2+wM7qFaK64A@mail.gmail.com>
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
Content-Type: text/plain; charset="UTF-8"
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Andrew Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 11, 2018 at 11:55 AM Kristen Carlson Accardi
<kristen@linux.intel.com> wrote:
>
> This patch aims to make it harder to perform cache timing attacks on data
> left behind by system calls. If we have an error returned from a syscall,
> flush the L1 cache.
>
> It's important to note that this patch is not addressing any specific
> exploit, nor is it intended to be a complete defense against anything.
> It is intended to be a low cost way of eliminating some of side effects
> of a failed system call.
>
> A performance test using sysbench on one hyperthread and a script which
> attempts to repeatedly access files it does not have permission to access
> on the other hyperthread found no significant performance impact.
>

> +__visible inline void l1_cache_flush(struct pt_regs *regs)
> +{
> +       if (IS_ENABLED(CONFIG_SYSCALL_FLUSH) &&
> +           static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
> +               if (regs->ax == 0 || regs->ax == -EAGAIN ||
> +                   regs->ax == -EEXIST || regs->ax == -ENOENT ||
> +                   regs->ax == -EXDEV || regs->ax == -ETIMEDOUT ||
> +                   regs->ax == -ENOTCONN || regs->ax == -EINPROGRESS)
> +                       return;
> +
> +               wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
> +       }
> +}

Ugh.

What exactly is this trying to protect against?  And how many cycles
should we expect L1D_FLUSH to take?

ISTM that, if we have a situation where the L1D can be read by user
code, we lose, via hyperthreading, successful syscalls, /dev/random,
and may other vectors.  This seems like a small mitigation at a rather
large cost.
