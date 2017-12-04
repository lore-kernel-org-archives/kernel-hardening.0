Date: Mon, 4 Dec 2017 23:27:09 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Message-ID: <20171204142709.GA3376@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening][PATCH v3 3/3] arm: mm: dump: add checking for
 writable and executable pages
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: afzal.mohd.ma@gmail.com, mark.rutland@arm.com, labbott@redhat.com, linux@armlinux.org.uk, gregkh@linuxfoundation.org, keescook@chromium.org, vladimir.murzin@arm.com, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

Page mappings with full RWX permissions are a security risk.
x86, arm64 has an option to walk the page tables
and dump any bad pages.

(1404d6f13e47
("arm64: dump: Add checking for writable and exectuable pages"))
Add a similar implementation for arm.

Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
---
v3: Reuse pg_level, prot_bits to check ro, nx prot.

 arch/arm/Kconfig.debug        | 27 +++++++++++++++++++++++
 arch/arm/include/asm/ptdump.h |  8 +++++++
 arch/arm/mm/dump.c            | 51 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mm/init.c            |  2 ++
 4 files changed, 88 insertions(+)

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
index 3a6c0b7..b6a0162 100644
--- a/arch/arm/include/asm/ptdump.h
+++ b/arch/arm/include/asm/ptdump.h
@@ -43,6 +43,14 @@ static inline int ptdump_debugfs_register(struct ptdump_info *info,
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
index 43a2bee..3e2e6f0 100644
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
 
@@ -194,6 +196,8 @@ struct pg_level {
 	const struct prot_bits *bits;
 	size_t num;
 	u64 mask;
+	const struct prot_bits *ro_bit;
+	const struct prot_bits *nx_bit;
 };
 
 static struct pg_level pg_level[] = {
@@ -203,9 +207,17 @@ struct pg_level {
 	}, { /* pmd */
 		.bits	= section_bits,
 		.num	= ARRAY_SIZE(section_bits),
+	#ifdef CONFIG_ARM_LPAE
+		.ro_bit	= section_bits + 1,
+	#else
+		.ro_bit = section_bits,
+	#endif
+		.nx_bit	= section_bits + ARRAY_SIZE(section_bits) - 2,
 	}, { /* pte */
 		.bits	= pte_bits,
 		.num	= ARRAY_SIZE(pte_bits),
+		.ro_bit	= pte_bits + 1,
+		.nx_bit	= pte_bits + 2,
 	},
 };
 
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
+	WARN_ONCE(1, "arm/mm: Found insecure W+X mapping at address %p/%pS\n",
+		(void *)st->start_address, (void *)st->start_address);
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
@@ -391,6 +422,26 @@ static void ptdump_initialize(void)
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
