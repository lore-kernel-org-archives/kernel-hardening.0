From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 2/2] arm64: mm: apply r/o permissions of VM areas to its linear alias as well
Date: Wed,  7 Nov 2018 11:36:20 +0100
Message-Id: <20181107103620.16054-3-ard.biesheuvel@linaro.org>
In-Reply-To: <20181107103620.16054-1-ard.biesheuvel@linaro.org>
References: <20181107103620.16054-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, labbott@redhat.com, will.deacon@arm.com, jannh@google.com, mark.rutland@arm.com, james.morse@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On arm64, we use block mappings and contiguous hints to map the linear
region, to minimize the TLB footprint. However, this means that the
entire region is mapped using read/write permissions, which we cannot
modify at page granularity without having to take intrusive measures to
prevent TLB conflicts.

This means the linear aliases of pages belonging to read-only mappings
(executable or otherwise) in the vmalloc region are also mapped read/write,
and could potentially be abused to modify things like module code, bpf JIT
code or other read-only data.

So let's fix this, by extending the set_memory_ro/rw routines to take
the linear alias into account. The consequence of enabling this is
that we can no longer use block mappings or contiguous hints, so in
cases where the TLB footprint of the linear region is a bottleneck,
performance may be affected.

Therefore, allow this feature to be runtime en/disabled, by setting
rodata=full (or 'on' to disable just this enhancement, or 'off' to
disable read-only mappings for code and r/o data entirely) on the
kernel command line. Also, allow the default value to be set via a
Kconfig option.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig                   | 14 ++++++++++++++
 arch/arm64/include/asm/mmu_context.h |  2 ++
 arch/arm64/mm/mmu.c                  | 16 ++++++++++++++--
 arch/arm64/mm/pageattr.c             | 15 +++++++++++++++
 4 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 787d7850e064..bf57c48c77df 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -958,6 +958,20 @@ config ARM64_SSBD
 
 	  If unsure, say Y.
 
+config RODATA_FULL_DEFAULT_ENABLED
+	bool "Apply r/o permissions of VM areas also to their linear aliases"
+	default y
+	help
+	  Apply read-only attributes of VM areas to the linear alias of
+	  the backing pages as well. This prevents code or read-only data
+	  from being modified (inadvertently or intentionally) via another
+	  mapping of the same memory page. This additional enhancement can
+	  be turned off at runtime by passing rodata=[off|on] (and turned on
+	  with rodata=full if this option is set to 'n')
+
+	  This requires the linear region to be mapped down to pages,
+	  which may adversely affect performance in some cases.
+
 menuconfig ARMV8_DEPRECATED
 	bool "Emulate deprecated/obsolete ARMv8 instructions"
 	depends on COMPAT
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 1e58bf58c22b..dfcfeffd2080 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -35,6 +35,8 @@
 #include <asm/sysreg.h>
 #include <asm/tlbflush.h>
 
+extern bool rodata_full;
+
 static inline void contextidr_thread_switch(struct task_struct *next)
 {
 	if (!IS_ENABLED(CONFIG_PID_IN_CONTEXTIDR))
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index d1d6601b385d..e1b2d58a311a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -451,7 +451,7 @@ static void __init map_mem(pgd_t *pgdp)
 	struct memblock_region *reg;
 	int flags = 0;
 
-	if (debug_pagealloc_enabled())
+	if (rodata_full || debug_pagealloc_enabled())
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
@@ -552,7 +552,19 @@ static void __init map_kernel_segment(pgd_t *pgdp, void *va_start, void *va_end,
 
 static int __init parse_rodata(char *arg)
 {
-	return strtobool(arg, &rodata_enabled);
+	int ret = strtobool(arg, &rodata_enabled);
+	if (!ret) {
+		rodata_full = false;
+		return 0;
+	}
+
+	/* permit 'full' in addition to boolean options */
+	if (strcmp(arg, "full"))
+		return -EINVAL;
+
+	rodata_enabled = true;
+	rodata_full = true;
+	return 0;
 }
 early_param("rodata", parse_rodata);
 
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 787f9e385e6d..6cd645edcf35 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -25,6 +25,8 @@ struct page_change_data {
 	pgprot_t clear_mask;
 };
 
+bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED);
+
 static int change_page_range(pte_t *ptep, pgtable_t token, unsigned long addr,
 			void *data)
 {
@@ -64,6 +66,7 @@ static int change_memory_common(unsigned long addr, int numpages,
 	unsigned long size = PAGE_SIZE*numpages;
 	unsigned long end = start + size;
 	struct vm_struct *area;
+	int i;
 
 	if (!PAGE_ALIGNED(addr)) {
 		start &= PAGE_MASK;
@@ -93,6 +96,18 @@ static int change_memory_common(unsigned long addr, int numpages,
 	if (!numpages)
 		return 0;
 
+	/*
+	 * If we are manipulating read-only permissions, apply the same
+	 * change to the linear mapping of the pages that back this VM area.
+	 */
+	if (rodata_full && (pgprot_val(set_mask) == PTE_RDONLY ||
+			    pgprot_val(clear_mask) == PTE_RDONLY)) {
+		for (i = 0; i < area->nr_pages; i++) {
+			__change_memory_common((u64)page_address(area->pages[i]),
+					       PAGE_SIZE, set_mask, clear_mask);
+		}
+	}
+
 	/*
 	 * Get rid of potentially aliasing lazily unmapped vm areas that may
 	 * have permissions set that deviate from the ones we are setting here.
-- 
2.19.1
