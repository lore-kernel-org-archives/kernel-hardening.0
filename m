From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 2/2] arm64: mm: apply r/o permissions of VM areas to its linear alias as well
Date: Tue,  6 Nov 2018 22:44:04 +0100
Message-Id: <20181106214404.2497-3-ard.biesheuvel@linaro.org>
In-Reply-To: <20181106214404.2497-1-ard.biesheuvel@linaro.org>
References: <20181106214404.2497-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-arm-kernel@lists.infradead.org
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com, labbott@redhat.com, will.deacon@arm.com, jannh@google.com, mark.rutland@arm.com, james.morse@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On arm64, we use block mappings and contiguous hints to map the linear
region, to minimize the TLB footprint. However, this means that the
entire region is mapped using read/write permissions, and so the linear
aliases of pages belonging to read-only mappings (executable or otherwise)
in the vmalloc region could potentially be abused to modify things like
module code, bpf JIT code or read-only data.

So let's fix this, by extending the set_memory_ro/rw routines to take
the linear alias into account. The consequence of enabling this is
that we can no longer use block mappings or contiguous hints, so in
cases where the TLB footprint of the linear region is a bottleneck,
performance may be affected.

Therefore, allow this feature to be runtime disabled, by setting
rola=off on the kernel command line. Also, allow the default value
to be set via a Kconfig option.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig                   | 14 +++++++++
 arch/arm64/include/asm/mmu_context.h |  2 ++
 arch/arm64/mm/mmu.c                  |  2 +-
 arch/arm64/mm/pageattr.c             | 30 ++++++++++++++++----
 4 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 787d7850e064..d000c379b670 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -958,6 +958,20 @@ config ARM64_SSBD
 
 	  If unsure, say Y.
 
+config ROLA_DEFAULT_ENABLED
+	bool "Apply read-only permissions of VM areas also to its linear alias"
+	default y
+	help
+	  Apply read-only attributes of VM areas to the linear alias of
+	  the backing pages as well. This prevents code or read/only data
+	  from being modified (inadvertently or intentionally) via another
+	  mapping of the same memory page. This can be turned off at runtime
+	  by passing rola=off (and turned on with rola=on if this option is
+	  set to 'n')
+
+	  This requires the linear region to be mapped down to pages,
+	  which may adversely affect performance in some cases.
+
 menuconfig ARMV8_DEPRECATED
 	bool "Emulate deprecated/obsolete ARMv8 instructions"
 	depends on COMPAT
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 1e58bf58c22b..df39a07fe5f0 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -35,6 +35,8 @@
 #include <asm/sysreg.h>
 #include <asm/tlbflush.h>
 
+extern bool rola_enabled;
+
 static inline void contextidr_thread_switch(struct task_struct *next)
 {
 	if (!IS_ENABLED(CONFIG_PID_IN_CONTEXTIDR))
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index d1d6601b385d..79fd3bf102fa 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -451,7 +451,7 @@ static void __init map_mem(pgd_t *pgdp)
 	struct memblock_region *reg;
 	int flags = 0;
 
-	if (debug_pagealloc_enabled())
+	if (rola_enabled || debug_pagealloc_enabled())
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index f8cf5bc1d1f8..1dddb69e6f1c 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -25,6 +25,13 @@ struct page_change_data {
 	pgprot_t clear_mask;
 };
 
+bool rola_enabled __ro_after_init = IS_ENABLED(CONFIG_ROLA_DEFAULT_ENABLED);
+static int __init parse_rola(char *arg)
+{
+	return strtobool(arg, &rola_enabled);
+}
+early_param("rola", parse_rola);
+
 static int change_page_range(pte_t *ptep, pgtable_t token, unsigned long addr,
 			void *data)
 {
@@ -58,12 +65,14 @@ static int __change_memory_common(unsigned long start, unsigned long size,
 }
 
 static int change_memory_common(unsigned long addr, int numpages,
-				pgprot_t set_mask, pgprot_t clear_mask)
+				pgprot_t set_mask, pgprot_t clear_mask,
+				bool remap_alias)
 {
 	unsigned long start = addr;
 	unsigned long size = PAGE_SIZE*numpages;
 	unsigned long end = start + size;
 	struct vm_struct *area;
+	int i;
 
 	if (!PAGE_ALIGNED(addr)) {
 		start &= PAGE_MASK;
@@ -93,6 +102,13 @@ static int change_memory_common(unsigned long addr, int numpages,
 	if (!numpages)
 		return 0;
 
+	if (rola_enabled && remap_alias) {
+		for (i = 0; i < area->nr_pages; i++) {
+			__change_memory_common((u64)page_address(area->pages[i]),
+					       PAGE_SIZE, set_mask, clear_mask);
+		}
+	}
+
 	/*
 	 * Get rid of lazily unmapped vm areas that may have permission
 	 * attributes that deviate from the ones we are setting here.
@@ -106,21 +122,24 @@ int set_memory_ro(unsigned long addr, int numpages)
 {
 	return change_memory_common(addr, numpages,
 					__pgprot(PTE_RDONLY),
-					__pgprot(PTE_WRITE));
+					__pgprot(PTE_WRITE),
+					true);
 }
 
 int set_memory_rw(unsigned long addr, int numpages)
 {
 	return change_memory_common(addr, numpages,
 					__pgprot(PTE_WRITE),
-					__pgprot(PTE_RDONLY));
+					__pgprot(PTE_RDONLY),
+					true);
 }
 
 int set_memory_nx(unsigned long addr, int numpages)
 {
 	return change_memory_common(addr, numpages,
 					__pgprot(PTE_PXN),
-					__pgprot(0));
+					__pgprot(0),
+					false);
 }
 EXPORT_SYMBOL_GPL(set_memory_nx);
 
@@ -128,7 +147,8 @@ int set_memory_x(unsigned long addr, int numpages)
 {
 	return change_memory_common(addr, numpages,
 					__pgprot(0),
-					__pgprot(PTE_PXN));
+					__pgprot(PTE_PXN),
+					false);
 }
 EXPORT_SYMBOL_GPL(set_memory_x);
 
-- 
2.19.1
