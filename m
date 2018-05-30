From: YaoJun <yaojun8558363@gmail.com>
Subject: [PATCH 0/4] arm64/mm: migrate swapper_pg_dir
Date: Wed, 30 May 2018 17:12:55 +0800
Message-Id: <20180530091259.9386-1-yaojun8558363@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, mark.rutland@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Currently, The offset between swapper_pg_dir and _text is
fixed. When attackers know the address of _text(no KASLR or
breaking KASLR), they can caculate the address of
swapper_pg_dir. Then KSMA(Kernel Space Mirroring Attack) can
be applied.

The principle of KSMA is to insert a carefully constructed PGD
entry into the translation table. The type of this entry is
block, which maps the kernel text and its access permissions
bits are 01. The user process can then modify kernel text
directly through this mapping.

To protect against KSMA, these patches migrate swapper_pg_dir
to new place, which is dynamically allocated. Since it is
allocated during the kernel boot process and the address is
relatively fixed, further randomization may be required.

YaoJun (4):
  arm64/mm: Introduce __pa_swapper_pg_dir to save physical
	    address of swapper_pg_dir. And pass it as an
	    argument to __enable_mmu().
  arm64/mm: Introduce new_swapper_pg_dir to save virtual
	    address of new swapper_pg_dir.
  arm64/mm: Make tramp_pg_dir and swapper_pg_dir adjacent.
  arm64/mm: Migrate swapper_pg_dir and tramp_pg_dir.

 arch/arm64/include/asm/mmu_context.h |  6 +--
 arch/arm64/include/asm/pgtable.h     |  2 +
 arch/arm64/kernel/cpufeature.c       |  2 +-
 arch/arm64/kernel/entry.S            |  4 +-
 arch/arm64/kernel/head.S             | 10 ++--
 arch/arm64/kernel/hibernate.c        |  2 +-
 arch/arm64/kernel/sleep.S            |  2 +
 arch/arm64/kernel/vmlinux.lds.S      | 10 ++--
 arch/arm64/mm/kasan_init.c           |  6 +--
 arch/arm64/mm/mmu.c                  | 72 ++++++++++++++++++++--------
 10 files changed, 75 insertions(+), 41 deletions(-)

-- 
2.17.0
