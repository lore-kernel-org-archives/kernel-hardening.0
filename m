From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v3 2/3] modules: Create rlimit for module space
Date: Fri, 19 Oct 2018 13:47:22 -0700
Message-Id: <20181019204723.3903-3-rick.p.edgecombe@intel.com>
In-Reply-To: <20181019204723.3903-1-rick.p.edgecombe@intel.com>
References: <20181019204723.3903-1-rick.p.edgecombe@intel.com>
To: kernel-hardening@lists.openwall.com, daniel@iogearbox.net, keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org, arnd@arndb.de, jeyu@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, jannh@google.com
Cc: kristen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, deneen.t.dock@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

This introduces a new rlimit, RLIMIT_MODSPACE, which limits the amount of
module space a user can use. The intention is to be able to limit module space
allocations that may come from un-privlidged users inserting e/BPF filters.

Since filters attached to sockets can be passed to other processes via domain
sockets and freed there, there is new tracking for the uid of each allocation.
This way if the allocation is freed by a different user, it will not throw off
the accounting.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/pgtable_32_types.h |   3 +
 arch/x86/include/asm/pgtable_64_types.h |   2 +
 fs/proc/base.c                          |   1 +
 include/asm-generic/resource.h          |   8 ++
 include/linux/sched/user.h              |   4 +
 include/uapi/asm-generic/resource.h     |   3 +-
 kernel/module.c                         | 140 +++++++++++++++++++++++-
 7 files changed, 159 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_32_types.h b/arch/x86/include/asm/pgtable_32_types.h
index b0bc0fff5f1f..185e382fa8c3 100644
--- a/arch/x86/include/asm/pgtable_32_types.h
+++ b/arch/x86/include/asm/pgtable_32_types.h
@@ -68,6 +68,9 @@ extern bool __vmalloc_start_set; /* set once high_memory is set */
 #define MODULES_END	VMALLOC_END
 #define MODULES_LEN	(MODULES_VADDR - MODULES_END)
 
+/* Half of 128MB vmalloc space */
+#define MODSPACE_LIMIT (1 << 25)
+
 #define MAXMEM	(VMALLOC_END - PAGE_OFFSET - __VMALLOC_RESERVE)
 
 #endif /* _ASM_X86_PGTABLE_32_DEFS_H */
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 04edd2d58211..39288812be5a 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -143,6 +143,8 @@ extern unsigned int ptrs_per_p4d;
 #define MODULES_END		_AC(0xffffffffff000000, UL)
 #define MODULES_LEN		(MODULES_END - MODULES_VADDR)
 
+#define MODSPACE_LIMIT		(MODULES_LEN / 10)
+
 #define ESPFIX_PGD_ENTRY	_AC(-2, UL)
 #define ESPFIX_BASE_ADDR	(ESPFIX_PGD_ENTRY << P4D_SHIFT)
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7e9f07bf260d..84824f50e9f8 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -562,6 +562,7 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
 	[RLIMIT_NICE] = {"Max nice priority", NULL},
 	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
 	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
+	[RLIMIT_MODSPACE] = {"Max module space", "bytes"},
 };
 
 /* Display limits for a process */
diff --git a/include/asm-generic/resource.h b/include/asm-generic/resource.h
index 8874f681b056..94c150e3dd12 100644
--- a/include/asm-generic/resource.h
+++ b/include/asm-generic/resource.h
@@ -4,6 +4,13 @@
 
 #include <uapi/asm-generic/resource.h>
 
+/*
+ * If the module space rlimit is not defined in an arch specific way, leave
+ * room for 10000 large eBPF filters.
+ */
+#ifndef MODSPACE_LIMIT
+#define MODSPACE_LIMIT (5*PAGE_SIZE*10000)
+#endif
 
 /*
  * boot-time rlimit defaults for the init task:
@@ -26,6 +33,7 @@
 	[RLIMIT_NICE]		= { 0, 0 },				\
 	[RLIMIT_RTPRIO]		= { 0, 0 },				\
 	[RLIMIT_RTTIME]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
+	[RLIMIT_MODSPACE]	= {  MODSPACE_LIMIT,  MODSPACE_LIMIT },	\
 }
 
 #endif
diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index 39ad98c09c58..4c6d99d066fe 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -44,6 +44,10 @@ struct user_struct {
 	atomic_long_t locked_vm;
 #endif
 
+#ifdef CONFIG_MODULES
+	atomic_long_t module_vm;
+#endif
+
 	/* Miscellaneous per-user rate limit */
 	struct ratelimit_state ratelimit;
 };
diff --git a/include/uapi/asm-generic/resource.h b/include/uapi/asm-generic/resource.h
index f12db7a0da64..3f998340ed30 100644
--- a/include/uapi/asm-generic/resource.h
+++ b/include/uapi/asm-generic/resource.h
@@ -46,7 +46,8 @@
 					   0-39 for nice level 19 .. -20 */
 #define RLIMIT_RTPRIO		14	/* maximum realtime priority */
 #define RLIMIT_RTTIME		15	/* timeout for RT tasks in us */
-#define RLIM_NLIMITS		16
+#define RLIMIT_MODSPACE		16	/* max module space address usage */
+#define RLIM_NLIMITS		17
 
 /*
  * SuS says limits have to be unsigned.
diff --git a/kernel/module.c b/kernel/module.c
index 41c22aba8209..c26ad50365dd 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2110,6 +2110,134 @@ static void free_module_elf(struct module *mod)
 }
 #endif /* CONFIG_LIVEPATCH */
 
+struct mod_alloc_user {
+	struct rb_node node;
+	unsigned long addr;
+	unsigned long pages;
+	struct user_struct *user;
+};
+
+static struct rb_root alloc_users = RB_ROOT;
+static DEFINE_SPINLOCK(alloc_users_lock);
+
+static unsigned int get_mod_page_cnt(unsigned long size)
+{
+	/* Add one for guard page */
+	return (PAGE_ALIGN(size) >> PAGE_SHIFT) + 1;
+}
+
+void update_mod_rlimit(void *addr, unsigned long size)
+{
+	unsigned long addrl = (unsigned long) addr;
+	struct rb_node **new = &(alloc_users.rb_node), *parent = NULL;
+	struct mod_alloc_user *track = kmalloc(sizeof(struct mod_alloc_user),
+				GFP_KERNEL);
+	unsigned int pages = get_mod_page_cnt(size);
+	struct user_struct *user = get_current_user();
+
+	/*
+	 * If addr is NULL, then we need to reverse the earlier increment that
+	 * would have happened in an check_inc_mod_rlimit call.
+	 */
+	if (!addr) {
+		atomic_long_sub(pages, &user->module_vm);
+		free_uid(user);
+		return;
+	}
+
+	/* Now, add tracking for the uid that allocated this */
+	track->addr = addrl;
+	track->pages = pages;
+	track->user = user;
+
+	spin_lock(&alloc_users_lock);
+
+	while (*new) {
+		struct mod_alloc_user *cur =
+				rb_entry(*new, struct mod_alloc_user, node);
+		parent = *new;
+		if (cur->addr > addrl)
+			new = &(*new)->rb_left;
+		else
+			new = &(*new)->rb_right;
+	}
+
+	rb_link_node(&(track->node), parent, new);
+	rb_insert_color(&(track->node), &alloc_users);
+
+	spin_unlock(&alloc_users_lock);
+}
+
+/* Remove user allocation tracking, return NULL if allocation untracked */
+static struct user_struct *remove_user_alloc(void *addr, unsigned long *pages)
+{
+	struct rb_node *cur_node = alloc_users.rb_node;
+	unsigned long addrl = (unsigned long) addr;
+	struct mod_alloc_user *cur_alloc_user = NULL;
+	struct user_struct *user;
+
+	spin_lock(&alloc_users_lock);
+	while (cur_node) {
+		cur_alloc_user =
+			rb_entry(cur_node, struct mod_alloc_user, node);
+		if (cur_alloc_user->addr > addrl)
+			cur_node = cur_node->rb_left;
+		else if (cur_alloc_user->addr < addrl)
+			cur_node = cur_node->rb_right;
+		else
+			goto found;
+	}
+	spin_unlock(&alloc_users_lock);
+
+	return NULL;
+found:
+	rb_erase(&cur_alloc_user->node, &alloc_users);
+	spin_unlock(&alloc_users_lock);
+
+	user = cur_alloc_user->user;
+	*pages = cur_alloc_user->pages;
+	kfree(cur_alloc_user);
+
+	return user;
+}
+
+int check_inc_mod_rlimit(unsigned long size)
+{
+	struct user_struct *user = get_current_user();
+	unsigned long modspace_pages = rlimit(RLIMIT_MODSPACE) >> PAGE_SHIFT;
+	unsigned long cur_pages = atomic_long_read(&user->module_vm);
+	unsigned long new_pages = get_mod_page_cnt(size);
+
+	if (rlimit(RLIMIT_MODSPACE) != RLIM_INFINITY
+			&& cur_pages + new_pages > modspace_pages) {
+		free_uid(user);
+		return 1;
+	}
+
+	atomic_long_add(new_pages, &user->module_vm);
+
+	if (atomic_long_read(&user->module_vm) > modspace_pages) {
+		atomic_long_sub(new_pages, &user->module_vm);
+		free_uid(user);
+		return 1;
+	}
+
+	free_uid(user);
+	return 0;
+}
+
+void dec_mod_rlimit(void *addr)
+{
+	unsigned long pages;
+	struct user_struct *user = remove_user_alloc(addr, &pages);
+
+	if (!user)
+		return;
+
+	atomic_long_sub(pages, &user->module_vm);
+	free_uid(user);
+}
+
 void __weak arch_module_memfree(void *module_region)
 {
 	vfree(module_region);
@@ -2118,6 +2246,7 @@ void __weak arch_module_memfree(void *module_region)
 void module_memfree(void *module_region)
 {
 	arch_module_memfree(module_region);
+	dec_mod_rlimit(module_region);
 }
 
 void __weak module_arch_cleanup(struct module *mod)
@@ -2740,7 +2869,16 @@ void * __weak arch_module_alloc(unsigned long size)
 
 void *module_alloc(unsigned long size)
 {
-	return arch_module_alloc(size);
+	void *p;
+
+	if (check_inc_mod_rlimit(size))
+		return NULL;
+
+	p = arch_module_alloc(size);
+
+	update_mod_rlimit(p, size);
+
+	return p;
 }
 
 #ifdef CONFIG_DEBUG_KMEMLEAK
-- 
2.17.1
