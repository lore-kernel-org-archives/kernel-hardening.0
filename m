From: Joao Moreira <jmoreira@suse.de>
Subject: [PATCH] vgacon: fix function prototypes
Date: Sat, 10 Mar 2018 03:40:59 -0300
Message-Id: <20180310064059.12720-1-jmoreira@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, danielmicay@gmail.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

It is possible to indirectly invoke functions with prototypes that do not
match those of the respectively used function pointers by using void types.
Despite widely used as a feature for relaxing function invocation, this
should be avoided when possible as it may prevent the use of heuristics
such as prototype matching-based Control-Flow Integrity, which can be used
to prevent ROP-based attacks.

Given the above, the current efforts to improve the Linux security, and the
upcoming kernel support to compilers with CFI features, fix prototypes in
vgacon console driver.

Another similar fix can be seen in [1].

[1] https://android-review.googlesource.com/c/kernel/common/+/602010

Signed-off-by:	João Moreira <jmoreira@suse.de>
---
 drivers/video/console/vgacon.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index a17ba1465815..f00b630f6839 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -1407,21 +1407,29 @@ static bool vgacon_scroll(struct vc_data *c, unsigned int t, unsigned int b,
  *  The console `switch' structure for the VGA based console
  */
 
-static int vgacon_dummy(struct vc_data *c)
+static int vgacon_clear(struct vc_data *c)
 {
 	return 0;
 }
 
-#define DUMMY (void *) vgacon_dummy
+static void vgacon_putc(struct vc_data *c, int a, int b, int d)
+{
+	return;
+}
+
+static void vgacon_putcs(struct vc_data *c, ushort *s, int a, int b, int d)
+{
+	return;
+}
 
 const struct consw vga_con = {
 	.owner = THIS_MODULE,
 	.con_startup = vgacon_startup,
 	.con_init = vgacon_init,
 	.con_deinit = vgacon_deinit,
-	.con_clear = DUMMY,
-	.con_putc = DUMMY,
-	.con_putcs = DUMMY,
+	.con_clear = vgacon_clear,
+	.con_putc = vgacon_putc,
+	.con_putcs = vgacon_putcs,
 	.con_cursor = vgacon_cursor,
 	.con_scroll = vgacon_scroll,
 	.con_switch = vgacon_switch,
-- 
2.13.6
