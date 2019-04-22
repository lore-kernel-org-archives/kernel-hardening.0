From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v4 00/23] Merge text_poke fixes and executable lockdowns
Date: Mon, 22 Apr 2019 11:57:42 -0700
Message-Id: <20190422185805.1169-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Picking this up again after seeing how things shook out around the issue
raised here: https://lkml.org/lkml/2019/2/22/702

This patchset improves several overlapping issues around stale TLB entries and
W^X violations. It is combined from "x86/alternative: text_poke() enhancements
v7" [1] and "Don’t leave executable TLB entries to freed pages v2" [2] patchsets
that were conflicting.

The related issues that this fixes:
1. Fixmap PTEs that are used for patching are available for access from
   other cores and might be exploited. They are not even flushed from
   the TLB in remote cores, so the risk is even higher. Address this
   issue by introducing a temporary mm that is only used during
   patching. Unfortunately, due to init ordering, fixmap is still used
   during boot-time patching. Future patches can eliminate the need for
   it.
2. Missing lockdep assertion to ensure text_mutex is taken. It is
   actually not always taken, so fix the instances that were found not
   to take the lock (although they should be safe even without taking
   the lock).
3. Module_alloc returning memory that is RWX until a module is finished
   loading.
4. Sometimes when memory is freed via the module subsystem, an
   executable permissioned TLB entry can remain to a freed page. If the
   page is re-used to back an address that will receive data from
   userspace, it can result in user data being mapped as executable in
   the kernel. The root of this behavior is vfree lazily flushing the
   TLB, but not lazily freeing the underlying pages.

Changes v3 to v4:
 - Remove the size parameter from tramp_free() [Steven]
 - Remove caching of hw_breakpoint_active() [Sean]
 - Prevent the use of bpf_probe_write_user() while using temporary mm [Jann]
 - Fix build issues on other archs

Changes v2 to v3:
 - Fix commit messages and comments [Boris]
 - Rename VM_HAS_SPECIAL_PERMS [Boris]
 - Remove unnecessary local variables [Boris]
 - Rename set_alias_*() functions [Boris, Andy]
 - Save/restore DR registers when using temporary mm
 - Move line deletion from patch 10 to patch 17

Changes v1 to v2:
 - Adding “Reviewed-by tag” [Masami]
 - Comment instead of code to warn against module removal while
   patching [Masami]
 - Avoiding open-coded TLB flush [Andy]
 - Remove "This patch" [Borislav Petkov]
 - Not set global bit during text poking [Andy, hpa]
 - Add Ack from [Pavel Machek]
 - Split patch 16 "Plug in new special vfree flag" into 4 patches (16-19)
   to make it easier to review. There were no code changes.

The changes from "Don’t leave executable TLB entries to freed pages
v2" to v1:
 - Add support for case of hibernate trying to save an unmapped page
   on the directmap. (Ard Biesheuvel)
 - No week arch breakout for vfree-ing special memory (Andy Lutomirski)
 - Avoid changing deferred free code by moving modules init free to work
   queue (Andy Lutomirski)
 - Plug in new flag for kprobes and ftrace
 - More arch generic names for set_pages functions (Ard Biesheuvel)
 - Fix for TLB not always flushing the directmap (Nadav Amit)
 
Changes from "x86/alternative: text_poke() enhancements v7" to v1
 - Fix build failure on CONFIG_RANDOMIZE_BASE=n (Rick)
 - Remove text_poke usage from ftrace (Nadav)
 
[1] https://lkml.org/lkml/2018/12/5/200
[2] https://lkml.org/lkml/2018/12/11/1571


Andy Lutomirski (1):
  x86/mm: Introduce temporary mm structs

Nadav Amit (15):
  Fix "x86/alternatives: Lockdep-enforce text_mutex in text_poke*()"
  x86/jump_label: Use text_poke_early() during early init
  x86/mm: Save DRs when loading a temporary mm
  fork: Provide a function for copying init_mm
  x86/alternative: Initialize temporary mm for patching
  x86/alternative: Use temporary mm for text poking
  x86/kgdb: Avoid redundant comparison of patched code
  x86/ftrace: Set trampoline pages as executable
  x86/kprobes: Set instruction page as executable
  x86/module: Avoid breaking W^X while loading modules
  x86/jump-label: Remove support for custom poker
  x86/alternative: Remove the return value of text_poke_*()
  x86/alternative: Comment about module removal races
  tlb: provide default nmi_uaccess_okay()
  bpf: Fail bpf_probe_write_user() while mm is switched

Rick Edgecombe (7):
  x86/mm/cpa: Add set_direct_map_ functions
  mm: Make hibernate handle unmapped pages
  vmalloc: Add flag for free of special permsissions
  modules: Use vmalloc special flag
  bpf: Use vmalloc special flag
  x86/ftrace: Use vmalloc special flag
  x86/kprobes: Use vmalloc special flag

 arch/Kconfig                         |   4 +
 arch/x86/Kconfig                     |   1 +
 arch/x86/include/asm/fixmap.h        |   2 -
 arch/x86/include/asm/mmu_context.h   |  56 ++++++++
 arch/x86/include/asm/pgtable.h       |   3 +
 arch/x86/include/asm/set_memory.h    |   3 +
 arch/x86/include/asm/text-patching.h |   7 +-
 arch/x86/include/asm/tlbflush.h      |   2 +
 arch/x86/kernel/alternative.c        | 201 ++++++++++++++++++++-------
 arch/x86/kernel/ftrace.c             |  22 +--
 arch/x86/kernel/jump_label.c         |  21 ++-
 arch/x86/kernel/kgdb.c               |  25 +---
 arch/x86/kernel/kprobes/core.c       |  19 ++-
 arch/x86/kernel/module.c             |   2 +-
 arch/x86/mm/init_64.c                |  36 +++++
 arch/x86/mm/pageattr.c               |  16 ++-
 arch/x86/xen/mmu_pv.c                |   2 -
 include/asm-generic/tlb.h            |   9 ++
 include/linux/filter.h               |  18 +--
 include/linux/mm.h                   |  18 +--
 include/linux/sched/task.h           |   1 +
 include/linux/set_memory.h           |  11 ++
 include/linux/vmalloc.h              |  15 ++
 init/main.c                          |   3 +
 kernel/bpf/core.c                    |   1 -
 kernel/fork.c                        |  24 +++-
 kernel/module.c                      |  82 ++++++-----
 kernel/power/snapshot.c              |   5 +-
 kernel/trace/bpf_trace.c             |   8 ++
 mm/page_alloc.c                      |   7 +-
 mm/vmalloc.c                         | 113 ++++++++++++---
 31 files changed, 542 insertions(+), 195 deletions(-)

-- 
2.17.1
