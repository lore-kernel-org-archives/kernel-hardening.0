From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH] crypto: ctr: avoid VLA use
Date: Wed, 14 Mar 2018 14:17:30 +0100
Message-Id: <1521033450-14447-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

All ciphers implemented in Linux have a block size less than or
equal to 16 bytes and the most demanding hw require 16 bits
alignment for the block buffer.
We avoid 2 VLAs[1] by always allocating 16 bytes with 16 bits
alignment, unless the architecture support efficient unaligned
accesses.
We also check, at runtime, that our assumptions still stand,
possibly dynamically allocating a new buffer, just in case
something changes in the future.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---

Notes:
    Can we maybe skip the runtime check?

 crypto/ctr.c | 50 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 8 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index 854d924..f37adf0 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -35,6 +35,16 @@ struct crypto_rfc3686_req_ctx {
 	struct skcipher_request subreq CRYPTO_MINALIGN_ATTR;
 };
 
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+#define DECLARE_CIPHER_BUFFER(name) u8 name[16]
+#else
+#define DECLARE_CIPHER_BUFFER(name) u8 __aligned(16) name[16]
+#endif
+
+#define CHECK_CIPHER_BUFFER(name, size, align)			\
+	likely(size <= sizeof(name) &&				\
+	       name == PTR_ALIGN(((u8 *) name), align + 1))
+
 static int crypto_ctr_setkey(struct crypto_tfm *parent, const u8 *key,
 			     unsigned int keylen)
 {
@@ -52,22 +62,35 @@ static int crypto_ctr_setkey(struct crypto_tfm *parent, const u8 *key,
 	return err;
 }
 
-static void crypto_ctr_crypt_final(struct blkcipher_walk *walk,
-				   struct crypto_cipher *tfm)
+static int crypto_ctr_crypt_final(struct blkcipher_walk *walk,
+				  struct crypto_cipher *tfm)
 {
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
 	unsigned long alignmask = crypto_cipher_alignmask(tfm);
 	u8 *ctrblk = walk->iv;
-	u8 tmp[bsize + alignmask];
-	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
 	unsigned int nbytes = walk->nbytes;
+	DECLARE_CIPHER_BUFFER(tmp);
+	u8 *keystream, *tmp2;
+
+	if (CHECK_CIPHER_BUFFER(tmp, bsize, alignmask))
+		keystream = tmp;
+	else {
+		tmp2 = kmalloc(bsize + alignmask, GFP_ATOMIC);
+		if (!tmp2)
+			return -ENOMEM;
+		keystream = PTR_ALIGN(tmp2 + 0, alignmask + 1);
+	}
 
 	crypto_cipher_encrypt_one(tfm, keystream, ctrblk);
 	crypto_xor_cpy(dst, keystream, src, nbytes);
 
 	crypto_inc(ctrblk, bsize);
+
+	if (unlikely(keystream != tmp))
+		kfree(tmp2);
+	return 0;
 }
 
 static int crypto_ctr_crypt_segment(struct blkcipher_walk *walk,
@@ -106,8 +129,17 @@ static int crypto_ctr_crypt_inplace(struct blkcipher_walk *walk,
 	unsigned int nbytes = walk->nbytes;
 	u8 *ctrblk = walk->iv;
 	u8 *src = walk->src.virt.addr;
-	u8 tmp[bsize + alignmask];
-	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
+	DECLARE_CIPHER_BUFFER(tmp);
+	u8 *keystream, *tmp2;
+
+	if (CHECK_CIPHER_BUFFER(tmp, bsize, alignmask))
+		keystream = tmp;
+	else {
+		tmp2 = kmalloc(bsize + alignmask, GFP_ATOMIC);
+		if (!tmp2)
+			return -ENOMEM;
+		keystream = PTR_ALIGN(tmp2 + 0, alignmask + 1);
+	}
 
 	do {
 		/* create keystream */
@@ -120,6 +152,8 @@ static int crypto_ctr_crypt_inplace(struct blkcipher_walk *walk,
 		src += bsize;
 	} while ((nbytes -= bsize) >= bsize);
 
+	if (unlikely(keystream != tmp))
+		kfree(tmp2);
 	return nbytes;
 }
 
@@ -147,8 +181,8 @@ static int crypto_ctr_crypt(struct blkcipher_desc *desc,
 	}
 
 	if (walk.nbytes) {
-		crypto_ctr_crypt_final(&walk, child);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = crypto_ctr_crypt_final(&walk, child);
+		err = blkcipher_walk_done(desc, &walk, err);
 	}
 
 	return err;
-- 
1.9.1
