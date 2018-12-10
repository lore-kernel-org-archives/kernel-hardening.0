From: Russell Currey <ruscur@russell.cc>
Subject: [PATCH v2 0/3] [PATCH v2 0/3] Kernel Userspace Protection for Radix MMU
Date: Mon, 10 Dec 2018 18:00:41 +1100
Message-Id: <20181210070044.27503-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linuxppc-dev@lists.ozlabs.org
Cc: mikey@neuling.org, mpe@ellerman.id.au, benh@kernel.crashing.org, npiggin@gmail.com, christophe.leroy@c-s.fr, kernel-hardening@lists.openwall.com, Russell Currey <ruscur@russell.cc>
List-ID: <kernel-hardening.lists.openwall.com>

This series is based on Christophe's series:
http://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=78469
with some minor changes.

I wanted to move my patches to apply at the tail of his series to make it
easier for the two of us to work on independent parts, so I'm resending my
part of the series with the intent that it applies at the end.  There are
two required changes to his series to make this work:

In patch 04/11, the #ifdef around the paca_struct flag user_access_allowed
needs to be dropped.

With my patches removed, patch 11/11 needs to not reference
asm/book3s/64/kup-radix.h in asm/book3s/64/kup.h (so below the kup.h chunk
in that patch).

Sorry for being a pain, I'd rather not send a gigantic series full of
patches that aren't mine.

This branch shows how I'd imagine it would be pulled together:
https://github.com/ruscur/linux/commits/kuap2

Since the last version of this series:

      - fixed issues booting on hash, and the series now fully bisects
      - dropped some parts which are now part of Christophe's series
      - Fix __patch_instruction() in early boot
      - save three instructions in LOCK_USER_ACCESS()

Russell Currey (3):
  powerpc/mm/radix: Use KUEP API for Radix MMU
  powerpc/lib: Refactor __patch_instruction() to use __put_user_asm()
  powerpc/64s: Implement KUAP for Radix MMU

 .../powerpc/include/asm/book3s/64/kup-radix.h | 36 +++++++++++++++++++
 arch/powerpc/include/asm/exception-64s.h      | 15 ++++++--
 arch/powerpc/include/asm/kup.h                |  3 ++
 arch/powerpc/include/asm/mmu.h                |  9 ++++-
 arch/powerpc/include/asm/reg.h                |  1 +
 arch/powerpc/lib/code-patching.c              |  4 +--
 arch/powerpc/mm/pgtable-radix.c               | 25 +++++++++++--
 arch/powerpc/mm/pkeys.c                       |  7 ++--
 arch/powerpc/platforms/Kconfig.cputype        |  2 ++
 9 files changed, 92 insertions(+), 10 deletions(-)
 create mode 100644 arch/powerpc/include/asm/book3s/64/kup-radix.h

-- 
2.19.2
