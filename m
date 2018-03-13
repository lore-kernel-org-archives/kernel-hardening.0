From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH] drm/i915: drop various VLAs in i915_debugfs.c
Date: Tue, 13 Mar 2018 20:51:28 +0100
Message-Id: <1520970688-19683-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kernel-hardening@lists.openwall.com, David Airlie <airlied@linux.ie>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Kees Cook <keescook@chromium.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Salvatore Mesoraca <s.mesoraca16@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Avoid 3 VLAs[1] by using real constant expressions instead of variables.
The compiler should be able to optimize the original code and avoid using
any actual VLAs. Anyway this change is useful because it will avoid a false
positives with -Wvla, it might also help the compiler generating better
code.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 drivers/gpu/drm/i915/i915_debugfs.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index e968aea..bf0a8e3 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -4259,19 +4259,20 @@ static ssize_t cur_wm_latency_write(struct file *file, const char __user *ubuf,
 			i915_cache_sharing_get, i915_cache_sharing_set,
 			"%llu\n");
 
+#define CHERRYVIEW_SS_MAX 2
+
 static void cherryview_sseu_device_status(struct drm_i915_private *dev_priv,
 					  struct sseu_dev_info *sseu)
 {
-	int ss_max = 2;
 	int ss;
-	u32 sig1[ss_max], sig2[ss_max];
+	u32 sig1[CHERRYVIEW_SS_MAX], sig2[CHERRYVIEW_SS_MAX];
 
 	sig1[0] = I915_READ(CHV_POWER_SS0_SIG1);
 	sig1[1] = I915_READ(CHV_POWER_SS1_SIG1);
 	sig2[0] = I915_READ(CHV_POWER_SS0_SIG2);
 	sig2[1] = I915_READ(CHV_POWER_SS1_SIG2);
 
-	for (ss = 0; ss < ss_max; ss++) {
+	for (ss = 0; ss < CHERRYVIEW_SS_MAX; ss++) {
 		unsigned int eu_cnt;
 
 		if (sig1[ss] & CHV_SS_PG_ENABLE)
@@ -4290,15 +4291,17 @@ static void cherryview_sseu_device_status(struct drm_i915_private *dev_priv,
 	}
 }
 
+#define GEN10_S_MAX 6
+#define GEN10_SS_MAX 4
+
 static void gen10_sseu_device_status(struct drm_i915_private *dev_priv,
 				     struct sseu_dev_info *sseu)
 {
 	const struct intel_device_info *info = INTEL_INFO(dev_priv);
-	int s_max = 6, ss_max = 4;
 	int s, ss;
-	u32 s_reg[s_max], eu_reg[2 * s_max], eu_mask[2];
+	u32 s_reg[GEN10_S_MAX], eu_reg[2 * GEN10_S_MAX], eu_mask[2];
 
-	for (s = 0; s < s_max; s++) {
+	for (s = 0; s < GEN10_S_MAX; s++) {
 		/*
 		 * FIXME: Valid SS Mask respects the spec and read
 		 * only valid bits for those registers, excluding reserverd
@@ -4320,7 +4323,7 @@ static void gen10_sseu_device_status(struct drm_i915_private *dev_priv,
 		     GEN9_PGCTL_SSB_EU210_ACK |
 		     GEN9_PGCTL_SSB_EU311_ACK;
 
-	for (s = 0; s < s_max; s++) {
+	for (s = 0; s < GEN10_S_MAX; s++) {
 		if ((s_reg[s] & GEN9_PGCTL_SLICE_ACK) == 0)
 			/* skip disabled slice */
 			continue;
@@ -4328,7 +4331,7 @@ static void gen10_sseu_device_status(struct drm_i915_private *dev_priv,
 		sseu->slice_mask |= BIT(s);
 		sseu->subslice_mask = info->sseu.subslice_mask;
 
-		for (ss = 0; ss < ss_max; ss++) {
+		for (ss = 0; ss < GEN10_SS_MAX; ss++) {
 			unsigned int eu_cnt;
 
 			if (!(s_reg[s] & (GEN9_PGCTL_SS_ACK(ss))))
@@ -4345,12 +4348,15 @@ static void gen10_sseu_device_status(struct drm_i915_private *dev_priv,
 	}
 }
 
+#define GEN9_S_MAX 3
+#define GEN9_SS_MAX 4
+
 static void gen9_sseu_device_status(struct drm_i915_private *dev_priv,
 				    struct sseu_dev_info *sseu)
 {
-	int s_max = 3, ss_max = 4;
+	int s_max = GEN9_S_MAX, ss_max = GEN9_SS_MAX;
 	int s, ss;
-	u32 s_reg[s_max], eu_reg[2*s_max], eu_mask[2];
+	u32 s_reg[GEN9_S_MAX], eu_reg[2*GEN9_S_MAX], eu_mask[2];
 
 	/* BXT has a single slice and at most 3 subslices. */
 	if (IS_GEN9_LP(dev_priv)) {
-- 
1.9.1
