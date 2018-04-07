From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH 6/6] crypto: cfb - avoid VLA use
Date: Sat,  7 Apr 2018 20:38:23 +0200
Message-Id: <1523126303-23205-7-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
References: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

We avoid 3 VLAs[1] by always allocating MAX_BLOCKSIZE bytes or,
when needed for alignement, MAX_BLOCKSIZE + MAX_ALIGNMASK bytes.
We also check the selected cipher at instance creation time, if
it doesn't comply with these limits, the creation will fail.

[1] http://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 crypto/cfb.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/crypto/cfb.c b/crypto/cfb.c
index 94ee39b..f500816 100644
--- a/crypto/cfb.c
+++ b/crypto/cfb.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include "internal.h"
 
 struct crypto_cfb_ctx {
 	struct crypto_cipher *child;
@@ -53,9 +54,8 @@ static void crypto_cfb_encrypt_one(struct crypto_skcipher *tfm,
 static void crypto_cfb_final(struct skcipher_walk *walk,
 			     struct crypto_skcipher *tfm)
 {
-	const unsigned int bsize = crypto_cfb_bsize(tfm);
 	const unsigned long alignmask = crypto_skcipher_alignmask(tfm);
-	u8 tmp[bsize + alignmask];
+	u8 tmp[MAX_BLOCKSIZE + MAX_ALIGNMASK];
 	u8 *stream = PTR_ALIGN(tmp + 0, alignmask + 1);
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
@@ -94,7 +94,7 @@ static int crypto_cfb_encrypt_inplace(struct skcipher_walk *walk,
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *iv = walk->iv;
-	u8 tmp[bsize];
+	u8 tmp[MAX_BLOCKSIZE];
 
 	do {
 		crypto_cfb_encrypt_one(tfm, iv, tmp);
@@ -164,7 +164,7 @@ static int crypto_cfb_decrypt_inplace(struct skcipher_walk *walk,
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *iv = walk->iv;
-	u8 tmp[bsize];
+	u8 tmp[MAX_BLOCKSIZE];
 
 	do {
 		crypto_cfb_encrypt_one(tfm, iv, tmp);
@@ -295,6 +295,12 @@ static int crypto_cfb_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		goto err_drop_spawn;
 
+	err = -EINVAL;
+	if (alg->cra_blocksize > MAX_BLOCKSIZE)
+		goto err_drop_spawn;
+	if (alg->cra_alignmask > MAX_ALIGNMASK)
+		goto err_drop_spawn;
+
 	inst->alg.base.cra_priority = alg->cra_priority;
 	/* we're a stream cipher independend of the crypto cra_blocksize */
 	inst->alg.base.cra_blocksize = 1;
-- 
1.9.1
