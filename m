From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Thu, 30 Mar 2017 23:39:33 +0900
Message-Id: <1490884982-5066-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] [RFCv2] arm64: support HAVE_ARCH_RARE_WRITE and HAVE_ARCH_RARE_WRITE_MEMCPY
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, luto@kernel.org, pageexec@freemail.hu, re.emese@gmail.com, linux@armlinux.org.uk, x86@kernel.org, Hoeun Ryu <hoeun.ryu@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Laura Abbott <labbott@redhat.com>, Hugh Dickins <hughd@google.com>, Steve Capper <steve.capper@arm.com>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, James Morse <james.morse@arm.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

 This patch might be a part of Kees Cook's rare_write infrastructure series
for [1] for arm64 architecture.

 This implementation is based on Mark Rutland's suggestions [2], which is
that a special userspace mm that maps only __start/end_rodata as RW permi-
ssion is prepared during early boot time (paging_init) and __arch_rare_-
write_begin() switches to the mm [2].

 rare_write_mm address space is added for the special purpose and a page
global directory is also prepared for it. The mm remaps __start_rodata ~
__end_rodata to rodata_rw_alias_start which starts from TASK_SIZE_64 / 4
+ kaslr_offset().

 It passes LKDTM's rare write test.

[1] : http://www.openwall.com/lists/kernel-hardening/2017/02/27/5
[2] : https://lkml.org/lkml/2017/3/29/704

Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
---
 arch/arm64/Kconfig               |   2 +
 arch/arm64/include/asm/pgtable.h |   4 ++
 arch/arm64/mm/mmu.c              | 101 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index f2b0b52..6e2c592 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -102,6 +102,8 @@ config ARM64
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_ARCH_RARE_WRITE
+	select HAVE_ARCH_RARE_WRITE_MEMCPY
 	select IOMMU_DMA if IOMMU_SUPPORT
 	select IRQ_DOMAIN
 	select IRQ_FORCED_THREADING
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index c213fdbd0..1514933 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -741,6 +741,10 @@ static inline void update_mmu_cache(struct vm_area_struct *vma,
 #define kc_vaddr_to_offset(v)	((v) & ~VA_START)
 #define kc_offset_to_vaddr(o)	((o) | VA_START)
 
+unsigned long __arch_rare_write_begin(void);
+unsigned long __arch_rare_write_end(void);
+void __arch_rare_write_memcpy(void *dst, const void *src, __kernel_size_t len);
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __ASM_PGTABLE_H */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 91502e3..86b25c9 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -570,6 +570,105 @@ static void __init map_kernel(pgd_t *pgd)
 	kasan_copy_shadow(pgd);
 }
 
+struct mm_struct rare_write_mm = {
+	.mm_rb		= RB_ROOT,
+	.mm_users	= ATOMIC_INIT(2),
+	.mm_count	= ATOMIC_INIT(1),
+	.mmap_sem	= __RWSEM_INITIALIZER(rare_write_mm.mmap_sem),
+	.page_table_lock= __SPIN_LOCK_UNLOCKED(rare_write_mm.page_table_lock),
+	.mmlist		= LIST_HEAD_INIT(rare_write_mm.mmlist),
+};
+
+#ifdef CONFIG_ARM64_PTDUMP_DEBUGFS
+#include <asm/ptdump.h>
+
+static struct ptdump_info rare_write_ptdump_info = {
+	.mm		= &rare_write_mm,
+	.markers	= (struct addr_marker[]){
+		{ 0,		"rare-write start" },
+		{ TASK_SIZE_64,	"rare-write end" }
+	},
+	.base_addr	= 0,
+};
+
+static int __init ptdump_init(void)
+{
+	return ptdump_debugfs_register(&rare_write_ptdump_info,
+				       "rare_write_page_tables");
+}
+device_initcall(ptdump_init);
+
+#endif
+
+__always_inline unsigned long __arch_rare_write_begin(void)
+{
+	struct mm_struct *mm = &rare_write_mm;
+
+	preempt_disable();
+
+	__switch_mm(mm);
+
+	if (system_uses_ttbr0_pan()) {
+		update_saved_ttbr0(current, mm);
+		cpu_switch_mm(mm->pgd, mm);
+	}
+
+	return 0;
+}
+
+__always_inline unsigned long __arch_rare_write_end(void)
+{
+	struct mm_struct *mm = current->active_mm;
+
+	__switch_mm(mm);
+
+	if (system_uses_ttbr0_pan()) {
+		cpu_set_reserved_ttbr0();
+		if (mm != &init_mm)
+			update_saved_ttbr0(current, mm);
+	}
+
+	preempt_enable_no_resched();
+
+	return 0;
+}
+
+static unsigned long rodata_rw_alias_start __ro_after_init = TASK_SIZE_64 / 4;
+
+__always_inline void __arch_rare_write_memcpy(void *dst, const void *src,
+					      __kernel_size_t len)
+{
+	unsigned long __dst = (unsigned long)dst;
+
+	__dst -= (unsigned long)__start_rodata;
+	__dst += rodata_rw_alias_start;
+
+	memcpy((void *)__dst, src, len);
+}
+
+void __init rare_write_init(void)
+{
+	phys_addr_t pgd_phys = early_pgtable_alloc();
+	pgd_t *pgd = (pgd_t *)__phys_to_virt(pgd_phys);
+	phys_addr_t pa_start = __pa_symbol(__start_rodata);
+	unsigned long size = __end_rodata - __start_rodata;
+
+	BUG_ON(!PAGE_ALIGNED(pa_start));
+	BUG_ON(!PAGE_ALIGNED(size));
+
+	rodata_rw_alias_start += kaslr_offset();
+
+	BUG_ON(rodata_rw_alias_start + size > TASK_SIZE_64);
+
+	rare_write_mm.pgd = pgd;
+	init_new_context(NULL, &rare_write_mm);
+
+	__create_pgd_mapping(pgd,
+			     pa_start, rodata_rw_alias_start, size,
+			     __pgprot(pgprot_val(PAGE_KERNEL) | PTE_NG),
+			     early_pgtable_alloc, debug_pagealloc_enabled());
+}
+
 /*
  * paging_init() sets up the page tables, initialises the zone memory
  * maps and sets up the zero page.
@@ -603,6 +702,8 @@ void __init paging_init(void)
 	 */
 	memblock_free(__pa_symbol(swapper_pg_dir) + PAGE_SIZE,
 		      SWAPPER_DIR_SIZE - PAGE_SIZE);
+
+	rare_write_init();
 }
 
 /*
-- 
2.7.4
