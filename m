Date: Fri, 8 Dec 2017 20:02:19 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Message-ID: <20171208110219.GA12171@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening][PATCH v6 3/3] arm: mm: dump: add checking for
 writable and executable pages
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: afzal.mohd.ma@gmail.com, mark.rutland@arm.com, labbott@redhat.com, linux@armlinux.org.uk, gregkh@linuxfoundation.org, keescook@chromium.org, vladimir.murzin@arm.com, arnd@arndb.de, pombredanne@nexb.com
List-ID: <kernel-hardening.lists.openwall.com>

Page mappings with full RWX permissions are a security risk.
x86, arm64 has an option to walk the page tables
and dump any bad pages.

(1404d6f13e47
("arm64: dump: Add checking for writable and exectuable pages"))
Add a similar implementation for arm.

Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Laura Abbott <labbott@redhat.com>
Reviewed-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
---
v6: No changes
    (Just add Reviewed-by from Kees Cook)
---
 arch/arm/Kconfig.debug        | 27 ++++++++++++++++++++
 arch/arm/include/asm/ptdump.h |  8 ++++++
 arch/arm/mm/dump.c            | 58 ++++++++++++++++++++++++++++++++++++++++++-
 arch/arm/mm/init.c            |  2 ++
 4 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index e7b94db..78a6470 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -20,6 +20,33 @@ config ARM_PTDUMP_DEBUGFS
 	  kernel.
 	  If in doubt, say "N"
 
+config DEBUG_WX
+	bool "Warn on W+X mappings at boot"
+	select ARM_PTDUMP_CORE
+	---help---
+		Generate a warning if any W+X mappings are found at boot.
+
+		This is useful for discovering cases where the kernel is leaving
+		W+X mappings after applying NX, as such mappings are a security risk.
+
+		Look for a message in dmesg output like this:
+
+			arm/mm: Checked W+X mappings: passed, no W+X pages found.
+
+		or like this, if the check failed:
+
+			arm/mm: Checked W+X mappings: FAILED, <N> W+X pages found.
+
+		Note that even if the check fails, your kernel is possibly
+		still fine, as W+X mappings are not a security hole in
+		themselves, what they do is that they make the exploitation
+		of other unfixed kernel bugs easier.
+
+		There is no runtime or memory usage effect of this option
+		once the kernel has booted up - it's a one time check.
+
+		If in doubt, say "Y".
+
 # RMK wants arm kernels compiled with frame pointers or stack unwinding.
 # If you know what you are doing and are willing to live without stack
 # traces, you can get a slightly smaller kernel by setting this option to
diff --git a/arch/arm/include/asm/ptdump.h b/arch/arm/include/asm/ptdump.h
index 45d2de3..3ebf971 100644
--- a/arch/arm/include/asm/ptdump.h
+++ b/arch/arm/include/asm/ptdump.h
@@ -30,6 +30,14 @@ static inline int ptdump_debugfs_register(struct ptdump_info *info,
 }
 #endif /* CONFIG_ARM_PTDUMP_DEBUGFS */
 
+void ptdump_check_wx(void);
+
 #endif /* CONFIG_ARM_PTDUMP_CORE */
 
+#ifdef CONFIG_DEBUG_WX
+#define debug_checkwx() ptdump_check_wx()
+#else
+#define debug_checkwx() do { } while (0)
+#endif
+
 #endif /* __ASM_PTDUMP_H */
diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
index 43a2bee..084779c 100644
--- a/arch/arm/mm/dump.c
+++ b/arch/arm/mm/dump.c
@@ -52,6 +52,8 @@ struct pg_state {
 	unsigned long start_address;
 	unsigned level;
 	u64 current_prot;
+	bool check_wx;
+	unsigned long wx_pages;
 	const char *current_domain;
 };
 
@@ -60,6 +62,8 @@ struct prot_bits {
 	u64		val;
 	const char	*set;
 	const char	*clear;
+	bool		ro_bit;
+	bool		nx_bit;
 };
 
 static const struct prot_bits pte_bits[] = {
@@ -73,11 +77,13 @@ struct prot_bits {
 		.val	= L_PTE_RDONLY,
 		.set	= "ro",
 		.clear	= "RW",
+		.ro_bit	= true,
 	}, {
 		.mask	= L_PTE_XN,
 		.val	= L_PTE_XN,
 		.set	= "NX",
 		.clear	= "x ",
+		.nx_bit	= true,
 	}, {
 		.mask	= L_PTE_SHARED,
 		.val	= L_PTE_SHARED,
@@ -141,11 +147,13 @@ struct prot_bits {
 		.val	= L_PMD_SECT_RDONLY | PMD_SECT_AP2,
 		.set	= "ro",
 		.clear	= "RW",
+		.ro_bit	= true,
 #elif __LINUX_ARM_ARCH__ >= 6
 	{
 		.mask	= PMD_SECT_APX | PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
 		.val	= PMD_SECT_APX | PMD_SECT_AP_WRITE,
 		.set	= "    ro",
+		.ro_bit	= true,
 	}, {
 		.mask	= PMD_SECT_APX | PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
 		.val	= PMD_SECT_AP_WRITE,
@@ -164,6 +172,7 @@ struct prot_bits {
 		.mask   = PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
 		.val    = 0,
 		.set    = "    ro",
+		.ro_bit	= true,
 	}, {
 		.mask   = PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
 		.val    = PMD_SECT_AP_WRITE,
@@ -182,6 +191,7 @@ struct prot_bits {
 		.val	= PMD_SECT_XN,
 		.set	= "NX",
 		.clear	= "x ",
+		.nx_bit	= true,
 	}, {
 		.mask	= PMD_SECT_S,
 		.val	= PMD_SECT_S,
@@ -194,6 +204,8 @@ struct pg_level {
 	const struct prot_bits *bits;
 	size_t num;
 	u64 mask;
+	const struct prot_bits *ro_bit;
+	const struct prot_bits *nx_bit;
 };
 
 static struct pg_level pg_level[] = {
@@ -226,6 +238,23 @@ static void dump_prot(struct pg_state *st, const struct prot_bits *bits, size_t
 	}
 }
 
+static void note_prot_wx(struct pg_state *st, unsigned long addr)
+{
+	if (!st->check_wx)
+		return;
+	if ((st->current_prot & pg_level[st->level].ro_bit->mask) ==
+				pg_level[st->level].ro_bit->val)
+		return;
+	if ((st->current_prot & pg_level[st->level].nx_bit->mask) ==
+				pg_level[st->level].nx_bit->val)
+		return;
+
+	WARN_ONCE(1, "arm/mm: Found insecure W+X mapping at address %pS\n",
+			(void *)st->start_address);
+
+	st->wx_pages += (addr - st->start_address) / PAGE_SIZE;
+}
+
 static void note_page(struct pg_state *st, unsigned long addr,
 		      unsigned int level, u64 val, const char *domain)
 {
@@ -244,6 +273,7 @@ static void note_page(struct pg_state *st, unsigned long addr,
 		unsigned long delta;
 
 		if (st->current_prot) {
+			note_prot_wx(st, addr);
 			pt_dump_seq_printf(st->seq, "0x%08lx-0x%08lx   ",
 				   st->start_address, addr);
 
@@ -367,6 +397,7 @@ void ptdump_walk_pgd(struct seq_file *m, struct ptdump_info *info)
 	struct pg_state st = {
 		.seq = m,
 		.marker = info->markers,
+		.check_wx = false,
 	};
 
 	walk_pgd(&st, info->mm, info->base_addr);
@@ -379,8 +410,13 @@ static void ptdump_initialize(void)
 
 	for (i = 0; i < ARRAY_SIZE(pg_level); i++)
 		if (pg_level[i].bits)
-			for (j = 0; j < pg_level[i].num; j++)
+			for (j = 0; j < pg_level[i].num; j++) {
 				pg_level[i].mask |= pg_level[i].bits[j].mask;
+				if (pg_level[i].bits[j].ro_bit)
+					pg_level[i].ro_bit = &pg_level[i].bits[j];
+				if (pg_level[i].bits[j].nx_bit)
+					pg_level[i].nx_bit = &pg_level[i].bits[j];
+			}
 
 	address_markers[2].start_address = VMALLOC_START;
 }
@@ -391,6 +427,26 @@ static void ptdump_initialize(void)
 	.base_addr = 0,
 };
 
+void ptdump_check_wx(void)
+{
+	struct pg_state st = {
+		.seq = NULL,
+		.marker = (struct addr_marker[]) {
+			{ 0, NULL},
+			{ -1, NULL},
+		},
+		.check_wx = true,
+	};
+
+	walk_pgd(&st, &init_mm, 0);
+	note_page(&st, 0, 0, 0, NULL);
+	if (st.wx_pages)
+		pr_warn("Checked W+X mappings: FAILED, %lu W+X pages found\n",
+			st.wx_pages);
+	else
+		pr_info("Checked W+X mappings: passed, no W+X pages found\n");
+}
+
 static int ptdump_init(void)
 {
 	ptdump_initialize();
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index a1f11a7..bd6f451 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -36,6 +36,7 @@
 #include <asm/system_info.h>
 #include <asm/tlb.h>
 #include <asm/fixmap.h>
+#include <asm/ptdump.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -738,6 +739,7 @@ static int __mark_rodata_ro(void *unused)
 void mark_rodata_ro(void)
 {
 	stop_machine(__mark_rodata_ro, NULL, NULL);
+	debug_checkwx();
 }
 
 void set_kernel_text_rw(void)
-- 
1.9.1
