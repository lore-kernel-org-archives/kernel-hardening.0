From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 10 Jun 2017 04:59:09 +0200
Message-Id: <20170610025912.6499-4-Jason@zx2c4.com>
In-Reply-To: <20170610025912.6499-1-Jason@zx2c4.com>
References: <20170610025912.6499-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH 3/6] ccree: use constant time memory comparison for macs and tags
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Gilad Ben-Yossef <gilad@benyossef.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Otherwise, we enable several different forgeries via timing attack.

While the C inside this file is nearly incomprehensible, I did notice a
high volume of "FIPS" and "NIST", which makes this kind of bug slightly
more embarrassing.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
---
 drivers/staging/ccree/ssi_fips_ll.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips_ll.c b/drivers/staging/ccree/ssi_fips_ll.c
index d573574bbb98..3310997d8e3e 100644
--- a/drivers/staging/ccree/ssi_fips_ll.c
+++ b/drivers/staging/ccree/ssi_fips_ll.c
@@ -19,6 +19,7 @@ This file defines the driver FIPS Low Level implmentaion functions,
 that executes the KAT.
 ***************************************************************/
 #include <linux/kernel.h>
+#include <crypto/algapi.h>
 
 #include "ssi_driver.h"
 #include "ssi_fips_local.h"
@@ -462,7 +463,7 @@ ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffe
 		}
 
 		/* compare actual dout to expected */
-		if (memcmp(virt_ctx->dout, cipherData->dataOut, cipherData->dataInSize) != 0)
+		if (crypto_memneq(virt_ctx->dout, cipherData->dataOut, cipherData->dataInSize))
 		{
 			FIPS_LOG("dout comparison error %d - oprMode=%d, isAes=%d\n", i, cipherData->oprMode, cipherData->isAes);
 			FIPS_LOG("  i  expected   received \n");
@@ -586,7 +587,7 @@ ssi_cmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 		}
 
 		/* compare actual mac result to expected */
-		if (memcmp(virt_ctx->mac_res, cmac_data->mac_res, cmac_data->mac_res_size) != 0)
+		if (crypto_memneq(virt_ctx->mac_res, cmac_data->mac_res, cmac_data->mac_res_size))
 		{
 			FIPS_LOG("comparison error %d - digest_size=%d \n", i, cmac_data->mac_res_size);
 			FIPS_LOG("  i  expected   received \n");
@@ -760,7 +761,7 @@ ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
                 }
 
 		/* compare actual mac result to expected */
-		if (memcmp(virt_ctx->mac_res, hash_data->mac_res, digest_size) != 0)
+		if (crypto_memneq(virt_ctx->mac_res, hash_data->mac_res, digest_size))
 		{
 			FIPS_LOG("comparison error %d - hash_mode=%d digest_size=%d \n", i, hash_data->hash_mode, digest_size);
 			FIPS_LOG("  i  expected   received \n");
@@ -1093,7 +1094,7 @@ ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 		}
 
 		/* compare actual mac result to expected */
-		if (memcmp(virt_ctx->mac_res, hmac_data->mac_res, digest_size) != 0)
+		if (crypto_memneq(virt_ctx->mac_res, hmac_data->mac_res, digest_size))
 		{
 			FIPS_LOG("comparison error %d - hash_mode=%d digest_size=%d \n", i, hmac_data->hash_mode, digest_size);
 			FIPS_LOG("  i  expected   received \n");
@@ -1310,7 +1311,7 @@ ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 		}
 
 		/* compare actual dout to expected */
-		if (memcmp(virt_ctx->dout, ccmData->dataOut, ccmData->dataInSize) != 0)
+		if (crypto_memneq(virt_ctx->dout, ccmData->dataOut, ccmData->dataInSize))
 		{
 			FIPS_LOG("dout comparison error %d - size=%d \n", i, ccmData->dataInSize);
                         error = CC_REE_FIPS_ERROR_AESCCM_PUT;
@@ -1318,7 +1319,7 @@ ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
                 }
 
 		/* compare actual mac result to expected */
-		if (memcmp(virt_ctx->mac_res, ccmData->macResOut, ccmData->tagSize) != 0)
+		if (crypto_memneq(virt_ctx->mac_res, ccmData->macResOut, ccmData->tagSize))
 		{
 			FIPS_LOG("mac_res comparison error %d - mac_size=%d \n", i, ccmData->tagSize);
 			FIPS_LOG("  i  expected   received \n");
@@ -1633,7 +1634,7 @@ ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 
 		if (gcmData->direction == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 			/* compare actual dout to expected */
-			if (memcmp(virt_ctx->dout, gcmData->dataOut, gcmData->dataInSize) != 0)
+			if (crypto_memneq(virt_ctx->dout, gcmData->dataOut, gcmData->dataInSize))
 			{
 				FIPS_LOG("dout comparison error %d - size=%d \n", i, gcmData->dataInSize);
 				FIPS_LOG("  i  expected   received \n");
@@ -1649,7 +1650,7 @@ ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 		}
 
 		/* compare actual mac result to expected */
-		if (memcmp(virt_ctx->mac_res, gcmData->macResOut, gcmData->tagSize) != 0)
+		if (crypto_memneq(virt_ctx->mac_res, gcmData->macResOut, gcmData->tagSize))
 		{
 			FIPS_LOG("mac_res comparison error %d - mac_size=%d \n", i, gcmData->tagSize);
 			FIPS_LOG("  i  expected   received \n");
-- 
2.13.1
