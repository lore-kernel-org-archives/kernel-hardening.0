From: YaoJun <yaojun8558363@gmail.com>
Subject: [PATCH 0/4] migrate swapper_pg_dir
Date: Tue, 29 May 2018 12:37:28 +0800
Message-Id: <20180529043728.27738-1-yaojun8558363@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, jmorris@namei.org
List-ID: <kernel-hardening.lists.openwall.com>

Because the offset between swapper_pg_dir and _text is fixed, when
attackers break KASLR, they can calculate the address of swapper_pg_dir,
and then they can apply KSMA(Kernel Space Mirror Attack). The principle
of KSMA is to insert an entry to PGD, and this entry has type of block
with AP = 01, so attackers can read/write kernel memory directly. Details
can reference:

https://www.blackhat.com/docs/asia-18/asia-18-WANG-KSMA-Breaking-Android-kernel-isolation-and-Rooting-with-ARM-MMU-features.pdf

These patches migrate swapper_pg_dir to new place, and there is no
relationship between swapper_pg_dir and _text. Because this is done
during kernel booting, the physical address of new swapper_pg_dir may
be fixed. Do we need to further randomize it?

YaoJun (4):
  Introduce a variable to record physical address of swapper_pg_dir.
  Introduce a variable to record new virtual address of swapper_pg_dir.
  Make tramp_pg_dir and swapper_pg_dir adjacent
  Migrate swapper_pg_dir and tramp_pg_dir.

 arch/arm64/include/asm/mmu_context.h |  6 +--
 arch/arm64/include/asm/pgtable.h     |  2 +
 arch/arm64/kernel/cpufeature.c       |  2 +-
 arch/arm64/kernel/entry.S            |  4 +-
 arch/arm64/kernel/head.S             | 10 ++--
 arch/arm64/kernel/hibernate.c        |  2 +-
 arch/arm64/kernel/sleep.S            |  2 +
 arch/arm64/kernel/vmlinux.lds.S      | 10 ++--
 arch/arm64/mm/kasan_init.c           |  6 +--
 arch/arm64/mm/mmu.c                  | 72 +++++++++++++++++++---------
 10 files changed, 74 insertions(+), 42 deletions(-)

-- 
2.17.0
