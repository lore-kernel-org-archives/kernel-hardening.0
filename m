Date: Mon, 14 Aug 2017 21:51:38 -0600
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170815035138.qylh4mhpqom5g6qx@smitten>
References: <20170809200755.11234-1-tycho@docker.com>
 <20170809200755.11234-3-tycho@docker.com>
 <910adbb5-c5d7-3091-1c92-996f73dd6221@redhat.com>
 <20170815034718.o6fej2gqkmypxtl2@smitten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170815034718.o6fej2gqkmypxtl2@smitten>
Subject: [kernel-hardening] Re: [PATCH v5 02/10] mm, x86: Add support for eXclusive Page Frame
 Ownership (XPFO)
To: Laura Abbott <labbott@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, Juerg Haefliger <juerg.haefliger@hpe.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 14, 2017 at 09:47:18PM -0600, Tycho Andersen wrote:
> I'll do that for the next version

Actually looking closer, I think we just need to mirror the
debug_pagealloc_enabled() checks in set_kpte() from
split_large_page(),

diff --git a/arch/x86/mm/xpfo.c b/arch/x86/mm/xpfo.c
index a1344f27406c..c962bd7f34cc 100644
--- a/arch/x86/mm/xpfo.c
+++ b/arch/x86/mm/xpfo.c
@@ -54,9 +54,11 @@ inline void set_kpte(void *kaddr, struct page *page, pgprot_t prot)
 
 		do_split = try_preserve_large_page(pte, (unsigned long)kaddr, &cpa);
 		if (do_split) {
-			spin_lock(&cpa_lock);
+			if (!debug_pagealloc_enabled())
+				spin_lock(&cpa_lock);
 			BUG_ON(split_large_page(&cpa, pte, (unsigned long)kaddr));
-			spin_unlock(&cpa_lock);
+			if (!debug_pagealloc_enabled())
+				spin_unlock(&cpa_lock);
 		}
 
 		break;


Tycho
