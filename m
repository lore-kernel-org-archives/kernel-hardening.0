From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LRH.2.20.1702150016220.32759@namei.org>
	<201702142324.IFB95862.MOSJLOVFQFtFHO@I-love.SAKURA.ne.jp>
	<alpine.LRH.2.20.1702150952360.6813@namei.org>
In-Reply-To: <alpine.LRH.2.20.1702150952360.6813@namei.org>
Message-Id: <201702152342.GBH04183.FOFJFHQOLMOtVS@I-love.SAKURA.ne.jp>
Date: Wed, 15 Feb 2017 23:42:35 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [RFC v2 PATCH 1/2] security: introduce CONFIG_SECURITY_WRITABLE_HOOKS
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

James Morris wrote:
> On Tue, 14 Feb 2017, Tetsuo Handa wrote:
> 
> > > diff --git a/security/Kconfig b/security/Kconfig
> > > index 118f454..f6f90c4 100644
> > > --- a/security/Kconfig
> > > +++ b/security/Kconfig
> > > @@ -31,6 +31,11 @@ config SECURITY
> > >  
> > >  	  If you are unsure how to answer this question, answer N.
> > >  
> > > +config SECURITY_WRITABLE_HOOKS
> > > +	depends on SECURITY
> > > +	bool
> > > +	default n
> > > +
> > 
> > This configuration option must not be set to N without big fat explanation
> > about implications of setting this option to N.
> 
> It's not visible in the config menu, it's only there to support SELinux 
> runtime disablement, otherwise it wouldn't even be an option.
> 
> > 
> > Honestly, I still don't like this option, regardless of whether SELinux
> > needs this option or not.
> > 
> 
> I agree, it would be better to just enable RO hardening without an option 
> to disable it.

Here is my version. printk() is only for testing purpose and will be removed
in the final version.

  (1) Use set_memory_ro() instead of __ro_after_init so that runtime disablement
      of SELinux and runtime enablement of dynamically loadable LSMs can use
      set_memory_rw().

  (2) Replace "struct security_hook_list"->head with "struct security_hook_list"->offset
      so that "struct security_hook_heads security_hook_heads;" can become a local variable
      in security/security.c .

  (3) (Not in this patch.) The "struct security_hook_list" variable in each LSM
      module is considered as "__init" and "const" because the content is copied to
      dynamically allocated (and protected via set_memory_ro()) memory pages.

  (4) (Not in this patch.) If we add EXPORT_SYMBOL_GPL(security_add_hooks), dynamically
      loadable LSMs are legally allowed.

 include/linux/lsm_hooks.h |   31 +++++++---------
 security/security.c       |   89 ++++++++++++++++++++++++++++++++++++++++++----
 security/selinux/hooks.c  |   12 +++++-
 3 files changed, 107 insertions(+), 25 deletions(-)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index e29d4c6..00050a7 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1865,9 +1865,16 @@ struct security_hook_heads {
  */
 struct security_hook_list {
 	struct list_head		list;
-	struct list_head		*head;
 	union security_list_options	hook;
-	char				*lsm;
+	const char			*lsm;
+	unsigned int			offset;
+};
+
+struct lsm_entry {
+	struct list_head head;
+	unsigned int order;
+	unsigned int count;
+	struct security_hook_list hooks[0];
 };
 
 /*
@@ -1877,14 +1884,13 @@ struct security_hook_list {
  * text involved.
  */
 #define LSM_HOOK_INIT(HEAD, HOOK) \
-	{ .head = &security_hook_heads.HEAD, .hook = { .HEAD = HOOK } }
+	{ .offset = offsetof(struct security_hook_heads, HEAD), \
+	  .hook = { .HEAD = HOOK } }
 
-extern struct security_hook_heads security_hook_heads;
 extern char *lsm_names;
 
-extern void security_add_hooks(struct security_hook_list *hooks, int count,
-				char *lsm);
-
+extern struct lsm_entry *security_add_hooks(const struct security_hook_list *
+					    hooks, int count, const char *lsm);
 #ifdef CONFIG_SECURITY_SELINUX_DISABLE
 /*
  * Assuring the safety of deleting a security module is up to
@@ -1898,15 +1904,8 @@ extern void security_add_hooks(struct security_hook_list *hooks, int count,
  * disabling their module is a good idea needs to be at least as
  * careful as the SELinux team.
  */
-static inline void security_delete_hooks(struct security_hook_list *hooks,
-						int count)
-{
-	int i;
-
-	for (i = 0; i < count; i++)
-		list_del_rcu(&hooks[i].list);
-}
-#endif /* CONFIG_SECURITY_SELINUX_DISABLE */
+extern void security_delete_hooks(struct lsm_entry *entry);
+#endif
 
 extern int __init security_module_enable(const char *module);
 extern void __init capability_add_hooks(void);
diff --git a/security/security.c b/security/security.c
index d0e07f2..dffe69b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -32,6 +32,7 @@
 /* Maximum number of letters for an LSM name string */
 #define SECURITY_NAME_MAX	10
 
+static bool lsm_initialized;
 char *lsm_names;
 /* Boot-time LSM user choice */
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
@@ -47,6 +48,38 @@ static void __init do_security_initcalls(void)
 	}
 }
 
+static struct security_hook_heads security_hook_heads;
+static LIST_HEAD(lsm_entry_list);
+#ifdef CONFIG_DEBUG_RODATA
+static inline void mark_security_hooks_ro(void)
+{
+	struct lsm_entry *tmp;
+
+	list_for_each_entry(tmp, &lsm_entry_list, head) {
+		printk("Marking LSM hooks at %p read only.\n", tmp);
+		set_memory_ro((unsigned long) tmp, 1 << tmp->order);
+	}
+}
+
+static inline void mark_security_hooks_rw(void)
+{
+	struct lsm_entry *tmp;
+
+	list_for_each_entry(tmp, &lsm_entry_list, head) {
+		printk("Marking LSM hooks at %p read write.\n", tmp);
+		set_memory_rw((unsigned long) tmp, 1 << tmp->order);
+	}
+}
+#else
+static inline void mark_security_hooks_ro(void)
+{
+}
+
+static inline void mark_security_hooks_rw(void)
+{
+}
+#endif
+
 /**
  * security_init - initializes the security framework
  *
@@ -68,6 +101,8 @@ int __init security_init(void)
 	 */
 	do_security_initcalls();
 
+	lsm_initialized = true;
+	mark_security_hooks_ro();
 	return 0;
 }
 
@@ -79,7 +114,7 @@ static int __init choose_lsm(char *str)
 }
 __setup("security=", choose_lsm);
 
-static int lsm_append(char *new, char **result)
+static int lsm_append(const char *new, char **result)
 {
 	char *cp;
 
@@ -122,18 +157,58 @@ int __init security_module_enable(const char *module)
  *
  * Each LSM has to register its hooks with the infrastructure.
  */
-void __init security_add_hooks(struct security_hook_list *hooks, int count,
-				char *lsm)
+struct lsm_entry *security_add_hooks(const struct security_hook_list *hooks,
+				     int count, const char *lsm)
 {
 	int i;
+	/*
+	 * entry has to be an PAGE_ALIGNED multiple of PAGE_SIZE memory
+	 * in order to pass to set_memory_ro()/set_memory_rw().
+	 */
+	const size_t size = sizeof(*hooks) * count + sizeof(struct lsm_entry);
+	const unsigned int order = get_order(size);
+	struct lsm_entry *entry = kmalloc_order(size, GFP_KERNEL | __GFP_ZERO,
+						order);
 
+	if (!entry || !PAGE_ALIGNED(entry) || lsm_append(lsm, &lsm_names) < 0) {
+		kfree(entry);
+		goto out;
+	}
+	if (lsm_initialized)
+		mark_security_hooks_rw();
+	printk("Allocating LSM hooks for %s at %p\n", lsm, entry);
+	entry->order = order;
+	entry->count = count;
+	memcpy(&entry->hooks[0], hooks, size - sizeof(struct lsm_entry));
 	for (i = 0; i < count; i++) {
-		hooks[i].lsm = lsm;
-		list_add_tail_rcu(&hooks[i].list, hooks[i].head);
+		entry->hooks[i].lsm = lsm;
+		list_add_tail_rcu(&entry->hooks[i].list, (struct list_head *)
+				  (((char *) &security_hook_heads)
+				   + entry->hooks[i].offset));
 	}
-	if (lsm_append(lsm, &lsm_names) < 0)
+	list_add_tail(&entry->head, &lsm_entry_list);
+	if (lsm_initialized)
+		mark_security_hooks_ro();
+	return entry;
+ out:
+	if (!lsm_initialized)
 		panic("%s - Cannot get early memory.\n", __func__);
+	return NULL;
+}
+
+#ifdef CONFIG_SECURITY_SELINUX_DISABLE
+void security_delete_hooks(struct lsm_entry *entry)
+{
+	int i;
+
+	mark_security_hooks_rw();
+	list_del_rcu(&entry->head);
+	for (i = 0; i < entry->count; i++)
+		list_del_rcu(&entry->hooks[i].list);
+	/* Not calling kfree() in order to avoid races. */
+	mark_security_hooks_ro();
 }
+#endif /* CONFIG_SECURITY_SELINUX_DISABLE */
 
 /*
  * Hook list operation macros.
@@ -1622,7 +1697,7 @@ int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
 }
 #endif /* CONFIG_AUDIT */
 
-struct security_hook_heads security_hook_heads = {
+static struct security_hook_heads security_hook_heads = {
 	.binder_set_context_mgr =
 		LIST_HEAD_INIT(security_hook_heads.binder_set_context_mgr),
 	.binder_transaction =
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9bc12bc..4668590 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6319,6 +6319,10 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 #endif
 };
 
+#ifdef CONFIG_SECURITY_SELINUX_DISABLE
+static struct lsm_entry *selinux_entry;
+#endif
+
 static __init int selinux_init(void)
 {
 	if (!security_module_enable("selinux")) {
@@ -6346,7 +6350,11 @@ static __init int selinux_init(void)
 					    0, SLAB_PANIC, NULL);
 	avc_init();
 
-	security_add_hooks(selinux_hooks, ARRAY_SIZE(selinux_hooks), "selinux");
+#ifdef CONFIG_SECURITY_SELINUX_DISABLE
+	selinux_entry =
+#endif
+		security_add_hooks(selinux_hooks, ARRAY_SIZE(selinux_hooks),
+				   "selinux");
 
 	if (avc_add_callback(selinux_netcache_avc_callback, AVC_CALLBACK_RESET))
 		panic("SELinux: Unable to register AVC netcache callback\n");
@@ -6475,7 +6483,7 @@ int selinux_disable(void)
 	selinux_disabled = 1;
 	selinux_enabled = 0;
 
-	security_delete_hooks(selinux_hooks, ARRAY_SIZE(selinux_hooks));
+	security_delete_hooks(selinux_entry);
 
 	/* Try to destroy the avc node cache */
 	avc_disable();
