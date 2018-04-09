From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH] drm/gma500: Remove VLA
Date: Mon,  9 Apr 2018 14:06:47 -0700
Message-Id: <20180409210647.3718-1-labbott@redhat.com>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Laura Abbott <labbott@redhat.com>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>


There's an ongoing effort to remove VLAs[1] from the kernel to eventually
turn on -Wvla. Switch to a reasonable upper bound for the VLAs in
the gma500 driver.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
This was a little hard to figure out but I think 32 should be a
comfortable upper bound based on all the structures I saw. Of course I
can't test it.
---
 drivers/gpu/drm/gma500/psb_intel_sdvo.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/psb_intel_sdvo.c b/drivers/gpu/drm/gma500/psb_intel_sdvo.c
index 84507912be84..3d4fa9f6b94c 100644
--- a/drivers/gpu/drm/gma500/psb_intel_sdvo.c
+++ b/drivers/gpu/drm/gma500/psb_intel_sdvo.c
@@ -429,13 +429,20 @@ static const char *cmd_status_names[] = {
 	"Scaling not supported"
 };
 
+#define MAX_ARG_LEN 32
+
 static bool psb_intel_sdvo_write_cmd(struct psb_intel_sdvo *psb_intel_sdvo, u8 cmd,
 				 const void *args, int args_len)
 {
-	u8 buf[args_len*2 + 2], status;
-	struct i2c_msg msgs[args_len + 3];
+	u8 buf[MAX_ARG_LEN*2 + 2], status;
+	struct i2c_msg msgs[MAX_ARG_LEN + 3];
 	int i, ret;
 
+	if (args_len > MAX_ARG_LEN) {
+		DRM_ERROR("Need to increase arg length\n");
+		return false;
+	}
+
 	psb_intel_sdvo_debug_write(psb_intel_sdvo, cmd, args, args_len);
 
 	for (i = 0; i < args_len; i++) {
-- 
2.14.3
