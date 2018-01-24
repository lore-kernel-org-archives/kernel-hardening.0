From: Igor Stoppa <igor.stoppa@huawei.com>
Date: Wed, 24 Jan 2018 19:56:25 +0200
Message-ID: <20180124175631.22925-1-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] [RFC PATCH v11 0/6] mm: security: ro protection for dynamic data
To: jglisse@redhat.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, hch@infradead.org, willy@infradead.org
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

Changes since the v10 version:

Initially I tried to provide support for hardening the LSM hooks, but the
LSM code was too much in a flux to have some chance to be merged.

Several drop-in replacement for kmalloc based functions, for example
kzalloc.

>From this perspective I have also modified genalloc, to make its free
functionality follow more closely the kfree, which doesn't need to be told
the size of the allocation being released. This was sent out for review
twice, but it has not received any feedback, so far.

Also genalloc now comes with self-testing.

The latest can be found also here:

https://www.spinics.net/lists/kernel/msg2696152.html

The need to integrate with hardened user copy has driven an optimization
in the management of vmap_areas, where each struct page in a vmalloc area
has a reference to it, saving the search through the various areas.

I was planning - and can still do it - to provide hardening for some IMA
data, but in the meanwhile it seems that the XFS developers might be
interested in htis functionality:

http://www.openwall.com/lists/kernel-hardening/2018/01/24/1

So I'm sending it out as preview.


Igor Stoppa (6):
  genalloc: track beginning of allocations
  genalloc: selftest
  struct page: add field for vm_struct
  Protectable Memory
  Documentation for Pmalloc
  Pmalloc: self-test

 Documentation/core-api/pmalloc.txt | 104 ++++++++
 include/linux/genalloc-selftest.h  |  30 +++
 include/linux/genalloc.h           |   6 +-
 include/linux/mm_types.h           |   1 +
 include/linux/pmalloc.h            | 215 ++++++++++++++++
 include/linux/vmalloc.h            |   1 +
 init/main.c                        |   2 +
 lib/Kconfig                        |  15 ++
 lib/Makefile                       |   1 +
 lib/genalloc-selftest.c            | 402 +++++++++++++++++++++++++++++
 lib/genalloc.c                     | 444 +++++++++++++++++++++----------
 mm/Kconfig                         |   7 +
 mm/Makefile                        |   2 +
 mm/pmalloc-selftest.c              |  65 +++++
 mm/pmalloc-selftest.h              |  30 +++
 mm/pmalloc.c                       | 516 +++++++++++++++++++++++++++++++++++++
 mm/usercopy.c                      |  25 +-
 mm/vmalloc.c                       |  18 +-
 18 files changed, 1744 insertions(+), 140 deletions(-)
 create mode 100644 Documentation/core-api/pmalloc.txt
 create mode 100644 include/linux/genalloc-selftest.h
 create mode 100644 include/linux/pmalloc.h
 create mode 100644 lib/genalloc-selftest.c
 create mode 100644 mm/pmalloc-selftest.c
 create mode 100644 mm/pmalloc-selftest.h
 create mode 100644 mm/pmalloc.c

-- 
2.9.3
