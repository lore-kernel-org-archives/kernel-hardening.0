From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon,  5 Jun 2017 05:47:53 +0200
Message-Id: <20170605034757.4803-5-Jason@zx2c4.com>
In-Reply-To: <20170605034757.4803-1-Jason@zx2c4.com>
References: <20170605034757.4803-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH RFC v2 4/8] crypto/rng: ensure that the RNG is ready before using
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>
List-ID: <kernel-hardening.lists.openwall.com>

Otherwise, we might be seeding the RNG using bad randomness, which is
dangerous.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 crypto/rng.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index f46dac5288b9..e042437e64b4 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -48,12 +48,14 @@ int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 		if (!buf)
 			return -ENOMEM;
 
-		get_random_bytes(buf, slen);
+		err = get_random_bytes_wait(buf, slen);
+		if (err)
+			goto out;
 		seed = buf;
 	}
 
 	err = crypto_rng_alg(tfm)->seed(tfm, seed, slen);
-
+out:
 	kzfree(buf);
 	return err;
 }
-- 
2.13.0
