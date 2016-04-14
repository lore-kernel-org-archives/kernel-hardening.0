Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:29:03 -0700
Message-Id: <1460672954-32567-11-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 10/21] x86, KASLR: Consolidate mem_avoid entries
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Yinghai Lu <yinghai@kernel.org>

The mem_avoid array is used to track positions that should be avoided
(like the compressed kernel, decompression code, etc) when selecting a
memory position for the relocated kernel. Since ZO is now at the end of
the decompression buffer and the decompression code (and its heap and
stack) are at the front, we can safely consolidate the decompression
entry, the heap entry, and the stack entry. The boot_params memory,
however, could be elsewhere, so it should be explicitly included.

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog, cleaned up code comment]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c | 72 ++++++++++++++++++++++++++++++++---------
 1 file changed, 56 insertions(+), 16 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 462654097d63..277c7a4ec3a3 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -109,7 +109,7 @@ struct mem_vector {
 	unsigned long size;
 };
 
-#define MEM_AVOID_MAX 5
+#define MEM_AVOID_MAX 4
 static struct mem_vector mem_avoid[MEM_AVOID_MAX];
 
 static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
@@ -134,22 +134,66 @@ static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
 	return true;
 }
 
+/*
+ * In theroy, KASLR can put the kernel anywhere in area of [16M, 64T). The
+ * mem_avoid array is used to store the ranges that need be avoided when
+ * KASLR searches for the relocated address. We must avoid any regions that
+ * are unsafe to overlap with during decompression, and other things like
+ * the initrd, cmdline and boot_params.
+ *
+ * How to calculate the unsafe area used by decompression is detailed here.
+ * The compressed vmlinux (ZO) plus relocs and the run space of ZO can't be
+ * overwritten by decompression output.
+ *
+ * ZO sits against the end of the decompression buffer, so we can calculate
+ * where text, data, bss, etc of ZO are positioned.
+ *
+ * The follow are already enforced by the code:
+ *  - init_size >= run_size,
+ *  - input+input_len >= output+output_len,
+ *  - run_size could be >= or < output_len
+ *
+ * From this, we can make several observations, illustrated by a diagram:
+ *  - init_size > run_size
+ *  - input+input_len > output+output_len
+ *  - run_size > output_len
+ *
+ * 0   output            input            input+input_len    output+init_size
+ * |     |                 |                       |                       |
+ * |-----|--------|--------|------------------|----|------------|----------|
+ *                |                           |                 |
+ *   output+init_size-ZO_INIT_SIZE    output+output_len    output+run_size
+ *
+ * [output, output+init_size) is for the buffer for decompressing the
+ * compressed kernel (ZO).
+ *
+ * [output, output+run_size) is for the uncompressed kernel (VO) run size.
+ * [output, output+output_len) is VO plus relocs
+ *
+ * [output+init_size-ZO_INIT_SIZE, output+init_size) is copied ZO.
+ * [input, input+input_len) is copied compressed (VO (vmlinux after objcopy)
+ * plus relocs), not the ZO.
+ *
+ * [input+input_len, output+init_size) is [_text, _end) for ZO. That was the
+ * first range in mem_avoid, which included ZO's heap and stack. Also
+ * [input, input+input_size) need be put in mem_avoid array, but since it
+ * is adjacent to the first entry, they can be merged. This is how we get
+ * the first entry in mem_avoid[].
+ */
 static void mem_avoid_init(unsigned long input, unsigned long input_size,
-			   unsigned long output, unsigned long output_size)
+			   unsigned long output)
 {
+	unsigned long init_size = real_mode->hdr.init_size;
 	u64 initrd_start, initrd_size;
 	u64 cmd_line, cmd_line_size;
-	unsigned long unsafe, unsafe_len;
 	char *ptr;
 
 	/*
 	 * Avoid the region that is unsafe to overlap during
-	 * decompression (see calculations at top of misc.c).
+	 * decompression.
 	 */
-	unsafe_len = (output_size >> 12) + 32768 + 18;
-	unsafe = (unsigned long)input + input_size - unsafe_len;
-	mem_avoid[0].start = unsafe;
-	mem_avoid[0].size = unsafe_len;
+	mem_avoid[0].start = input;
+	mem_avoid[0].size = (output + init_size) - input;
 
 	/* Avoid initrd. */
 	initrd_start  = (u64)real_mode->ext_ramdisk_image << 32;
@@ -169,13 +213,9 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	mem_avoid[2].start = cmd_line;
 	mem_avoid[2].size = cmd_line_size;
 
-	/* Avoid heap memory. */
-	mem_avoid[3].start = (unsigned long)free_mem_ptr;
-	mem_avoid[3].size = BOOT_HEAP_SIZE;
-
-	/* Avoid stack memory. */
-	mem_avoid[4].start = (unsigned long)free_mem_end_ptr;
-	mem_avoid[4].size = BOOT_STACK_SIZE;
+	/* Avoid params */
+	mem_avoid[3].start = (unsigned long)real_mode;
+	mem_avoid[3].size = sizeof(*real_mode);
 }
 
 /* Does this memory vector overlap a known avoided area? */
@@ -317,7 +357,7 @@ unsigned char *choose_kernel_location(unsigned char *input,
 
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init((unsigned long)input, input_size,
-		       (unsigned long)output, output_size);
+		       (unsigned long)output);
 
 	/* Walk e820 and find a random address. */
 	random = find_random_addr(choice, output_size);
-- 
2.6.3
