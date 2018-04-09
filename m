From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH 5/6] crypto: cts - avoid VLA use
Date: Mon,  9 Apr 2018 15:54:03 +0200
Message-Id: <1523282044-22075-6-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1523282044-22075-1-git-send-email-s.mesoraca16@gmail.com>
References: <1523282044-22075-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

We avoid 2 VLAs[1] by always allocating MAX_BLOCKSIZE*2 bytes.
We also check the selected cipher at instance creation time, if
it doesn't comply with these limits, the creation will fail.

[1] http://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 crypto/cts.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/crypto/cts.c b/crypto/cts.c
index 4773c18..12e6bd3 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -50,6 +50,7 @@
 #include <crypto/scatterwalk.h>
 #include <linux/slab.h>
 #include <linux/compiler.h>
+#include "internal.h"
 
 struct crypto_cts_ctx {
 	struct crypto_skcipher *child;
@@ -104,7 +105,7 @@ static int cts_cbc_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 	int bsize = crypto_skcipher_blocksize(tfm);
-	u8 d[bsize * 2] __aligned(__alignof__(u32));
+	u8 d[MAX_BLOCKSIZE * 2] __aligned(__alignof__(u32));
 	struct scatterlist *sg;
 	unsigned int offset;
 	int lastn;
@@ -183,7 +184,7 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 	int bsize = crypto_skcipher_blocksize(tfm);
-	u8 d[bsize * 2] __aligned(__alignof__(u32));
+	u8 d[MAX_BLOCKSIZE * 2] __aligned(__alignof__(u32));
 	struct scatterlist *sg;
 	unsigned int offset;
 	u8 *space;
@@ -359,6 +360,9 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (crypto_skcipher_alg_ivsize(alg) != alg->base.cra_blocksize)
 		goto err_drop_spawn;
 
+	if (alg->base.cra_blocksize > MAX_BLOCKSIZE)
+		goto err_drop_spawn;
+
 	if (strncmp(alg->base.cra_name, "cbc(", 4))
 		goto err_drop_spawn;
 
-- 
1.9.1
