From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 46/64] nl80211: Sanitize array index in parse_txq_params
Date: Mon,  5 Feb 2018 10:23:05 -0800
Message-Id: <20180205182140.464675558@linuxfoundation.org>
In-Reply-To: <20180205182138.571333346@linuxfoundation.org>
References: <20180205182138.571333346@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Johannes Berg <johannes@sipsolutions.net>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-wireless@vger.kernel.org, torvalds@linux-foundation.org, "David S. Miller" <davem@davemloft.net>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams dan.j.williams@intel.com

commit 259d8c1e984318497c84eef547bbb6b1d9f4eb05

Wireless drivers rely on parse_txq_params to validate that txq_params->ac
is less than NL80211_NUM_ACS by the time the low-level driver's ->conf_tx()
handler is called. Use a new helper, array_index_nospec(), to sanitize
txq_params->ac with respect to speculation. I.e. ensure that any
speculation into ->conf_tx() handlers is done with a value of
txq_params->ac that is within the bounds of [0, NL80211_NUM_ACS).

Reported-by: Christian Lamparter <chunkeey@gmail.com>
Reported-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-arch@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
Cc: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Cc: torvalds@linux-foundation.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: alan@linux.intel.com
Link: https://lkml.kernel.org/r/151727419584.33451.7700736761686184303.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 net/wireless/nl80211.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16,6 +16,7 @@
 #include <linux/nl80211.h>
 #include <linux/rtnetlink.h>
 #include <linux/netlink.h>
+#include <linux/nospec.h>
 #include <linux/etherdevice.h>
 #include <net/net_namespace.h>
 #include <net/genetlink.h>
@@ -2056,20 +2057,22 @@ static const struct nla_policy txq_param
 static int parse_txq_params(struct nlattr *tb[],
 			    struct ieee80211_txq_params *txq_params)
 {
+	u8 ac;
+
 	if (!tb[NL80211_TXQ_ATTR_AC] || !tb[NL80211_TXQ_ATTR_TXOP] ||
 	    !tb[NL80211_TXQ_ATTR_CWMIN] || !tb[NL80211_TXQ_ATTR_CWMAX] ||
 	    !tb[NL80211_TXQ_ATTR_AIFS])
 		return -EINVAL;
 
-	txq_params->ac = nla_get_u8(tb[NL80211_TXQ_ATTR_AC]);
+	ac = nla_get_u8(tb[NL80211_TXQ_ATTR_AC]);
 	txq_params->txop = nla_get_u16(tb[NL80211_TXQ_ATTR_TXOP]);
 	txq_params->cwmin = nla_get_u16(tb[NL80211_TXQ_ATTR_CWMIN]);
 	txq_params->cwmax = nla_get_u16(tb[NL80211_TXQ_ATTR_CWMAX]);
 	txq_params->aifs = nla_get_u8(tb[NL80211_TXQ_ATTR_AIFS]);
 
-	if (txq_params->ac >= NL80211_NUM_ACS)
+	if (ac >= NL80211_NUM_ACS)
 		return -EINVAL;
-
+	txq_params->ac = array_index_nospec(ac, NL80211_NUM_ACS);
 	return 0;
 }
 
