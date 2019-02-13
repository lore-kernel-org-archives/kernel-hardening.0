From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [RFC PATCH v5 00/12] hardening: statically allocated protected memory
Date: Thu, 14 Feb 2019 00:41:29 +0200
Message-Id: <cover.1550097697.git.igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Kees Cook <keescook@chromium.org>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity <linux-integrity@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

To: Andy Lutomirski <luto@amacapital.net>,
To: Matthew Wilcox <willy@infradead.org>,
To: Nadav Amit <nadav.amit@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
To: Dave Hansen <dave.hansen@linux.intel.com>,
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Thiago Jung Bauermann <bauerman@linux.ibm.com>
CC: Kees Cook <keescook@chromium.org>
CC: Ahmed Soliman <ahmedsoliman@mena.vt.edu>
CC: linux-integrity <linux-integrity@vger.kernel.org>
CC: Kernel Hardening <kernel-hardening@lists.openwall.com>
CC: Linux-MM <linux-mm@kvack.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hello,
new version of the patchset, with default memset_user() function.

Patch-set implementing write-rare memory protection for statically
allocated data.
Its purpose is to keep write protected the kernel data which is seldom
modified, especially if altering it can be exploited during an attack.

There is no read overhead, however writing requires special operations that
are probably unsuitable for often-changing data.
The use is opt-in, by applying the modifier __wr_after_init to a variable
declaration.

As the name implies, the write protection kicks in only after init() is
completed; before that moment, the data is modifiable in the usual way.

Current Limitations:
* supports only data which is allocated statically, at build time.
* verified (and enabled) only x86_64 and arm64; other architectures need to
  be tested, possibly providing own backend.

Some notes:
- in case an architecture doesn't support write rare, the behavior is to
  fallback to regular write operations
- before altering any memory, the destination is sanitized
- write rare data is segregated into own set of pages
- only x86_64 and arm64 verified, atm
- the memset_user() assembly functions seems to work, but I'm not too sure
  they are really ok
- I've added a simple example: the protection of ima_policy_flags
- the last patch is optional, but it seemed worth to do the refactoring
- the x86_64 user space address range is double the size of the kernel
  address space, so it's possible to randomize the beginning of the
  mapping of the kernel address space, but on arm64 they have the same
  size, so it's not possible to do the same. Eventually, the randomization
  could affect exclusively the ranges containing protectable memory, but
  this should be done togeter with the protection of dynamically allocated
  data (once it is available).
- unaddressed: Nadav proposed to do:
	#define __wr          __attribute__((address_space(5)))
  but I don't know exactly where to use it atm

Changelog:

v4->v5
------
* turned conditional inclusion of mm.h into permanent
* added generic, albeit unoptimized memset_user() function
* more verbose error messages for testing of wr_memset()

v3->v4
------

* added function for setting memory in user space mapping for arm64
* refactored code, to work with both supported architectures
* reduced dependency on x86_64 specific code, to support by default also
  arm64
* improved memset_user() for x86_64, but I'm not sure if I understood
  correctly what was the best way to enhance it.

v2->v3
------

* both wr_memset and wr_memcpy are implemented as generic functions
  the arch code must provide suitable helpers
* regular initialization for ima_policy_flags: it happens during init
* remove spurious code from the initialization function

v1->v2
------

* introduce cleaner split between generic and arch code
* add x86_64 specific memset_user()
* replace kernel-space memset() memcopy() with userspace counterpart
* randomize the base address for the alternate map across the entire
  available address range from user space (128TB - 64TB)
* convert BUG() to WARN()
* turn verification of written data into debugging option
* wr_rcu_assign_pointer() as special case of wr_assign()
* example with protection of ima_policy_flags
* documentation

Igor Stoppa (11):
  __wr_after_init: linker section and attribute
  __wr_after_init: Core and default arch
  __wr_after_init: x86_64: randomize mapping offset
  __wr_after_init: x86_64: enable
  __wr_after_init: arm64: enable
  __wr_after_init: Documentation: self-protection
  __wr_after_init: lkdtm test
  __wr_after_init: rodata_test: refactor tests
  __wr_after_init: rodata_test: test __wr_after_init
  __wr_after_init: test write rare functionality
  IMA: turn ima_policy_flags into __wr_after_init

Nadav Amit (1):
  fork: provide a function for copying init_mm

 Documentation/security/self-protection.rst |  14 +-
 arch/Kconfig                               |  22 +++
 arch/arm64/Kconfig                         |   1 +
 arch/x86/Kconfig                           |   1 +
 arch/x86/mm/Makefile                       |   2 +
 arch/x86/mm/prmem.c (new)                  |  20 +++
 drivers/misc/lkdtm/core.c                  |   3 +
 drivers/misc/lkdtm/lkdtm.h                 |   3 +
 drivers/misc/lkdtm/perms.c                 |  29 ++++
 include/asm-generic/vmlinux.lds.h          |  25 +++
 include/linux/cache.h                      |  21 +++
 include/linux/prmem.h (new)                |  70 ++++++++
 include/linux/sched/task.h                 |   1 +
 init/main.c                                |   3 +
 kernel/fork.c                              |  24 ++-
 mm/Kconfig.debug                           |   8 +
 mm/Makefile                                |   2 +
 mm/prmem.c (new)                           | 193 +++++++++++++++++++++
 mm/rodata_test.c                           |  69 +++++---
 mm/test_write_rare.c (new)                 | 142 +++++++++++++++
 security/integrity/ima/ima.h               |   3 +-
 security/integrity/ima/ima_policy.c        |   9 +-
 22 files changed, 628 insertions(+), 37 deletions(-)
 create mode 100644 arch/x86/mm/prmem.c
 create mode 100644 include/linux/prmem.h
 create mode 100644 mm/prmem.c
 create mode 100644 mm/test_write_rare.c

-- 
2.19.1
