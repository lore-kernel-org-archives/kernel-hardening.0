From: Laura Abbott <labbott@redhat.com>
Subject: [PATCHv2] drm/i2c: tda998x: Remove VLA usage
Date: Tue, 10 Apr 2018 18:03:30 -0700
Message-Id: <20180411010330.17866-1-labbott@redhat.com>
To: Russell King <linux@armlinux.org.uk>, David Airlie <airlied@linux.ie>
Cc: Laura Abbott <labbott@redhat.com>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

There's an ongoing effort to remove VLAs[1] from the kernel to eventually
turn on -Wvla. The vla in reg_write_range is based on the length of data
passed. The one use of a non-constant size for this range is bounded by
the size buffer passed to hdmi_infoframe_pack which is a fixed size.
Switch to this upper bound.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
v2: Switch to make the buffer size more transparent and add a bounds
check.
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 9e67a7b4e3a4..c8b6029b7839 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -466,13 +466,22 @@ reg_read_range(struct tda998x_priv *priv, u16 reg, char *buf, int cnt)
 	return ret;
 }
 
+#define MAX_WRITE_RANGE_BUF 32
+
 static void
 reg_write_range(struct tda998x_priv *priv, u16 reg, u8 *p, int cnt)
 {
 	struct i2c_client *client = priv->hdmi;
-	u8 buf[cnt+1];
+	/* This is the maximum size of the buffer passed in */
+	u8 buf[MAX_WRITE_RANGE_BUF + 1];
 	int ret;
 
+	if (cnt > MAX_WRITE_RANGE_BUF) {
+		dev_err(&client->dev, "Fixed write buffer too small (%d)\n",
+				MAX_WRITE_RANGE_BUF);
+		return;
+	}
+
 	buf[0] = REG2ADDR(reg);
 	memcpy(&buf[1], p, cnt);
 
@@ -679,7 +688,7 @@ static void
 tda998x_write_if(struct tda998x_priv *priv, u8 bit, u16 addr,
 		 union hdmi_infoframe *frame)
 {
-	u8 buf[32];
+	u8 buf[MAX_WRITE_RANGE_BUF];
 	ssize_t len;
 
 	len = hdmi_infoframe_pack(frame, buf, sizeof(buf));
-- 
2.14.3
