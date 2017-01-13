Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 13 Jan 2017 14:13:42 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170113221342.GA67566@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] gcc-plugins: consolidate on PASS_INFO macro
To: kernel-hardening@lists.openwall.com
Cc: PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Now that PASS_INFO() exists, use it in the other existing gcc plugins,
instead of always open coding the same thing.

Based on updates to the grsecurity/PaX gcc plugins.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/cyc_complexity_plugin.c | 6 +-----
 scripts/gcc-plugins/sancov_plugin.c         | 8 ++------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/scripts/gcc-plugins/cyc_complexity_plugin.c b/scripts/gcc-plugins/cyc_complexity_plugin.c
index 8af7db06122d..1909ec617431 100644
--- a/scripts/gcc-plugins/cyc_complexity_plugin.c
+++ b/scripts/gcc-plugins/cyc_complexity_plugin.c
@@ -52,12 +52,8 @@ static unsigned int cyc_complexity_execute(void)
 __visible int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gcc_version *version)
 {
 	const char * const plugin_name = plugin_info->base_name;
-	struct register_pass_info cyc_complexity_pass_info;
 
-	cyc_complexity_pass_info.pass				= make_cyc_complexity_pass();
-	cyc_complexity_pass_info.reference_pass_name		= "ssa";
-	cyc_complexity_pass_info.ref_pass_instance_number	= 1;
-	cyc_complexity_pass_info.pos_op				= PASS_POS_INSERT_AFTER;
+	PASS_INFO(cyc_complexity, "ssa", 1, PASS_POS_INSERT_AFTER);
 
 	if (!plugin_default_version_check(version, &gcc_version)) {
 		error(G_("incompatible gcc/plugin versions"));
diff --git a/scripts/gcc-plugins/sancov_plugin.c b/scripts/gcc-plugins/sancov_plugin.c
index 70f5fe0d590a..9b0b5cbc5b89 100644
--- a/scripts/gcc-plugins/sancov_plugin.c
+++ b/scripts/gcc-plugins/sancov_plugin.c
@@ -89,7 +89,6 @@ static void sancov_start_unit(void __unused *gcc_data, void __unused *user_data)
 __visible int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gcc_version *version)
 {
 	int i;
-	struct register_pass_info sancov_plugin_pass_info;
 	const char * const plugin_name = plugin_info->base_name;
 	const int argc = plugin_info->argc;
 	const struct plugin_argument * const argv = plugin_info->argv;
@@ -107,14 +106,11 @@ __visible int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gc
 	};
 
 	/* BBs can be split afterwards?? */
-	sancov_plugin_pass_info.pass				= make_sancov_pass();
 #if BUILDING_GCC_VERSION >= 4009
-	sancov_plugin_pass_info.reference_pass_name		= "asan";
+	PASS_INFO(sancov, "asan", 0, PASS_POS_INSERT_BEFORE);
 #else
-	sancov_plugin_pass_info.reference_pass_name		= "nrv";
+	PASS_INFO(sancov, "nrv", 1, PASS_POS_INSERT_BEFORE);
 #endif
-	sancov_plugin_pass_info.ref_pass_instance_number	= 0;
-	sancov_plugin_pass_info.pos_op				= PASS_POS_INSERT_BEFORE;
 
 	if (!plugin_default_version_check(version, &gcc_version)) {
 		error(G_("incompatible gcc/plugin versions"));
-- 
2.7.4


-- 
Kees Cook
Nexus Security
