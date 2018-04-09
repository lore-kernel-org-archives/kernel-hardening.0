From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH] drm/i2c: tda998x: Remove VLA usage
Date: Mon,  9 Apr 2018 14:07:03 -0700
Message-Id: <20180409210703.3787-1-labbott@redhat.com>
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
This one really feels like it should be a #define but I wasn't sure
where the 32 came from. It looks like most other uses use one of the
#defines in include/linux/hdmi?
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 9e67a7b4e3a4..29e2f49601c7 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -470,7 +470,8 @@ static void
 reg_write_range(struct tda998x_priv *priv, u16 reg, u8 *p, int cnt)
 {
 	struct i2c_client *client = priv->hdmi;
-	u8 buf[cnt+1];
+	/* This is the maximum size of the buffer passed in */
+	u8 buf[33];
 	int ret;
 
 	buf[0] = REG2ADDR(reg);
-- 
2.14.3
