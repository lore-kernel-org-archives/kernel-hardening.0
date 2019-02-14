From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: [RFC PATCH v8 05/14] arm64/mm: Add support for XPFO
Date: Wed, 13 Feb 2019 17:01:28 -0700
Message-Id: <4a7b373b438d5b93999349c648189bd5ba8f9198.1550088114.git.khalid.aziz@oracle.com>
In-Reply-To: <cover.1550088114.git.khalid.aziz@oracle.com>
References: <cover.1550088114.git.khalid.aziz@oracle.com>
In-Reply-To: <cover.1550088114.git.khalid.aziz@oracle.com>
References: <cover.1550088114.git.khalid.aziz@oracle.com>
To: juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, akpm@linux-foundation.org, mhocko@suse.com, catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org, konrad.wilk@oracle.com
Cc: Juerg Haefliger <juerg.haefliger@canonical.com>, deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, oao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, dave.hansen@intel.com, peterz@infradead.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Tycho Andersen <tycho@docker.com>, Khalid Aziz <khalid.aziz@oracle.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Juerg Haefliger <juerg.haefliger@canonical.com>

Enable support for eXclusive Page Frame Ownership (XPFO) for arm64 and
provide a hook for updating a single kernel page table entry (which is
required by the generic XPFO code).

CC: linux-arm-kernel@lists.infradead.org
Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
Signed-off-by: Tycho Andersen <tycho@docker.com>
Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
---
v6:
	- use flush_tlb_kernel_range() instead of __flush_tlb_one()

v8:
	- Add check for NULL pte in set_kpte()

 arch/arm64/Kconfig     |  1 +
 arch/arm64/mm/Makefile |  2 ++
 arch/arm64/mm/xpfo.c   | 64 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+)
 create mode 100644 arch/arm64/mm/xpfo.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ea2ab0330e3a..f0a9c0007d23 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -171,6 +171,7 @@ config ARM64
 	select SWIOTLB
 	select SYSCTL_EXCEPTION_TRACE
 	select THREAD_INFO_IN_TASK
+	select ARCH_SUPPORTS_XPFO
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
diff --git a/arch/arm64/mm/Makefile b/arch/arm64/mm/Makefile
index 849c1df3d214..cca3808d9776 100644
--- a/arch/arm64/mm/Makefile
+++ b/arch/arm64/mm/Makefile
@@ -12,3 +12,5 @@ KASAN_SANITIZE_physaddr.o	+= n
 
 obj-$(CONFIG_KASAN)		+= kasan_init.o
 KASAN_SANITIZE_kasan_init.o	:= n
+
+obj-$(CONFIG_XPFO)		+= xpfo.o
diff --git a/arch/arm64/mm/xpfo.c b/arch/arm64/mm/xpfo.c
new file mode 100644
index 000000000000..1f790f7746ad
--- /dev/null
+++ b/arch/arm64/mm/xpfo.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2017 Hewlett Packard Enterprise Development, L.P.
+ * Copyright (C) 2016 Brown University. All rights reserved.
+ *
+ * Authors:
+ *   Juerg Haefliger <juerg.haefliger@hpe.com>
+ *   Vasileios P. Kemerlis <vpk@cs.brown.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/mm.h>
+#include <linux/module.h>
+
+#include <asm/tlbflush.h>
+
+/*
+ * Lookup the page table entry for a virtual address and return a pointer to
+ * the entry. Based on x86 tree.
+ */
+static pte_t *lookup_address(unsigned long addr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	pgd = pgd_offset_k(addr);
+	if (pgd_none(*pgd))
+		return NULL;
+
+	pud = pud_offset(pgd, addr);
+	if (pud_none(*pud))
+		return NULL;
+
+	pmd = pmd_offset(pud, addr);
+	if (pmd_none(*pmd))
+		return NULL;
+
+	return pte_offset_kernel(pmd, addr);
+}
+
+/* Update a single kernel page table entry */
+inline void set_kpte(void *kaddr, struct page *page, pgprot_t prot)
+{
+	pte_t *pte = lookup_address((unsigned long)kaddr);
+
+	if (unlikely(!pte)) {
+		WARN(1, "xpfo: invalid address %p\n", kaddr);
+		return;
+	}
+
+	set_pte(pte, pfn_pte(page_to_pfn(page), prot));
+}
+
+inline void xpfo_flush_kernel_tlb(struct page *page, int order)
+{
+	unsigned long kaddr = (unsigned long)page_address(page);
+	unsigned long size = PAGE_SIZE;
+
+	flush_tlb_kernel_range(kaddr, kaddr + (1 << order) * size);
+}
-- 
2.17.1
