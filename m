From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v5 0/4] KASLR feature to randomize each loadable module
Date: Wed, 12 Sep 2018 15:55:36 -0700
Message-Id: <1536792940-8294-1-git-send-email-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, daniel@iogearbox.net, jannh@google.com, keescook@chromium.org, alexei.starovoitov@gmail.com
Cc: kristen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is V5 of the "KASLR feature to randomize each loadable module" patchset.
The purpose is to increase the randomization and also to make the modules
randomized in relation to each other instead of just the base, so that if one
module leaks the location of the others can't be inferred.

V5 is the addition of a module_alloc micro benchmarking module. It can be used
to see the performance and module area capacity differences between module_alloc
algorithms. Because of the dataset of the module text section sizes is very
large, I replaced it with a heuristic that generates module sizes that roughly
approximate the real X86_64 modules. As a result the benchmarks are slightly
different. If there is any interest in the real dataset I am happy to send it
out.

Changes for V5:
 - Add module_alloc test module

Changes for V4:
 - Fix issue caused by KASAN, kmemleak being provided different allocation
   lengths (padding).
 - Avoid kmalloc until sure its needed in __vmalloc_node_try_addr.
 - Fixed issues reported by 0-day.

Changes for V3:
 - Code cleanup based on internal feedback. (thanks to Dave Hansen and Andriy
   Shevchenko)
 - Slight refactor of existing algorithm to more cleanly live along side new
   one.
 - BPF synthetic benchmark

Changes for V2:
 - New implementation of __vmalloc_node_try_addr based on the
   __vmalloc_node_range implementation, that only flushes TLB when needed.
 - Modified module loading algorithm to try to reduce the TLB flushes further.
 - Increase "random area" tries in order to increase the number of modules that
   can get high randomness.
 - Increase "random area" size to 2/3 of module area in order to increase the
  number of modules that can get high randomness.
 - Fix for 0day failures on other architectures.
 - Fix for wrong debugfs permissions. (thanks to Jann Horn)
 - Spelling fix. (thanks to Jann Horn)
 - Data on module_alloc performance and TLB flushes. (brought up by Kees Cook
   and Jann Horn)
 - Data on memory usage. (suggested by Jann)


Rick Edgecombe (4):
  vmalloc: Add __vmalloc_node_try_addr function
  x86/modules: Increase randomization for modules
  vmalloc: Add debugfs modfraginfo
  Kselftest for module text allocation benchmarking

 arch/x86/include/asm/pgtable_64_types.h       |   7 +
 arch/x86/kernel/module.c                      | 165 ++++++++--
 include/linux/vmalloc.h                       |   3 +
 lib/Kconfig.debug                             |  10 +
 lib/Makefile                                  |   1 +
 lib/test_mod_alloc.c                          | 446 ++++++++++++++++++++++++++
 mm/vmalloc.c                                  | 279 +++++++++++++++-
 tools/testing/selftests/bpf/test_mod_alloc.sh |  29 ++
 8 files changed, 915 insertions(+), 25 deletions(-)
 create mode 100644 lib/test_mod_alloc.c
 create mode 100755 tools/testing/selftests/bpf/test_mod_alloc.sh

-- 
2.7.4
