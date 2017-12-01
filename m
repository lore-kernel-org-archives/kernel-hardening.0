Date: Fri, 1 Dec 2017 20:33:15 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Message-ID: <20171201113315.GA5190@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening][PATCH v2 1/3] arm: mm: dump: make page table
 dumping reusable
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: afzal.mohd.ma@gmail.com, mark.rutland@arm.com, labbott@redhat.com, linux@armlinux.org.uk, gregkh@linuxfoundation.org, keescook@chromium.org, vladimir.murzin@arm.com, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

This patch refactors the arm page table dumping code,
so multiple tables may be registered with the framework.

This patch refers below commits of arm64.
(4674fdb9f149 ("arm64: mm: dump: make page table dumping reusable"))
(4ddb9bf83349 ("arm64: dump: Make ptdump debugfs a separate option"))

Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
---
 arch/arm/Kconfig.debug        |  6 +++-
 arch/arm/include/asm/ptdump.h | 48 ++++++++++++++++++++++++++++++++
 arch/arm/mm/Makefile          |  3 +-
 arch/arm/mm/dump.c            | 65 +++++++++++++++++++------------------------
 arch/arm/mm/ptdump_debugfs.c  | 34 ++++++++++++++++++++++
 5 files changed, 117 insertions(+), 39 deletions(-)
 create mode 100644 arch/arm/include/asm/ptdump.h
 create mode 100644 arch/arm/mm/ptdump_debugfs.c

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 17685e1..e7b94db 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -3,10 +3,14 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config ARM_PTDUMP
+config ARM_PTDUMP_CORE
+	def_bool n
+
+config ARM_PTDUMP_DEBUGFS
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
 	depends on MMU
+	select ARM_PTDUMP_CORE
 	select DEBUG_FS
 	---help---
 	  Say Y here if you want to show the kernel pagetable layout in a
diff --git a/arch/arm/include/asm/ptdump.h b/arch/arm/include/asm/ptdump.h
new file mode 100644
index 0000000..3a6c0b7
--- /dev/null
+++ b/arch/arm/include/asm/ptdump.h
@@ -0,0 +1,48 @@
+/*
+ * Copyright (C) 2014 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PTDUMP_H
+#define __ASM_PTDUMP_H
+
+#ifdef CONFIG_ARM_PTDUMP_CORE
+
+#include <linux/mm_types.h>
+#include <linux/seq_file.h>
+
+struct addr_marker {
+	unsigned long start_address;
+	char *name;
+};
+
+struct ptdump_info {
+	struct mm_struct		*mm;
+	const struct addr_marker	*markers;
+	unsigned long			base_addr;
+};
+
+void ptdump_walk_pgd(struct seq_file *s, struct ptdump_info *info);
+#ifdef CONFIG_ARM_PTDUMP_DEBUGFS
+int ptdump_debugfs_register(struct ptdump_info *info, const char *name);
+#else
+static inline int ptdump_debugfs_register(struct ptdump_info *info,
+					const char *name)
+{
+	return 0;
+}
+#endif /* CONFIG_ARM_PTDUMP_DEBUGFS */
+
+#endif /* CONFIG_ARM_PTDUMP_CORE */
+
+#endif /* __ASM_PTDUMP_H */
diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
index 01bcc33..28be5f4 100644
--- a/arch/arm/mm/Makefile
+++ b/arch/arm/mm/Makefile
@@ -13,7 +13,8 @@ obj-y				+= nommu.o
 obj-$(CONFIG_ARM_MPU)		+= pmsa-v7.o
 endif
 
-obj-$(CONFIG_ARM_PTDUMP)	+= dump.o
+obj-$(CONFIG_ARM_PTDUMP_CORE)	+= dump.o
+obj-$(CONFIG_ARM_PTDUMP_DEBUGFS)	+= ptdump_debugfs.o
 obj-$(CONFIG_MODULES)		+= proc-syms.o
 obj-$(CONFIG_DEBUG_VIRTUAL)	+= physaddr.o
 
diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
index fc3b440..8dfe7c3 100644
--- a/arch/arm/mm/dump.c
+++ b/arch/arm/mm/dump.c
@@ -21,11 +21,7 @@
 #include <asm/fixmap.h>
 #include <asm/memory.h>
 #include <asm/pgtable.h>
-
-struct addr_marker {
-	unsigned long start_address;
-	const char *name;
-};
+#include <asm/ptdump.h>
 
 static struct addr_marker address_markers[] = {
 	{ MODULES_VADDR,	"Modules" },
@@ -335,50 +331,36 @@ static void walk_pud(struct pg_state *st, pgd_t *pgd, unsigned long start)
 	}
 }
 
-static void walk_pgd(struct seq_file *m)
+static void walk_pgd(struct pg_state *st, struct mm_struct *mm,
+			unsigned long start)
 {
-	pgd_t *pgd = swapper_pg_dir;
-	struct pg_state st;
-	unsigned long addr;
+	pgd_t *pgd = pgd_offset(mm, 0UL);
 	unsigned i;
-
-	memset(&st, 0, sizeof(st));
-	st.seq = m;
-	st.marker = address_markers;
+	unsigned long addr;
 
 	for (i = 0; i < PTRS_PER_PGD; i++, pgd++) {
-		addr = i * PGDIR_SIZE;
+		addr = start + i * PGDIR_SIZE;
 		if (!pgd_none(*pgd)) {
-			walk_pud(&st, pgd, addr);
+			walk_pud(st, pgd, addr);
 		} else {
-			note_page(&st, addr, 1, pgd_val(*pgd), NULL);
+			note_page(st, addr, 1, pgd_val(*pgd), NULL);
 		}
 	}
-
-	note_page(&st, 0, 0, 0, NULL);
 }
 
-static int ptdump_show(struct seq_file *m, void *v)
+void ptdump_walk_pgd(struct seq_file *m, struct ptdump_info *info)
 {
-	walk_pgd(m);
-	return 0;
-}
+	struct pg_state st = {
+		.seq = m,
+		.marker = info->markers,
+	};
 
-static int ptdump_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ptdump_show, NULL);
+	walk_pgd(&st, info->mm, info->base_addr);
+	note_page(&st, 0, 0, 0, NULL);
 }
 
-static const struct file_operations ptdump_fops = {
-	.open		= ptdump_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int ptdump_init(void)
+static void ptdump_initialize(void)
 {
-	struct dentry *pe;
 	unsigned i, j;
 
 	for (i = 0; i < ARRAY_SIZE(pg_level); i++)
@@ -387,9 +369,18 @@ static int ptdump_init(void)
 				pg_level[i].mask |= pg_level[i].bits[j].mask;
 
 	address_markers[2].start_address = VMALLOC_START;
+}
 
-	pe = debugfs_create_file("kernel_page_tables", 0400, NULL, NULL,
-				 &ptdump_fops);
-	return pe ? 0 : -ENOMEM;
+static struct ptdump_info kernel_ptdump_info = {
+	.mm = &init_mm,
+	.markers = address_markers,
+	.base_addr = 0,
+};
+
+static int ptdump_init(void)
+{
+	ptdump_initialize();
+	return ptdump_debugfs_register(&kernel_ptdump_info,
+					"kernel_page_tables");
 }
 __initcall(ptdump_init);
diff --git a/arch/arm/mm/ptdump_debugfs.c b/arch/arm/mm/ptdump_debugfs.c
new file mode 100644
index 0000000..be8d87b
--- /dev/null
+++ b/arch/arm/mm/ptdump_debugfs.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#include <asm/ptdump.h>
+
+static int ptdump_show(struct seq_file *m, void *v)
+{
+	struct ptdump_info *info = m->private;
+
+	ptdump_walk_pgd(m, info);
+	return 0;
+}
+
+static int ptdump_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ptdump_show, inode->i_private);
+}
+
+static const struct file_operations ptdump_fops = {
+	.open		= ptdump_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+int ptdump_debugfs_register(struct ptdump_info *info, const char *name)
+{
+	struct dentry *pe;
+
+	pe = debugfs_create_file(name, 0400, NULL, info, &ptdump_fops);
+	return pe ? 0 : -ENOMEM;
+
+}
-- 
1.9.1
