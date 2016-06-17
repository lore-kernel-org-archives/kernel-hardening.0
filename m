Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 17 Jun 2016 13:00:38 -0700
Message-Id: <832aa0209ca4bd94b043add243ac36ab56285639.1466192946.git.luto@kernel.org>
In-Reply-To: <cover.1466192946.git.luto@kernel.org>
References: <cover.1466192946.git.luto@kernel.org>
In-Reply-To: <cover.1466192946.git.luto@kernel.org>
References: <cover.1466192946.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v2 02/13] x86/cpa: In populate_pgd, don't set the pgd entry until it's populated
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

This avoids pointless races in which another CPU or task might see a
partially populated global pgd entry.  These races should normally
be harmless, but, if another CPU propagates the entry via
vmalloc_fault and then populate_pgd fails (due to memory allocation
failure, for example), this prevents a use-after-free of the pgd
entry.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/mm/pageattr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 7a1f7bbf4105..6a8026918bf6 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1113,7 +1113,9 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 
 	ret = populate_pud(cpa, addr, pgd_entry, pgprot);
 	if (ret < 0) {
-		unmap_pgd_range(cpa->pgd, addr,
+		if (pud)
+			free_page((unsigned long)pud);
+		unmap_pud_range(pgd_entry, addr,
 				addr + (cpa->numpages << PAGE_SHIFT));
 		return ret;
 	}
-- 
2.5.5
