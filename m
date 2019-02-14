From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: [RFC PATCH v8 12/14] xpfo, mm: optimize spinlock usage in xpfo_kunmap
Date: Wed, 13 Feb 2019 17:01:35 -0700
Message-Id: <fb183dba421ad5cc1eda9acaf0678970bdf2159b.1550088114.git.khalid.aziz@oracle.com>
In-Reply-To: <cover.1550088114.git.khalid.aziz@oracle.com>
References: <cover.1550088114.git.khalid.aziz@oracle.com>
In-Reply-To: <cover.1550088114.git.khalid.aziz@oracle.com>
References: <cover.1550088114.git.khalid.aziz@oracle.com>
To: juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, akpm@linux-foundation.org, mhocko@suse.com, catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org, konrad.wilk@oracle.com
Cc: deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, oao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, dave.hansen@intel.com, peterz@infradead.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Khalid Aziz <khalid.aziz@oracle.com>, "Vasileios P . Kemerlis" <vpk@cs.columbia.edu>, Juerg Haefliger <juerg.haefliger@canonical.com>, Tycho Andersen <tycho@docker.com>, Marco Benatto <marco.antonio.780@gmail.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Julian Stecklina <jsteckli@amazon.de>

Only the xpfo_kunmap call that needs to actually unmap the page
needs to be serialized. We need to be careful to handle the case,
where after the atomic decrement of the mapcount, a xpfo_kmap
increased the mapcount again. In this case, we can safely skip
modifying the page table.

Model-checked with up to 4 concurrent callers with Spin.

Signed-off-by: Julian Stecklina <jsteckli@amazon.de>
Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
Cc: x86@kernel.org
Cc: kernel-hardening@lists.openwall.com
Cc: Vasileios P. Kemerlis <vpk@cs.columbia.edu>
Cc: Juerg Haefliger <juerg.haefliger@canonical.com>
Cc: Tycho Andersen <tycho@docker.com>
Cc: Marco Benatto <marco.antonio.780@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 mm/xpfo.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/mm/xpfo.c b/mm/xpfo.c
index dc03c423c52f..5157cbebce4b 100644
--- a/mm/xpfo.c
+++ b/mm/xpfo.c
@@ -124,28 +124,35 @@ EXPORT_SYMBOL(xpfo_kmap);
 
 void xpfo_kunmap(void *kaddr, struct page *page)
 {
+	bool flush_tlb = false;
+
 	if (!static_branch_unlikely(&xpfo_inited))
 		return;
 
 	if (!PageXpfoUser(page))
 		return;
 
-	spin_lock(&page->xpfo_lock);
-
 	/*
 	 * The page is to be allocated back to user space, so unmap it from the
 	 * kernel, flush the TLB and tag it as a user page.
 	 */
 	if (atomic_dec_return(&page->xpfo_mapcount) == 0) {
-#ifdef CONFIG_XPFO_DEBUG
-		BUG_ON(PageXpfoUnmapped(page));
-#endif
-		SetPageXpfoUnmapped(page);
-		set_kpte(kaddr, page, __pgprot(0));
-		xpfo_flush_kernel_tlb(page, 0);
+		spin_lock(&page->xpfo_lock);
+
+		/*
+		 * In the case, where we raced with kmap after the
+		 * atomic_dec_return, we must not nuke the mapping.
+		 */
+		if (atomic_read(&page->xpfo_mapcount) == 0) {
+			SetPageXpfoUnmapped(page);
+			set_kpte(kaddr, page, __pgprot(0));
+			flush_tlb = true;
+		}
+		spin_unlock(&page->xpfo_lock);
 	}
 
-	spin_unlock(&page->xpfo_lock);
+	if (flush_tlb)
+		xpfo_flush_kernel_tlb(page, 0);
 }
 EXPORT_SYMBOL(xpfo_kunmap);
 
-- 
2.17.1
