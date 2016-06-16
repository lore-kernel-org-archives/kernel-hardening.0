Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 15 Jun 2016 17:28:22 -0700
Message-Id: <cover.1466036668.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH 00/13] Virtually mapped stacks with guard pages (x86, core)
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, x86@kernel.org, Borislav Petkov <bp@alien8.de>
Cc: Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Since the dawn of time, a kernel stack overflow has been a real PITA
to debug, has caused nondeterministic crashes some time after the
actual overflow, and has generally been easy to exploit for root.

With this series, arches can enable HAVE_ARCH_VMAP_STACK.  Arches
that enable it (just x86 for now) get virtually mapped stacks with
guard pages.  This causes reliable faults when the stack overflows.

If the arch implements it well, we get a nice OOPS on stack overflow
(as opposed to panicing directly or otherwise exploding badly).  On
x86, the OOPS is nice, has a usable call trace, and the overflowing
task is killed cleanly.

This does not address interrupt stacks.

Andy Lutomirski (12):
  x86/cpa: In populate_pgd, don't set the pgd entry until it's populated
  x86/cpa: Warn if kernel_unmap_pages_in_pgd is used inappropriately
  mm: Track NR_KERNEL_STACK in pages instead of number of stacks
  mm: Move memcg stack accounting to account_kernel_stack
  fork: Add generic vmalloced stack support
  x86/die: Don't try to recover from an OOPS on a non-default stack
  x86/dumpstack: When OOPSing, rewind the stack before do_exit
  x86/dumpstack: When dumping stack bytes due to OOPS, start with
    regs->sp
  x86/dumpstack: Try harder to get a call trace on stack overflow
  x86/dumpstack/64: Handle faults when printing the "Stack:" part of an
    OOPS
  x86/mm/64: Enable vmapped stacks
  x86/mm: Improve stack-overflow #PF handling

Ingo Molnar (1):
  x86/mm/hotplug: Don't remove PGD entries in remove_pagetable()

 arch/Kconfig                     | 12 ++++++++++
 arch/x86/Kconfig                 |  1 +
 arch/x86/entry/entry_32.S        | 11 +++++++++
 arch/x86/entry/entry_64.S        | 11 +++++++++
 arch/x86/include/asm/switch_to.h | 28 +++++++++++++++++++++-
 arch/x86/include/asm/traps.h     |  6 +++++
 arch/x86/kernel/dumpstack.c      | 17 +++++++++++++-
 arch/x86/kernel/dumpstack_32.c   |  4 +++-
 arch/x86/kernel/dumpstack_64.c   | 16 ++++++++++---
 arch/x86/kernel/traps.c          | 32 +++++++++++++++++++++++++
 arch/x86/mm/fault.c              | 39 ++++++++++++++++++++++++++++++
 arch/x86/mm/init_64.c            | 27 ---------------------
 arch/x86/mm/pageattr.c           |  7 +++++-
 arch/x86/mm/tlb.c                | 15 ++++++++++++
 fs/proc/meminfo.c                |  2 +-
 kernel/fork.c                    | 51 ++++++++++++++++++++++++++++++----------
 mm/page_alloc.c                  |  3 +--
 17 files changed, 233 insertions(+), 49 deletions(-)

-- 
2.7.4
