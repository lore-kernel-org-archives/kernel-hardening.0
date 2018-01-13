From: Dan Aloni <dan@kernelim.com>
Date: Sat, 13 Jan 2018 23:34:35 +0200
Message-Id: <20180113213441.52047-2-dan@kernelim.com>
In-Reply-To: <20180113213441.52047-1-dan@kernelim.com>
References: <20180113213441.52047-1-dan@kernelim.com>
Subject: [kernel-hardening] [PATCHv2 1/7] crypto: fix memory leak in rsa-kcs1pad encryption
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>
List-ID: <kernel-hardening.lists.openwall.com>

The encryption mode of pkcs1pad never uses out_sg and out_buf, so
there's no need to allocate the buffer, which presently is not even
being freed.

CC: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Dan Aloni <dan@kernelim.com>
---
 crypto/rsa-pkcs1pad.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 2908f93c3e55..e8354084ef4e 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -261,15 +261,6 @@ static int pkcs1pad_encrypt(struct akcipher_request *req)
 	pkcs1pad_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
 			ctx->key_size - 1 - req->src_len, req->src);
 
-	req_ctx->out_buf = kmalloc(ctx->key_size, GFP_KERNEL);
-	if (!req_ctx->out_buf) {
-		kfree(req_ctx->in_buf);
-		return -ENOMEM;
-	}
-
-	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
-			ctx->key_size, NULL);
-
 	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
 	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
 			pkcs1pad_encrypt_sign_complete_cb, req);
-- 
2.14.3
