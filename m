Date: Thu, 8 Mar 2018 11:39:49 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] video: fbdev: via: remove VLA usage
Message-ID: <20180308173949.GA19305@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Emil Velikov <emil.l.velikov@gmail.com>, Florian Tobias Schandinat <FlorianSchandinat@gmx.de>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

In preparation to enabling -Wvla, remove VLA usage.

Also, fixed as part of the directive to remove all VLAs from
the kernel: https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/video/fbdev/via/via_aux_sii164.c | 2 +-
 drivers/video/fbdev/via/via_aux_vt1631.c | 2 +-
 drivers/video/fbdev/via/via_aux_vt1632.c | 2 +-
 drivers/video/fbdev/via/via_aux_vt1636.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/via/via_aux_sii164.c b/drivers/video/fbdev/via/via_aux_sii164.c
index ca1b35f..c27f62c 100644
--- a/drivers/video/fbdev/via/via_aux_sii164.c
+++ b/drivers/video/fbdev/via/via_aux_sii164.c
@@ -36,7 +36,7 @@ static void probe(struct via_aux_bus *bus, u8 addr)
 		.name	=	name};
 	/* check vendor id and device id */
 	const u8 id[] = {0x01, 0x00, 0x06, 0x00}, len = ARRAY_SIZE(id);
-	u8 tmp[len];
+	u8 tmp[ARRAY_SIZE(id)];
 
 	if (!via_aux_read(&drv, 0x00, tmp, len) || memcmp(id, tmp, len))
 		return;
diff --git a/drivers/video/fbdev/via/via_aux_vt1631.c b/drivers/video/fbdev/via/via_aux_vt1631.c
index 06e742f..32978a0 100644
--- a/drivers/video/fbdev/via/via_aux_vt1631.c
+++ b/drivers/video/fbdev/via/via_aux_vt1631.c
@@ -36,7 +36,7 @@ void via_aux_vt1631_probe(struct via_aux_bus *bus)
 		.name	=	name};
 	/* check vendor id and device id */
 	const u8 id[] = {0x06, 0x11, 0x91, 0x31}, len = ARRAY_SIZE(id);
-	u8 tmp[len];
+	u8 tmp[ARRAY_SIZE(id)];
 
 	if (!via_aux_read(&drv, 0x00, tmp, len) || memcmp(id, tmp, len))
 		return;
diff --git a/drivers/video/fbdev/via/via_aux_vt1632.c b/drivers/video/fbdev/via/via_aux_vt1632.c
index d24f4cd..cec8cc4 100644
--- a/drivers/video/fbdev/via/via_aux_vt1632.c
+++ b/drivers/video/fbdev/via/via_aux_vt1632.c
@@ -36,7 +36,7 @@ static void probe(struct via_aux_bus *bus, u8 addr)
 		.name	=	name};
 	/* check vendor id and device id */
 	const u8 id[] = {0x06, 0x11, 0x92, 0x31}, len = ARRAY_SIZE(id);
-	u8 tmp[len];
+	u8 tmp[ARRAY_SIZE(id)];
 
 	if (!via_aux_read(&drv, 0x00, tmp, len) || memcmp(id, tmp, len))
 		return;
diff --git a/drivers/video/fbdev/via/via_aux_vt1636.c b/drivers/video/fbdev/via/via_aux_vt1636.c
index 9e015c1..2b10bc2 100644
--- a/drivers/video/fbdev/via/via_aux_vt1636.c
+++ b/drivers/video/fbdev/via/via_aux_vt1636.c
@@ -36,7 +36,7 @@ void via_aux_vt1636_probe(struct via_aux_bus *bus)
 		.name	=	name};
 	/* check vendor id and device id */
 	const u8 id[] = {0x06, 0x11, 0x45, 0x33}, len = ARRAY_SIZE(id);
-	u8 tmp[len];
+	u8 tmp[ARRAY_SIZE(id)];
 
 	if (!via_aux_read(&drv, 0x00, tmp, len) || memcmp(id, tmp, len))
 		return;
-- 
2.7.4
