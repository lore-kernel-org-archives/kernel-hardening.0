Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:28:59 -0700
Message-Id: <1460672954-32567-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 06/21] x86, KASLR: Update description for decompressor worst case size
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Baoquan He <bhe@redhat.com>

The comment that describes the analysis for the size of the decompressor
code only took gzip into account (there are 6 other decompressors that
could be used). The actual z_extract_offset calculation in code was
already handling the correct maximum size, but this documentation hadn't
been updated. This updates the documentation and fixes several typos.

Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog, cleaned up comment style]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/misc.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index e2a998f8c304..31e2d6155643 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -19,11 +19,13 @@
  */
 
 /*
- * Getting to provable safe in place decompression is hard.
- * Worst case behaviours need to be analyzed.
- * Background information:
+ * Getting to provable safe in place decompression is hard. Worst case
+ * behaviours need be analyzed. Here let's take decompressing gzip-compressed
+ * kernel as example to illustrate it.
+ *
+ * The file layout of gzip compressed kernel is as follows. For more
+ * information, please refer to RFC 1951 and RFC 1952.
  *
- * The file layout is:
  *    magic[2]
  *    method[1]
  *    flags[1]
@@ -70,13 +72,13 @@
  * of 5 bytes per 32767 bytes.
  *
  * The worst case internal to a compressed block is very hard to figure.
- * The worst case can at least be boundined by having one bit that represents
+ * The worst case can at least be bounded by having one bit that represents
  * 32764 bytes and then all of the rest of the bytes representing the very
  * very last byte.
  *
  * All of which is enough to compute an amount of extra data that is required
  * to be safe.  To avoid problems at the block level allocating 5 extra bytes
- * per 32767 bytes of data is sufficient.  To avoind problems internal to a
+ * per 32767 bytes of data is sufficient.  To avoid problems internal to a
  * block adding an extra 32767 bytes (the worst case uncompressed block size)
  * is sufficient, to ensure that in the worst case the decompressed data for
  * block will stop the byte before the compressed data for a block begins.
@@ -88,11 +90,17 @@
  * Adding 8 bytes per 32K is a bit excessive but much easier to calculate.
  * Adding 32768 instead of 32767 just makes for round numbers.
  *
+ * Above analysis is for decompressing gzip compressed kernel only. Up to
+ * now 6 different decompressor are supported all together. And among them
+ * xz stores data in chunks and has maximum chunk of 64K. Hence safety
+ * margin should be updated to cover all decompressors so that we don't
+ * need to deal with each of them separately. Please check
+ * the description in lib/decompressor_xxx.c for specific information.
+ *
+ * extra_bytes = (uncompressed_size >> 12) + 65536 + 128.
+ *
  */
 
-/*
- * gzip declarations
- */
 #define STATIC		static
 
 #undef memcpy
-- 
2.6.3
