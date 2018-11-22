From: Russell Currey <ruscur@russell.cc>
Subject: [PATCH 0/4] Kernel Userspace Protection for Radix MMU
Date: Fri, 23 Nov 2018 01:04:12 +1100
Message-Id: <20181122140416.3447-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, kernel-hardening@lists.openwall.com, christophe.leroy@c-s.fr, Russell Currey <ruscur@russell.cc>
List-ID: <kernel-hardening.lists.openwall.com>

Back again, this time based on top of Christophe Leroy's series:
http://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=74541

With the magic perk of being the snowpatch maintainer I will try and get
the snowpatch results for this series to be applied on top of that series
so all the tests aren't failures.

There aren't really any major functional changes, just working what I
already did into Christophe's framework.  The biggest change is that
execution prevention is now optional, and all the radix-specific code
is now in the radix-specific place where it should be.

Russell Currey (4):
  powerpc: Track KUAP state in the PACA
  powerpc/64: Setup KUP before feature fixups
  powerpc/mm/radix: Use KUEP API for Radix MMU
  powerpc/64s: Implement KUAP for Radix MMU

 arch/powerpc/include/asm/book3s/64/radix.h   | 43 ++++++++++++++++++++
 arch/powerpc/include/asm/exception-64e.h     |  3 ++
 arch/powerpc/include/asm/exception-64s.h     | 19 ++++++++-
 arch/powerpc/include/asm/mmu.h               |  9 +++-
 arch/powerpc/include/asm/nohash/32/pte-8xx.h |  8 ++--
 arch/powerpc/include/asm/paca.h              |  3 ++
 arch/powerpc/include/asm/reg.h               |  1 +
 arch/powerpc/include/asm/uaccess.h           | 23 ++++++++++-
 arch/powerpc/kernel/asm-offsets.c            |  1 +
 arch/powerpc/kernel/entry_64.S               | 16 +++++++-
 arch/powerpc/kernel/setup_64.c               |  7 +++-
 arch/powerpc/mm/pgtable-radix.c              | 21 ++++++++--
 arch/powerpc/mm/pkeys.c                      |  7 +++-
 arch/powerpc/platforms/Kconfig.cputype       |  2 +
 14 files changed, 148 insertions(+), 15 deletions(-)

-- 
2.19.1
