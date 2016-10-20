Reply-To: kernel-hardening@lists.openwall.com
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Date: Thu, 20 Oct 2016 15:24:58 +0900
Message-Id: <20161020062458.14014-1-takahiro.akashi@linaro.org>
Subject: [kernel-hardening] [PATCH] module: extend 'rodata=off' boot cmdline parameter to module mappings
To: rusty@rustcorp.com.au
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, AKASHI Takahiro <takahiro.akashi@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

The current "rodata=off" parameter disables read-only kernel mappings
under CONFIG_DEBUG_RODATA:
    commit d2aa1acad22f ("mm/init: Add 'rodata=off' boot cmdline parameter
    to disable read-only kernel mappings")

This patch is a logical extension to module mappings ie. read-only mappings
at module loading can be disabled even if CONFIG_DEBUG_SET_MODULE_RONX
(mainly for debug use). Please note, however, that it only affects RO/RW
permissions, keeping NX set.

This is the first step to make CONFIG_DEBUG_SET_MODULE_RONX mandatory
(always-on) in the future as CONFIG_DEBUG_RODATA on x86 and arm64.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
v1:
  * remove RFC's "module_ronx=" and merge it with "rodata="
  * always keep NX set if CONFIG_SET_MODULE_RONX

 include/linux/init.h |  3 ++-
 init/main.c          |  2 +-
 kernel/module.c      | 21 ++++++++++++++++++---
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index e30104c..20aa2eb 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -126,7 +126,8 @@ void prepare_namespace(void);
 void __init load_default_modules(void);
 int __init init_rootfs(void);
 
-#ifdef CONFIG_DEBUG_RODATA
+#if defined(CONFIG_DEBUG_RODATA) || defined(CONFIG_DEBUG_SET_MODULE_RONX)
+extern bool rodata_enabled;
 void mark_rodata_ro(void);
 #endif
 
diff --git a/init/main.c b/init/main.c
index 2858be7..92db2f3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -915,7 +915,7 @@ static int try_to_run_init_process(const char *init_filename)
 static noinline void __init kernel_init_freeable(void);
 
 #ifdef CONFIG_DEBUG_RODATA
-static bool rodata_enabled = true;
+bool rodata_enabled = true;
 static int __init set_debug_rodata(char *str)
 {
 	return strtobool(str, &rodata_enabled);
diff --git a/kernel/module.c b/kernel/module.c
index f57dd63..34d1880 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1910,6 +1910,9 @@ static void frob_writable_data(const struct module_layout *layout,
 /* livepatching wants to disable read-only so it can frob module. */
 void module_disable_ro(const struct module *mod)
 {
+	if (!rodata_enabled)
+		return;
+
 	frob_text(&mod->core_layout, set_memory_rw);
 	frob_rodata(&mod->core_layout, set_memory_rw);
 	frob_ro_after_init(&mod->core_layout, set_memory_rw);
@@ -1919,6 +1922,9 @@ void module_disable_ro(const struct module *mod)
 
 void module_enable_ro(const struct module *mod, bool after_init)
 {
+	if (!rodata_enabled)
+		return;
+
 	frob_text(&mod->core_layout, set_memory_ro);
 	frob_rodata(&mod->core_layout, set_memory_ro);
 	frob_text(&mod->init_layout, set_memory_ro);
@@ -1951,6 +1957,9 @@ void set_all_modules_text_rw(void)
 {
 	struct module *mod;
 
+	if (!rodata_enabled)
+		return;
+
 	mutex_lock(&module_mutex);
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
@@ -1967,6 +1976,9 @@ void set_all_modules_text_ro(void)
 {
 	struct module *mod;
 
+	if (!rodata_enabled)
+		return;
+
 	mutex_lock(&module_mutex);
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
@@ -1980,10 +1992,13 @@ void set_all_modules_text_ro(void)
 
 static void disable_ro_nx(const struct module_layout *layout)
 {
-	frob_text(layout, set_memory_rw);
-	frob_rodata(layout, set_memory_rw);
+	if (rodata_enabled) {
+		frob_text(layout, set_memory_rw);
+		frob_rodata(layout, set_memory_rw);
+	}
 	frob_rodata(layout, set_memory_x);
-	frob_ro_after_init(layout, set_memory_rw);
+	if (rodata_enabled)
+		frob_ro_after_init(layout, set_memory_rw);
 	frob_ro_after_init(layout, set_memory_x);
 	frob_writable_data(layout, set_memory_x);
 }
-- 
2.10.0
