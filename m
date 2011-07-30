Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 30 Jul 2011 22:38:30 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110730183830.GA4314@albatros>
References: <20110723162251.GA11485@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110723162251.GA11485@openwall.com>
Subject: Re: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

This is a patch, which should solve the problem.  Note that the default
base address allocation policy for the mainline is top-down, so
0x00110000 was not considered even in x86-32.  Now it should work for
both 32-bit systems and 32-bit tasks in 64-bit systems.

I used some code from Exec Shield part of RHEL6 patch.


Shortly:

By default the kernel calculates a random gap size (8 bits of entropy
for 32 bits and 28 for 64 bits) and skips this size from the top
addresses.  Then it merely fills the address space (top-down) with
libraries without any gaps between the libraries.

In Exec Shield the base address for each library is a random value from
0x00110000-0x01000000.  If it fails, a simple bottom-up algo is used,
whitout any gaps AND any random.  IMO it is weird as for some specific
library sequences the base addresses are somewhat guessable (I haven't
got strict numbers, though).

So, I've implemented an analog of upstream's top-down allocation algo,
but bottom-up, with the same gap (with the same entropy).


diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 1dab519..20d6085 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -131,6 +131,10 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 	} else {
 		mm->mmap_base = mmap_base();
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		if (mmap_is_ia32()) {
+			mm->get_unmapped_exec_area = arch_get_unmapped_exec_area;
+			mm->lib_mmap_base = 0x00110000 + mmap_rnd();
+		}
 		mm->unmap_area = arch_unmap_area_topdown;
 	}
 }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 027935c..5f2dca9 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -225,9 +225,13 @@ struct mm_struct {
 	unsigned long (*get_unmapped_area) (struct file *filp,
 				unsigned long addr, unsigned long len,
 				unsigned long pgoff, unsigned long flags);
+	unsigned long (*get_unmapped_exec_area) (struct file *filp,
+				unsigned long addr, unsigned long len,
+				unsigned long pgoff, unsigned long flags);
 	void (*unmap_area) (struct mm_struct *mm, unsigned long addr);
 #endif
 	unsigned long mmap_base;		/* base of mmap area */
+	unsigned long lib_mmap_base;		/* base of mmap libraries area (includes zero symbol) */
 	unsigned long task_size;		/* size of task vm space */
 	unsigned long cached_hole_size; 	/* if non-zero, the largest hole below free_area_cache */
 	unsigned long free_area_cache;		/* first hole of size cached_hole_size or larger */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f024c63..8feaba9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -394,6 +394,9 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 			  unsigned long flags);
 extern void arch_unmap_area(struct mm_struct *, unsigned long);
 extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
+extern unsigned long
+arch_get_unmapped_exec_area(struct file *, unsigned long,
+		unsigned long, unsigned long, unsigned long);
 #else
 static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
 #endif
diff --git a/mm/mmap.c b/mm/mmap.c
index d49736f..3e39165 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -50,6 +50,10 @@ static void unmap_region(struct mm_struct *mm,
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end);
 
+static unsigned long
+get_unmapped_area_prot(struct file *file, unsigned long addr, unsigned long len,
+		unsigned long pgoff, unsigned long flags, bool exec);
+
 /*
  * WARNING: the debugging will use recursive algorithms so never enable this
  * unless you know what you are doing.
@@ -989,7 +993,8 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	/* Obtain the address to map to. we verify (or select) it and ensure
 	 * that it represents a valid section of the address space.
 	 */
-	addr = get_unmapped_area(file, addr, len, pgoff, flags);
+	addr = get_unmapped_area_prot(file, addr, len, pgoff, flags,
+			prot & PROT_EXEC);
 	if (addr & ~PAGE_MASK)
 		return addr;
 
@@ -1528,6 +1533,49 @@ bottomup:
 }
 #endif
 
+unsigned long
+arch_get_unmapped_exec_area(struct file *filp, unsigned long addr0,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	unsigned long addr = addr0;
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+
+	if (len > TASK_SIZE)
+		return -ENOMEM;
+
+	if (flags & MAP_FIXED)
+		return addr;
+
+	pr_err("mmap (pid = %lu): addr = %p, len = %lu\n", (long)current->pid, (void *)addr, (long)len);
+
+	/* We ALWAYS start from the beginning as base addresses
+	 * with zero high bits is a valued resource */
+	addr = mm->lib_mmap_base;
+
+	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
+		/* At this point:  (!vma || addr < vma->vm_end). */
+		if (TASK_SIZE - len < addr)
+			return -ENOMEM;
+
+		/* We don't want to touch brk of not DYNAMIC elf binaries */
+		if (mm->brk && addr > mm->brk)
+			goto failed;
+
+		if (!vma || addr + len <= vma->vm_start) {
+			return addr;
+		}
+
+		addr = vma->vm_end;
+		/* If 0x01000000 is touched, the algo gives up */
+		if (addr >= 0x01000000)
+			goto failed;
+	}
+
+failed:
+	return current->mm->get_unmapped_area(filp, addr0, len, pgoff, flags);
+}
+
 void arch_unmap_area_topdown(struct mm_struct *mm, unsigned long addr)
 {
 	/*
@@ -1541,9 +1589,9 @@ void arch_unmap_area_topdown(struct mm_struct *mm, unsigned long addr)
 		mm->free_area_cache = mm->mmap_base;
 }
 
-unsigned long
-get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
-		unsigned long pgoff, unsigned long flags)
+static unsigned long
+get_unmapped_area_prot(struct file *file, unsigned long addr, unsigned long len,
+		unsigned long pgoff, unsigned long flags, bool exec)
 {
 	unsigned long (*get_area)(struct file *, unsigned long,
 				  unsigned long, unsigned long, unsigned long);
@@ -1556,7 +1604,11 @@ get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
-	get_area = current->mm->get_unmapped_area;
+	if (exec && current->mm->get_unmapped_exec_area)
+		get_area = current->mm->get_unmapped_exec_area;
+	else
+		get_area = current->mm->get_unmapped_area;
+
 	if (file && file->f_op && file->f_op->get_unmapped_area)
 		get_area = file->f_op->get_unmapped_area;
 	addr = get_area(file, addr, len, pgoff, flags);
@@ -1571,6 +1623,13 @@ get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 	return arch_rebalance_pgtables(addr, len);
 }
 
+unsigned long
+get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
+		unsigned long pgoff, unsigned long flags)
+{
+	return get_unmapped_area_prot(file, addr, len, pgoff, flags, false);
+}
+
 EXPORT_SYMBOL(get_unmapped_area);
 
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
--
