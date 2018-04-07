From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH 3/6] crypto: api - avoid VLA use
Date: Sat,  7 Apr 2018 20:38:20 +0200
Message-Id: <1523126303-23205-4-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
References: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

We avoid a VLA[1] by always allocating MAX_BLOCKSIZE +
MAX_ALIGNMASK bytes.
We also check the selected cipher at initialization time, if
it doesn't comply with these limits, the initialization will
fail.

[1] http://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 crypto/cipher.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/crypto/cipher.c b/crypto/cipher.c
index 94fa355..9cedf23 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -67,7 +67,7 @@ static void cipher_crypt_unaligned(void (*fn)(struct crypto_tfm *, u8 *,
 {
 	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
 	unsigned int size = crypto_tfm_alg_blocksize(tfm);
-	u8 buffer[size + alignmask];
+	u8 buffer[MAX_BLOCKSIZE + MAX_ALIGNMASK];
 	u8 *tmp = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 
 	memcpy(tmp, src, size);
@@ -105,9 +105,14 @@ static void cipher_decrypt_unaligned(struct crypto_tfm *tfm,
 
 int crypto_init_cipher_ops(struct crypto_tfm *tfm)
 {
+	const unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
+	const unsigned int size = crypto_tfm_alg_blocksize(tfm);
 	struct cipher_tfm *ops = &tfm->crt_cipher;
 	struct cipher_alg *cipher = &tfm->__crt_alg->cra_cipher;
 
+	if (size > MAX_BLOCKSIZE || alignmask > MAX_ALIGNMASK)
+		return -EINVAL;
+
 	ops->cit_setkey = setkey;
 	ops->cit_encrypt_one = crypto_tfm_alg_alignmask(tfm) ?
 		cipher_encrypt_unaligned : cipher->cia_encrypt;
-- 
1.9.1
