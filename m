From: Hector Martin 'marcan' <marcan@marcan.st>
Message-ID: <c6603960-c155-8f9f-6458-38e9ba6d4bdd@marcan.st>
Date: Fri, 10 Nov 2017 19:40:30 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] vDSO maximum stack usage, stack probes, and -fstack-check
To: luto@amacapital.net
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

As far as I know, the vDSO specs (both Documentation/ABI/stable/vdso and
`man 7 vdso`) make no mention of how much stack the vDSO functions are
allowed to use. They just say "the usual C ABI", which makes no guarantees.

It turns out that Go has been assuming that those functions use less
than 104 bytes of stack space, because it calls them directly on its
tiny stack allocations with no guard pages or other hardware overflow
protection [1]. On most systems, this is fine.

However, on my system the stars aligned and turned it into a
nondeterministic crash. I use Gentoo Hardened, which builds its
toolchain with -fstack-check on by default. It turns out that with the
combination of GCC 6.4.0, -fstack-protect, linux-4.13.9-gentoo, and
CONFIG_OPTIMIZE_INLINING=n, gcc decides to *not* inline vread_tsc (it's
not marked inline, so it's perfectly within its right not to do that,
though for some reason it does inline when CONFIG_OPTIMIZE_INLINING=y
even though that nominally gives it greater freedom *not* to inline
things marked inline). That turns __vdso_clock_gettime and
__vdso_gettimeofday into non-leaf functions, and GCC then inserts a
stack probe (full objdump at [2]):

0000000000000030 <__vdso_clock_gettime>:
  30:	55                   	push   %rbp
  31:	48 89 e5             	mov    %rsp,%rbp
  34:	48 81 ec 20 10 00 00 	sub    $0x1020,%rsp
  3b:	48 83 0c 24 00       	orq    $0x0,(%rsp)
  40:	48 81 c4 20 10 00 00 	add    $0x1020,%rsp

That silently overflows the Go stack. "orq 0" does nothing as long as
the page is mapped, but it's not atomic. It turns out that sometimes
(pretty often on my box) that races another thread accessing the same
location and corrupts memory.

The stack probe sounds unnecessary, since it only calls vread_tsc and
that can't ever skip over more than a page of stack. In fact I don't
even know why it does the probe; I thought the point of stack probes was
to poke the stack on allocations >4K to ensure the guard page isn't
skipped, but none of these functions use more than a few bytes of stack
space. Nonetheless, none of this is wrong per se; the current vDSO spec
makes no guarantees about stack usage.

The question is, should it? Should the vDSO spec set a hard limit on
stack consumption that userspace can rely on, and perhaps inline
everything and/or disable -fstack-check to avoid the stack probes?

[1] https://github.com/golang/go/issues/20427#issuecomment-343255844
[2] https://marcan.st/paste/HCVuLG6T.txt

-- 
Hector Martin "marcan" (marcan@marcan.st)
Public Key: https://mrcn.st/pub
