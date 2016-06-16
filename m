Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 15 Jun 2016 17:28:25 -0700
Message-Id: <3336bb02792d56c49d18e2f7a435fd194a4a22e4.1466036668.git.luto@kernel.org>
In-Reply-To: <cover.1466036668.git.luto@kernel.org>
References: <cover.1466036668.git.luto@kernel.org>
In-Reply-To: <cover.1466036668.git.luto@kernel.org>
References: <cover.1466036668.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH 03/13] x86/cpa: Warn if kernel_unmap_pages_in_pgd is used inappropriately
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, x86@kernel.org, Borislav Petkov <bp@alien8.de>
Cc: Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

It's currently only used in the EFI code, which is safe AFAICT.
Warn if anyone tries to use it on the normal kernel pgd.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/mm/pageattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 6a8026918bf6..e9b9c5cedbb8 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1996,6 +1996,9 @@ out:
 void kernel_unmap_pages_in_pgd(pgd_t *root, unsigned long address,
 			       unsigned numpages)
 {
+	/* Unmapping kernel entries from init_mm's pgd is not allowed. */
+	WARN_ON(root == init_mm.pgd);
+
 	unmap_pgd_range(root, address, address + (numpages << PAGE_SHIFT));
 }
 
-- 
2.7.4
