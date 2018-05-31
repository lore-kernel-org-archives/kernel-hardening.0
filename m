From: Jun Yao <yaojun8558363@gmail.com>
Subject: [PATCH v2 0/2] mark tramp_pg_dir read-only
Date: Thu, 31 May 2018 18:30:49 +0800
Message-Id: <20180531103049.31690-1-yaojun8558363@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Version 2 changes:
	split tramp_pg_dir off from the data segment and create
	a dedicated pgdir segment for it.

Jun Yao (2):
  arm64/mm: split tramp_pg_dir off from the data segment
  arm64/mm: make tramp_pg_dir read-only

 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/vmlinux.lds.S   |  3 +++
 arch/arm64/mm/mmu.c               | 19 +++++++++++++++++++
 3 files changed, 23 insertions(+)

-- 
2.17.0
