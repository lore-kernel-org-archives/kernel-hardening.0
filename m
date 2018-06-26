From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH] arm64/mm: unmap the linear alias of module allocations
Date: Tue, 26 Jun 2018 18:54:55 +0200
Message-Id: <20180626165455.22636-1-ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: mark.rutland@arm.com, keescook@chromium.org, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, yaojun8558363@gmail.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

When CONFIG_STRICT_KERNEL_RXW=y [which is the default on arm64], we
take great care to ensure that the mappings of modules in the vmalloc
space are locked down as much as possible, i.e., executable code is
mapped read-only, read-only data is mapped read-only and non-executable,
and read-write data is mapped non-executable as well.

However, due to the way we map the linear region [aka the kernel direct
mapping], those module regions are aliased by read-write mappings, and
it is possible for an attacker to modify code or data that was assumed
to be immutable in this configuration.

So let's ensure that the linear alias of module memory is unmapped upon
allocation and remapped when it is freed. The latter requires some
special handling involving a workqueue due to the fact that it may be
called in softirq context at which time calling find_vm_area() is unsafe.

Note that this requires the entire linear region to be mapped down to
pages, which may result in a performance regression in some configurations.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
For this RFC, I simply reused set_memory_valid() to do the unmap/remap,
but I am aware that this likely breaks hibernation, and perhaps some
other things as well, so we should probably remap r/o instead.

 arch/arm64/kernel/module.c | 57 ++++++++++++++++++++
 arch/arm64/mm/mmu.c        |  2 +-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 155fd91e78f4..4a1d3c7486f5 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -26,10 +26,66 @@
 #include <linux/mm.h>
 #include <linux/moduleloader.h>
 #include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 #include <asm/alternative.h>
+#include <asm/cacheflush.h>
 #include <asm/insn.h>
 #include <asm/sections.h>
 
+#ifdef CONFIG_STRICT_KERNEL_RWX
+
+static struct workqueue_struct *module_free_wq;
+
+static int init_workqueue(void)
+{
+	module_free_wq = alloc_ordered_workqueue("module_free_wq", 0);
+	WARN_ON(!module_free_wq);
+
+	return 0;
+}
+pure_initcall(init_workqueue);
+
+static void remap_linear_module_alias(void *module_region, int enable)
+{
+	struct vm_struct *vm = find_vm_area(module_region);
+	struct page **p;
+	unsigned long size;
+
+	WARN_ON(!vm || !vm->pages);
+
+	for (p = vm->pages, size = vm->size; size > 0; size -= PAGE_SIZE)
+		set_memory_valid((u64)page_address(*p++), 1, enable);
+}
+
+static void module_free_wq_worker(struct work_struct *work)
+{
+	remap_linear_module_alias(work, true);
+	vfree(work);
+}
+
+void module_memfree(void *module_region)
+{
+	struct work_struct *work;
+
+	if (!module_region)
+		return;
+
+	/*
+	 * At this point, module_region is a pointer to an allocation of at
+	 * least PAGE_SIZE bytes that is mapped read-write. So instead of
+	 * allocating memory for a data structure containing a work_struct
+	 * instance and a copy of the value of module_region, just reuse the
+	 * allocation directly.
+	 */
+	work = module_region;
+	INIT_WORK(work, module_free_wq_worker);
+	queue_work(module_free_wq, work);
+}
+
+#else
+static void remap_linear_module_alias(void *module_region, int enable) {}
+#endif
+
 void *module_alloc(unsigned long size)
 {
 	gfp_t gfp_mask = GFP_KERNEL;
@@ -65,6 +121,7 @@ void *module_alloc(unsigned long size)
 		return NULL;
 	}
 
+	remap_linear_module_alias(p, false);
 	return p;
 }
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 493ff75670ff..e1057ebb672d 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -432,7 +432,7 @@ static void __init map_mem(pgd_t *pgdp)
 	struct memblock_region *reg;
 	int flags = 0;
 
-	if (debug_pagealloc_enabled())
+	if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX) || debug_pagealloc_enabled())
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
-- 
2.11.0
