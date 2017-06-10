From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 10 Jun 2017 04:59:10 +0200
Message-Id: <20170610025912.6499-5-Jason@zx2c4.com>
In-Reply-To: <20170610025912.6499-1-Jason@zx2c4.com>
References: <20170610025912.6499-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH 4/6] security/keys: use constant time memory comparison for macs
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, David Safford <safford@us.ibm.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Otherwise, we enable a MAC forgery via timing attack.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: David Safford <safford@us.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org
Cc: stable@vger.kernel.org
---
 security/keys/trusted.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 2ae31c5a87de..df7d30b0a6f7 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -11,6 +11,7 @@
  * See Documentation/security/keys-trusted-encrypted.txt
  */
 
+#include <crypto/algapi.h>
 #include <crypto/hash_info.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
@@ -243,7 +244,7 @@ static int TSS_checkhmac1(unsigned char *buffer,
 	if (ret < 0)
 		goto out;
 
-	if (memcmp(testhmac, authdata, SHA1_DIGEST_SIZE))
+	if (crypto_memneq(testhmac, authdata, SHA1_DIGEST_SIZE))
 		ret = -EINVAL;
 out:
 	kfree(sdesc);
@@ -335,7 +336,7 @@ static int TSS_checkhmac2(unsigned char *buffer,
 			  TPM_NONCE_SIZE, ononce, 1, continueflag1, 0, 0);
 	if (ret < 0)
 		goto out;
-	if (memcmp(testhmac1, authdata1, SHA1_DIGEST_SIZE)) {
+	if (crypto_memneq(testhmac1, authdata1, SHA1_DIGEST_SIZE)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -344,7 +345,7 @@ static int TSS_checkhmac2(unsigned char *buffer,
 			  TPM_NONCE_SIZE, ononce, 1, continueflag2, 0, 0);
 	if (ret < 0)
 		goto out;
-	if (memcmp(testhmac2, authdata2, SHA1_DIGEST_SIZE))
+	if (crypto_memneq(testhmac2, authdata2, SHA1_DIGEST_SIZE))
 		ret = -EINVAL;
 out:
 	kfree(sdesc);
-- 
2.13.1
