Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 17 Jun 2016 13:00:36 -0700
Message-Id: <cover.1466192946.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH v2 00/13] Virtually mapped stacks with guard pages (x86, core)
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
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

On my laptop, this adds about 1.5µs of overhead to task creation,
which seems to be mainly caused by vmalloc inefficiently allocating
individual pages even when a higher-order page is available on the
freelist.

This does not address interrupt stacks.  It also does not address
the possibility of privilege escalation by a controlled stack
overflow that overwrites thread_info without hitting the guard page.
I'll send patches to address the latter issue once this series
lands.

It's worth noting that s390 has an arch-specific gcc feature that
detects stack overflows by adjusting function prologues.  Arches
with features like that may wish to avoid using vmapped stacks to
minimize the performance hit.

Ingo, once this gets a bit more review, would it make sense to
throw it into a seaparate branch in -tip?  I wouldn't mind seeing
some -next testing to give people a chance to shake out problems.
I'm particularly interested in whether there are any drivers that
expect virt_to_phys to work on stack addresses.  (I know that
virtio-net used to, but I fixed that a while back.)

Changes from v1:
 - Fix rewind_stack_and_do_exit (Josh)
 - Fix deadlock under load
 - Clean up generic stack vmalloc code
 - Many other minor fixes

Andy Lutomirski (12):
  x86/cpa: In populate_pgd, don't set the pgd entry until it's populated
  x86/cpa: Warn if kernel_unmap_pages_in_pgd is used inappropriately
  mm: Track NR_KERNEL_STACK in KiB instead of number of stacks
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

 arch/Kconfig                        | 29 +++++++++++++
 arch/ia64/include/asm/thread_info.h |  2 +-
 arch/x86/Kconfig                    |  1 +
 arch/x86/entry/entry_32.S           | 11 +++++
 arch/x86/entry/entry_64.S           | 11 +++++
 arch/x86/include/asm/switch_to.h    | 28 +++++++++++-
 arch/x86/include/asm/traps.h        |  6 +++
 arch/x86/kernel/dumpstack.c         | 19 ++++++++-
 arch/x86/kernel/dumpstack_32.c      |  4 +-
 arch/x86/kernel/dumpstack_64.c      | 16 +++++--
 arch/x86/kernel/traps.c             | 32 ++++++++++++++
 arch/x86/mm/fault.c                 | 39 +++++++++++++++++
 arch/x86/mm/init_64.c               | 27 ------------
 arch/x86/mm/pageattr.c              |  7 ++-
 arch/x86/mm/tlb.c                   | 15 +++++++
 drivers/base/node.c                 |  3 +-
 fs/proc/meminfo.c                   |  2 +-
 include/linux/mmzone.h              |  2 +-
 include/linux/sched.h               | 15 +++++++
 kernel/fork.c                       | 85 ++++++++++++++++++++++++++++---------
 mm/page_alloc.c                     |  3 +-
 21 files changed, 295 insertions(+), 62 deletions(-)

-- 
2.5.5
