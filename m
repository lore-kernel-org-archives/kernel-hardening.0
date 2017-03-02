From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Fri,  3 Mar 2017 00:00:31 +0900
Message-Id: <1488466831-13918-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] [RFC] arm64: support HAVE_ARCH_RARE_WRITE
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, PaX Team <pageexec@freemail.hu>, x86@kernel.org, Hoeun Ryu <hoeun.ryu@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

 This RFC is a quick and dirty arm64 implementation for Kees Cook's RFC for
rare_write infrastructure [1].

 This implementation is based on Mark Rutland's suggestions, which is that
a special userspace mm that maps only __start/end_rodata as RW permission
is prepared during early boot time (paging_init) and __arch_rare_write_map()
switches to the mm [2].

 Due to the limit of implementation (the mm having RW mapping is userspace
mm), we need a new arch-specific __arch_rare_write_ptr() to convert RO
address to RW address (CONFIG_HAVE_RARE_WRITE_PTR is added), which is
general for all architectures (__rare_write_ptr()) in Kees's RFC . So all
writes should be instrumented by __rare_write().

 One caveat for arm64 is CONFIG_ARM64_SW_TTBR0_PAN.
Because __arch_rare_write_map() installes a special user mm to ttbr0,
usercopy inside  __arch_rare_write_map/unmap() pair will break rare_write.
(uaccess_enable() replaces the special mm and RW alias is no longer valid.)

 A similar problem could rise in general usercopy inside
__arch_rare_write_map/unmap(). __arch_rare_write_map() replaces current->mm,
so we loose the address space of the `current` process.

It passes LKDTM's rare write test.

[1] : http://www.openwall.com/lists/kernel-hardening/2017/02/27/5
[2] : https://lkml.org/lkml/2017/2/22/254

Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
---
 arch/Kconfig                     |  4 ++
 arch/arm64/Kconfig               |  2 +
 arch/arm64/include/asm/pgtable.h | 12 ++++++
 arch/arm64/mm/mmu.c              | 90 ++++++++++++++++++++++++++++++++++++++++
 include/linux/compiler.h         |  6 ++-
 5 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index b1bae4c..0d7b82d 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -902,4 +902,8 @@ config HAVE_ARCH_RARE_WRITE
 	  - the routines must validate expected state (e.g. when enabling
 	    writes, BUG() if writes are already be enabled).
 
+config HAVE_ARCH_RARE_WRITE_PTR
+	def_bool n
+	help
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 896eba6..e6845ca 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -70,6 +70,8 @@ config ARM64
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	select HAVE_ARCH_RARE_WRITE
+	select HAVE_ARCH_RARE_WRITE_PTR
 	select HAVE_ARM_SMCCC
 	select HAVE_EBPF_JIT
 	select HAVE_C_RECORDMCOUNT
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 0eef606..0d4974d 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -731,6 +731,18 @@ static inline void update_mmu_cache(struct vm_area_struct *vma,
 #define kc_vaddr_to_offset(v)	((v) & ~VA_START)
 #define kc_offset_to_vaddr(o)	((o) | VA_START)
 
+extern unsigned long __rare_write_rw_alias_start;
+
+#define __arch_rare_write_ptr(__var) ({				\
+	unsigned long __addr = (unsigned long)&__var;		\
+	__addr -= (unsigned long)__start_rodata;		\
+	__addr += __rare_write_rw_alias_start;			\
+	(typeof(__var) *)__addr;				\
+})
+
+unsigned long __arch_rare_write_map(void);
+unsigned long __arch_rare_write_unmap(void);
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __ASM_PGTABLE_H */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index b805c01..cf5d3dd 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -504,6 +504,94 @@ static void __init map_kernel(pgd_t *pgd)
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
+unsigned long __rare_write_rw_alias_start = TASK_SIZE_64 / 4;
+
+__always_inline unsigned long __arch_rare_write_map(void)
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
+__always_inline unsigned long __arch_rare_write_unmap(void)
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
+void __init rare_write_init(void)
+{
+	phys_addr_t pgd_phys = early_pgtable_alloc();
+	pgd_t *pgd = pgd_set_fixmap(pgd_phys);
+	phys_addr_t pa_start = __pa_symbol(__start_rodata);
+	unsigned long size = __end_rodata - __start_rodata;
+
+	BUG_ON(!pgd);
+	BUG_ON(!PAGE_ALIGNED(pa_start));
+	BUG_ON(!PAGE_ALIGNED(size));
+	BUG_ON(__rare_write_rw_alias_start + size > TASK_SIZE_64);
+
+	rare_write_mm.pgd = (pgd_t *)__phys_to_virt(pgd_phys);
+	init_new_context(NULL, &rare_write_mm);
+
+	__create_pgd_mapping(pgd,
+			     pa_start, __rare_write_rw_alias_start, size,
+			     __pgprot(pgprot_val(PAGE_KERNEL) | PTE_NG),
+			     early_pgtable_alloc, debug_pagealloc_enabled());
+
+	pgd_clear_fixmap();
+}
+
 /*
  * paging_init() sets up the page tables, initialises the zone memory
  * maps and sets up the zero page.
@@ -537,6 +625,8 @@ void __init paging_init(void)
 	 */
 	memblock_free(__pa_symbol(swapper_pg_dir) + PAGE_SIZE,
 		      SWAPPER_DIR_SIZE - PAGE_SIZE);
+
+	rare_write_init();
 }
 
 /*
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c8c684c..a610ef2 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -355,7 +355,11 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 # define __wr_rare		__ro_after_init
 # define __wr_rare_type		const
 # define __rare_write_type(v)	typeof((typeof(v))0)
-# define __rare_write_ptr(v)	((__rare_write_type(v) *)&(v))
+# ifndef CONFIG_HAVE_ARCH_RARE_WRITE_PTR
+#  define __rare_write_ptr(v)	((__rare_write_type(v) *)&(v))
+# else
+#  define __rare_write_ptr(v)	__arch_rare_write_ptr(v)
+# endif
 # define __rare_write(__var, __val) ({			\
 	__rare_write_type(__var) *__rw_var;		\
 							\
-- 
2.7.4
