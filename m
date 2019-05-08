Date: Wed,  8 May 2019 17:37:32 +0200
Message-Id: <20190508153736.256401-1-glider@google.com>
Mime-Version: 1.0
Subject: [PATCH 0/4] RFC: add init_on_alloc/init_on_free boot options
From: Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
To: akpm@linux-foundation.org, cl@linux.com, keescook@chromium.org, labbott@redhat.com
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, yamada.masahiro@socionext.com, jmorris@namei.org, serge@hallyn.com, ndesaulniers@google.com, kcc@google.com, dvyukov@google.com, sspatil@android.com, rdunlap@infradead.org, jannh@google.com, mark.rutland@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Provide init_on_alloc and init_on_free boot options.

These are aimed at preventing possible information leaks and making the
control-flow bugs that depend on uninitialized values more deterministic.

Enabling either of the options guarantees that the memory returned by the
page allocator and SL[AOU]B is initialized with zeroes.

Enabling init_on_free also guarantees that pages and heap objects are
initialized right after they're freed, so it won't be possible to access
stale data by using a dangling pointer.

Alexander Potapenko (4):
  mm: security: introduce init_on_alloc=1 and init_on_free=1 boot
    options
  lib: introduce test_meminit module
  gfp: mm: introduce __GFP_NOINIT
  net: apply __GFP_NOINIT to AF_UNIX sk_buff allocations

 .../admin-guide/kernel-parameters.txt         |   8 +
 drivers/infiniband/core/uverbs_ioctl.c        |   2 +-
 include/linux/gfp.h                           |   6 +-
 include/linux/mm.h                            |  22 ++
 include/net/sock.h                            |   5 +
 kernel/kexec_core.c                           |   4 +-
 lib/Kconfig.debug                             |   8 +
 lib/Makefile                                  |   1 +
 lib/test_meminit.c                            | 205 ++++++++++++++++++
 mm/dmapool.c                                  |   2 +-
 mm/page_alloc.c                               |  62 +++++-
 mm/slab.c                                     |  18 +-
 mm/slab.h                                     |  16 ++
 mm/slob.c                                     |  23 +-
 mm/slub.c                                     |  28 ++-
 net/core/sock.c                               |  31 ++-
 net/unix/af_unix.c                            |  13 +-
 security/Kconfig.hardening                    |  16 ++
 18 files changed, 439 insertions(+), 31 deletions(-)
 create mode 100644 lib/test_meminit.c

-- 
2.21.0.1020.gf2820cf01a-goog
