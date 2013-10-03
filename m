Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu,  3 Oct 2013 13:53:21 -0700
Message-Id: <1380833605-26313-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1380833605-26313-1-git-send-email-keescook@chromium.org>
References: <1380833605-26313-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 3/7] x86, kaslr: find minimum safe relocation position
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Examine all the known unsafe areas and avoid them by just raising the
minimum relocation position to be past them.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c |   50 +++++++++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/misc.c |   10 ++------
 arch/x86/boot/compressed/misc.h |    8 +++++++
 3 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index b73cc66..ed7e9f0 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -2,6 +2,53 @@
 
 #ifdef CONFIG_RANDOMIZE_BASE
 
+static unsigned long find_minimum_location(unsigned long input,
+					   unsigned long input_size,
+					   unsigned long output,
+					   unsigned long output_size)
+{
+	u64 initrd_start, initrd_size;
+	u64 cmd_line, cmd_line_size;
+	unsigned long unsafe, unsafe_len;
+	char *ptr;
+
+	/*
+	 * Mark off the region that is unsafe to overlap during
+	 * decompression (see calculations at top of misc.c).
+	 */
+	unsafe_len = (output_size >> 12) + 32768 + 18;
+	unsafe = (unsigned long)input + input_size - unsafe_len;
+
+	/*
+	 * Locate other regions that cannot be over-written during
+	 * decompression: initrd, cmd_line.
+	 */
+	initrd_start  = (u64)real_mode->ext_ramdisk_image << 32;
+	initrd_start |= real_mode->hdr.ramdisk_image;
+	initrd_size  = (u64)real_mode->ext_ramdisk_size << 32;
+	initrd_size |= real_mode->hdr.ramdisk_size;
+	cmd_line  = (u64)real_mode->ext_cmd_line_ptr << 32;
+	cmd_line |= real_mode->hdr.cmd_line_ptr;
+	/* Calculate size of cmd_line. */
+	ptr = (char *)(unsigned long)cmd_line;
+	for (cmd_line_size = 0; ptr[cmd_line_size++]; )
+		;
+
+	/* Minimum location must be above all these regions: */
+	output = max(output, unsafe + unsafe_len);
+	output = max(output, (unsigned long)free_mem_ptr + BOOT_HEAP_SIZE);
+	output = max(output, (unsigned long)free_mem_end_ptr + BOOT_STACK_SIZE);
+	output = max(output, (unsigned long)initrd_start
+			     + (unsigned long)initrd_size);
+	output = max(output, (unsigned long)cmd_line
+			     + (unsigned long)cmd_line_size);
+
+	/* Make sure the location is still aligned. */
+	output = ALIGN(output, CONFIG_PHYSICAL_ALIGN);
+
+	return output;
+}
+
 unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
@@ -14,6 +61,9 @@ unsigned char *choose_kernel_location(unsigned char *input,
 		goto out;
 	}
 
+	choice = find_minimum_location((unsigned long)input, input_size,
+				       (unsigned long)output, output_size);
+
 	/* XXX: choose random location. */
 
 out:
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 7138768..196eaf3 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -112,14 +112,8 @@ struct boot_params *real_mode;		/* Pointer to real-mode data */
 void *memset(void *s, int c, size_t n);
 void *memcpy(void *dest, const void *src, size_t n);
 
-#ifdef CONFIG_X86_64
-#define memptr long
-#else
-#define memptr unsigned
-#endif
-
-static memptr free_mem_ptr;
-static memptr free_mem_end_ptr;
+memptr free_mem_ptr;
+memptr free_mem_end_ptr;
 
 static char *vidmem;
 static int vidport;
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 9077af7..42f71bb 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -23,7 +23,15 @@
 #define BOOT_BOOT_H
 #include "../ctype.h"
 
+#ifdef CONFIG_X86_64
+#define memptr long
+#else
+#define memptr unsigned
+#endif
+
 /* misc.c */
+extern memptr free_mem_ptr;
+extern memptr free_mem_end_ptr;
 extern struct boot_params *real_mode;		/* Pointer to real-mode data */
 void __putstr(const char *s);
 #define error_putstr(__x)  __putstr(__x)
-- 
1.7.9.5
