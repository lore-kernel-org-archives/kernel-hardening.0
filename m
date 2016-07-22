Reply-To: kernel-hardening@lists.openwall.com
References: <cover.1468270393.git.luto@kernel.org>
 <cover.1468270393.git.luto@kernel.org>
 <fb3254e25e38790c538cca0f46c4a7a714c77ddf.1468270393.git.luto@kernel.org>
 <5741.1469162592@turing-police.cc.vt.edu>
From: Andy Lutomirski <luto@kernel.org>
Message-ID: <4b028b92-81f3-362f-c5be-b7a35cedf5ee@kernel.org>
Date: Thu, 21 Jul 2016 22:34:33 -0700
MIME-Version: 1.0
In-Reply-To: <5741.1469162592@turing-police.cc.vt.edu>
Content-Type: multipart/mixed;
 boundary="------------15810D8CF08AA71BDD37E6F8"
Subject: Re: [kernel-hardening] [PATCH v5 03/32] x86/cpa: In populate_pgd,
 don't set the pgd entry until it's populated
To: Valdis.Kletnieks@vt.edu, kernel-hardening@lists.openwall.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

This is a multi-part message in MIME format.
--------------15810D8CF08AA71BDD37E6F8
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 07/21/2016 09:43 PM, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 11 Jul 2016 13:53:36 -0700, Andy Lutomirski said:
>> This avoids pointless races in which another CPU or task might see a
>> partially populated global pgd entry.  These races should normally
>> be harmless, but, if another CPU propagates the entry via
>> vmalloc_fault and then populate_pgd fails (due to memory allocation
>> failure, for example), this prevents a use-after-free of the pgd
>> entry.
>>
>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>> ---
>>  arch/x86/mm/pageattr.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> I just bisected a failure to boot down to this patch.  On my Dell Latitude
> laptop, it results in the kernel being loaded and then just basically sitting
> there dead in the water - as far as I can tell, it dies before the kernel
> ever gets going far enough to do any console I/O (even with ignore_loglevel).
> Nothing in /sys/fs/pstore either.  I admit not understanding the VM code
> at all, so I don't have a clue *why* this causes indigestion...
>
> CPU is an Intel Core i5-3340M in case that matters....
>

How much memory do you have and what's your config?  My code is 
obviously buggy, but I'm wondering why neither I nor the 0day bot caught 
this.

The attached patch is compile-tested only.  (Even Thunderbird doesn't 
want to send non-flowed text right now, sigh.)

--Andy

--------------15810D8CF08AA71BDD37E6F8
Content-Type: text/x-patch;
 name="0001-x86-mm-Fix-populate_pgd.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-x86-mm-Fix-populate_pgd.patch"

>From 6589ddf69a1369e1ecb95f0af489d90b980e256e Mon Sep 17 00:00:00 2001
Message-Id: <6589ddf69a1369e1ecb95f0af489d90b980e256e.1469165371.git.luto@kernel.org>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 21 Jul 2016 22:22:02 -0700
Subject: [PATCH] x86/mm: Fix populate_pgd()

I make an obvious error in populate_pgd() -- it would fail to correctly
populate the page tables when it allocated a new pud page.

Fixes: 360cb4d15567 ("x86/mm/cpa: In populate_pgd(), don't set the PGD entry until it's populated")
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/mm/pageattr.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 26c93c6e04a0..5ee7d1c794a4 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -984,8 +984,8 @@ static int populate_pmd(struct cpa_data *cpa,
 	return num_pages;
 }
 
-static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
-			pgprot_t pgprot)
+static int populate_pud(struct cpa_data *cpa, unsigned long start,
+			pud_t *pud_page, pgprot_t pgprot)
 {
 	pud_t *pud;
 	unsigned long end;
@@ -1006,7 +1006,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
 		cur_pages = (pre_end - start) >> PAGE_SHIFT;
 		cur_pages = min_t(int, (int)cpa->numpages, cur_pages);
 
-		pud = pud_offset(pgd, start);
+		pud = pud_page + pud_index(start);
 
 		/*
 		 * Need a PMD page?
@@ -1027,7 +1027,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
 	if (cpa->numpages == cur_pages)
 		return cur_pages;
 
-	pud = pud_offset(pgd, start);
+	pud = pud_page + pud_index(start);
 	pud_pgprot = pgprot_4k_2_large(pgprot);
 
 	/*
@@ -1047,7 +1047,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
 	if (start < end) {
 		int tmp;
 
-		pud = pud_offset(pgd, start);
+		pud = pud_page + pud_index(start);
 		if (pud_none(*pud))
 			if (alloc_pmd_page(pud))
 				return -1;
@@ -1069,7 +1069,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
 static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 {
 	pgprot_t pgprot = __pgprot(_KERNPG_TABLE);
-	pud_t *pud = NULL;	/* shut up gcc */
+	pud_t *pud_page = NULL;	/* shut up gcc */
 	pgd_t *pgd_entry;
 	int ret;
 
@@ -1079,25 +1079,27 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	 * Allocate a PUD page and hand it down for mapping.
 	 */
 	if (pgd_none(*pgd_entry)) {
-		pud = (pud_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
-		if (!pud)
+		pud_page = (pud_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
+		if (!pud_page)
 			return -1;
 	}
 
 	pgprot_val(pgprot) &= ~pgprot_val(cpa->mask_clr);
 	pgprot_val(pgprot) |=  pgprot_val(cpa->mask_set);
 
-	ret = populate_pud(cpa, addr, pgd_entry, pgprot);
+	ret = populate_pud(cpa, addr,
+			   pud_page ?: (pud_t *)pgd_page_vaddr(*pgd_entry),
+			   pgprot);
 	if (ret < 0) {
-		if (pud)
-			free_page((unsigned long)pud);
+		if (pud_page)
+			free_page((unsigned long)pud_page);
 		unmap_pud_range(pgd_entry, addr,
 				addr + (cpa->numpages << PAGE_SHIFT));
 		return ret;
 	}
 
-	if (pud)
-		set_pgd(pgd_entry, __pgd(__pa(pud) | _KERNPG_TABLE));
+	if (pud_page)
+		set_pgd(pgd_entry, __pgd(__pa(pud_page) | _KERNPG_TABLE));
 
 	cpa->numpages = ret;
 	return 0;
-- 
2.7.4


--------------15810D8CF08AA71BDD37E6F8--
