Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 10 May 2016 10:19:12 -0700
Message-Id: <1462900755-20005-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1462900755-20005-1-git-send-email-keescook@chromium.org>
References: <1462900755-20005-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v8 1/4] x86/KASLR: Clarify identity map interface
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

This extracts the call to prepare_level4() into a top-level function
that the user of the pagetable.c interface must call to initialize
the new page tables. For clarity and to match the "finalize" function,
it has been renamed to initialize_identity_maps(). This function also
gains the initialization of mapping_info so we don't have to do it each
time in add_identity_map().

Additionally add copyright notice to the top, to make it clear that the
bulk of the pagetable.c code was written by Yinghai, and that I just
added bugs later. :)

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/kaslr.c     |  3 +++
 arch/x86/boot/compressed/misc.h      |  3 +++
 arch/x86/boot/compressed/pagetable.c | 26 ++++++++++++++++----------
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index cfeb0259ed81..03a6f5d85a6b 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -485,6 +485,9 @@ unsigned char *choose_random_location(unsigned long input,
 
 	boot_params->hdr.loadflags |= KASLR_FLAG;
 
+	/* Prepare to add new identity pagetables on demand. */
+	initialize_identity_maps();
+
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init(input, input_size, output);
 
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index b6fec1ff10e4..09c4ddd02ac6 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -85,10 +85,13 @@ unsigned char *choose_random_location(unsigned long input_ptr,
 #endif
 
 #ifdef CONFIG_X86_64
+void initialize_identity_maps(void);
 void add_identity_map(unsigned long start, unsigned long size);
 void finalize_identity_maps(void);
 extern unsigned char _pgtable[];
 #else
+static inline void initialize_identity_maps(void)
+{ }
 static inline void add_identity_map(unsigned long start, unsigned long size)
 { }
 static inline void finalize_identity_maps(void)
diff --git a/arch/x86/boot/compressed/pagetable.c b/arch/x86/boot/compressed/pagetable.c
index 34b95df14e69..ea4ee6abc0d2 100644
--- a/arch/x86/boot/compressed/pagetable.c
+++ b/arch/x86/boot/compressed/pagetable.c
@@ -2,6 +2,9 @@
  * This code is used on x86_64 to create page table identity mappings on
  * demand by building up a new set of page tables (or appending to the
  * existing ones), and then switching over to them when ready.
+ *
+ * Copyright (C) 2015-2016  Yinghai Lu
+ * Copyright (C)      2016  Kees Cook
  */
 
 /*
@@ -59,9 +62,21 @@ static struct alloc_pgt_data pgt_data;
 /* The top level page table entry pointer. */
 static unsigned long level4p;
 
+/*
+ * Mapping information structure passed to kernel_ident_mapping_init().
+ * Due to relocation, pointers must be assigned at run time not build time.
+ */
+static struct x86_mapping_info mapping_info = {
+	.pmd_flag       = __PAGE_KERNEL_LARGE_EXEC,
+};
+
 /* Locates and clears a region for a new top level page table. */
-static void prepare_level4(void)
+void initialize_identity_maps(void)
 {
+	/* Init mapping_info with run-time function/buffer pointers. */
+	mapping_info.alloc_pgt_page = alloc_pgt_page;
+	mapping_info.context = &pgt_data;
+
 	/*
 	 * It should be impossible for this not to already be true,
 	 * but since calling this a second time would rewind the other
@@ -96,17 +111,8 @@ static void prepare_level4(void)
  */
 void add_identity_map(unsigned long start, unsigned long size)
 {
-	struct x86_mapping_info mapping_info = {
-		.alloc_pgt_page	= alloc_pgt_page,
-		.context	= &pgt_data,
-		.pmd_flag	= __PAGE_KERNEL_LARGE_EXEC,
-	};
 	unsigned long end = start + size;
 
-	/* Make sure we have a top level page table ready to use. */
-	if (!level4p)
-		prepare_level4();
-
 	/* Align boundary to 2M. */
 	start = round_down(start, PMD_SIZE);
 	end = round_up(end, PMD_SIZE);
-- 
2.6.3
