Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@redhat.com>
Date: Thu, 27 Oct 2016 09:27:31 -0700
Message-Id: <1477585654-8908-2-git-send-email-labbott@redhat.com>
In-Reply-To: <1477585654-8908-1-git-send-email-labbott@redhat.com>
References: <1477585654-8908-1-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] [PATCHv4 1/4] arm64: dump: Make ptdump debugfs a separate option
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Laura Abbott <labbott@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Matt Fleming <matt@codeblueprint.co.uk>, linux-efi@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


ptdump_register currently initializes a set of page table information and
registers debugfs. There are uses for the ptdump option without wanting the
debugfs options. Split this out to make it a separate option.

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
v4: Reviewed-by from Ard
---
 arch/arm64/Kconfig.debug           |  6 +++++-
 arch/arm64/include/asm/ptdump.h    | 15 +++++++++------
 arch/arm64/mm/Makefile             |  3 ++-
 arch/arm64/mm/dump.c               | 26 +++++---------------------
 arch/arm64/mm/ptdump_debugfs.c     | 31 +++++++++++++++++++++++++++++++
 drivers/firmware/efi/arm-runtime.c |  4 ++--
 6 files changed, 54 insertions(+), 31 deletions(-)
 create mode 100644 arch/arm64/mm/ptdump_debugfs.c

diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index b661fe7..21a5b74 100644
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
index 07b8ed0..16335da 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -16,9 +16,10 @@
 #ifndef __ASM_PTDUMP_H
 #define __ASM_PTDUMP_H
 
-#ifdef CONFIG_ARM64_PTDUMP
+#ifdef CONFIG_ARM64_PTDUMP_CORE
 
 #include <linux/mm_types.h>
+#include <linux/seq_file.h>
 
 struct addr_marker {
 	unsigned long start_address;
@@ -32,13 +33,15 @@ struct ptdump_info {
 	unsigned long			max_addr;
 };
 
-int ptdump_register(struct ptdump_info *info, const char *name);
-
+void ptdump_walk_pgd(struct seq_file *s, struct ptdump_info *info);
+#ifdef CONFIG_ARM64_PTDUMP_DEBUGFS
+int ptdump_debugfs_register(struct ptdump_info *info, const char *name);
 #else
-static inline int ptdump_register(struct ptdump_info *info, const char *name)
+static inline int ptdump_debugfs_register(struct ptdump_info *info,
+					const char *name)
 {
 	return 0;
 }
-#endif /* CONFIG_ARM64_PTDUMP */
-
+#endif
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
index 9c3e75d..f0f0be7 100644
--- a/arch/arm64/mm/dump.c
+++ b/arch/arm64/mm/dump.c
@@ -304,9 +304,8 @@ static void walk_pgd(struct pg_state *st, struct mm_struct *mm,
 	}
 }
 
-static int ptdump_show(struct seq_file *m, void *v)
+void ptdump_walk_pgd(struct seq_file *m, struct ptdump_info *info)
 {
-	struct ptdump_info *info = m->private;
 	struct pg_state st = {
 		.seq = m,
 		.marker = info->markers,
@@ -315,33 +314,16 @@ static int ptdump_show(struct seq_file *m, void *v)
 	walk_pgd(&st, info->mm, info->base_addr);
 
 	note_page(&st, 0, 0, 0);
-	return 0;
 }
 
-static int ptdump_open(struct inode *inode, struct file *file)
+static void ptdump_initialize(void)
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
-
-	pe = debugfs_create_file(name, 0400, NULL, info, &ptdump_fops);
-	return pe ? 0 : -ENOMEM;
 }
 
 static struct ptdump_info kernel_ptdump_info = {
@@ -352,6 +334,8 @@ static struct ptdump_info kernel_ptdump_info = {
 
 static int ptdump_init(void)
 {
-	return ptdump_register(&kernel_ptdump_info, "kernel_page_tables");
+	ptdump_initialize();
+	return ptdump_debugfs_register(&kernel_ptdump_info,
+					"kernel_page_tables");
 }
 device_initcall(ptdump_init);
diff --git a/arch/arm64/mm/ptdump_debugfs.c b/arch/arm64/mm/ptdump_debugfs.c
new file mode 100644
index 0000000..eee4d86
--- /dev/null
+++ b/arch/arm64/mm/ptdump_debugfs.c
@@ -0,0 +1,31 @@
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
+int ptdump_debugfs_register(struct ptdump_info *info, const char *name)
+{
+	struct dentry *pe;
+	pe = debugfs_create_file(name, 0400, NULL, info, &ptdump_fops);
+	return pe ? 0 : -ENOMEM;
+
+}
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 7c75a8d..349dc3e 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -39,7 +39,7 @@ static struct mm_struct efi_mm = {
 	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
 };
 
-#ifdef CONFIG_ARM64_PTDUMP
+#ifdef CONFIG_ARM64_PTDUMP_DEBUGFS
 #include <asm/ptdump.h>
 
 static struct ptdump_info efi_ptdump_info = {
@@ -53,7 +53,7 @@ static struct ptdump_info efi_ptdump_info = {
 
 static int __init ptdump_init(void)
 {
-	return ptdump_register(&efi_ptdump_info, "efi_page_tables");
+	return ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
 }
 device_initcall(ptdump_init);
 
-- 
2.7.4
