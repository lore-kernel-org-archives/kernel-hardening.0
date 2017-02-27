From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 27 Feb 2017 21:29:03 +0100
Message-Id: <20170227202915.3190748-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH] gcc-plugins: fix sancov_plugin for gcc-5
To: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Emese Revfy <re.emese@gmail.com>, Jiri Kosina <jkosina@suse.cz>, Michal Marek <mmarek@suse.com>, Masanari Iida <standby24x7@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The name of the local variable was inadvertantly changed from
sancov_plugin_pass_info to sancov_pass_info:

scripts/gcc-plugins/sancov_plugin.c: In function ‘int plugin_init(plugin_name_args*, plugin_gcc_version*)’:
scripts/gcc-plugins/sancov_plugin.c:136:67: error: ‘sancov_plugin_pass_info’ was not declared in this scope

This changes the conditional reference to this variable as well.

Fixes: 5a45a4c5c3f5 ("gcc-plugins: consolidate on PASS_INFO macro")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 scripts/gcc-plugins/sancov_plugin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/sancov_plugin.c b/scripts/gcc-plugins/sancov_plugin.c
index 9b0b5cbc5b89..0f98634c20a0 100644
--- a/scripts/gcc-plugins/sancov_plugin.c
+++ b/scripts/gcc-plugins/sancov_plugin.c
@@ -133,7 +133,7 @@ __visible int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gc
 #if BUILDING_GCC_VERSION < 6000
 	register_callback(plugin_name, PLUGIN_START_UNIT, &sancov_start_unit, NULL);
 	register_callback(plugin_name, PLUGIN_REGISTER_GGC_ROOTS, NULL, (void *)&gt_ggc_r_gt_sancov);
-	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &sancov_plugin_pass_info);
+	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &sancov_pass_info);
 #endif
 
 	return 0;
-- 
2.9.0
