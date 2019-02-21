From: Russell Currey <ruscur@russell.cc>
Subject: [PATCH 0/7] Kernel Userspace Protection for radix
Date: Thu, 21 Feb 2019 20:35:54 +1100
Message-Id: <20190221093601.27920-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@c-s.fr, kernel-hardening@lists.openwall.com, Russell Currey <ruscur@russell.cc>
List-ID: <kernel-hardening.lists.openwall.com>

The first three patches of these series are from Christophe's work and are
the bare minimum framework needed to implement the support for radix.

In patch 3, I have removed from Christophe's patch my implementation of
the 64-bit exception handling code, since we don't have an answer for
making nested exceptions work yet.  This is mentioned in the final KUAP
patch.  Regardless, this is still a significant security improvement
and greatly narrows the attack surface.

Here are patches you will want if you want this to work:

http://patchwork.ozlabs.org/patch/1045215/
http://patchwork.ozlabs.org/patch/1045049/
http://patchwork.ozlabs.org/patch/1038568/

(or subsequent revisions, which the latter two will need)

I wouldn't expect this series to be merged without those fixes.

Thanks to Christophe for his great work and to Michael Ellerman for a
ton of feedback as I've worked on this.

Christophe Leroy (3):
  powerpc: Add framework for Kernel Userspace Protection
  powerpc: Add skeleton for Kernel Userspace Execution Prevention
  powerpc/mm: Add a framework for Kernel Userspace Access Protection

Russell Currey (4):
  powerpc/64: Setup KUP on secondary CPUs
  powerpc/mm/radix: Use KUEP API for Radix MMU
  powerpc/lib: Refactor __patch_instruction() to use __put_user_asm()
  powerpc/64s: Implement KUAP for Radix MMU

 .../admin-guide/kernel-parameters.txt         |  4 +-
 .../powerpc/include/asm/book3s/64/kup-radix.h | 36 ++++++++++++++++
 arch/powerpc/include/asm/exception-64e.h      |  3 ++
 arch/powerpc/include/asm/exception-64s.h      |  3 ++
 arch/powerpc/include/asm/futex.h              |  4 ++
 arch/powerpc/include/asm/kup.h                | 42 +++++++++++++++++++
 arch/powerpc/include/asm/mmu.h                |  9 +++-
 arch/powerpc/include/asm/paca.h               |  3 ++
 arch/powerpc/include/asm/processor.h          |  3 ++
 arch/powerpc/include/asm/ptrace.h             |  3 ++
 arch/powerpc/include/asm/reg.h                |  1 +
 arch/powerpc/include/asm/uaccess.h            | 38 +++++++++++++----
 arch/powerpc/kernel/asm-offsets.c             |  7 ++++
 arch/powerpc/kernel/entry_32.S                |  8 +++-
 arch/powerpc/kernel/process.c                 |  3 ++
 arch/powerpc/kernel/setup_64.c                | 10 +++++
 arch/powerpc/lib/checksum_wrappers.c          |  4 ++
 arch/powerpc/lib/code-patching.c              |  4 +-
 arch/powerpc/mm/fault.c                       | 20 ++++++---
 arch/powerpc/mm/init-common.c                 | 26 ++++++++++++
 arch/powerpc/mm/init_32.c                     |  3 ++
 arch/powerpc/mm/pgtable-radix.c               | 28 +++++++++++--
 arch/powerpc/mm/pkeys.c                       |  7 +++-
 arch/powerpc/platforms/Kconfig.cputype        | 26 ++++++++++++
 24 files changed, 271 insertions(+), 24 deletions(-)
 create mode 100644 arch/powerpc/include/asm/book3s/64/kup-radix.h
 create mode 100644 arch/powerpc/include/asm/kup.h

-- 
2.20.1
