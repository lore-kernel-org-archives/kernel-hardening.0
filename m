Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 18 Oct 2016 15:09:51 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Message-ID: <20161018060950.GM19531@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [RFC] module: add 'module_ronx=off' boot cmdline parameter to
 disable ro/nx module mappings
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

As making CONFIG_DEBUG_RODATA mandatory is a good idea, so will be
for CONFIG_SET_MODULE_RONX.
This patch adds a command line parameter, "module_ronx=," in order to
make this configuration always on in the future, but still allowing for
disabling read-only module mappings at boot time as "rodata=" does.

I have, however, some concerns on this prototype:
(1) should we use a separate parameter like "module_ronx=," or
    unify it with "rodata="?
(2) should we keep NX permission set even if module_ronx=off?

I tested this patch with:
  - insmod lkdtm.ko cpoint_name=DIRECT cpoint_type="WRITE_KERN"
  - insmod lkdtm.ko cpoint_name=DIRECT cpoint_type="WRITE_RO"
  - insmod lkdtm.ko cpoint_name=DIRECT cpoint_type="EXEC_DATA"

WRITE_RO_AFTER_INIT case doesn't fail because the test is executed
*before* setting the ro_after_init data ro.

Any comments are welcome.

Thanks,
-Takahiro AKASHI
===8<===
>From aeb6bcdbe462251f5aab828ba58f2f64e9c51d69 Mon Sep 17 00:00:00 2001
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Date: Thu, 13 Oct 2016 14:39:20 +0900
Subject: [RFC] module: add 'module_ronx=off' boot cmdline parameter to disable
 ro/nx module mappings

"module_ronx=off" allows for writing to read-only module text as well as
executing any code in data section (as if !CONFIG_SET_MODULE_RONX).
It corresponds to the kernel patch:
    commit d2aa1acad22f ("mm/init: Add 'rodata=off' boot cmdline parameter
    to disable read-only kernel mappings")

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 kernel/module.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index f57dd63..cc75ad6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1855,6 +1855,9 @@ static void mod_sysfs_teardown(struct module *mod)
 }
 
 #ifdef CONFIG_DEBUG_SET_MODULE_RONX
+static bool module_ronx_enabled = true;
+core_param(module_ronx, module_ronx_enabled, bool, 0);
+
 /*
  * LKM RO/NX protection: protect module's text/ro-data
  * from modification and any data from execution.
@@ -1989,6 +1992,8 @@ static void disable_ro_nx(const struct module_layout *layout)
 }
 
 #else
+#define module_ronx_enabled false
+
 static void disable_ro_nx(const struct module_layout *layout) { }
 static void module_enable_nx(const struct module *mod) { }
 static void module_disable_nx(const struct module *mod) { }
@@ -2124,7 +2129,8 @@ static void free_module(struct module *mod)
 	mutex_unlock(&module_mutex);
 
 	/* This may be empty, but that's OK */
-	disable_ro_nx(&mod->init_layout);
+	if (module_ronx_enabled)
+		disable_ro_nx(&mod->init_layout);
 	module_arch_freeing_init(mod);
 	module_memfree(mod->init_layout.base);
 	kfree(mod->args);
@@ -2134,7 +2140,8 @@ static void free_module(struct module *mod)
 	lockdep_free_key_range(mod->core_layout.base, mod->core_layout.size);
 
 	/* Finally, free the core (containing the module structure) */
-	disable_ro_nx(&mod->core_layout);
+	if (module_ronx_enabled)
+		disable_ro_nx(&mod->core_layout);
 	module_memfree(mod->core_layout.base);
 
 #ifdef CONFIG_MPU
@@ -3428,9 +3435,11 @@ static noinline int do_init_module(struct module *mod)
 	/* Switch to core kallsyms now init is done: kallsyms may be walking! */
 	rcu_assign_pointer(mod->kallsyms, &mod->core_kallsyms);
 #endif
-	module_enable_ro(mod, true);
+	if (module_ronx_enabled)
+		module_enable_ro(mod, true);
 	mod_tree_remove_init(mod);
-	disable_ro_nx(&mod->init_layout);
+	if (module_ronx_enabled)
+		disable_ro_nx(&mod->init_layout);
 	module_arch_freeing_init(mod);
 	mod->init_layout.base = NULL;
 	mod->init_layout.size = 0;
@@ -3527,8 +3536,10 @@ static int complete_formation(struct module *mod, struct load_info *info)
 	/* This relies on module_mutex for list integrity. */
 	module_bug_finalize(info->hdr, info->sechdrs, mod);
 
-	module_enable_ro(mod, false);
-	module_enable_nx(mod);
+	if (module_ronx_enabled) {
+		module_enable_ro(mod, false);
+		module_enable_nx(mod);
+	}
 
 	/* Mark state as coming so strong_try_module_get() ignores us,
 	 * but kallsyms etc. can see us. */
@@ -3718,8 +3729,10 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	mutex_unlock(&module_mutex);
 
 	/* we can't deallocate the module until we clear memory protection */
-	module_disable_ro(mod);
-	module_disable_nx(mod);
+	if (module_ronx_enabled) {
+		module_disable_ro(mod);
+		module_disable_nx(mod);
+	}
 
  ddebug_cleanup:
 	dynamic_debug_remove(info->debug);
-- 
2.10.0
