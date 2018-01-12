From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jan 2018 16:47:52 -0800
Message-ID: <151571807201.27429.3448043288988637265.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 16/19] p54: prevent bounds-check bypass via speculative
 execution
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, Elena Reshetova <elena.reshetova@intel.com>, Christian Lamparter <chunkeey@googlemail.com>, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, Kalle Valo <kvalo@codeaurora.org>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Static analysis reports that 'queue' may be a user controlled value that
is used as a data dependency to read from the 'priv->qos_params' array.
In order to avoid potential leaks of kernel memory values, block
speculative execution of the instruction stream that could issue reads
based on an invalid result of 'priv->qos_params[queue]'.

Based on an original patch by Elena Reshetova.

Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/net/wireless/intersil/p54/main.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
index ab6d39e12069..5ce693ff547e 100644
--- a/drivers/net/wireless/intersil/p54/main.c
+++ b/drivers/net/wireless/intersil/p54/main.c
@@ -20,6 +20,7 @@
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/module.h>
+#include <linux/nospec.h>
 
 #include <net/mac80211.h>
 
@@ -411,12 +412,14 @@ static int p54_conf_tx(struct ieee80211_hw *dev,
 		       const struct ieee80211_tx_queue_params *params)
 {
 	struct p54_common *priv = dev->priv;
+	struct p54_edcf_queue_param *p54_q;
 	int ret;
 
 	mutex_lock(&priv->conf_mutex);
-	if (queue < dev->queues) {
-		P54_SET_QUEUE(priv->qos_params[queue], params->aifs,
-			params->cw_min, params->cw_max, params->txop);
+	p54_q = array_ptr(priv->qos_params, queue, dev->queues);
+	if (p54_q) {
+		P54_SET_QUEUE(p54_q[0], params->aifs, params->cw_min,
+				params->cw_max, params->txop);
 		ret = p54_set_edcf(priv);
 	} else
 		ret = -EINVAL;
