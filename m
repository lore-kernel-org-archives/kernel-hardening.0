Sender: Hans Liljestrand <ishkamiel@gmail.com>
From: Hans Liljestrand <liljestrandh@gmail.com>
Date: Mon, 24 Jul 2017 16:38:19 +0300
Message-Id: <20170724133824.27223-1-LiljestrandH@gmail.com>
Subject: [kernel-hardening] [RFC PATCH 0/5] MPXK: Intel MPX for in-kernel use
To: kernel-hardening@lists.openwall.com
Cc: elena.reshetova@intel.com, dave.hansen@intel.com, keescook@chromium.org, hpa@zytor.com, Hans Liljestrand <LiljestrandH@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patch series adds experimental Intel MPX support for in-kernel code.
Intel MPX provides runtime pointer bounds checking via hardware, operating
system support and compiler instrumentation[1,2,3]. Intel MPX provides new
registers and instructions for pointer bounds checking. Briefly, it keeps
track of pointer bounds by propagating them through stack/registers and
storing them in a hardware address in-memory data-structure.

While the hardware is designed for both ring 0 and 3, current software
(kernel and compiler) only support MPX in user space. This patch-set
introduces MPXK, which provides a way to use MPX in kernel space. As with
vanilla MPX this protection is modular, i.e. it can be enabled only for
specific subsystems or even translation units. This allows MPXK to be
enabled selectively on for instance only known troublesome subsystems. This
patch-set in itself enable MPX only for the accompanying LKDTM tests.

Our work build on existing GCC MPX instrumentation but modifies it via a
gcc-plugin to better accommodate kernel use. The main difference to vanilla
MPX being that we do not use the BNDSTX and BNDLDX instructions that can
cause excessive memory use. The vanilla BNDSTX+BNDLDX storage requires, on
64bit systems, a 2GB directory for addressing and several 4MB tables for
the bounds data, by contrast MPXK requires no extra memory (although the
instrumentation increases kernel and stack size). MPXK instead relies on
existing in-kernel metadata to determine bounds when necessary; This is
however not always possible, in which case MPXK cannot check bounds.

That brings us to the limitations and known problems of MPXK, some of which
can potentially be mitigated in future iterations:

- Vanilla MPX loads bounds based on the linear address of pointers, whereas
  MPXK instead uses the pointer's value. This means that if a corrupted
  pointer value points into another object the load will be based on that, in
  this case incorrect, object. This attack however already assumes a memory
  attack to corrupt the pointer, and would also be missed vanilla MPX BNDLDX
  due to compatibility reasons.

- The bound loading is limited to kmalloc allocated pointers, this only
  affects situations where bounds need to be dynamically loaded. In common
  cases bounds are propagated via hardware registers and the stack. This is
  something we believe can be improved by utilizing other information
  available to the kernel.

- We currently do not support support MPXK in modules (which means the
  accompanying lkdtm tests must be compiled into the kernel).

- Providing modular support requires handling pointers originating or
  passed via non-protected code, such pointer are treated as non-bounded to
  ensure compatibility.

In addition to these fundamental issues there are several other aspects
that still need work, including several potential performance improvements.
At present we all still working on both PoC exploit code and performance
measurements, any suggestions on meaningful measurements or appropriate
exploits are happily taken.

Feedback on the general approach and details are appreciated.

Best Regards,
-hans liljestrand

[1]: https://01.org/blogs/2016/intel-mpx-linux
[2]: https://lwn.net/Articles/582712/
[3]: https://gcc.gnu.org/wiki/Intel%20MPX%20support%20in%20the%20GCC%20compiler

Hans Liljestrand (5):
  x86: add CONFIG_X86_INTEL_MPX_KERNEL to Kconfig
  gcc-plugins: adds MPXK gcc plugin
  x86: add mpxk-wrappers
  x86: MPXK base
  lkdtm: Add kernel MPX testing

 arch/x86/Kconfig                          |  19 ++++
 arch/x86/include/asm/mpxk.h               |  18 ++++
 arch/x86/kernel/traps.c                   |  44 +++++++-
 arch/x86/lib/Makefile                     |   5 +
 arch/x86/lib/mpxk-wrappers.c              | 157 +++++++++++++++++++++++++++
 arch/x86/lib/mpxk.c                       |  69 ++++++++++++
 drivers/misc/Makefile                     |   7 ++
 drivers/misc/lkdtm.h                      |   7 ++
 drivers/misc/lkdtm_core.c                 |   6 ++
 drivers/misc/lkdtm_mpxk.c                 | 115 ++++++++++++++++++++
 drivers/misc/lkdtm_mpxk.h                 |  11 ++
 drivers/misc/lkdtm_mpxk_base.c            |  65 ++++++++++++
 include/asm-generic/mpxk.h                |  20 ++++
 init/main.c                               |   2 +
 scripts/Makefile.gcc-plugins              |  17 +++
 scripts/gcc-plugins/Makefile              |   6 ++
 scripts/gcc-plugins/mpxk.c                | 171 ++++++++++++++++++++++++++++++
 scripts/gcc-plugins/mpxk.h                |  60 +++++++++++
 scripts/gcc-plugins/mpxk_builtins.c       | 102 ++++++++++++++++++
 scripts/gcc-plugins/mpxk_builtins.def     |  41 +++++++
 scripts/gcc-plugins/mpxk_pass_bnd_store.c | 147 +++++++++++++++++++++++++
 scripts/gcc-plugins/mpxk_pass_cfun_args.c |  98 +++++++++++++++++
 scripts/gcc-plugins/mpxk_pass_sweeper.c   | 107 +++++++++++++++++++
 scripts/gcc-plugins/mpxk_pass_wrappers.c  | 128 ++++++++++++++++++++++
 24 files changed, 1421 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/mpxk.h
 create mode 100644 arch/x86/lib/mpxk-wrappers.c
 create mode 100644 arch/x86/lib/mpxk.c
 create mode 100644 drivers/misc/lkdtm_mpxk.c
 create mode 100644 drivers/misc/lkdtm_mpxk.h
 create mode 100644 drivers/misc/lkdtm_mpxk_base.c
 create mode 100644 include/asm-generic/mpxk.h
 create mode 100644 scripts/gcc-plugins/mpxk.c
 create mode 100644 scripts/gcc-plugins/mpxk.h
 create mode 100644 scripts/gcc-plugins/mpxk_builtins.c
 create mode 100644 scripts/gcc-plugins/mpxk_builtins.def
 create mode 100644 scripts/gcc-plugins/mpxk_pass_bnd_store.c
 create mode 100644 scripts/gcc-plugins/mpxk_pass_cfun_args.c
 create mode 100644 scripts/gcc-plugins/mpxk_pass_sweeper.c
 create mode 100644 scripts/gcc-plugins/mpxk_pass_wrappers.c

-- 
2.11.0
