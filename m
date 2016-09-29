Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@redhat.com>
Date: Thu, 29 Sep 2016 14:32:55 -0700
Message-Id: <20160929213257.30505-2-labbott@redhat.com>
In-Reply-To: <20160929213257.30505-1-labbott@redhat.com>
References: <20160929213257.30505-1-labbott@redhat.com>
Subject: [kernel-hardening] [PATCH 1/3] arm64: dump: Make ptdump debugfs a separate option
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Laura Abbott <labbott@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

ptdump_register currently initializes a set of page table information and
registers debugfs. There are uses for the ptdump option without wanting the
debugfs options. Split this out to make it a separate option.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 arch/arm64/Kconfig.debug        |  6 +++++-
 arch/arm64/include/asm/ptdump.h | 15 +++++++++++++--
 arch/arm64/mm/Makefile          |  3 ++-
 arch/arm64/mm/dump.c            | 30 +++++++++---------------------
 arch/arm64/mm/ptdump_debugfs.c  | 33 +++++++++++++++++++++++++++++++++
 5 files changed, 62 insertions(+), 25 deletions(-)
 create mode 100644 arch/arm64/mm/ptdump_debugfs.c

diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 0cc758c..9015f02 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -2,9 +2,13 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config ARM64_PTDUMP
+config ARM64_PTDUMP_CORE
+	def_bool n
+
+config ARM64_PTDUMP_DEBUGFS
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
+	select ARM64_PTDUMP_CORE
 	select DEBUG_FS
         help
 	  Say Y here if you want to show the kernel pagetable layout in a
diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index 07b8ed0..b18a62c 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -16,8 +16,9 @@
 #ifndef __ASM_PTDUMP_H
 #define __ASM_PTDUMP_H
 
-#ifdef CONFIG_ARM64_PTDUMP
+#ifdef CONFIG_ARM64_PTDUMP_CORE
 
+#include <linux/seq_file.h>
 #include <linux/mm_types.h>
 
 struct addr_marker {
@@ -33,12 +34,22 @@ struct ptdump_info {
 };
 
 int ptdump_register(struct ptdump_info *info, const char *name);
+void ptdump_walk_pgd(struct seq_file *s, struct ptdump_info *info);
+#ifdef CONFIG_ARM64_PTDUMP_DEBUGFS
+int ptdump_debugfs_create(struct ptdump_info *info, const char *name);
+#else
+static inline int ptdump_debugfs_create(struct ptdump_info *info,
+					const char *name)
+{
+	return 0;
+}
+#endif
 
 #else
 static inline int ptdump_register(struct ptdump_info *info, const char *name)
 {
 	return 0;
 }
-#endif /* CONFIG_ARM64_PTDUMP */
+#endif /* CONFIG_ARM64_PTDUMP_CORE */
 
 #endif /* __ASM_PTDUMP_H */
diff --git a/arch/arm64/mm/Makefile b/arch/arm64/mm/Makefile
index 54bb209..e703fb9 100644
--- a/arch/arm64/mm/Makefile
+++ b/arch/arm64/mm/Makefile
@@ -3,7 +3,8 @@ obj-y				:= dma-mapping.o extable.o fault.o init.o \
 				   ioremap.o mmap.o pgd.o mmu.o \
 				   context.o proc.o pageattr.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
-obj-$(CONFIG_ARM64_PTDUMP)	+= dump.o
+obj-$(CONFIG_ARM64_PTDUMP_CORE)	+= dump.o
+obj-$(CONFIG_ARM64_PTDUMP_DEBUGFS)	+= ptdump_debugfs.o
 obj-$(CONFIG_NUMA)		+= numa.o
 
 obj-$(CONFIG_KASAN)		+= kasan_init.o
diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
index 9c3e75d..29e0838 100644
--- a/arch/arm64/mm/dump.c
+++ b/arch/arm64/mm/dump.c
@@ -286,7 +286,7 @@ static void walk_pud(struct pg_state *st, pgd_t *pgd, unsigned long start)
 	}
 }
 
-static void walk_pgd(struct pg_state *st, struct mm_struct *mm,
+static void __walk_pgd(struct pg_state *st, struct mm_struct *mm,
 		     unsigned long start)
 {
 	pgd_t *pgd = pgd_offset(mm, 0UL);
@@ -304,44 +304,32 @@ static void walk_pgd(struct pg_state *st, struct mm_struct *mm,
 	}
 }
 
-static int ptdump_show(struct seq_file *m, void *v)
+void ptdump_walk_pgd(struct seq_file *m, struct ptdump_info *info)
 {
-	struct ptdump_info *info = m->private;
 	struct pg_state st = {
 		.seq = m,
 		.marker = info->markers,
 	};
 
-	walk_pgd(&st, info->mm, info->base_addr);
+	__walk_pgd(&st, info->mm, info->base_addr);
 
 	note_page(&st, 0, 0, 0);
-	return 0;
 }
 
-static int ptdump_open(struct inode *inode, struct file *file)
+static void ptdump_initialize(struct ptdump_info *info)
 {
-	return single_open(file, ptdump_show, inode->i_private);
-}
-
-static const struct file_operations ptdump_fops = {
-	.open		= ptdump_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-int ptdump_register(struct ptdump_info *info, const char *name)
-{
-	struct dentry *pe;
 	unsigned i, j;
 
 	for (i = 0; i < ARRAY_SIZE(pg_level); i++)
 		if (pg_level[i].bits)
 			for (j = 0; j < pg_level[i].num; j++)
 				pg_level[i].mask |= pg_level[i].bits[j].mask;
+}
 
-	pe = debugfs_create_file(name, 0400, NULL, info, &ptdump_fops);
-	return pe ? 0 : -ENOMEM;
+int ptdump_register(struct ptdump_info *info, const char *name)
+{
+	ptdump_initialize(info);
+	return ptdump_debugfs_create(info, name);
 }
 
 static struct ptdump_info kernel_ptdump_info = {
diff --git a/arch/arm64/mm/ptdump_debugfs.c b/arch/arm64/mm/ptdump_debugfs.c
new file mode 100644
index 0000000..03e161f
--- /dev/null
+++ b/arch/arm64/mm/ptdump_debugfs.c
@@ -0,0 +1,33 @@
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#include <asm/ptdump.h>
+
+static int ptdump_show(struct seq_file *m, void *v)
+{
+	struct ptdump_info *info = m->private;
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
+int ptdump_debugfs_create(struct ptdump_info *info, const char *name)
+{
+	struct dentry *pe;
+	pe = debugfs_create_file(name, 0400, NULL, info, &ptdump_fops);
+	return pe ? 0 : -ENOMEM;
+
+}
+
+
-- 
2.10.0
