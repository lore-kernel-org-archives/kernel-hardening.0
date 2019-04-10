Date: Wed, 10 Apr 2019 15:17:23 +0200
Message-Id: <20190410131726.250295-1-glider@google.com>
Mime-Version: 1.0
Subject: [PATCH v4 0/3] RFC: introduce CONFIG_INIT_ALL_MEMORY
From: Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
To: yamada.masahiro@socionext.com, jmorris@namei.org, serge@hallyn.com
Cc: linux-security-module@vger.kernel.org, linux-kbuild@vger.kernel.org, ndesaulniers@google.com, kcc@google.com, dvyukov@google.com, keescook@chromium.org, sspatil@android.com, labbott@redhat.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This patch is a part of a bigger initiative to allow initializing
heap/stack memory in the Linux kernels by default.
The rationale behind doing so is to reduce the severity of bugs caused
by using uninitialized memory.

Over the last two years KMSAN (https://github.com/google/kmsan/) has
found more than a hundred bugs running in a really moderate setup (orders
of magnitude less CPU/months than KASAN). Some of those bugs led to
information leaks if uninitialized memory was copied to the userspace,
other could cause DoS because of subverted control flow.
A lot more bugs remain uncovered, so we want to provide the distros and OS
vendors with a last resort measure to mitigate such bugs.

Our plan is to introduce configuration flags to force initialization of
stack and heap variables with a fixed pattern.
This is going to render information leaks inefficient (as we'll only leak
pattern data) and make uses of uninitialized values in conditions more
deterministic and discoverable.

The stack instrumentation part is based on Clang's -ftrivial-auto-var-init
(see https://reviews.llvm.org/D54604 ; there's also a GCC feature request
for a similar flag: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=87210)
or GCC's -fplugin-arg-structleak_plugin-byref-all
The heap initialization part is compiler-agnostic and is done in the
places that previously checked for __GFP_ZERO to initialize the newly
allocated memory.

Alexander Potapenko (3):
  initmem: introduce CONFIG_INIT_ALL_MEMORY and CONFIG_INIT_ALL_STACK
  initmem: introduce CONFIG_INIT_ALL_HEAP
  net: make sk_prot_alloc() work with CONFIG_INIT_ALL_HEAP

 Makefile                               | 10 ++++++
 arch/arm64/Kconfig                     |  1 +
 arch/arm64/include/asm/page.h          |  1 +
 arch/x86/Kconfig                       |  1 +
 arch/x86/include/asm/page_64.h         | 10 ++++++
 arch/x86/lib/clear_page_64.S           | 24 ++++++++++++++
 drivers/infiniband/core/uverbs_ioctl.c |  4 +--
 include/linux/gfp.h                    | 10 ++++++
 include/linux/highmem.h                |  8 +++++
 include/net/sock.h                     |  8 ++---
 kernel/kexec_core.c                    |  8 +++--
 mm/dmapool.c                           |  4 +--
 mm/page_alloc.c                        |  9 ++++--
 mm/slab.c                              | 19 ++++++++----
 mm/slub.c                              | 12 ++++---
 net/core/sock.c                        |  5 +--
 security/Kconfig                       |  1 +
 security/Kconfig.initmem               | 43 ++++++++++++++++++++++++++
 18 files changed, 154 insertions(+), 24 deletions(-)
 create mode 100644 security/Kconfig.initmem

-- 
2.21.0.392.gf8f6787159e-goog
