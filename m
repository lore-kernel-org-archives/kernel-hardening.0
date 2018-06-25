From: Jun Yao <yaojun8558363@gmail.com>
Subject: [PATCH v2 0/2] Move {tramp_pg_dir,swapper_pg_dir} to .rodata
Date: Mon, 25 Jun 2018 19:39:19 +0800
Message-Id: <20180625113921.21854-1-yaojun8558363@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, james.morse@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Version 2 changes:

	As James Morse suggested[1], we introduce init_pg_dir, which
	is a reserved area of __initdata section. We setup initial
	page tables in it and then we setup final page tables in
	swapper_pg_dir directly. In this way, we can avoid using
	temporary top level.

	To defend 'KSMA', we need to handle page table configurations
	which we can write a block-mapping into swapper_pg_dir. These
	configurations are:

	CONFIG_ARM64_VA_BITS_39(4KB granule, 1GB block)
	CONFIG_ARM64_VA_BITS_36(16KB granule, 32MB block)
	CONFIG_ARM64_VA_BITS_42(64KB granule, 512MB block)

	If these configurations are selected, we move {tramp_pg_dir,
	swapper_pg_dir} to .rodata section. And we update
	swapper_pg_dir by fixmap.

[1] https://patchwork.kernel.org/patch/10476597/

Jun Yao (2):
  arm64/mm: Introduce init_pg_dir
  arm64/mm: Move {tramp_pg_dir, swapper_pg_dir} to .rodata section

 arch/arm64/include/asm/fixmap.h   |  2 +-
 arch/arm64/include/asm/pgalloc.h  | 33 ++++++++++++++++++++
 arch/arm64/include/asm/pgtable.h  |  8 +++--
 arch/arm64/kernel/head.S          | 52 ++++++++++++++++++++++---------
 arch/arm64/kernel/vmlinux.lds.S   | 26 +++++++++++++++-
 arch/arm64/mm/mmu.c               | 36 +++++++--------------
 include/asm-generic/vmlinux.lds.h |  5 +++
 mm/init-mm.c                      |  2 +-
 8 files changed, 119 insertions(+), 45 deletions(-)

-- 
2.17.1
