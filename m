From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH] mISDN: Remove VLAs
Date: Mon,  9 Apr 2018 14:07:47 -0700
Message-Id: <20180409210747.3990-1-labbott@redhat.com>
To: Karsten Keil <isdn@linux-pingi.de>, "David S. Miller" <davem@davemloft.net>
Cc: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


There's an ongoing effort to remove VLAs[1] from the kernel to eventually
turn on -Wvla. Remove the VLAs from the mISDN code by switching to using
kstrdup in one place and just using the upper bound in another.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/isdn/mISDN/dsp_hwec.c   | 8 +++++---
 drivers/isdn/mISDN/l1oip_core.c | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

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
index 21d50e4cc5e1..df594245deca 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -279,7 +279,7 @@ l1oip_socket_send(struct l1oip *hc, u8 localcodec, u8 channel, u32 chanmask,
 		  u16 timebase, u8 *buf, int len)
 {
 	u8 *p;
-	u8 frame[len + 32];
+	u8 frame[L1OIP_MAX_PERFRAME + 32];
 	struct socket *socket = NULL;
 
 	if (debug & DEBUG_L1OIP_MSG)
-- 
2.14.3
