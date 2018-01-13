From: Dan Aloni <dan@kernelim.com>
Date: Sat, 13 Jan 2018 23:34:37 +0200
Message-Id: <20180113213441.52047-4-dan@kernelim.com>
In-Reply-To: <20180113213441.52047-1-dan@kernelim.com>
References: <20180113213441.52047-1-dan@kernelim.com>
Subject: [kernel-hardening] [PATCHv2 3/7] base64-armor: add bounds checking
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Future use of the API can benefit from bounds checking.

Signed-off-by: Dan Aloni <dan@kernelim.com>
---
 include/linux/base64-armor.h | 17 +++++++++++------
 lib/base64-armor.c           | 20 ++++++++++++++++++--
 net/ceph/crypto.c            |  2 +-
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/include/linux/base64-armor.h b/include/linux/base64-armor.h
index e5160c77bb2f..bb0b4491799e 100644
--- a/include/linux/base64-armor.h
+++ b/include/linux/base64-armor.h
@@ -8,11 +8,13 @@
  * not contain newlines, depending on input length.
  *
  * @dst: Beginning of the destination buffer.
+ * @dst_max: Maximum amount of bytes to write to the destination buffer.
  * @src: Beginning of the source buffer.
  * @end: Sentinel for the source buffer, pointing one byte after the
  *       last byte to be encoded.
  *
- * Returns the number of bytes written to the destination buffer.
+ * Returns the number of bytes written to the destination buffer, or
+ * an error of the output buffer is insufficient in size.
  *
  * _Neither_ the input or output are expected to be NULL-terminated.
  *
@@ -22,19 +24,21 @@
  *
  * See base64_encode_buffer_bound below.
  */
-
-extern int base64_armor(char *dst, const char *src, const char *end);
+extern int base64_armor(char *dst, int dst_max, const char *src,
+			const char *end);
 
 /**
  * base64_unarmor: Perform armored base64 decoding.
  *
  * @dst: Beginning of the destination buffer.
+ * @dst_max: Maximum amount of bytes to write to the destination buffer.
  * @src: Beginning of the source buffer
  * @end: Sentinel for the source buffer, pointing one byte after the
  *       last byte to be encoded.
  *
- * Returns the number of bytes written to the destination buffer, or
- * -EINVAL if the source buffer contains invalid bytes.
+ * Returns the number of bytes written to the destination buffer,
+ * -EINVAL if the source buffer contains invalid bytes, or -ENOSPC
+ * if the output buffer is insufficient in size.
  *
  * _Neither_ the input or output are expected to be NULL-terminated.
  *
@@ -43,7 +47,8 @@ extern int base64_armor(char *dst, const char *src, const char *end);
  *
  * See base64_decode_buffer_bound below.
  */
-extern int base64_unarmor(char *dst, const char *src, const char *end);
+extern int base64_unarmor(char *dst, int dst_max, const char *src,
+			  const char *end);
 
 
 /*
diff --git a/lib/base64-armor.c b/lib/base64-armor.c
index e07d25ac2850..f4a289f8da6a 100644
--- a/lib/base64-armor.c
+++ b/lib/base64-armor.c
@@ -33,7 +33,7 @@ static int decode_bits(char c)
 	return -EINVAL;
 }
 
-int base64_armor(char *dst, const char *src, const char *end)
+int base64_armor(char *dst, int dst_max, const char *src, const char *end)
 {
 	int olen = 0;
 	int line = 0;
@@ -42,6 +42,8 @@ int base64_armor(char *dst, const char *src, const char *end)
 		unsigned char a, b, c;
 
 		a = *src++;
+		if (dst_max < 4)
+			return -ENOSPC;
 		*dst++ = encode_bits(a >> 2);
 		if (src < end) {
 			b = *src++;
@@ -62,17 +64,22 @@ int base64_armor(char *dst, const char *src, const char *end)
 		}
 		olen += 4;
 		line += 4;
+		dst_max -= 4;
+
 		if (line == 64) {
 			line = 0;
+			if (dst_max < 1)
+				return -ENOSPC;
 			*(dst++) = '\n';
 			olen++;
+			dst_max--;
 		}
 	}
 	return olen;
 }
 EXPORT_SYMBOL(base64_unarmor);
 
-int base64_unarmor(char *dst, const char *src, const char *end)
+int base64_unarmor(char *dst, int dst_max, const char *src, const char *end)
 {
 	int olen = 0;
 
@@ -92,13 +99,22 @@ int base64_unarmor(char *dst, const char *src, const char *end)
 		if (a < 0 || b < 0 || c < 0 || d < 0)
 			return -EINVAL;
 
+		if (dst_max < 1)
+			return -ENOSPC;
 		*dst++ = (a << 2) | (b >> 4);
+		dst_max--;
 		if (src[2] == '=')
 			return olen + 1;
+		if (dst_max < 1)
+			return -ENOSPC;
 		*dst++ = ((b & 15) << 4) | (c >> 2);
+		dst_max--;
 		if (src[3] == '=')
 			return olen + 2;
+		if (dst_max < 1)
+			return -ENOSPC;
 		*dst++ = ((c & 3) << 6) | d;
+		dst_max--;
 		olen += 3;
 		src += 4;
 	}
diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 25e04e3b1aa4..f7c75368989a 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -116,7 +116,7 @@ int ceph_crypto_key_unarmor(struct ceph_crypto_key *key, const char *inkey)
 	buf = kmalloc(blen, GFP_NOFS);
 	if (!buf)
 		return -ENOMEM;
-	blen = base64_unarmor(buf, inkey, inkey+inlen);
+	blen = base64_unarmor(buf, blen, inkey, inkey+inlen);
 	if (blen < 0) {
 		kfree(buf);
 		return blen;
-- 
2.14.3
