Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Mon,  9 May 2016 13:22:05 -0700
Message-Id: <1462825332-10505-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1462825332-10505-1-git-send-email-keescook@chromium.org>
References: <1462825332-10505-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 2/9] x86/boot: Add missing file header comments
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

There were some files with missing header comments. Since they are
included from both compressed and regular kernels, make note of that.
Also corrects a typo in the mem_avoid comments.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/kaslr.c     | 2 +-
 arch/x86/boot/early_serial_console.c | 4 ++++
 arch/x86/mm/ident_map.c              | 5 +++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index f82975b0f9d6..3f0692dcd30d 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -163,7 +163,7 @@ static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
  * memory ranges lead to really hard to debug boot failures.
  *
  * The initrd, cmdline, and boot_params are trivial to identify for
- * avoiding. The are MEM_AVOID_INITRD, MEM_AVOID_CMDLINE, and
+ * avoiding. They are MEM_AVOID_INITRD, MEM_AVOID_CMDLINE, and
  * MEM_AVOID_BOOTPARAMS respectively below.
  *
  * What is not obvious how to avoid is the range of memory that is used
diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
index 45a07684bbab..f0b8d6d93164 100644
--- a/arch/x86/boot/early_serial_console.c
+++ b/arch/x86/boot/early_serial_console.c
@@ -1,3 +1,7 @@
+/*
+ * Serial port routines for use during early boot reporting. This code is
+ * included from both the compressed kernel and the regular kernel.
+ */
 #include "boot.h"
 
 #define DEFAULT_SERIAL_PORT 0x3f8 /* ttyS0 */
diff --git a/arch/x86/mm/ident_map.c b/arch/x86/mm/ident_map.c
index 751ca920773a..ec21796ac5fd 100644
--- a/arch/x86/mm/ident_map.c
+++ b/arch/x86/mm/ident_map.c
@@ -1,3 +1,7 @@
+/*
+ * Helper routines for building identity mapping page tables. This is
+ * included by both the compressed kernel and the regular kernel.
+ */
 
 static void ident_pmd_init(unsigned long pmd_flag, pmd_t *pmd_page,
 			   unsigned long addr, unsigned long end)
@@ -10,6 +14,7 @@ static void ident_pmd_init(unsigned long pmd_flag, pmd_t *pmd_page,
 			set_pmd(pmd, __pmd(addr | pmd_flag));
 	}
 }
+
 static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
 			  unsigned long addr, unsigned long end)
 {
-- 
2.6.3
