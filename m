From: Laura Abbott <labbott@redhat.com>
Date: Mon, 10 Jul 2017 15:04:42 -0700
Message-Id: <1499724283-30719-2-git-send-email-labbott@redhat.com>
In-Reply-To: <1499724283-30719-1-git-send-email-labbott@redhat.com>
References: <1499724283-30719-1-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] [RFC][PATCH 1/2] stackleak: Update for arm64
To: Kees Cook <keescook@chromium.org>, Alex Popov <alex.popov@linux.com>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

- The arm64 rtl has another layer of indirection in the RTL
- Drop x86 check model check
- Add disable option

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
This can potentially be folded into the existing patch set if there is
agreement.

I still strongly dislike the disable flag approach but it might be cleaner than
the approach for e.g. KASAN. Each plugin has a unique name and arguments so
there ends up being an explosion of items that need to be filtered out. I'm
also not an expert in Makefiles so it might actually be easier than I'm making
it out to be.
---
 scripts/gcc-plugins/stackleak_plugin.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
index 2ee49c4..0cf4c5d 100644
--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -176,8 +176,14 @@ static unsigned int stackleak_final_execute(void)
 		if (!CALL_P(insn))
 			continue;
 		body = PATTERN(insn);
+		/* arm64 is different */
+		if (GET_CODE(body) == PARALLEL) {
+			body = XEXP(body, 0);
+			body = XEXP(body, 0);
+		}
 		if (GET_CODE(body) != CALL)
 			continue;
+
 		body = XEXP(body, 0);
 		if (GET_CODE(body) != MEM)
 			continue;
@@ -187,7 +193,7 @@ static unsigned int stackleak_final_execute(void)
 //		if (strcmp(XSTR(body, 0), track_function))
 		if (SYMBOL_REF_DECL(body) != track_function_decl)
 			continue;
-//		warning(0, "track_frame_size: %d %ld %d", cfun->calls_alloca, get_frame_size(), track_frame_size);
+		//warning(0, "track_frame_size: %d %ld %d", cfun->calls_alloca, get_frame_size(), track_frame_size);
 		// 2. delete call
 		delete_insn_and_edges(insn);
 #if BUILDING_GCC_VERSION >= 4007
@@ -210,8 +216,10 @@ static bool stackleak_track_stack_gate(void)
 {
 	tree section;
 
+#if 0
 	if (ix86_cmodel != CM_KERNEL)
 		return false;
+#endif
 
 	section = lookup_attribute("section", DECL_ATTRIBUTES(current_function_decl));
 	if (section && TREE_VALUE(section)) {
@@ -277,6 +285,7 @@ static bool stackleak_final_gate(void)
 
 __visible int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gcc_version *version)
 {
+	bool enabled = true;
 	const char * const plugin_name = plugin_info->base_name;
 	const int argc = plugin_info->argc;
 	const struct plugin_argument * const argv = plugin_info->argv;
@@ -330,13 +339,19 @@ __visible int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gc
 			init_locals = true;
 			continue;
 		}
+		if (!(strcmp(argv[i].key, "disable"))) {
+			enabled = false;
+			continue;
+		}
 		error(G_("unknown option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
 	}
 
-	register_callback(plugin_name, PLUGIN_START_UNIT, &stackleak_start_unit, NULL);
-	register_callback(plugin_name, PLUGIN_REGISTER_GGC_ROOTS, NULL, (void *)&gt_ggc_r_gt_stackleak);
-	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &stackleak_tree_instrument_pass_info);
-	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &stackleak_final_pass_info);
+	if (enabled) {
+		register_callback(plugin_name, PLUGIN_START_UNIT, &stackleak_start_unit, NULL);
+		register_callback(plugin_name, PLUGIN_REGISTER_GGC_ROOTS, NULL, (void *)&gt_ggc_r_gt_stackleak);
+		register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &stackleak_tree_instrument_pass_info);
+		register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &stackleak_final_pass_info);
+	}
 
 	return 0;
 }
-- 
2.7.5
