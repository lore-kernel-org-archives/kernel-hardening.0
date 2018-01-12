From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jan 2018 16:48:02 -0800
Message-ID: <151571808286.27429.10595818963597903281.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 18/19] cw1200: prevent bounds-check bypass via
 speculative execution
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, Elena Reshetova <elena.reshetova@intel.com>, Solomon Peachy <pizza@shaftnet.org>, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, Kalle Valo <kvalo@codeaurora.org>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Static analysis reports that 'queue' may be a user controlled value that
is used as a data dependency to read 'txq_params' from the
'priv->tx_queue_params.params' array.  In order to avoid potential leaks
of kernel memory values, block speculative execution of the instruction
stream that could issue reads based on an invalid value of 'txq_params'.
In this case 'txq_params' is referenced later in the function.

Based on an original patch by Elena Reshetova.

Cc: Solomon Peachy <pizza@shaftnet.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/net/wireless/st/cw1200/sta.c |   11 +++++++----
 drivers/net/wireless/st/cw1200/wsm.h |    4 +---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index 38678e9a0562..7521077e50a4 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -14,6 +14,7 @@
 #include <linux/firmware.h>
 #include <linux/module.h>
 #include <linux/etherdevice.h>
+#include <linux/nospec.h>
 
 #include "cw1200.h"
 #include "sta.h"
@@ -612,18 +613,20 @@ int cw1200_conf_tx(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
 		   u16 queue, const struct ieee80211_tx_queue_params *params)
 {
 	struct cw1200_common *priv = dev->priv;
+	struct wsm_set_tx_queue_params *txq_params;
 	int ret = 0;
 	/* To prevent re-applying PM request OID again and again*/
 	bool old_uapsd_flags;
 
 	mutex_lock(&priv->conf_mutex);
 
-	if (queue < dev->queues) {
+	txq_params = array_ptr(priv->tx_queue_params.params, queue,
+			dev->queues);
+	if (txq_params) {
 		old_uapsd_flags = le16_to_cpu(priv->uapsd_info.uapsd_flags);
 
-		WSM_TX_QUEUE_SET(&priv->tx_queue_params, queue, 0, 0, 0);
-		ret = wsm_set_tx_queue_params(priv,
-					      &priv->tx_queue_params.params[queue], queue);
+		WSM_TX_QUEUE_SET(txq_params, 0, 0, 0);
+		ret = wsm_set_tx_queue_params(priv, txq_params, queue);
 		if (ret) {
 			ret = -EINVAL;
 			goto out;
diff --git a/drivers/net/wireless/st/cw1200/wsm.h b/drivers/net/wireless/st/cw1200/wsm.h
index 48086e849515..8c8d9191e233 100644
--- a/drivers/net/wireless/st/cw1200/wsm.h
+++ b/drivers/net/wireless/st/cw1200/wsm.h
@@ -1099,10 +1099,8 @@ struct wsm_tx_queue_params {
 };
 
 
-#define WSM_TX_QUEUE_SET(queue_params, queue, ack_policy, allowed_time,\
-		max_life_time)	\
+#define WSM_TX_QUEUE_SET(p, ack_policy, allowed_time, max_life_time)	\
 do {							\
-	struct wsm_set_tx_queue_params *p = &(queue_params)->params[queue]; \
 	p->ackPolicy = (ack_policy);				\
 	p->allowedMediumTime = (allowed_time);				\
 	p->maxTransmitLifetime = (max_life_time);			\
