Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Mon,  9 May 2016 13:22:04 -0700
Message-Id: <1462825332-10505-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1462825332-10505-1-git-send-email-keescook@chromium.org>
References: <1462825332-10505-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 1/9] x86/KASLR: Initialize mapping_info every time
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

As it turns out, mapping_info DOES need to be initialized every
time. Without this, page tables were not being corrected updated, which
could cause reboots when a physical address beyond 2G was chosen.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/pagetable.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/boot/compressed/pagetable.c b/arch/x86/boot/compressed/pagetable.c
index 3c99051566a9..34b95df14e69 100644
--- a/arch/x86/boot/compressed/pagetable.c
+++ b/arch/x86/boot/compressed/pagetable.c
@@ -90,23 +90,17 @@ static void prepare_level4(void)
 }
 
 /*
- * Mapping information structure passed to kernel_ident_mapping_init().
- * Since this never changes, there's no reason to repeatedly fill it
- * in on the stack when calling add_identity_map().
- */
-static struct x86_mapping_info mapping_info = {
-	.alloc_pgt_page	= alloc_pgt_page,
-	.context	= &pgt_data,
-	.pmd_flag	= __PAGE_KERNEL_LARGE_EXEC,
-};
-
-/*
  * Adds the specified range to what will become the new identity mappings.
  * Once all ranges have been added, the new mapping is activated by calling
  * finalize_identity_maps() below.
  */
 void add_identity_map(unsigned long start, unsigned long size)
 {
+	struct x86_mapping_info mapping_info = {
+		.alloc_pgt_page	= alloc_pgt_page,
+		.context	= &pgt_data,
+		.pmd_flag	= __PAGE_KERNEL_LARGE_EXEC,
+	};
 	unsigned long end = start + size;
 
 	/* Make sure we have a top level page table ready to use. */
-- 
2.6.3
