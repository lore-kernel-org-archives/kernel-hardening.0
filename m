From: Tycho Andersen <tycho@docker.com>
Date: Wed,  9 Aug 2017 14:07:45 -0600
Message-Id: <20170809200755.11234-1-tycho@docker.com>
Subject: [kernel-hardening] [PATCH v5 00/10] Add support for eXclusive Page Frame Ownership
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi all,

Here's a v5 of the XPFO set. Changes from v4 are:

* huge pages support actually works now on x86
* arm64 support, which boots on several different arm64 boards
* tests for hugepages support as well via LKDTM (thanks Kees for suggesting how
  to make this work)

Patch 2 contains some potentially controversial stuff, exposing the cpa_lock
and lifting some other static functions out; there is probably a better way to
do this, thoughts welcome.

Still to do are:

* get it to work with non-64k pages on ARM
* get rid of the BUG()s, in favor or WARN or similar
* other things people come up with in this review

Please have a look. Thoughts welcome!

Previously: http://www.openwall.com/lists/kernel-hardening/2017/06/07/24

Tycho

Juerg Haefliger (8):
  mm, x86: Add support for eXclusive Page Frame Ownership (XPFO)
  swiotlb: Map the buffer if it was unmapped by XPFO
  arm64: Add __flush_tlb_one()
  arm64/mm: Add support for XPFO
  arm64/mm: Disable section mappings if XPFO is enabled
  arm64/mm: Don't flush the data cache if the page is unmapped by XPFO
  arm64/mm: Add support for XPFO to swiotlb
  lkdtm: Add test for XPFO

Tycho Andersen (2):
  mm: add MAP_HUGETLB support to vm_mmap
  mm: add a user_virt_to_phys symbol

 Documentation/admin-guide/kernel-parameters.txt |   2 +
 arch/arm64/Kconfig                              |   1 +
 arch/arm64/include/asm/cacheflush.h             |  11 ++
 arch/arm64/include/asm/tlbflush.h               |   8 +
 arch/arm64/mm/Makefile                          |   2 +
 arch/arm64/mm/dma-mapping.c                     |  32 ++--
 arch/arm64/mm/flush.c                           |   5 +-
 arch/arm64/mm/mmu.c                             |  14 +-
 arch/arm64/mm/xpfo.c                            | 160 +++++++++++++++++
 arch/x86/Kconfig                                |   1 +
 arch/x86/include/asm/pgtable.h                  |  23 +++
 arch/x86/mm/Makefile                            |   1 +
 arch/x86/mm/pageattr.c                          |  24 +--
 arch/x86/mm/xpfo.c                              | 153 +++++++++++++++++
 drivers/misc/Makefile                           |   1 +
 drivers/misc/lkdtm.h                            |   4 +
 drivers/misc/lkdtm_core.c                       |   4 +
 drivers/misc/lkdtm_xpfo.c                       |  62 +++++++
 include/linux/highmem.h                         |  15 +-
 include/linux/mm.h                              |   2 +
 include/linux/xpfo.h                            |  47 +++++
 lib/swiotlb.c                                   |   3 +-
 mm/Makefile                                     |   1 +
 mm/mmap.c                                       |  19 +--
 mm/page_alloc.c                                 |   2 +
 mm/page_ext.c                                   |   4 +
 mm/util.c                                       |  32 ++++
 mm/xpfo.c                                       | 217 ++++++++++++++++++++++++
 security/Kconfig                                |  19 +++
 29 files changed, 810 insertions(+), 59 deletions(-)
 create mode 100644 arch/arm64/mm/xpfo.c
 create mode 100644 arch/x86/mm/xpfo.c
 create mode 100644 drivers/misc/lkdtm_xpfo.c
 create mode 100644 include/linux/xpfo.h
 create mode 100644 mm/xpfo.c

-- 
2.11.0
