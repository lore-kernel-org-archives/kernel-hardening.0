Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@redhat.com>
Date: Thu, 29 Sep 2016 14:32:57 -0700
Message-Id: <20160929213257.30505-4-labbott@redhat.com>
In-Reply-To: <20160929213257.30505-1-labbott@redhat.com>
References: <20160929213257.30505-1-labbott@redhat.com>
Subject: [kernel-hardening] [PATCH 3/3] arm64: dump: Add checking for writable and exectuable pages
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Laura Abbott <labbott@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Page mappings with full RWX permissions are a security risk. x86
has an option to walk the page tables and dump any bad pages.
(See e1a58320a38d ("x86/mm: Warn on W^X mappings")). Add a similar
implementation for arm64.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 arch/arm64/Kconfig.debug        | 28 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/ptdump.h | 10 ++++++++++
 arch/arm64/mm/dump.c            | 36 ++++++++++++++++++++++++++++++++++++
 arch/arm64/mm/mmu.c             |  2 ++
 4 files changed, 76 insertions(+)

diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 9015f02..037dba4 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -42,6 +42,34 @@ config ARM64_RANDOMIZE_TEXT_OFFSET
 	  of TEXT_OFFSET and platforms must not require a specific
 	  value.
 
+config DEBUG_WX
+	bool "Warn on W+X mappings at boot"
+	select ARM64_PTDUMP_CORE
+	---help---
+	  Generate a warning if any W+X mappings are found at boot.
+
+	  This is useful for discovering cases where the kernel is leaving
+	  W+X mappings after applying NX, as such mappings are a security risk.
+
+	  Look for a message in dmesg output like this:
+
+	    arm64/mm: Checked W+X mappings: passed, no W+X pages found.
+
+	  or like this, if the check failed:
+
+	    arm64/mm: Checked W+X mappings: FAILED, <N> W+X pages found.
+
+	  Note that even if the check fails, your kernel is possibly
+	  still fine, as W+X mappings are not a security hole in
+	  themselves, what they do is that they make the exploitation
+	  of other unfixed kernel bugs easier.
+
+	  There is no runtime or memory usage effect of this option
+	  once the kernel has booted up - it's a one time check.
+
+	  If in doubt, say "Y".
+
+
 config DEBUG_SET_MODULE_RONX
 	bool "Set loadable kernel module data as NX and text as RO"
 	depends on MODULES
diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index b18a62c..e3c6bc0 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -20,6 +20,7 @@
 
 #include <linux/seq_file.h>
 #include <linux/mm_types.h>
+#include <linux/list.h>
 
 struct addr_marker {
 	unsigned long start_address;
@@ -31,6 +32,8 @@ struct ptdump_info {
 	const struct addr_marker	*markers;
 	unsigned long			base_addr;
 	unsigned long			max_addr;
+	/* Internal, do not touch */
+	struct list_head		node;
 };
 
 int ptdump_register(struct ptdump_info *info, const char *name);
@@ -44,6 +47,13 @@ static inline int ptdump_debugfs_create(struct ptdump_info *info,
 	return 0;
 }
 #endif
+void ptdump_check_wx(void);
+
+#ifdef CONFIG_DEBUG_WX
+#define debug_checkwx()	ptdump_check_wx()
+#else
+#define debug_checkwx()	do { } while (0)
+#endif
 
 #else
 static inline int ptdump_register(struct ptdump_info *info, const char *name)
diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
index e318f3d..b0b1dd6 100644
--- a/arch/arm64/mm/dump.c
+++ b/arch/arm64/mm/dump.c
@@ -29,6 +29,8 @@
 #include <asm/pgtable-hwdef.h>
 #include <asm/ptdump.h>
 
+static LIST_HEAD(dump_info);
+
 static const struct addr_marker address_markers[] = {
 #ifdef CONFIG_KASAN
 	{ KASAN_SHADOW_START,		"Kasan shadow start" },
@@ -74,6 +76,8 @@ struct pg_state {
 	unsigned long start_address;
 	unsigned level;
 	u64 current_prot;
+	bool check_wx;
+	unsigned long wx_pages;
 };
 
 struct prot_bits {
@@ -219,6 +223,15 @@ static void note_page(struct pg_state *st, unsigned long addr, unsigned level,
 		unsigned long delta;
 
 		if (st->current_prot) {
+			if (st->check_wx &&
+			((st->current_prot & PTE_RDONLY) != PTE_RDONLY) &&
+			((st->current_prot & PTE_PXN) != PTE_PXN)) {
+				WARN_ONCE(1, "arm64/mm: Found insecure W+X mapping at address %p/%pS\n",
+					 (void *)st->start_address,
+					 (void *)st->start_address);
+				st->wx_pages += (addr - st->start_address) / PAGE_SIZE;
+			}
+
 			pt_dump_seq_printf(st->seq, "0x%016lx-0x%016lx   ",
 				   st->start_address, addr);
 
@@ -341,6 +354,7 @@ static void ptdump_initialize(struct ptdump_info *info)
 int ptdump_register(struct ptdump_info *info, const char *name)
 {
 	ptdump_initialize(info);
+	list_add(&info->node, &dump_info);
 	return ptdump_debugfs_create(info, name);
 }
 
@@ -350,6 +364,28 @@ static struct ptdump_info kernel_ptdump_info = {
 	.base_addr	= VA_START,
 };
 
+void ptdump_check_wx(void)
+{
+	struct ptdump_info *info;
+
+	list_for_each_entry(info, &dump_info, node) {
+		struct pg_state st = {
+			.seq = NULL,
+			.marker = info->markers,
+			.check_wx = true,
+		};
+
+		__walk_pgd(&st, info->mm, info->base_addr);
+		note_page(&st, 0, 0, 0);
+		if (st.wx_pages)
+			pr_info("Checked W+X mappings (%p): FAILED, %lu W+X pages found\n",
+				info->mm,
+				st.wx_pages);
+		else
+			pr_info("Checked W+X mappings (%p): passed, no W+X pages found\n", info->mm);
+	}
+}
+
 static int ptdump_init(void)
 {
 	return ptdump_register(&kernel_ptdump_info, "kernel_page_tables");
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 4989948..1f036d2 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -41,6 +41,7 @@
 #include <asm/tlb.h>
 #include <asm/memblock.h>
 #include <asm/mmu_context.h>
+#include <asm/ptdump.h>
 
 #include "mm.h"
 
@@ -397,6 +398,7 @@ void mark_rodata_ro(void)
 	section_size = (unsigned long)__init_begin - (unsigned long)__start_rodata;
 	create_mapping_late(__pa(__start_rodata), (unsigned long)__start_rodata,
 			    section_size, PAGE_KERNEL_RO);
+	debug_checkwx();
 }
 
 void fixup_init(void)
-- 
2.10.0
