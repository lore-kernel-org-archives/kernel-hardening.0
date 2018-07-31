Date: Tue, 31 Jul 2018 23:10:40 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Subject: [PATCH] mac80211_hwsim: Fix possible Spectre-v1 for
 hwsim_world_regdom_custom
Message-ID: <20180731141040.GA8936@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: johannes@sipsolutions.net, kvalo@codeaurora.org, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

User controls @idx which to be used as index of hwsim_world_regdom_custom.
So, It can be exploited via Spectre-like attack. (speculative execution)

This kind of attack leaks address of hwsim_world_regdom_custom,
It leads an attacker to bypass security mechanism such as KASLR.

So sanitize @idx before using it to prevent attack.

I leveraged strategy [1] to find and exploit this gadget.

[1] https://github.com/jinb-park/linux-exploit/
tree/master/exploit-remaining-spectre-gadget/

Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 998dfac..b41fdc3 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -34,6 +34,7 @@
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 #include <linux/rhashtable.h>
+#include <linux/nospec.h>
 #include "mac80211_hwsim.h"
 
 #define WARN_QUEUE 100
@@ -3350,6 +3351,9 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 			kfree(hwname);
 			return -EINVAL;
 		}
+
+		idx = array_index_nospec(idx,
+					 ARRAY_SIZE(hwsim_world_regdom_custom));
 		param.regd = hwsim_world_regdom_custom[idx];
 	}
 
-- 
1.9.1
