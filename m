From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 0/2] get rid of writable linear aliases of read-only vmalloc mappings
Date: Wed,  7 Nov 2018 11:36:18 +0100
Message-Id: <20181107103620.16054-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, labbott@redhat.com, will.deacon@arm.com, jannh@google.com, mark.rutland@arm.com, james.morse@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This is a followup to my patch 'arm64/mm: unmap the linear alias of module
allocations'. (v1-v2)

This version changes the approach to match what x86 does, i.e., to deal
with the linear alias at a more fundamental level, in the set_memory_ro/rw
routines.

Changes since v3:
- drop boolean function parameter and infer whether to remap the alias from
  set_mask/clear_mask
- overload rodata= instead of adding yet another kernel cmdline arg
- fix typos

Ard Biesheuvel (2):
  arm64: mm: purge lazily unmapped vm regions before changing
    permissions
  arm64: mm: apply r/o permissions of VM areas to its linear alias as
    well

 arch/arm64/Kconfig                   | 14 +++++++++++++
 arch/arm64/include/asm/mmu_context.h |  2 ++
 arch/arm64/mm/mmu.c                  | 16 +++++++++++++--
 arch/arm64/mm/pageattr.c             | 21 ++++++++++++++++++++
 4 files changed, 51 insertions(+), 2 deletions(-)

-- 
2.19.1
