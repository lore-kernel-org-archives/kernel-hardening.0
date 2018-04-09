From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH 2/6] crypto: ctr - avoid VLA use
Date: Mon,  9 Apr 2018 15:54:00 +0200
Message-Id: <1523282044-22075-3-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1523282044-22075-1-git-send-email-s.mesoraca16@gmail.com>
References: <1523282044-22075-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

We avoid 2 VLAs[1] by always allocating MAX_BLOCKSIZE +
MAX_ALIGNMASK bytes.
We also check the selected cipher at instance creation time, if
it doesn't comply with these limits, the creation will fail.

[1] http://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 crypto/ctr.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index 854d924..ce62552 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -20,6 +20,7 @@
 #include <linux/random.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include "internal.h"
 
 struct crypto_ctr_ctx {
 	struct crypto_cipher *child;
@@ -58,7 +59,7 @@ static void crypto_ctr_crypt_final(struct blkcipher_walk *walk,
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
 	unsigned long alignmask = crypto_cipher_alignmask(tfm);
 	u8 *ctrblk = walk->iv;
-	u8 tmp[bsize + alignmask];
+	u8 tmp[MAX_BLOCKSIZE + MAX_ALIGNMASK];
 	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
@@ -106,7 +107,7 @@ static int crypto_ctr_crypt_inplace(struct blkcipher_walk *walk,
 	unsigned int nbytes = walk->nbytes;
 	u8 *ctrblk = walk->iv;
 	u8 *src = walk->src.virt.addr;
-	u8 tmp[bsize + alignmask];
+	u8 tmp[MAX_BLOCKSIZE + MAX_ALIGNMASK];
 	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
 
 	do {
@@ -206,6 +207,14 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 	if (alg->cra_blocksize < 4)
 		goto out_put_alg;
 
+	/* Block size must be <= MAX_BLOCKSIZE. */
+	if (alg->cra_blocksize > MAX_BLOCKSIZE)
+		goto out_put_alg;
+
+	/* Alignmask must be <= MAX_ALIGNMASK. */
+	if (alg->cra_alignmask > MAX_ALIGNMASK)
+		goto out_put_alg;
+
 	/* If this is false we'd fail the alignment of crypto_inc. */
 	if (alg->cra_blocksize % 4)
 		goto out_put_alg;
-- 
1.9.1
