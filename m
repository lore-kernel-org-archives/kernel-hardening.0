From: Igor Stoppa <igor.stoppa@huawei.com>
Subject: [RFC PATCH v15 0/6] mm: security: ro protection for dynamic data
Date: Sun, 11 Feb 2018 05:19:14 +0200
Message-ID: <20180211031920.3424-1-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: willy@infradead.org, rdunlap@infradead.org, corbet@lwn.net, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, jglisse@redhat.com, hch@infradead.org
Cc: cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Igor Stoppa <igor.stoppa@huawei.com>
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

Changes since v14:
[http://www.openwall.com/lists/kernel-hardening/2018/02/04/2]

- fix various warnings from sparse
- multiline comments
- fix naming of headers guards
- fix compilation of individual patches, for bisect
- split genalloc documentation about bitmap for allocation
- fix headers to match kerneldoc format for "Return:" field
- fix variable naming according to coding guidelines
- fix wrong default value for pmalloc Kconfig option
- refreshed integration of pmalloc with hardened usercopy
- removed unnecessary include that was causing compilation failures
- changed license of pmalloc documentation from GPL 2.0 to CC-BY-SA-4.0

Igor Stoppa (6):
  genalloc: track beginning of allocations
  genalloc: selftest
  struct page: add field for vm_struct
  Protectable Memory
  Pmalloc: self-test
  Documentation for Pmalloc

 Documentation/core-api/index.rst   |   1 +
 Documentation/core-api/pmalloc.rst | 114 ++++++++
 include/linux/genalloc-selftest.h  |  26 ++
 include/linux/genalloc.h           |   7 +-
 include/linux/mm_types.h           |   1 +
 include/linux/pmalloc.h            | 222 +++++++++++++++
 include/linux/vmalloc.h            |   1 +
 init/main.c                        |   2 +
 lib/Kconfig                        |  15 +
 lib/Makefile                       |   1 +
 lib/genalloc-selftest.c            | 400 ++++++++++++++++++++++++++
 lib/genalloc.c                     | 554 +++++++++++++++++++++++++++----------
 mm/Kconfig                         |  15 +
 mm/Makefile                        |   2 +
 mm/pmalloc-selftest.c              |  63 +++++
 mm/pmalloc-selftest.h              |  24 ++
 mm/pmalloc.c                       | 499 +++++++++++++++++++++++++++++++++
 mm/usercopy.c                      |  33 +++
 mm/vmalloc.c                       |  18 +-
 19 files changed, 1852 insertions(+), 146 deletions(-)
 create mode 100644 Documentation/core-api/pmalloc.rst
 create mode 100644 include/linux/genalloc-selftest.h
 create mode 100644 include/linux/pmalloc.h
 create mode 100644 lib/genalloc-selftest.c
 create mode 100644 mm/pmalloc-selftest.c
 create mode 100644 mm/pmalloc-selftest.h
 create mode 100644 mm/pmalloc.c

-- 
2.14.1
