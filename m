Date: Wed, 7 Mar 2018 13:56:15 -0800
From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] crypto/ecc: Remove stack VLA usage
Message-ID: <20180307215615.GA18928@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On the quest to remove all VLAs from the kernel[1], this switches to
a pair of kmalloc regions instead of using the stack. This also moves
the get_random_bytes() after all allocations (and drops the needless
"nbytes" variable).

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/ecc.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 18f32f2a5e1c..5bfa63603da0 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1025,9 +1025,7 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 {
 	int ret = 0;
 	struct ecc_point *product, *pk;
-	u64 priv[ndigits];
-	u64 rand_z[ndigits];
-	unsigned int nbytes;
+	u64 *priv, *rand_z;
 	const struct ecc_curve *curve = ecc_get_curve(curve_id);
 
 	if (!private_key || !public_key || !curve) {
@@ -1035,14 +1033,22 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 		goto out;
 	}
 
-	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
+	priv = kmalloc_array(ndigits, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	get_random_bytes(rand_z, nbytes);
+	rand_z = kmalloc_array(ndigits, sizeof(*rand_z), GFP_KERNEL);
+	if (!rand_z) {
+		ret = -ENOMEM;
+		goto kfree_out;
+	}
 
 	pk = ecc_alloc_point(ndigits);
 	if (!pk) {
 		ret = -ENOMEM;
-		goto out;
+		goto kfree_out;
 	}
 
 	product = ecc_alloc_point(ndigits);
@@ -1051,6 +1057,8 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 		goto err_alloc_product;
 	}
 
+	get_random_bytes(rand_z, ndigits << ECC_DIGITS_TO_BYTES_SHIFT);
+
 	ecc_swap_digits(public_key, pk->x, ndigits);
 	ecc_swap_digits(&public_key[ndigits], pk->y, ndigits);
 	ecc_swap_digits(private_key, priv, ndigits);
@@ -1065,6 +1073,9 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 	ecc_free_point(product);
 err_alloc_product:
 	ecc_free_point(pk);
+kfree_out:
+	kfree(priv);
+	kfree(rand_z);
 out:
 	return ret;
 }
-- 
2.7.4


-- 
Kees Cook
Pixel Security
