From: Igor Stoppa <igor.stoppa@huawei.com>
Subject: [RFC PATCH v18 0/7] mm: security: ro protection for dynamic data
Date: Wed, 28 Feb 2018 22:06:13 +0200
Message-ID: <20180228200620.30026-1-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: david@fromorbit.com, willy@infradead.org, keescook@chromium.org, mhocko@kernel.org
Cc: labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Igor Stoppa <igor.stoppa@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patch-set introduces the possibility of protecting memory that has
been allocated dynamically.

The memory is managed in pools: when a memory pool is turned into R/O,
all the memory that is part of it, will become R/O.

A R/O pool can be destroyed, to recover its memory, but it cannot be
turned back into R/W mode.

This is intentional. This feature is meant for data that doesn't need
further modifications after initialization.

However the data might need to be released, for example as part of module
unloading.
To do this, the memory must first be freed, then the pool can be destroyed.

An example is provided, in the form of self-testing.

Changes since v17:

* turned all BUGs into WARNs, with the exceptions of the (optional)
  genalloc selftesting
* added mode descriptive messages, in case of failures
* fixed incorrect description of behavior when destroying a pool
* added tetst case of allocating memory from protected pool
* fixed kerneldoc description also for genalloc.h
* added missing Kconfig dependency for pmalloc, on MMU
* fixed location of initialization of link page struct -> vm_area

Igor Stoppa (7):
  genalloc: track beginning of allocations
  genalloc: selftest
  struct page: add field for vm_struct
  Protectable Memory
  Pmalloc selftest
  lkdtm: crash on overwriting protected pmalloc var
  Documentation for Pmalloc

 Documentation/core-api/index.rst   |   1 +
 Documentation/core-api/pmalloc.rst | 111 ++++++
 drivers/misc/lkdtm.h               |   1 +
 drivers/misc/lkdtm_core.c          |   3 +
 drivers/misc/lkdtm_perms.c         |  28 ++
 include/linux/genalloc.h           | 367 +++++++++++++++---
 include/linux/mm_types.h           |   1 +
 include/linux/pmalloc.h            | 242 ++++++++++++
 include/linux/test_genalloc.h      |  26 ++
 include/linux/test_pmalloc.h       |  24 ++
 include/linux/vmalloc.h            |   1 +
 init/main.c                        |   4 +
 lib/Kconfig                        |  15 +
 lib/Makefile                       |   1 +
 lib/genalloc.c                     | 745 +++++++++++++++++++++++++++----------
 lib/test_genalloc.c                | 410 ++++++++++++++++++++
 mm/Kconfig                         |  17 +
 mm/Makefile                        |   2 +
 mm/pmalloc.c                       | 468 +++++++++++++++++++++++
 mm/test_pmalloc.c                  | 100 +++++
 mm/usercopy.c                      |  33 ++
 mm/vmalloc.c                       |   2 +
 22 files changed, 2364 insertions(+), 238 deletions(-)
 create mode 100644 Documentation/core-api/pmalloc.rst
 create mode 100644 include/linux/pmalloc.h
 create mode 100644 include/linux/test_genalloc.h
 create mode 100644 include/linux/test_pmalloc.h
 create mode 100644 lib/test_genalloc.c
 create mode 100644 mm/pmalloc.c
 create mode 100644 mm/test_pmalloc.c

-- 
2.14.1
