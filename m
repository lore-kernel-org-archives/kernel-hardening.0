From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH v2 2/2] crypto: remove several VLAs
Date: Mon,  9 Apr 2018 15:54:47 +0200
Message-Id: <1523282087-22128-3-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1523282087-22128-1-git-send-email-s.mesoraca16@gmail.com>
References: <1523282087-22128-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

We avoid various VLAs[1] by using constant expressions for block size
and alignment mask.

[1] http://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 crypto/cfb.c    | 7 +++----
 crypto/cipher.c | 3 ++-
 crypto/ctr.c    | 4 ++--
 crypto/cts.c    | 5 +++--
 crypto/pcbc.c   | 5 +++--
 5 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/crypto/cfb.c b/crypto/cfb.c
index 94ee39b..a0d68c0 100644
--- a/crypto/cfb.c
+++ b/crypto/cfb.c
@@ -53,9 +53,8 @@ static void crypto_cfb_encrypt_one(struct crypto_skcipher *tfm,
 static void crypto_cfb_final(struct skcipher_walk *walk,
 			     struct crypto_skcipher *tfm)
 {
-	const unsigned int bsize = crypto_cfb_bsize(tfm);
 	const unsigned long alignmask = crypto_skcipher_alignmask(tfm);
-	u8 tmp[bsize + alignmask];
+	u8 tmp[MAX_CIPHER_BLOCKSIZE + MAX_CIPHER_ALIGNMASK];
 	u8 *stream = PTR_ALIGN(tmp + 0, alignmask + 1);
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
@@ -94,7 +93,7 @@ static int crypto_cfb_encrypt_inplace(struct skcipher_walk *walk,
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *iv = walk->iv;
-	u8 tmp[bsize];
+	u8 tmp[MAX_CIPHER_BLOCKSIZE];
 
 	do {
 		crypto_cfb_encrypt_one(tfm, iv, tmp);
@@ -164,7 +163,7 @@ static int crypto_cfb_decrypt_inplace(struct skcipher_walk *walk,
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *iv = walk->iv;
-	u8 tmp[bsize];
+	u8 tmp[MAX_CIPHER_BLOCKSIZE];
 
 	do {
 		crypto_cfb_encrypt_one(tfm, iv, tmp);
diff --git a/crypto/cipher.c b/crypto/cipher.c
index 94fa355..57836c3 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -13,6 +13,7 @@
  *
  */
 
+#include <crypto/algapi.h>
 #include <linux/kernel.h>
 #include <linux/crypto.h>
 #include <linux/errno.h>
@@ -67,7 +68,7 @@ static void cipher_crypt_unaligned(void (*fn)(struct crypto_tfm *, u8 *,
 {
 	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
 	unsigned int size = crypto_tfm_alg_blocksize(tfm);
-	u8 buffer[size + alignmask];
+	u8 buffer[MAX_CIPHER_BLOCKSIZE + MAX_CIPHER_ALIGNMASK];
 	u8 *tmp = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 
 	memcpy(tmp, src, size);
diff --git a/crypto/ctr.c b/crypto/ctr.c
index 854d924..435b75b 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -58,7 +58,7 @@ static void crypto_ctr_crypt_final(struct blkcipher_walk *walk,
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
 	unsigned long alignmask = crypto_cipher_alignmask(tfm);
 	u8 *ctrblk = walk->iv;
-	u8 tmp[bsize + alignmask];
+	u8 tmp[MAX_CIPHER_BLOCKSIZE + MAX_CIPHER_ALIGNMASK];
 	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
@@ -106,7 +106,7 @@ static int crypto_ctr_crypt_inplace(struct blkcipher_walk *walk,
 	unsigned int nbytes = walk->nbytes;
 	u8 *ctrblk = walk->iv;
 	u8 *src = walk->src.virt.addr;
-	u8 tmp[bsize + alignmask];
+	u8 tmp[MAX_CIPHER_BLOCKSIZE + MAX_CIPHER_ALIGNMASK];
 	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
 
 	do {
diff --git a/crypto/cts.c b/crypto/cts.c
index 4773c18..4e28d83 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -40,6 +40,7 @@
  * rfc3962 includes errata information in its Appendix A.
  */
 
+#include <crypto/algapi.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -104,7 +105,7 @@ static int cts_cbc_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 	int bsize = crypto_skcipher_blocksize(tfm);
-	u8 d[bsize * 2] __aligned(__alignof__(u32));
+	u8 d[MAX_CIPHER_BLOCKSIZE * 2] __aligned(__alignof__(u32));
 	struct scatterlist *sg;
 	unsigned int offset;
 	int lastn;
@@ -183,7 +184,7 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 	int bsize = crypto_skcipher_blocksize(tfm);
-	u8 d[bsize * 2] __aligned(__alignof__(u32));
+	u8 d[MAX_CIPHER_BLOCKSIZE * 2] __aligned(__alignof__(u32));
 	struct scatterlist *sg;
 	unsigned int offset;
 	u8 *space;
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index d9e45a9..ef802f6 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -14,6 +14,7 @@
  *
  */
 
+#include <crypto/algapi.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -72,7 +73,7 @@ static int crypto_pcbc_encrypt_inplace(struct skcipher_request *req,
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *iv = walk->iv;
-	u8 tmpbuf[bsize];
+	u8 tmpbuf[MAX_CIPHER_BLOCKSIZE];
 
 	do {
 		memcpy(tmpbuf, src, bsize);
@@ -144,7 +145,7 @@ static int crypto_pcbc_decrypt_inplace(struct skcipher_request *req,
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *iv = walk->iv;
-	u8 tmpbuf[bsize] __aligned(__alignof__(u32));
+	u8 tmpbuf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(u32));
 
 	do {
 		memcpy(tmpbuf, src, bsize);
-- 
1.9.1
