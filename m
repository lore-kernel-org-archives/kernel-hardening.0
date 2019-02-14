From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: [RFC PATCH v8 13/14] xpfo, mm: Defer TLB flushes for non-current CPUs (x86 only)
Date: Wed, 13 Feb 2019 17:01:36 -0700
Message-Id: <98134cb73e911b2f0b59ffb76243a7777963d218.1550088114.git.khalid.aziz@oracle.com>
In-Reply-To: <cover.1550088114.git.khalid.aziz@oracle.com>
References: <cover.1550088114.git.khalid.aziz@oracle.com>
In-Reply-To: <cover.1550088114.git.khalid.aziz@oracle.com>
References: <cover.1550088114.git.khalid.aziz@oracle.com>
To: juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, akpm@linux-foundation.org, mhocko@suse.com, catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org, konrad.wilk@oracle.com
Cc: Khalid Aziz <khalid.aziz@oracle.com>, deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, oao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, dave.hansen@intel.com, peterz@infradead.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

XPFO flushes kernel space TLB entries for pages that are now mapped
in userspace on not only the current CPU but also all other CPUs
synchronously. Processes on each core allocating pages causes a
flood of IPI messages to all other cores to flush TLB entries.
Many of these messages are to flush the entire TLB on the core if
the number of entries being flushed from local core exceeds
tlb_single_page_flush_ceiling. The cost of TLB flush caused by
unmapping pages from physmap goes up dramatically on machines with
high core count.

This patch flushes relevant TLB entries for current process or
entire TLB depending upon number of entries for the current CPU
and posts a pending TLB flush on all other CPUs when a page is
unmapped from kernel space and mapped in userspace. Each core
checks the pending TLB flush flag for itself on every context
switch, flushes its TLB if the flag is set and clears it.
This patch potentially aggregates multiple TLB flushes into one.
This has very significant impact especially on machines with large
core counts. To illustrate this, kernel was compiled with -j on
two classes of machines - a server with high core count and large
amount of memory, and a desktop class machine with more modest
specs. System time from "make -j" from vanilla 4.20 kernel, 4.20
with XPFO patches before applying this patch and after applying
this patch are below:

Hardware: 96-core Intel Xeon Platinum 8160 CPU @ 2.10GHz, 768 GB RAM
make -j60 all

4.20                            950.966s
4.20+XPFO                       25073.169s      26.366x
4.20+XPFO+Deferred flush        1372.874s        1.44x

Hardware: 4-core Intel Core i5-3550 CPU @ 3.30GHz, 8G RAM
make -j4 all

4.20                            607.671s
4.20+XPFO                       1588.646s       2.614x
4.20+XPFO+Deferred flush        803.989s        1.32x

This patch could use more optimization. Batching more TLB entry
flushes, as was suggested for earlier version of these patches,
can help reduce these cases. This same code should be implemented
for other architectures as well once finalized.

Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
---
 arch/x86/include/asm/tlbflush.h |  1 +
 arch/x86/mm/tlb.c               | 38 +++++++++++++++++++++++++++++++++
 arch/x86/mm/xpfo.c              |  2 +-
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index f4204bf377fc..92d23629d01d 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -561,6 +561,7 @@ extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned int stride_shift,
 				bool freed_tables);
 extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
+extern void xpfo_flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
 static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)
 {
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 03b6b4c2238d..c907b643eecb 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -35,6 +35,15 @@
  */
 #define LAST_USER_MM_IBPB	0x1UL
 
+/*
+ * When a full TLB flush is needed to flush stale TLB entries
+ * for pages that have been mapped into userspace and unmapped
+ * from kernel space, this TLB flush will be delayed until the
+ * task is scheduled on that CPU. Keep track of CPUs with
+ * pending full TLB flush forced by xpfo.
+ */
+static cpumask_t pending_xpfo_flush;
+
 /*
  * We get here when we do something requiring a TLB invalidation
  * but could not go invalidate all of the contexts.  We do the
@@ -319,6 +328,15 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 		__flush_tlb_all();
 	}
 #endif
+
+	/* If there is a pending TLB flush for this CPU due to XPFO
+	 * flush, do it now.
+	 */
+	if (cpumask_test_and_clear_cpu(cpu, &pending_xpfo_flush)) {
+		count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
+		__flush_tlb_all();
+	}
+
 	this_cpu_write(cpu_tlbstate.is_lazy, false);
 
 	/*
@@ -801,6 +819,26 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 	}
 }
 
+void xpfo_flush_tlb_kernel_range(unsigned long start, unsigned long end)
+{
+	struct cpumask tmp_mask;
+
+	/* Balance as user space task's flush, a bit conservative */
+	if (end == TLB_FLUSH_ALL ||
+	    (end - start) > tlb_single_page_flush_ceiling << PAGE_SHIFT) {
+		do_flush_tlb_all(NULL);
+	} else {
+		struct flush_tlb_info info;
+
+		info.start = start;
+		info.end = end;
+		do_kernel_range_flush(&info);
+	}
+	cpumask_setall(&tmp_mask);
+	cpumask_clear_cpu(smp_processor_id(), &tmp_mask);
+	cpumask_or(&pending_xpfo_flush, &pending_xpfo_flush, &tmp_mask);
+}
+
 void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 {
 	struct flush_tlb_info info = {
diff --git a/arch/x86/mm/xpfo.c b/arch/x86/mm/xpfo.c
index e13b99019c47..d3833532bfdc 100644
--- a/arch/x86/mm/xpfo.c
+++ b/arch/x86/mm/xpfo.c
@@ -115,7 +115,7 @@ inline void xpfo_flush_kernel_tlb(struct page *page, int order)
 		return;
 	}
 
-	flush_tlb_kernel_range(kaddr, kaddr + (1 << order) * size);
+	xpfo_flush_tlb_kernel_range(kaddr, kaddr + (1 << order) * size);
 }
 
 /* Convert a user space virtual address to a physical address.
-- 
2.17.1
