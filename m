From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:18 -0700
Message-Id: <1495829844-69341-15-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH v2 14/20] drm/amd/powerplay: Use designated initializers
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Eric Huang <JinHuiEric.Huang@amd.com>, Alex Deucher <alexander.deucher@amd.com>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The randstruct plugin requires designated initializers for structures
that are entirely function pointers.

Cc: Christian König <christian.koenig@amd.com>
Cc: Eric Huang <JinHuiEric.Huang@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c   | 28 ++++++++++++++--------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c b/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c
index d5f53d04fa08..cfa187185dcc 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c
@@ -709,17 +709,22 @@ static int tf_vega10_thermal_disable_alert(struct pp_hwmgr *hwmgr,
 
 static struct phm_master_table_item
 vega10_thermal_start_thermal_controller_master_list[] = {
-	{NULL, tf_vega10_thermal_initialize},
-	{NULL, tf_vega10_thermal_set_temperature_range},
-	{NULL, tf_vega10_thermal_enable_alert},
+	{ .isFunctionNeededInRuntimeTable = NULL,
+	  .tableFunction = tf_vega10_thermal_initialize },
+	{ .isFunctionNeededInRuntimeTable = NULL,
+	  .tableFunction = tf_vega10_thermal_set_temperature_range },
+	{ .isFunctionNeededInRuntimeTable = NULL,
+	  .tableFunction = tf_vega10_thermal_enable_alert },
 /* We should restrict performance levels to low before we halt the SMC.
  * On the other hand we are still in boot state when we do this
  * so it would be pointless.
  * If this assumption changes we have to revisit this table.
  */
-	{NULL, tf_vega10_thermal_setup_fan_table},
-	{NULL, tf_vega10_thermal_start_smc_fan_control},
-	{NULL, NULL}
+	{ .isFunctionNeededInRuntimeTable = NULL,
+	  .tableFunction = tf_vega10_thermal_setup_fan_table },
+	{ .isFunctionNeededInRuntimeTable = NULL,
+	  .tableFunction = tf_vega10_thermal_start_smc_fan_control },
+	{ }
 };
 
 static struct phm_master_table_header
@@ -731,10 +736,13 @@ vega10_thermal_start_thermal_controller_master = {
 
 static struct phm_master_table_item
 vega10_thermal_set_temperature_range_master_list[] = {
-	{NULL, tf_vega10_thermal_disable_alert},
-	{NULL, tf_vega10_thermal_set_temperature_range},
-	{NULL, tf_vega10_thermal_enable_alert},
-	{NULL, NULL}
+	{ .isFunctionNeededInRuntimeTable = NULL,
+	  .tableFunction = tf_vega10_thermal_disable_alert },
+	{ .isFunctionNeededInRuntimeTable = NULL,
+	  .tableFunction = tf_vega10_thermal_set_temperature_range },
+	{ .isFunctionNeededInRuntimeTable = NULL,
+	  .tableFunction = tf_vega10_thermal_enable_alert },
+	{ }
 };
 
 struct phm_master_table_header
-- 
2.7.4
