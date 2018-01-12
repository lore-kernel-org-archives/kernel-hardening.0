From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jan 2018 16:47:46 -0800
Message-ID: <151571806633.27429.1504260808341642890.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 15/19] carl9170: prevent bounds-check bypass via
 speculative execution
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, Elena Reshetova <elena.reshetova@intel.com>, Christian Lamparter <chunkeey@googlemail.com>, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, Kalle Valo <kvalo@codeaurora.org>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Static analysis reports that 'queue' may be a user controlled value that
is used as a data dependency to read from the 'ar9170_qmap' array. In
order to avoid potential leaks of kernel memory values, block
speculative execution of the instruction stream that could issue reads
based on an invalid result of 'ar9170_qmap[queue]'. In this case the
value of 'ar9170_qmap[queue]' is immediately reused as an index to the
'ar->edcf' array.

Based on an original patch by Elena Reshetova.

Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/net/wireless/ath/carl9170/main.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 988c8857d78c..0acfa8c22b7d 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -41,6 +41,7 @@
 #include <linux/module.h>
 #include <linux/etherdevice.h>
 #include <linux/random.h>
+#include <linux/nospec.h>
 #include <net/mac80211.h>
 #include <net/cfg80211.h>
 #include "hw.h"
@@ -1384,11 +1385,13 @@ static int carl9170_op_conf_tx(struct ieee80211_hw *hw,
 			       const struct ieee80211_tx_queue_params *param)
 {
 	struct ar9170 *ar = hw->priv;
+	const u8 *elem;
 	int ret;
 
 	mutex_lock(&ar->mutex);
-	if (queue < ar->hw->queues) {
-		memcpy(&ar->edcf[ar9170_qmap[queue]], param, sizeof(*param));
+	elem = array_ptr(ar9170_qmap, queue, ar->hw->queues);
+	if (elem) {
+		memcpy(&ar->edcf[*elem], param, sizeof(*param));
 		ret = carl9170_set_qos(ar);
 	} else {
 		ret = -EINVAL;
