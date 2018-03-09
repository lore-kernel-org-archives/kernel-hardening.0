From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 4/4] video: Remove stack VLA usage
Date: Fri,  9 Mar 2018 16:50:25 +1100
Message-Id: <1520574625-4225-1-git-send-email-me@tobin.cc>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

The kernel would like to have all stack VLA usage removed[1].  The
arrays are fixed here (declared with a const variable) but they appear
like VLAs to the compiler.  We can use a pre-processor define to fix the
warning.  

[1]: https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 drivers/video/fbdev/via/via_aux_sii164.c |  8 +++++---
 drivers/video/fbdev/via/via_aux_vt1631.c | 11 +++++++----
 drivers/video/fbdev/via/via_aux_vt1632.c | 11 +++++++----
 drivers/video/fbdev/via/via_aux_vt1636.c | 11 +++++++----
 4 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/video/fbdev/via/via_aux_sii164.c b/drivers/video/fbdev/via/via_aux_sii164.c
index ca1b35f033b1..f715ea4f466c 100644
--- a/drivers/video/fbdev/via/via_aux_sii164.c
+++ b/drivers/video/fbdev/via/via_aux_sii164.c
@@ -27,6 +27,9 @@
 
 static const char *name = "SiI 164 PanelLink Transmitter";
 
+/* check vendor id and device id */
+const u8 id[] = {0x01, 0x00, 0x06, 0x00};
+#define VIA_SII164_LEN ARRAY_SIZE(id)
 
 static void probe(struct via_aux_bus *bus, u8 addr)
 {
@@ -34,9 +37,8 @@ static void probe(struct via_aux_bus *bus, u8 addr)
 		.bus	=	bus,
 		.addr	=	addr,
 		.name	=	name};
-	/* check vendor id and device id */
-	const u8 id[] = {0x01, 0x00, 0x06, 0x00}, len = ARRAY_SIZE(id);
-	u8 tmp[len];
+	u8 tmp[VIA_SII164_LEN];
+	int len = VIA_SII164_LEN;
 
 	if (!via_aux_read(&drv, 0x00, tmp, len) || memcmp(id, tmp, len))
 		return;
diff --git a/drivers/video/fbdev/via/via_aux_vt1631.c b/drivers/video/fbdev/via/via_aux_vt1631.c
index 06e742f1f723..5bfaa20ec5a8 100644
--- a/drivers/video/fbdev/via/via_aux_vt1631.c
+++ b/drivers/video/fbdev/via/via_aux_vt1631.c
@@ -27,16 +27,19 @@
 
 static const char *name = "VT1631 LVDS Transmitter";
 
+/* check vendor id and device id */
+const u8 id[] = {0x06, 0x11, 0x91, 0x31}, len = ARRAY_SIZE(id);
+#define VIA_VT1631_LEN ARRAY_SIZE(id)
 
 void via_aux_vt1631_probe(struct via_aux_bus *bus)
 {
 	struct via_aux_drv drv = {
 		.bus	=	bus,
 		.addr	=	0x38,
-		.name	=	name};
-	/* check vendor id and device id */
-	const u8 id[] = {0x06, 0x11, 0x91, 0x31}, len = ARRAY_SIZE(id);
-	u8 tmp[len];
+		.name	=	name
+	};
+	u8 tmp[VIA_VT1631_LEN];
+	int len = VIA_VT1631_LEN;
 
 	if (!via_aux_read(&drv, 0x00, tmp, len) || memcmp(id, tmp, len))
 		return;
diff --git a/drivers/video/fbdev/via/via_aux_vt1632.c b/drivers/video/fbdev/via/via_aux_vt1632.c
index d24f4cd97401..fcddd761d4a4 100644
--- a/drivers/video/fbdev/via/via_aux_vt1632.c
+++ b/drivers/video/fbdev/via/via_aux_vt1632.c
@@ -27,16 +27,19 @@
 
 static const char *name = "VT1632 DVI Transmitter";
 
+/* check vendor id and device id */
+const u8 id[] = {0x06, 0x11, 0x92, 0x31};
+#define VIA_VT1632_LEN ARRAY_SIZE(id)
 
 static void probe(struct via_aux_bus *bus, u8 addr)
 {
 	struct via_aux_drv drv = {
 		.bus	=	bus,
 		.addr	=	addr,
-		.name	=	name};
-	/* check vendor id and device id */
-	const u8 id[] = {0x06, 0x11, 0x92, 0x31}, len = ARRAY_SIZE(id);
-	u8 tmp[len];
+		.name	=	name
+	};
+	u8 tmp[VIA_VT1632_LEN];
+	int len = VIA_VT1632_LEN;
 
 	if (!via_aux_read(&drv, 0x00, tmp, len) || memcmp(id, tmp, len))
 		return;
diff --git a/drivers/video/fbdev/via/via_aux_vt1636.c b/drivers/video/fbdev/via/via_aux_vt1636.c
index 9e015c101d4d..49c9269c7f81 100644
--- a/drivers/video/fbdev/via/via_aux_vt1636.c
+++ b/drivers/video/fbdev/via/via_aux_vt1636.c
@@ -27,16 +27,19 @@
 
 static const char *name = "VT1636 LVDS Transmitter";
 
+/* check vendor id and device id */
+const u8 id[] = {0x06, 0x11, 0x45, 0x33};
+#define VIA_VT1636_LEN ARRAY_SIZE(id)
 
 void via_aux_vt1636_probe(struct via_aux_bus *bus)
 {
 	struct via_aux_drv drv = {
 		.bus	=	bus,
 		.addr	=	0x40,
-		.name	=	name};
-	/* check vendor id and device id */
-	const u8 id[] = {0x06, 0x11, 0x45, 0x33}, len = ARRAY_SIZE(id);
-	u8 tmp[len];
+		.name	=	name
+	};
+	u8 tmp[VIA_VT1636_LEN];
+	int len = VIA_VT1636_LEN;
 
 	if (!via_aux_read(&drv, 0x00, tmp, len) || memcmp(id, tmp, len))
 		return;
-- 
2.7.4
