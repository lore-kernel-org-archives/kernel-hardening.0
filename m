Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Jul 2016 13:53:33 -0700
Message-Id: <cover.1468270393.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH v5 00/32] virtually mapped stacks and thread_info cleanup
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi all-

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

This series (starting with v4) also extensively cleans up
thread_info.  thread_info has been partially redundant with
thread_struct for a long time -- both are places for arch code to
add additional per-task variables.  thread_struct is much cleaner:
it's always in task_struct, and there's nothing particularly magical
about it.  So this series contains a bunch of cleanups on x86 to
move almost everything from thread_info to thread_struct (which,
even by itself, deletes more code than it adds) and to remove x86's
dependence on thread_info's position on the stack.  Then it opts x86
into a new config option THREAD_INFO_IN_TASK to get rid of
arch-specific thread_info entirely and simply embed a defanged
thread_info (containing only flags) and 'int cpu' into task_struct.

Once thread_info stops being magical, there's another benefit: we
can free the thread stack as soon as the task is dead (without
waiting for RCU) and then, if vmapped stacks are in use, cache the
entire stack for reuse on the same cpu.

This seems to be an overall speedup of about 0.5-1 µs per
pthread_create/join in a simple test -- a percpu cache of vmalloced
stacks appears to be a bit faster than a high-order stack
allocation, at least when the cache hits.  (I expect that workloads
with a low cache hit rate are likely to be dominated by other
effects anyway.)

This does not address interrupt stacks.

It's worth noting that s390 has an arch-specific gcc feature that
detects stack overflows by adjusting function prologues.  Arches
with features like that may wish to avoid using vmapped stacks to
minimize the performance hit.

Known issues: - tcp md5, rxkad, virtio_net, and virtio_console will
have issues.  Eric Dumazet has a patch for tcp md5, and Michael
Tsirkin says he'll fix virtio_net and virtio_console.  rxkad will be
fixed via net-next.

Changes from v4:
 - Fix kthread (Oleg)
 - Tidy up some changelongs and fold some patches (Borislav, Josh)
 - Add "x86/mm/64: In vmalloc_fault(), use CR3 instead of current->active_mm"
 - Make VMAP_STACK depend on !KASAN (not worth waiting for the fix, I think)

Changes from v3:
 - Minor cleanups
 - Rebased onto Linus' tree
 - All the thread_info stuff is new

Changes from v2:
 - Delete kerne_unmap_pages_in_pgd rather than hardening it (Borislav)
 - Fix sub-page stack accounting better (Josh)

Changes from v1:
 - Fix rewind_stack_and_do_exit (Josh)
 - Fix deadlock under load
 - Clean up generic stack vmalloc code
 - Many other minor fixes

Andy Lutomirski (28):
  bluetooth: Switch SMP to crypto_cipher_encrypt_one()
  x86/cpa: In populate_pgd, don't set the pgd entry until it's populated
  x86/mm: Remove kernel_unmap_pages_in_pgd() and
    efi_cleanup_page_tables()
  mm: Track NR_KERNEL_STACK in KiB instead of number of stacks
  mm: Fix memcg stack accounting for sub-page stacks
  fork: Add generic vmalloced stack support
  dma-api: Teach the "DMA-from-stack" check about vmapped stacks
  x86/dumpstack: When OOPSing, rewind the stack before do_exit()
  x86/dumpstack: Honor supplied @regs arg
  x86/dumpstack: Try harder to get a call trace on stack overflow
  x86/dumpstack/64: Handle faults when printing the "Stack:" part of an
    OOPS
  x86/mm/64: In vmalloc_fault(), use CR3 instead of current->active_mm
  x86/mm/64: Enable vmapped stacks
  x86/mm: Improve stack-overflow #PF handling
  x86: Move uaccess_err and sig_on_uaccess_err to thread_struct
  x86: Move addr_limit to thread_struct
  signal: Consolidate {TS,TLF}_RESTORE_SIGMASK code
  x86/smp: Remove stack_smp_processor_id()
  x86/smp: Remove unnecessary initialization of thread_info::cpu
  x86/asm: Move 'status' from struct thread_info to struct thread_struct
  kdb: Use task_cpu() instead of task_thread_info()->cpu
  printk: When dumping regs, show the stack, not thread_info
  sched: Allow putting thread_info into task_struct
  x86: Move thread_info into task_struct
  sched: Add try_get_task_stack() and put_task_stack()
  x86/dumpstack: Pin the target stack in save_stack_trace_tsk()
  sched: Free the stack early if CONFIG_THREAD_INFO_IN_TASK
  fork: Cache two thread stacks per cpu if CONFIG_VMAP_STACK is set

Ingo Molnar (1):
  x86/mm/hotplug: Don't remove PGD entries in remove_pagetable()

Linus Torvalds (2):
  x86/entry: Get rid of pt_regs_to_thread_info()
  um: Stop conflating task_struct::stack with thread_info

Oleg Nesterov (1):
  kthread: to_live_kthread() needs try_get_task_stack()

 arch/Kconfig                              |  33 ++++++
 arch/alpha/include/asm/thread_info.h      |  27 -----
 arch/ia64/include/asm/thread_info.h       |  30 +----
 arch/microblaze/include/asm/thread_info.h |  27 -----
 arch/powerpc/include/asm/thread_info.h    |  25 -----
 arch/sh/include/asm/thread_info.h         |  26 -----
 arch/sparc/include/asm/thread_info_64.h   |  24 ----
 arch/tile/include/asm/thread_info.h       |  27 -----
 arch/x86/Kconfig                          |   2 +
 arch/x86/entry/common.c                   |  25 ++---
 arch/x86/entry/entry_32.S                 |  11 ++
 arch/x86/entry/entry_64.S                 |  20 +++-
 arch/x86/entry/vsyscall/vsyscall_64.c     |   6 +-
 arch/x86/include/asm/checksum_32.h        |   3 +-
 arch/x86/include/asm/cpu.h                |   1 -
 arch/x86/include/asm/efi.h                |   1 -
 arch/x86/include/asm/pgtable_types.h      |   2 -
 arch/x86/include/asm/processor.h          |  32 ++++--
 arch/x86/include/asm/smp.h                |   6 -
 arch/x86/include/asm/switch_to.h          |  34 +++++-
 arch/x86/include/asm/syscall.h            |  23 +---
 arch/x86/include/asm/thread_info.h        | 102 +----------------
 arch/x86/include/asm/traps.h              |   6 +
 arch/x86/include/asm/uaccess.h            |  10 +-
 arch/x86/kernel/asm-offsets.c             |   5 +-
 arch/x86/kernel/cpu/common.c              |   2 +-
 arch/x86/kernel/dumpstack.c               |  20 +++-
 arch/x86/kernel/dumpstack_32.c            |   4 +-
 arch/x86/kernel/dumpstack_64.c            |  16 ++-
 arch/x86/kernel/fpu/init.c                |   1 -
 arch/x86/kernel/irq_64.c                  |   3 +-
 arch/x86/kernel/process.c                 |   6 +-
 arch/x86/kernel/process_64.c              |   4 +-
 arch/x86/kernel/ptrace.c                  |   2 +-
 arch/x86/kernel/smpboot.c                 |   1 -
 arch/x86/kernel/stacktrace.c              |   5 +
 arch/x86/kernel/traps.c                   |  62 +++++++++++
 arch/x86/lib/copy_user_64.S               |   8 +-
 arch/x86/lib/csum-wrappers_64.c           |   1 +
 arch/x86/lib/getuser.S                    |  20 ++--
 arch/x86/lib/putuser.S                    |  10 +-
 arch/x86/lib/usercopy_64.c                |   2 +-
 arch/x86/mm/extable.c                     |   2 +-
 arch/x86/mm/fault.c                       |  38 ++++++-
 arch/x86/mm/init_64.c                     |  27 -----
 arch/x86/mm/pageattr.c                    |  37 +------
 arch/x86/mm/tlb.c                         |  15 +++
 arch/x86/platform/efi/efi.c               |   2 -
 arch/x86/platform/efi/efi_32.c            |   3 -
 arch/x86/platform/efi/efi_64.c            |   5 -
 arch/x86/um/ptrace_32.c                   |   8 +-
 drivers/base/node.c                       |   3 +-
 drivers/pnp/isapnp/proc.c                 |   2 +-
 fs/proc/meminfo.c                         |   2 +-
 include/linux/init_task.h                 |  11 ++
 include/linux/kdb.h                       |   2 +-
 include/linux/memcontrol.h                |   2 +-
 include/linux/mmzone.h                    |   2 +-
 include/linux/sched.h                     | 144 +++++++++++++++++++++++-
 include/linux/thread_info.h               |  56 +++-------
 init/Kconfig                              |  10 ++
 init/init_task.c                          |   7 +-
 kernel/fork.c                             | 177 ++++++++++++++++++++++++++----
 kernel/kthread.c                          |   8 +-
 kernel/printk/printk.c                    |   5 +-
 kernel/sched/core.c                       |   4 +
 kernel/sched/sched.h                      |   4 +
 lib/bitmap.c                              |   2 +-
 lib/dma-debug.c                           |  39 ++++++-
 mm/memcontrol.c                           |   2 +-
 mm/page_alloc.c                           |   3 +-
 net/bluetooth/smp.c                       |  67 +++++------
 72 files changed, 767 insertions(+), 597 deletions(-)

-- 
2.7.4
