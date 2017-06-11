From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sun, 11 Jun 2017 23:20:23 +0200
Message-Id: <20170611212023.31101-1-Jason@zx2c4.com>
In-Reply-To: <20170610025912.6499-1-Jason@zx2c4.com>
References: <20170610025912.6499-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH] rsa-pkcs1pad: use constant time memory comparison for MACs
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Otherwise, we enable all sorts of forgeries via timing attack.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Suggested-by: Stephan Müller <smueller@chronox.de>
Cc: stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
---
 crypto/rsa-pkcs1pad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 8baab4307f7b..7830d304dff6 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -496,7 +496,7 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 		goto done;
 	pos++;
 
-	if (memcmp(out_buf + pos, digest_info->data, digest_info->size))
+	if (crypto_memneq(out_buf + pos, digest_info->data, digest_info->size))
 		goto done;
 
 	pos += digest_info->size;
-- 
2.13.1
