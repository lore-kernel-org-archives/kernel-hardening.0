From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH v2 1/2] crypto: api - laying defines and checks for statically allocated buffers
Date: Mon,  9 Apr 2018 15:54:46 +0200
Message-Id: <1523282087-22128-2-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1523282087-22128-1-git-send-email-s.mesoraca16@gmail.com>
References: <1523282087-22128-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

In preparation for the removal of VLAs[1] from crypto code.
We create 2 new compile-time constants: all ciphers implemented
in Linux have a block size less than or equal to 16 bytes and
the most demanding hw require 16 bytes alignment for the block
buffer.
We also enforce these limits in crypto_check_alg when a new
cipher is registered.

[1] http://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 crypto/algapi.c         | 10 ++++++++++
 include/crypto/algapi.h |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 2a0271b..c0755cf 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -10,6 +10,7 @@
  *
  */
 
+#include <crypto/algapi.h>
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/fips.h>
@@ -59,6 +60,15 @@ static int crypto_check_alg(struct crypto_alg *alg)
 	if (alg->cra_blocksize > PAGE_SIZE / 8)
 		return -EINVAL;
 
+	if (!alg->cra_type && (alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+			       CRYPTO_ALG_TYPE_CIPHER) {
+		if (alg->cra_alignmask > MAX_CIPHER_ALIGNMASK)
+			return -EINVAL;
+
+		if (alg->cra_blocksize > MAX_CIPHER_BLOCKSIZE)
+			return -EINVAL;
+	}
+
 	if (alg->cra_priority < 0)
 		return -EINVAL;
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 1aba888..bd5e8cc 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -17,6 +17,14 @@
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 
+/*
+ * Maximum values for blocksize and alignmask, used to allocate
+ * static buffers that are big enough for any combination of
+ * ciphers and architectures.
+ */
+#define MAX_CIPHER_BLOCKSIZE		16
+#define MAX_CIPHER_ALIGNMASK		15
+
 struct crypto_aead;
 struct crypto_instance;
 struct module;
-- 
1.9.1
