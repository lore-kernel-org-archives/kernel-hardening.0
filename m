From: Laura Abbott <labbott@redhat.com>
Subject: [PATCHv2] mISDN: Remove VLAs
Date: Tue, 10 Apr 2018 18:04:29 -0700
Message-Id: <20180411010429.18074-1-labbott@redhat.com>
To: Karsten Keil <isdn@linux-pingi.de>, "David S. Miller" <davem@davemloft.net>
Cc: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


There's an ongoing effort to remove VLAs[1] from the kernel to eventually
turn on -Wvla. Remove the VLAs from the mISDN code by switching to using
kstrdup in one place and using an upper bound in another.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
v2: Switch to a tighter upper bound so we are allocating a more
reasonable amount on the stack (300). This is based on previous checks
against this value.
---
 drivers/isdn/mISDN/dsp_hwec.c   |  8 +++++---
 drivers/isdn/mISDN/l1oip_core.c | 14 +++++++++++---
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_hwec.c b/drivers/isdn/mISDN/dsp_hwec.c
index a6e87076acc2..5336bbdbfdc5 100644
--- a/drivers/isdn/mISDN/dsp_hwec.c
+++ b/drivers/isdn/mISDN/dsp_hwec.c
@@ -68,12 +68,12 @@ void dsp_hwec_enable(struct dsp *dsp, const char *arg)
 		goto _do;
 
 	{
-		char _dup[len + 1];
 		char *dup, *tok, *name, *val;
 		int tmp;
 
-		strcpy(_dup, arg);
-		dup = _dup;
+		dup = kstrdup(arg, GFP_ATOMIC);
+		if (!dup)
+			return;
 
 		while ((tok = strsep(&dup, ","))) {
 			if (!strlen(tok))
@@ -89,6 +89,8 @@ void dsp_hwec_enable(struct dsp *dsp, const char *arg)
 					deftaps = tmp;
 			}
 		}
+
+		kfree(dup);
 	}
 
 _do:
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index 21d50e4cc5e1..b05022f94f18 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -279,7 +279,7 @@ l1oip_socket_send(struct l1oip *hc, u8 localcodec, u8 channel, u32 chanmask,
 		  u16 timebase, u8 *buf, int len)
 {
 	u8 *p;
-	u8 frame[len + 32];
+	u8 frame[MAX_DFRAME_LEN_L1 + 32];
 	struct socket *socket = NULL;
 
 	if (debug & DEBUG_L1OIP_MSG)
@@ -902,7 +902,11 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 		p = skb->data;
 		l = skb->len;
 		while (l) {
-			ll = (l < L1OIP_MAX_PERFRAME) ? l : L1OIP_MAX_PERFRAME;
+			/*
+			 * This is technically bounded by L1OIP_MAX_PERFRAME but
+			 * MAX_DFRAME_LEN_L1 < L1OIP_MAX_PERFRAME
+			 */
+			ll = (l < MAX_DFRAME_LEN_L1) ? l : MAX_DFRAME_LEN_L1;
 			l1oip_socket_send(hc, 0, dch->slot, 0,
 					  hc->chan[dch->slot].tx_counter++, p, ll);
 			p += ll;
@@ -1140,7 +1144,11 @@ handle_bmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 		p = skb->data;
 		l = skb->len;
 		while (l) {
-			ll = (l < L1OIP_MAX_PERFRAME) ? l : L1OIP_MAX_PERFRAME;
+			/*
+			 * This is technically bounded by L1OIP_MAX_PERFRAME but
+			 * MAX_DFRAME_LEN_L1 < L1OIP_MAX_PERFRAME
+			 */
+			ll = (l < MAX_DFRAME_LEN_L1) ? l : MAX_DFRAME_LEN_L1;
 			l1oip_socket_send(hc, hc->codec, bch->slot, 0,
 					  hc->chan[bch->slot].tx_counter, p, ll);
 			hc->chan[bch->slot].tx_counter += ll;
-- 
2.14.3
