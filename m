From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 10 Jun 2017 04:59:11 +0200
Message-Id: <20170610025912.6499-6-Jason@zx2c4.com>
In-Reply-To: <20170610025912.6499-1-Jason@zx2c4.com>
References: <20170610025912.6499-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH 5/6] bluetooth/smp: use constant time memory comparison for secret values
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Marcel Holtmann <marcel@holtmann.org>, Gustavo Padovan <gustavo@padovan.org>, Johan Hedberg <johan.hedberg@gmail.com>, linux-bluetooth@vger.kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This file is filled with complex cryptography. Thus, the comparisons of
MACs and secret keys and curve points and so forth should not add timing
attacks, which could either result in a direct forgery, or, given the
complexity, some other type of attack.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: linux-bluetooth@vger.kernel.org
Cc: stable@vger.kernel.org
---
 net/bluetooth/smp.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 14585edc9439..a0ef89772c36 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -23,6 +23,7 @@
 #include <linux/debugfs.h>
 #include <linux/scatterlist.h>
 #include <linux/crypto.h>
+#include <crypto/algapi.h>
 #include <crypto/b128ops.h>
 #include <crypto/hash.h>
 
@@ -523,7 +524,7 @@ bool smp_irk_matches(struct hci_dev *hdev, const u8 irk[16],
 	if (err)
 		return false;
 
-	return !memcmp(bdaddr->b, hash, 3);
+	return !crypto_memneq(bdaddr->b, hash, 3);
 }
 
 int smp_generate_rpa(struct hci_dev *hdev, const u8 irk[16], bdaddr_t *rpa)
@@ -579,7 +580,7 @@ int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16])
 			/* This is unlikely, but we need to check that
 			 * we didn't accidentially generate a debug key.
 			 */
-			if (memcmp(smp->local_sk, debug_sk, 32))
+			if (crypto_memneq(smp->local_sk, debug_sk, 32))
 				break;
 		}
 		smp->debug_key = false;
@@ -993,7 +994,7 @@ static u8 smp_random(struct smp_chan *smp)
 	if (ret)
 		return SMP_UNSPECIFIED;
 
-	if (memcmp(smp->pcnf, confirm, sizeof(smp->pcnf)) != 0) {
+	if (crypto_memneq(smp->pcnf, confirm, sizeof(smp->pcnf))) {
 		BT_ERR("Pairing failed (confirmation values mismatch)");
 		return SMP_CONFIRM_FAILED;
 	}
@@ -1512,7 +1513,7 @@ static u8 sc_passkey_round(struct smp_chan *smp, u8 smp_op)
 			   smp->rrnd, r, cfm))
 			return SMP_UNSPECIFIED;
 
-		if (memcmp(smp->pcnf, cfm, 16))
+		if (crypto_memneq(smp->pcnf, cfm, 16))
 			return SMP_CONFIRM_FAILED;
 
 		smp->passkey_round++;
@@ -1908,7 +1909,7 @@ static u8 sc_send_public_key(struct smp_chan *smp)
 			/* This is unlikely, but we need to check that
 			 * we didn't accidentially generate a debug key.
 			 */
-			if (memcmp(smp->local_sk, debug_sk, 32))
+			if (crypto_memneq(smp->local_sk, debug_sk, 32))
 				break;
 		}
 	}
@@ -2176,7 +2177,7 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 		if (err)
 			return SMP_UNSPECIFIED;
 
-		if (memcmp(smp->pcnf, cfm, 16))
+		if (crypto_memneq(smp->pcnf, cfm, 16))
 			return SMP_CONFIRM_FAILED;
 	} else {
 		smp_send_cmd(conn, SMP_CMD_PAIRING_RANDOM, sizeof(smp->prnd),
@@ -2660,7 +2661,7 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
 		if (err)
 			return SMP_UNSPECIFIED;
 
-		if (memcmp(cfm.confirm_val, smp->pcnf, 16))
+		if (crypto_memneq(cfm.confirm_val, smp->pcnf, 16))
 			return SMP_CONFIRM_FAILED;
 	}
 
@@ -2693,7 +2694,7 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
 	else
 		hcon->pending_sec_level = BT_SECURITY_FIPS;
 
-	if (!memcmp(debug_pk, smp->remote_pk, 64))
+	if (!crypto_memneq(debug_pk, smp->remote_pk, 64))
 		set_bit(SMP_FLAG_DEBUG_KEY, &smp->flags);
 
 	if (smp->method == DSP_PASSKEY) {
@@ -2792,7 +2793,7 @@ static int smp_cmd_dhkey_check(struct l2cap_conn *conn, struct sk_buff *skb)
 	if (err)
 		return SMP_UNSPECIFIED;
 
-	if (memcmp(check->e, e, 16))
+	if (crypto_memneq(check->e, e, 16))
 		return SMP_DHKEY_CHECK_FAILED;
 
 	if (!hcon->out) {
@@ -3506,10 +3507,10 @@ static int __init test_debug_key(void)
 	if (!generate_ecdh_keys(pk, sk))
 		return -EINVAL;
 
-	if (memcmp(sk, debug_sk, 32))
+	if (crypto_memneq(sk, debug_sk, 32))
 		return -EINVAL;
 
-	if (memcmp(pk, debug_pk, 64))
+	if (crypto_memneq(pk, debug_pk, 64))
 		return -EINVAL;
 
 	return 0;
@@ -3529,7 +3530,7 @@ static int __init test_ah(struct crypto_cipher *tfm_aes)
 	if (err)
 		return err;
 
-	if (memcmp(res, exp, 3))
+	if (crypto_memneq(res, exp, 3))
 		return -EINVAL;
 
 	return 0;
@@ -3559,7 +3560,7 @@ static int __init test_c1(struct crypto_cipher *tfm_aes)
 	if (err)
 		return err;
 
-	if (memcmp(res, exp, 16))
+	if (crypto_memneq(res, exp, 16))
 		return -EINVAL;
 
 	return 0;
@@ -3584,7 +3585,7 @@ static int __init test_s1(struct crypto_cipher *tfm_aes)
 	if (err)
 		return err;
 
-	if (memcmp(res, exp, 16))
+	if (crypto_memneq(res, exp, 16))
 		return -EINVAL;
 
 	return 0;
@@ -3616,7 +3617,7 @@ static int __init test_f4(struct crypto_shash *tfm_cmac)
 	if (err)
 		return err;
 
-	if (memcmp(res, exp, 16))
+	if (crypto_memneq(res, exp, 16))
 		return -EINVAL;
 
 	return 0;
@@ -3650,10 +3651,10 @@ static int __init test_f5(struct crypto_shash *tfm_cmac)
 	if (err)
 		return err;
 
-	if (memcmp(mackey, exp_mackey, 16))
+	if (crypto_memneq(mackey, exp_mackey, 16))
 		return -EINVAL;
 
-	if (memcmp(ltk, exp_ltk, 16))
+	if (crypto_memneq(ltk, exp_ltk, 16))
 		return -EINVAL;
 
 	return 0;
@@ -3686,7 +3687,7 @@ static int __init test_f6(struct crypto_shash *tfm_cmac)
 	if (err)
 		return err;
 
-	if (memcmp(res, exp, 16))
+	if (crypto_memneq(res, exp, 16))
 		return -EINVAL;
 
 	return 0;
@@ -3740,7 +3741,7 @@ static int __init test_h6(struct crypto_shash *tfm_cmac)
 	if (err)
 		return err;
 
-	if (memcmp(res, exp, 16))
+	if (crypto_memneq(res, exp, 16))
 		return -EINVAL;
 
 	return 0;
-- 
2.13.1
