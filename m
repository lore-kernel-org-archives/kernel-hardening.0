MIME-Version: 1.0
In-Reply-To: <c6603960-c155-8f9f-6458-38e9ba6d4bdd@marcan.st>
References: <c6603960-c155-8f9f-6458-38e9ba6d4bdd@marcan.st>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 10 Nov 2017 06:57:55 -0800
Message-ID: <CALCETrXhUdMNfC0yBah39Z=xWVe3Fix-qF922gJjqzTO1B7TSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: vDSO maximum stack usage, stack probes, and -fstack-check
To: Hector Martin 'marcan' <marcan@marcan.st>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 10, 2017 at 2:40 AM, Hector Martin 'marcan'
<marcan@marcan.st> wrote:
> As far as I know, the vDSO specs (both Documentation/ABI/stable/vdso and
> `man 7 vdso`) make no mention of how much stack the vDSO functions are
> allowed to use. They just say "the usual C ABI", which makes no guarantees.
>
> It turns out that Go has been assuming that those functions use less
> than 104 bytes of stack space, because it calls them directly on its
> tiny stack allocations with no guard pages or other hardware overflow
> protection [1]. On most systems, this is fine.
>
> However, on my system the stars aligned and turned it into a
> nondeterministic crash. I use Gentoo Hardened, which builds its
> toolchain with -fstack-check on by default. It turns out that with the
> combination of GCC 6.4.0, -fstack-protect, linux-4.13.9-gentoo, and
> CONFIG_OPTIMIZE_INLINING=n, gcc decides to *not* inline vread_tsc (it's
> not marked inline, so it's perfectly within its right not to do that,
> though for some reason it does inline when CONFIG_OPTIMIZE_INLINING=y
> even though that nominally gives it greater freedom *not* to inline
> things marked inline). That turns __vdso_clock_gettime and
> __vdso_gettimeofday into non-leaf functions, and GCC then inserts a
> stack probe (full objdump at [2]):
>
> 0000000000000030 <__vdso_clock_gettime>:
>   30:   55                      push   %rbp
>   31:   48 89 e5                mov    %rsp,%rbp
>   34:   48 81 ec 20 10 00 00    sub    $0x1020,%rsp
>   3b:   48 83 0c 24 00          orq    $0x0,(%rsp)
>   40:   48 81 c4 20 10 00 00    add    $0x1020,%rsp

This code is so wrong I don't even no where to start.  Seriously, sub,
orq, add?  How about just orq with an offset?  How about a *load*
instead of a store?

But stepping back even further, an offset > 4096 is just bogus.
That's big enough to skip right over the guard page.

Anyway, my recollection is that GCC's stack check code is busted until
much newer gcc versions.  I suppose we could try to make the kernel
fail to build at all on a broken configuration like this.

--Andy
