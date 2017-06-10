From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 10 Jun 2017 04:59:12 +0200
Message-Id: <20170610025912.6499-7-Jason@zx2c4.com>
In-Reply-To: <20170610025912.6499-1-Jason@zx2c4.com>
References: <20170610025912.6499-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH 6/6] mac80211/wpa: use constant time memory comparison for MACs
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Otherwise, we enable all sorts of forgeries via timing attack.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Cc: stable@vger.kernel.org
---
 net/mac80211/wpa.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index c1ef22df865f..cc19614ff4e6 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -17,6 +17,7 @@
 #include <asm/unaligned.h>
 #include <net/mac80211.h>
 #include <crypto/aes.h>
+#include <crypto/algapi.h>
 
 #include "ieee80211_i.h"
 #include "michael.h"
@@ -153,7 +154,7 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 	data_len = skb->len - hdrlen - MICHAEL_MIC_LEN;
 	key = &rx->key->conf.key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY];
 	michael_mic(key, hdr, data, data_len, mic);
-	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0)
+	if (crypto_memneq(mic, data + data_len, MICHAEL_MIC_LEN))
 		goto mic_fail;
 
 	/* remove Michael MIC from payload */
@@ -1048,7 +1049,7 @@ ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx)
 		bip_aad(skb, aad);
 		ieee80211_aes_cmac(key->u.aes_cmac.tfm, aad,
 				   skb->data + 24, skb->len - 24, mic);
-		if (memcmp(mic, mmie->mic, sizeof(mmie->mic)) != 0) {
+		if (crypto_memneq(mic, mmie->mic, sizeof(mmie->mic))) {
 			key->u.aes_cmac.icverrors++;
 			return RX_DROP_UNUSABLE;
 		}
@@ -1098,7 +1099,7 @@ ieee80211_crypto_aes_cmac_256_decrypt(struct ieee80211_rx_data *rx)
 		bip_aad(skb, aad);
 		ieee80211_aes_cmac_256(key->u.aes_cmac.tfm, aad,
 				       skb->data + 24, skb->len - 24, mic);
-		if (memcmp(mic, mmie->mic, sizeof(mmie->mic)) != 0) {
+		if (crypto_memneq(mic, mmie->mic, sizeof(mmie->mic))) {
 			key->u.aes_cmac.icverrors++;
 			return RX_DROP_UNUSABLE;
 		}
@@ -1202,7 +1203,7 @@ ieee80211_crypto_aes_gmac_decrypt(struct ieee80211_rx_data *rx)
 		if (ieee80211_aes_gmac(key->u.aes_gmac.tfm, aad, nonce,
 				       skb->data + 24, skb->len - 24,
 				       mic) < 0 ||
-		    memcmp(mic, mmie->mic, sizeof(mmie->mic)) != 0) {
+		    crypto_memneq(mic, mmie->mic, sizeof(mmie->mic))) {
 			key->u.aes_gmac.icverrors++;
 			return RX_DROP_UNUSABLE;
 		}
-- 
2.13.1
