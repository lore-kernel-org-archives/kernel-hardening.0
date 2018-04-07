From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH 4/6] crypto: pcbc - avoid VLA use
Date: Sat,  7 Apr 2018 20:38:21 +0200
Message-Id: <1523126303-23205-5-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
References: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

We avoid 2 VLAs[1] by always allocating MAX_BLOCKSIZE bytes.
We also check the selected cipher at instance creation time, if
it doesn't comply with these limits, the creation will fail.

[1] http://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 crypto/pcbc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index d9e45a9..797da2f 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/compiler.h>
+#include "internal.h"
 
 struct crypto_pcbc_ctx {
 	struct crypto_cipher *child;
@@ -72,7 +73,7 @@ static int crypto_pcbc_encrypt_inplace(struct skcipher_request *req,
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *iv = walk->iv;
-	u8 tmpbuf[bsize];
+	u8 tmpbuf[MAX_BLOCKSIZE];
 
 	do {
 		memcpy(tmpbuf, src, bsize);
@@ -144,7 +145,7 @@ static int crypto_pcbc_decrypt_inplace(struct skcipher_request *req,
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *iv = walk->iv;
-	u8 tmpbuf[bsize] __aligned(__alignof__(u32));
+	u8 tmpbuf[MAX_BLOCKSIZE] __aligned(__alignof__(u32));
 
 	do {
 		memcpy(tmpbuf, src, bsize);
@@ -251,6 +252,10 @@ static int crypto_pcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		goto err_drop_spawn;
 
+	err = -EINVAL;
+	if (alg->cra_blocksize > MAX_BLOCKSIZE)
+		goto err_drop_spawn;
+
 	inst->alg.base.cra_flags = alg->cra_flags & CRYPTO_ALG_INTERNAL;
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
-- 
1.9.1
