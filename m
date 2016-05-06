Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri,  6 May 2016 15:01:33 -0700
Message-Id: <1462572095-11754-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1462572095-11754-1-git-send-email-keescook@chromium.org>
References: <1462572095-11754-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 1/3] x86/boot: Clean up indenting for asm/boot.h
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Before adding more defines to asm/boot.h, this cleans up the existing
indenting for readability.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/boot.h | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index 6b8d6e8cd449..52e6ca670ed0 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -12,29 +12,27 @@
 
 /* Minimum kernel alignment, as a power of two */
 #ifdef CONFIG_X86_64
-#define MIN_KERNEL_ALIGN_LG2	PMD_SHIFT
+# define MIN_KERNEL_ALIGN_LG2	PMD_SHIFT
 #else
-#define MIN_KERNEL_ALIGN_LG2	(PAGE_SHIFT + THREAD_SIZE_ORDER)
+# define MIN_KERNEL_ALIGN_LG2	(PAGE_SHIFT + THREAD_SIZE_ORDER)
 #endif
 #define MIN_KERNEL_ALIGN	(_AC(1, UL) << MIN_KERNEL_ALIGN_LG2)
 
 #if (CONFIG_PHYSICAL_ALIGN & (CONFIG_PHYSICAL_ALIGN-1)) || \
 	(CONFIG_PHYSICAL_ALIGN < MIN_KERNEL_ALIGN)
-#error "Invalid value for CONFIG_PHYSICAL_ALIGN"
+# error "Invalid value for CONFIG_PHYSICAL_ALIGN"
 #endif
 
 #ifdef CONFIG_KERNEL_BZIP2
-#define BOOT_HEAP_SIZE             0x400000
+# define BOOT_HEAP_SIZE		0x400000
 #else /* !CONFIG_KERNEL_BZIP2 */
-
-#define BOOT_HEAP_SIZE	0x10000
-
-#endif /* !CONFIG_KERNEL_BZIP2 */
+# define BOOT_HEAP_SIZE		 0x10000
+#endif
 
 #ifdef CONFIG_X86_64
-#define BOOT_STACK_SIZE	0x4000
-#else
-#define BOOT_STACK_SIZE	0x1000
+# define BOOT_STACK_SIZE	0x4000
+#else /* !CONFIG_X86_64 */
+# define BOOT_STACK_SIZE	0x1000
 #endif
 
 #endif /* _ASM_X86_BOOT_H */
-- 
2.6.3
