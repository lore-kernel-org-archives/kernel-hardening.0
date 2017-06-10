From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 10 Jun 2017 04:59:07 +0200
Message-Id: <20170610025912.6499-2-Jason@zx2c4.com>
In-Reply-To: <20170610025912.6499-1-Jason@zx2c4.com>
References: <20170610025912.6499-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH 1/6] sunrpc: use constant time memory comparison for mac
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Otherwise, we enable a MAC forgery via timing attack.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: linux-nfs@vger.kernel.org
Cc: stable@vger.kernel.org
---
 net/sunrpc/auth_gss/gss_krb5_crypto.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_crypto.c b/net/sunrpc/auth_gss/gss_krb5_crypto.c
index fb39284ec174..12649c9fedab 100644
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c
+++ b/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -34,6 +34,7 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
+#include <crypto/algapi.h>
 #include <crypto/hash.h>
 #include <crypto/skcipher.h>
 #include <linux/err.h>
@@ -927,7 +928,7 @@ gss_krb5_aes_decrypt(struct krb5_ctx *kctx, u32 offset, struct xdr_buf *buf,
 	if (ret)
 		goto out_err;
 
-	if (memcmp(pkt_hmac, our_hmac, kctx->gk5e->cksumlength) != 0) {
+	if (crypto_memneq(pkt_hmac, our_hmac, kctx->gk5e->cksumlength) != 0) {
 		ret = GSS_S_BAD_SIG;
 		goto out_err;
 	}
-- 
2.13.1
