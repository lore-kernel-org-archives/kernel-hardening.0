Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:28:58 -0700
Message-Id: <1460672954-32567-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 05/21] x86, boot: Calculate decompression size during boot not build
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Yinghai Lu <yinghai@kernel.org>

Currently z_extract_offset is calculated in boot/compressed/mkpiggy.c.
This doesn't work well because mkpiggy.c doesn't know the details of the
decompressor in use. As a result, it can only make an estimation, which
has risks:

 - output + output_len (VO) could be much bigger than input + input_len
   (ZO). In this case, the decompressed kernel plus relocs could overwrite
   the decompression code while it is running.

 - The head code of ZO could be bigger than z_extract_offset. In this case
   an overwrite could happen when the head code is running to move ZO to
   the end of buffer. Though currently the size of the head code is very
   small it's still a potential risk. Since there is no rule to limit the
   size of the head code of ZO, it runs the risk of suddenly becoming a
   (hard to find) bug.

Instead, this moves the z_extract_offset calculation into header.S, and
makes adjustments to be sure that the above two cases can never happen.

Since we have (previously) made ZO always be located against the end of
decompression buffer, z_extract_offset is only used here to calculate an
appropriate buffer size (INIT_SIZE), and is not longer used elsewhere. As
such, it can be removed from voffset.h.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/Makefile             |  2 +-
 arch/x86/boot/compressed/misc.c    |  5 +----
 arch/x86/boot/compressed/mkpiggy.c | 15 +--------------
 arch/x86/boot/header.S             | 23 ++++++++++++++++++++++-
 4 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index b1ef9e489084..942f7dabfb1e 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -95,7 +95,7 @@ targets += voffset.h
 $(obj)/voffset.h: vmlinux FORCE
 	$(call if_changed,voffset)
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|_ehead\|_text\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index c4477d5f3fff..e2a998f8c304 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -83,13 +83,10 @@
  * To avoid problems with the compressed data's meta information an extra 18
  * bytes are needed.  Leading to the formula:
  *
- * extra_bytes = (uncompressed_size >> 12) + 32768 + 18 + decompressor_size.
+ * extra_bytes = (uncompressed_size >> 12) + 32768 + 18.
  *
  * Adding 8 bytes per 32K is a bit excessive but much easier to calculate.
  * Adding 32768 instead of 32767 just makes for round numbers.
- * Adding the decompressor_size is necessary as it musht live after all
- * of the data as well.  Last I measured the decompressor is about 14K.
- * 10K of actual data and 4K of bss.
  *
  */
 
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index b980046c3329..a613c84d9b88 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -21,8 +21,7 @@
  * ----------------------------------------------------------------------- */
 
 /*
- * Compute the desired load offset from a compressed program; outputs
- * a small assembly wrapper with the appropriate symbols defined.
+ * outputs a small assembly wrapper with the appropriate symbols defined.
  */
 
 #include <stdlib.h>
@@ -35,7 +34,6 @@ int main(int argc, char *argv[])
 {
 	uint32_t olen;
 	long ilen;
-	unsigned long offs;
 	unsigned long run_size;
 	FILE *f = NULL;
 	int retval = 1;
@@ -67,15 +65,6 @@ int main(int argc, char *argv[])
 	ilen = ftell(f);
 	olen = get_unaligned_le32(&olen);
 
-	/*
-	 * Now we have the input (compressed) and output (uncompressed)
-	 * sizes, compute the necessary decompression offset...
-	 */
-
-	offs = (olen > ilen) ? olen - ilen : 0;
-	offs += olen >> 12;	/* Add 8 bytes for each 32K block */
-	offs += 64*1024 + 128;	/* Add 64K + 128 bytes slack */
-	offs = (offs+4095) & ~4095; /* Round to a 4K boundary */
 	run_size = atoi(argv[2]);
 
 	printf(".section \".rodata..compressed\",\"a\",@progbits\n");
@@ -83,8 +72,6 @@ int main(int argc, char *argv[])
 	printf("z_input_len = %lu\n", ilen);
 	printf(".globl z_output_len\n");
 	printf("z_output_len = %lu\n", (unsigned long)olen);
-	printf(".globl z_extract_offset\n");
-	printf("z_extract_offset = 0x%lx\n", offs);
 	printf(".globl z_run_size\n");
 	printf("z_run_size = %lu\n", run_size);
 
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 6236b9ec4b76..6565dcb2b899 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -440,7 +440,28 @@ setup_data:		.quad 0			# 64-bit physical pointer to
 
 pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
 
-#define ZO_INIT_SIZE	(ZO__end - ZO_startup_32 + ZO_z_extract_offset)
+/* Check arch/x86/boot/compressed/misc.c for the formula of extra_bytes*/
+#define ZO_z_extra_bytes	((ZO_z_output_len >> 12) + 65536 + 128)
+#if ZO_z_output_len > ZO_z_input_len
+#define ZO_z_extract_offset	(ZO_z_output_len + ZO_z_extra_bytes - \
+				 ZO_z_input_len)
+#else
+#define ZO_z_extract_offset	ZO_z_extra_bytes
+#endif
+
+/*
+ * extract_offset has to be bigger than ZO head section. Otherwise
+ * during head code running to move ZO to end of buffer, it will
+ * overwrite head code itself.
+ */
+#if (ZO__ehead - ZO_startup_32) > ZO_z_extract_offset
+#define ZO_z_min_extract_offset ((ZO__ehead - ZO_startup_32 + 4095) & ~4095)
+#else
+#define ZO_z_min_extract_offset ((ZO_z_extract_offset + 4095) & ~4095)
+#endif
+
+#define ZO_INIT_SIZE	(ZO__end - ZO_startup_32 + ZO_z_min_extract_offset)
+
 #define VO_INIT_SIZE	(VO__end - VO__text)
 #if ZO_INIT_SIZE > VO_INIT_SIZE
 #define INIT_SIZE ZO_INIT_SIZE
-- 
2.6.3
