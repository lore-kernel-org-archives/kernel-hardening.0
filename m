From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] gcc-plugins: arm_ssp_per_task_plugin: fix for GCC 9+
Date: Fri, 18 Jan 2019 11:58:07 +0100
Message-Id: <20190118105807.26425-3-ard.biesheuvel@linaro.org>
In-Reply-To: <20190118105807.26425-1-ard.biesheuvel@linaro.org>
References: <20190118105807.26425-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: keescook@chromium.org
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

GCC 9 reworks the way the references to the stack canary are
emitted, to prevent the value from being spilled to the stack
before the final comparison in the epilogue, defeating the
purpose, given that the spill slot is under control of the
attacker that we are protecting ourselves from.

Since our canary value address is obtained without accessing
memory (as opposed to pre-v7 code that will obtain it from a
literal pool), it is unlikely (although not guaranteed) that
the compiler will spill the canary value in the same way, so
let's just disable this improvement when building with GCC9+.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c b/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
index a65fbefb8501..89c47f57d1ce 100644
--- a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
+++ b/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
@@ -53,6 +53,19 @@ static unsigned int arm_pertask_ssp_rtl_execute(void)
 #define NO_GATE
 #include "gcc-generate-rtl-pass.h"
 
+#if BUILDING_GCC_VERSION >= 9000
+static bool no(void)
+{
+	return false;
+}
+
+static void arm_pertask_ssp_start_unit(void *gcc_data, void *user_data)
+{
+	targetm.have_stack_protect_combined_set = no;
+	targetm.have_stack_protect_combined_test = no;
+}
+#endif
+
 __visible int plugin_init(struct plugin_name_args *plugin_info,
 			  struct plugin_gcc_version *version)
 {
@@ -100,5 +113,10 @@ __visible int plugin_init(struct plugin_name_args *plugin_info,
 	register_callback(plugin_info->base_name, PLUGIN_PASS_MANAGER_SETUP,
 			  NULL, &arm_pertask_ssp_rtl_pass_info);
 
+#if BUILDING_GCC_VERSION >= 9000
+	register_callback(plugin_info->base_name, PLUGIN_START_UNIT,
+			  arm_pertask_ssp_start_unit, NULL);
+#endif
+
 	return 0;
 }
-- 
2.20.1
