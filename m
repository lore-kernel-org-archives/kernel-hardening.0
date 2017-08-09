From: Tycho Andersen <tycho@docker.com>
Date: Wed,  9 Aug 2017 14:07:46 -0600
Message-Id: <20170809200755.11234-2-tycho@docker.com>
In-Reply-To: <20170809200755.11234-1-tycho@docker.com>
References: <20170809200755.11234-1-tycho@docker.com>
Subject: [kernel-hardening] [PATCH v5 01/10] mm: add MAP_HUGETLB support to vm_mmap
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

vm_mmap is exported, which means kernel modules can use it. In particular,
for testing XPFO support, we want to use it with the MAP_HUGETLB flag, so
let's support it via vm_mmap.

Signed-off-by: Tycho Andersen <tycho@docker.com>
Tested-by: Marco Benatto <marco.antonio.780@gmail.com>
---
 include/linux/mm.h |  2 ++
 mm/mmap.c          | 19 +------------------
 mm/util.c          | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 46b9ac5e8569..e3bce22fe0f7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2140,6 +2140,8 @@ struct vm_unmapped_area_info {
 extern unsigned long unmapped_area(struct vm_unmapped_area_info *info);
 extern unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info);
 
+struct file *map_hugetlb_setup(unsigned long *len, unsigned long flags);
+
 /*
  * Search for an unmapped address range.
  *
diff --git a/mm/mmap.c b/mm/mmap.c
index f19efcf75418..f24fc14808e1 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1490,24 +1490,7 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 		if (unlikely(flags & MAP_HUGETLB && !is_file_hugepages(file)))
 			goto out_fput;
 	} else if (flags & MAP_HUGETLB) {
-		struct user_struct *user = NULL;
-		struct hstate *hs;
-
-		hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
-		if (!hs)
-			return -EINVAL;
-
-		len = ALIGN(len, huge_page_size(hs));
-		/*
-		 * VM_NORESERVE is used because the reservations will be
-		 * taken when vm_ops->mmap() is called
-		 * A dummy user value is used because we are not locking
-		 * memory so no accounting is necessary
-		 */
-		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len,
-				VM_NORESERVE,
-				&user, HUGETLB_ANONHUGE_INODE,
-				(flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
+		file = map_hugetlb_setup(&len, flags);
 		if (IS_ERR(file))
 			return PTR_ERR(file);
 	}
diff --git a/mm/util.c b/mm/util.c
index 7b07ec852e01..aac2c58d6f52 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -340,6 +340,29 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 	return ret;
 }
 
+struct file *map_hugetlb_setup(unsigned long *len, unsigned long flags)
+{
+	struct user_struct *user = NULL;
+	struct hstate *hs;
+
+	hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
+	if (!hs)
+		return ERR_PTR(-EINVAL);
+
+	*len = ALIGN(*len, huge_page_size(hs));
+
+	/*
+	 * VM_NORESERVE is used because the reservations will be
+	 * taken when vm_ops->mmap() is called
+	 * A dummy user value is used because we are not locking
+	 * memory so no accounting is necessary
+	 */
+	return hugetlb_file_setup(HUGETLB_ANON_FILE, *len,
+			VM_NORESERVE,
+			&user, HUGETLB_ANONHUGE_INODE,
+			(flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
+}
+
 unsigned long vm_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
 	unsigned long flag, unsigned long offset)
@@ -349,6 +372,15 @@ unsigned long vm_mmap(struct file *file, unsigned long addr,
 	if (unlikely(offset_in_page(offset)))
 		return -EINVAL;
 
+	if (flag & MAP_HUGETLB) {
+		if (file)
+			return -EINVAL;
+
+		file = map_hugetlb_setup(&len, flag);
+		if (IS_ERR(file))
+			return PTR_ERR(file);
+	}
+
 	return vm_mmap_pgoff(file, addr, len, prot, flag, offset >> PAGE_SHIFT);
 }
 EXPORT_SYMBOL(vm_mmap);
-- 
2.11.0
