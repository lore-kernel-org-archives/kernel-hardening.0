From: Dan Aloni <dan@kernelim.com>
Date: Sat, 13 Jan 2018 23:34:36 +0200
Message-Id: <20180113213441.52047-3-dan@kernelim.com>
In-Reply-To: <20180113213441.52047-1-dan@kernelim.com>
References: <20180113213441.52047-1-dan@kernelim.com>
Subject: [kernel-hardening] [PATCHv2 2/7] Move net/ceph/armor to lib/ and add docs
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Plus, add functions that assist in managing buffer bounds.

Signed-off-by: Dan Aloni <dan@kernelim.com>
---
 include/linux/base64-armor.h           | 65 ++++++++++++++++++++++++++++++++++
 lib/Kconfig                            |  7 ++++
 lib/Makefile                           |  1 +
 net/ceph/armor.c => lib/base64-armor.c | 13 ++++---
 net/ceph/Kconfig                       |  1 +
 net/ceph/Makefile                      |  2 +-
 net/ceph/crypto.c                      |  3 +-
 net/ceph/crypto.h                      |  4 ---
 8 files changed, 85 insertions(+), 11 deletions(-)
 create mode 100644 include/linux/base64-armor.h
 rename net/ceph/armor.c => lib/base64-armor.c (86%)

diff --git a/include/linux/base64-armor.h b/include/linux/base64-armor.h
new file mode 100644
index 000000000000..e5160c77bb2f
--- /dev/null
+++ b/include/linux/base64-armor.h
@@ -0,0 +1,65 @@
+#ifndef __LINUX_BASE64_ARMOR_H__
+#define __LINUX_BASE64_ARMOR_H__
+
+#include <linux/types.h>
+
+/**
+ * base64_armor: Perform armored base64 encoding. Output may or may
+ * not contain newlines, depending on input length.
+ *
+ * @dst: Beginning of the destination buffer.
+ * @src: Beginning of the source buffer.
+ * @end: Sentinel for the source buffer, pointing one byte after the
+ *       last byte to be encoded.
+ *
+ * Returns the number of bytes written to the destination buffer.
+ *
+ * _Neither_ the input or output are expected to be NULL-terminated.
+ *
+ * The number of output bytes is exactly (n * 4 + (n / 16)) where
+ * n = ((end - src) + 2) / 3. A less stringent but more wasteful
+ * validation for output buffer size can be: 4 + (end - src) * 2.
+ *
+ * See base64_encode_buffer_bound below.
+ */
+
+extern int base64_armor(char *dst, const char *src, const char *end);
+
+/**
+ * base64_unarmor: Perform armored base64 decoding.
+ *
+ * @dst: Beginning of the destination buffer.
+ * @src: Beginning of the source buffer
+ * @end: Sentinel for the source buffer, pointing one byte after the
+ *       last byte to be encoded.
+ *
+ * Returns the number of bytes written to the destination buffer, or
+ * -EINVAL if the source buffer contains invalid bytes.
+ *
+ * _Neither_ the input or output are expected to be NULL-terminated.
+ *
+ * It can be assumed that the number of output bytes is less or
+ * equals to: 3 * ((end - src) / 4).
+ *
+ * See base64_decode_buffer_bound below.
+ */
+extern int base64_unarmor(char *dst, const char *src, const char *end);
+
+
+/*
+ * Utility functions for buffer upper bounds:
+ */
+
+static inline size_t base64_encode_buffer_bound(size_t src_len)
+{
+	size_t n = (src_len + 2) / 3;
+
+	return (n * 4 + (n / 16));
+}
+
+static inline size_t base64_decode_buffer_bound(size_t src_len)
+{
+	return 3 * (src_len / 4);
+}
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index c5e84fbcb30b..caddcaebbc2f 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -188,6 +188,13 @@ config CRC8
 	  when they need to do cyclic redundancy check according CRC8
 	  algorithm. Module will be called crc8.
 
+config BASE64_ARMOR
+	tristate "BASE64 encoding/decoding functions"
+	help
+	  This option provides BASE64 encoding and decoding functions.
+	  Module name will be base64-armor if this code is built as a
+	  module.
+
 config XXHASH
 	tristate
 
diff --git a/lib/Makefile b/lib/Makefile
index d11c48ec8ffd..47335d28f77f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -94,6 +94,7 @@ ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
   lib-y += dec_and_lock.o
 endif
 
+obj-$(CONFIG_BASE64_ARMOR) += base64-armor.o
 obj-$(CONFIG_BITREVERSE) += bitrev.o
 obj-$(CONFIG_RATIONAL)	+= rational.o
 obj-$(CONFIG_CRC_CCITT)	+= crc-ccitt.o
diff --git a/net/ceph/armor.c b/lib/base64-armor.c
similarity index 86%
rename from net/ceph/armor.c
rename to lib/base64-armor.c
index 0db8065928df..e07d25ac2850 100644
--- a/net/ceph/armor.c
+++ b/lib/base64-armor.c
@@ -1,9 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/errno.h>
-
-int ceph_armor(char *dst, const char *src, const char *end);
-int ceph_unarmor(char *dst, const char *src, const char *end);
+#include <linux/module.h>
+#include <linux/base64-armor.h>
 
 /*
  * base64 encode/decode.
@@ -34,7 +33,7 @@ static int decode_bits(char c)
 	return -EINVAL;
 }
 
-int ceph_armor(char *dst, const char *src, const char *end)
+int base64_armor(char *dst, const char *src, const char *end)
 {
 	int olen = 0;
 	int line = 0;
@@ -71,8 +70,9 @@ int ceph_armor(char *dst, const char *src, const char *end)
 	}
 	return olen;
 }
+EXPORT_SYMBOL(base64_unarmor);
 
-int ceph_unarmor(char *dst, const char *src, const char *end)
+int base64_unarmor(char *dst, const char *src, const char *end)
 {
 	int olen = 0;
 
@@ -104,3 +104,6 @@ int ceph_unarmor(char *dst, const char *src, const char *end)
 	}
 	return olen;
 }
+EXPORT_SYMBOL(base64_armor);
+
+MODULE_LICENSE("GPL v2");
diff --git a/net/ceph/Kconfig b/net/ceph/Kconfig
index f8cceb99e732..5c4e7d0f2896 100644
--- a/net/ceph/Kconfig
+++ b/net/ceph/Kconfig
@@ -2,6 +2,7 @@ config CEPH_LIB
 	tristate "Ceph core library"
 	depends on INET
 	select LIBCRC32C
+	select BASE64_ARMOR
 	select CRYPTO_AES
 	select CRYPTO_CBC
 	select CRYPTO
diff --git a/net/ceph/Makefile b/net/ceph/Makefile
index b4bded4b5396..bf6f5e34bdb1 100644
--- a/net/ceph/Makefile
+++ b/net/ceph/Makefile
@@ -10,7 +10,7 @@ libceph-y := ceph_common.o messenger.o msgpool.o buffer.o pagelist.o \
 	osd_client.o osdmap.o crush/crush.o crush/mapper.o crush/hash.o \
 	debugfs.o \
 	auth.o auth_none.o \
-	crypto.o armor.o \
+	crypto.o \
 	auth_x.o \
 	ceph_fs.o ceph_strings.o ceph_hash.o \
 	pagevec.o snapshot.o string_table.o
diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index bf9d079cbafd..25e04e3b1aa4 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -10,6 +10,7 @@
 #include <crypto/skcipher.h>
 #include <linux/key-type.h>
 #include <linux/sched/mm.h>
+#include <linux/base64-armor.h>
 
 #include <keys/ceph-type.h>
 #include <keys/user-type.h>
@@ -115,7 +116,7 @@ int ceph_crypto_key_unarmor(struct ceph_crypto_key *key, const char *inkey)
 	buf = kmalloc(blen, GFP_NOFS);
 	if (!buf)
 		return -ENOMEM;
-	blen = ceph_unarmor(buf, inkey, inkey+inlen);
+	blen = base64_unarmor(buf, inkey, inkey+inlen);
 	if (blen < 0) {
 		kfree(buf);
 		return blen;
diff --git a/net/ceph/crypto.h b/net/ceph/crypto.h
index bb45c7d43739..a0236cbad530 100644
--- a/net/ceph/crypto.h
+++ b/net/ceph/crypto.h
@@ -29,8 +29,4 @@ int ceph_crypt(const struct ceph_crypto_key *key, bool encrypt,
 int ceph_crypto_init(void);
 void ceph_crypto_shutdown(void);
 
-/* armor.c */
-int ceph_armor(char *dst, const char *src, const char *end);
-int ceph_unarmor(char *dst, const char *src, const char *end);
-
 #endif
-- 
2.14.3
