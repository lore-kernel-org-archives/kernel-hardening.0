From: nadav.amit@gmail.com
Subject: [PATCH v6 18/24] modules: Use vmalloc special flag
Date: Fri, 26 Apr 2019 16:22:57 -0700
Message-Id: <20190426232303.28381-19-nadav.amit@gmail.com>
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>, Jessica Yu <jeyu@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Use new flag for handling freeing of special permissioned memory in vmalloc
and remove places where memory was set RW before freeing which is no longer
needed.

Since freeing of VM_FLUSH_RESET_PERMS memory is not supported in an
interrupt by vmalloc, the freeing of init sections is moved to a work
queue. Instead of call_rcu it now uses synchronize_rcu() in the work
queue.

Lastly, there is now a WARN_ON in module_memfree since it should not be
called in an interrupt with special memory as is required for
VM_FLUSH_RESET_PERMS.

Cc: Jessica Yu <jeyu@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 kernel/module.c | 77 +++++++++++++++++++++++++------------------------
 1 file changed, 39 insertions(+), 38 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 2b2845ae983e..a9020bdd4cf6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -98,6 +98,10 @@ DEFINE_MUTEX(module_mutex);
 EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
 
+/* Work queue for freeing init sections in success case */
+static struct work_struct init_free_wq;
+static struct llist_head init_free_list;
+
 #ifdef CONFIG_MODULES_TREE_LOOKUP
 
 /*
@@ -1949,6 +1953,8 @@ void module_enable_ro(const struct module *mod, bool after_init)
 	if (!rodata_enabled)
 		return;
 
+	set_vm_flush_reset_perms(mod->core_layout.base);
+	set_vm_flush_reset_perms(mod->init_layout.base);
 	frob_text(&mod->core_layout, set_memory_ro);
 	frob_text(&mod->core_layout, set_memory_x);
 
@@ -1972,15 +1978,6 @@ static void module_enable_nx(const struct module *mod)
 	frob_writable_data(&mod->init_layout, set_memory_nx);
 }
 
-static void module_disable_nx(const struct module *mod)
-{
-	frob_rodata(&mod->core_layout, set_memory_x);
-	frob_ro_after_init(&mod->core_layout, set_memory_x);
-	frob_writable_data(&mod->core_layout, set_memory_x);
-	frob_rodata(&mod->init_layout, set_memory_x);
-	frob_writable_data(&mod->init_layout, set_memory_x);
-}
-
 /* Iterate through all modules and set each module's text as RW */
 void set_all_modules_text_rw(void)
 {
@@ -2024,23 +2021,8 @@ void set_all_modules_text_ro(void)
 	}
 	mutex_unlock(&module_mutex);
 }
-
-static void disable_ro_nx(const struct module_layout *layout)
-{
-	if (rodata_enabled) {
-		frob_text(layout, set_memory_rw);
-		frob_rodata(layout, set_memory_rw);
-		frob_ro_after_init(layout, set_memory_rw);
-	}
-	frob_rodata(layout, set_memory_x);
-	frob_ro_after_init(layout, set_memory_x);
-	frob_writable_data(layout, set_memory_x);
-}
-
 #else
-static void disable_ro_nx(const struct module_layout *layout) { }
 static void module_enable_nx(const struct module *mod) { }
-static void module_disable_nx(const struct module *mod) { }
 #endif
 
 #ifdef CONFIG_LIVEPATCH
@@ -2120,6 +2102,11 @@ static void free_module_elf(struct module *mod)
 
 void __weak module_memfree(void *module_region)
 {
+	/*
+	 * This memory may be RO, and freeing RO memory in an interrupt is not
+	 * supported by vmalloc.
+	 */
+	WARN_ON(in_interrupt());
 	vfree(module_region);
 }
 
@@ -2171,7 +2158,6 @@ static void free_module(struct module *mod)
 	mutex_unlock(&module_mutex);
 
 	/* This may be empty, but that's OK */
-	disable_ro_nx(&mod->init_layout);
 	module_arch_freeing_init(mod);
 	module_memfree(mod->init_layout.base);
 	kfree(mod->args);
@@ -2181,7 +2167,6 @@ static void free_module(struct module *mod)
 	lockdep_free_key_range(mod->core_layout.base, mod->core_layout.size);
 
 	/* Finally, free the core (containing the module structure) */
-	disable_ro_nx(&mod->core_layout);
 	module_memfree(mod->core_layout.base);
 }
 
@@ -3420,17 +3405,34 @@ static void do_mod_ctors(struct module *mod)
 
 /* For freeing module_init on success, in case kallsyms traversing */
 struct mod_initfree {
-	struct rcu_head rcu;
+	struct llist_node node;
 	void *module_init;
 };
 
-static void do_free_init(struct rcu_head *head)
+static void do_free_init(struct work_struct *w)
 {
-	struct mod_initfree *m = container_of(head, struct mod_initfree, rcu);
-	module_memfree(m->module_init);
-	kfree(m);
+	struct llist_node *pos, *n, *list;
+	struct mod_initfree *initfree;
+
+	list = llist_del_all(&init_free_list);
+
+	synchronize_rcu();
+
+	llist_for_each_safe(pos, n, list) {
+		initfree = container_of(pos, struct mod_initfree, node);
+		module_memfree(initfree->module_init);
+		kfree(initfree);
+	}
 }
 
+static int __init modules_wq_init(void)
+{
+	INIT_WORK(&init_free_wq, do_free_init);
+	init_llist_head(&init_free_list);
+	return 0;
+}
+module_init(modules_wq_init);
+
 /*
  * This is where the real work happens.
  *
@@ -3507,7 +3509,6 @@ static noinline int do_init_module(struct module *mod)
 #endif
 	module_enable_ro(mod, true);
 	mod_tree_remove_init(mod);
-	disable_ro_nx(&mod->init_layout);
 	module_arch_freeing_init(mod);
 	mod->init_layout.base = NULL;
 	mod->init_layout.size = 0;
@@ -3518,14 +3519,18 @@ static noinline int do_init_module(struct module *mod)
 	 * We want to free module_init, but be aware that kallsyms may be
 	 * walking this with preempt disabled.  In all the failure paths, we
 	 * call synchronize_rcu(), but we don't want to slow down the success
-	 * path, so use actual RCU here.
+	 * path. module_memfree() cannot be called in an interrupt, so do the
+	 * work and call synchronize_rcu() in a work queue.
+	 *
 	 * Note that module_alloc() on most architectures creates W+X page
 	 * mappings which won't be cleaned up until do_free_init() runs.  Any
 	 * code such as mark_rodata_ro() which depends on those mappings to
 	 * be cleaned up needs to sync with the queued work - ie
 	 * rcu_barrier()
 	 */
-	call_rcu(&freeinit->rcu, do_free_init);
+	if (llist_add(&freeinit->node, &init_free_list))
+		schedule_work(&init_free_wq);
+
 	mutex_unlock(&module_mutex);
 	wake_up_all(&module_wq);
 
@@ -3822,10 +3827,6 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	module_bug_cleanup(mod);
 	mutex_unlock(&module_mutex);
 
-	/* we can't deallocate the module until we clear memory protection */
-	module_disable_ro(mod);
-	module_disable_nx(mod);
-
  ddebug_cleanup:
 	ftrace_release_mod(mod);
 	dynamic_debug_remove(mod, info->debug);
-- 
2.17.1
