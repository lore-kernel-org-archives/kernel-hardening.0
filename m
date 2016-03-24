Reply-To: kernel-hardening@lists.openwall.com
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Thu, 24 Mar 2016 03:53:57 +0100
Message-Id: <1458788042-26173-4-git-send-email-mic@digikod.net>
In-Reply-To: <1458788042-26173-1-git-send-email-mic@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <1458788042-26173-1-git-send-email-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [RFC v1 12/17] audit,seccomp: Extend audit with seccomp state
To: linux-security-module@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Extend the audit framework to known if we are in a seccomp filter
evaluation or not.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <pmoore@redhat.com>
Cc: Will Drewry <wad@chromium.org>
---
 include/linux/audit.h | 25 +++++++++++++++++++++++++
 kernel/audit.h        |  3 +++
 kernel/auditsc.c      | 36 ++++++++++++++++++++++++++++++++++--
 kernel/seccomp.c      | 21 ++++++++++++++++++---
 4 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index b40ed5df5542..480df19473d9 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -230,6 +230,8 @@ extern void __audit_free(struct task_struct *task);
 extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
 				  unsigned long a2, unsigned long a3);
 extern void __audit_syscall_exit(int ret_success, long ret_value);
+extern void __audit_seccomp_entry(void);
+extern void __audit_seccomp_exit(int do_free);
 extern struct filename *__audit_reusename(const __user char *uptr);
 extern void __audit_getname(struct filename *name);
 
@@ -270,17 +272,40 @@ static inline void audit_syscall_exit(void *pt_regs)
 		__audit_syscall_exit(success, return_code);
 	}
 }
+
+static inline void audit_seccomp_entry(void)
+{
+	if (unlikely(current->audit_context))
+		__audit_seccomp_entry();
+}
+
+static inline void audit_seccomp_exit(int do_free)
+{
+	if (unlikely(current->audit_context))
+		__audit_seccomp_exit(do_free);
+}
+
 static inline struct filename *audit_reusename(const __user char *name)
 {
 	if (unlikely(!audit_dummy_context()))
 		return __audit_reusename(name);
+#ifdef CONFIG_SECURITY_SECCOMP
+	if (current->audit_context)
+		return __audit_reusename(name);
+#endif /* CONFIG_SECURITY_SECCOMP */
 	return NULL;
 }
+
 static inline void audit_getname(struct filename *name)
 {
 	if (unlikely(!audit_dummy_context()))
 		__audit_getname(name);
+#ifdef CONFIG_SECURITY_SECCOMP
+	else if (current->audit_context)
+		__audit_getname(name);
+#endif /* CONFIG_SECURITY_SECCOMP */
 }
+
 static inline void audit_inode(struct filename *name,
 				const struct dentry *dentry,
 				unsigned int parent) {
diff --git a/kernel/audit.h b/kernel/audit.h
index cbbe6bb6496e..c63ce77b44ae 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -108,6 +108,9 @@ struct audit_proctitle {
 struct audit_context {
 	int		    dummy;	/* must be the first element */
 	int		    in_syscall;	/* 1 if task is in a syscall */
+#ifdef CONFIG_SECURITY_SECCOMP
+	int		    in_seccomp;	/* 1 if task is in seccomp */
+#endif
 	enum audit_state    state, current_state;
 	unsigned int	    serial;     /* serial number for record */
 	int		    major;      /* syscall number */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 195ffaee50b9..dd1d9f4b1c61 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1501,7 +1501,10 @@ void __audit_syscall_entry(int major, unsigned long a1, unsigned long a2,
 	if (!context)
 		return;
 
-	BUG_ON(context->in_syscall || context->name_count);
+	BUG_ON(context->in_syscall);
+#ifndef CONFIG_SECURITY_SECCOMP
+	BUG_ON(context->name_count);
+#endif /* CONFIG_SECURITY_SECCOMP */
 
 	if (!audit_enabled)
 		return;
@@ -1580,6 +1583,35 @@ void __audit_syscall_exit(int success, long return_code)
 	tsk->audit_context = context;
 }
 
+void __audit_seccomp_entry(void)
+{
+	struct audit_context *context = current->audit_context;
+
+	if (!context)
+		return;
+	BUG_ON(context->in_seccomp || context->name_count);
+	if (!audit_enabled)
+		return;
+
+	context->in_seccomp = 1;
+}
+
+void __audit_seccomp_exit(int do_free)
+{
+	struct audit_context *context = current->audit_context;
+
+	if (!context)
+		return;
+	BUG_ON(!context->in_seccomp);
+	if (!audit_enabled)
+		return;
+
+	BUG_ON(!context->in_seccomp);
+	context->in_seccomp = 0;
+	if (do_free)
+		audit_free_names(context);
+}
+
 static inline void handle_one(const struct inode *inode)
 {
 #ifdef CONFIG_AUDIT_TREE
@@ -1728,7 +1760,7 @@ void __audit_getname(struct filename *name)
 	struct audit_context *context = current->audit_context;
 	struct audit_names *n;
 
-	if (!context->in_syscall)
+	if (!context->in_syscall && !context->in_seccomp)
 		return;
 
 	n = audit_alloc_name(context, AUDIT_TYPE_UNKNOWN);
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 60e11863857e..a8a6ba31ecc4 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -881,7 +881,7 @@ int __secure_computing(void)
 static u32 __seccomp_phase1_filter(int this_syscall, struct seccomp_data *sd)
 {
 	u32 filter_ret, action;
-	int data;
+	int data, ret;
 
 	/*
 	 * Make sure that any changes to mode from another thread have
@@ -889,6 +889,9 @@ static u32 __seccomp_phase1_filter(int this_syscall, struct seccomp_data *sd)
 	 */
 	rmb();
 
+	/* Enable caching */
+	audit_seccomp_entry();
+
 	filter_ret = seccomp_run_filters(sd);
 	data = filter_ret & SECCOMP_RET_DATA;
 	action = filter_ret & SECCOMP_RET_ACTION;
@@ -910,13 +913,15 @@ static u32 __seccomp_phase1_filter(int this_syscall, struct seccomp_data *sd)
 		goto skip;
 
 	case SECCOMP_RET_TRACE:
-		return filter_ret;  /* Save the rest for phase 2. */
+		ret = filter_ret;  /* Save the rest for phase 2. */
+		goto audit_exit;
 
 	case SECCOMP_RET_ARGEVAL:
 		/* Handled in seccomp_run_filters() */
 		BUG();
 	case SECCOMP_RET_ALLOW:
-		return SECCOMP_PHASE1_OK;
+		ret = SECCOMP_PHASE1_OK;
+		goto audit_exit;
 
 	case SECCOMP_RET_KILL:
 	default:
@@ -926,7 +931,12 @@ static u32 __seccomp_phase1_filter(int this_syscall, struct seccomp_data *sd)
 
 	unreachable();
 
+audit_exit:
+	audit_seccomp_exit(0);
+	return ret;
+
 skip:
+	audit_seccomp_exit(1);
 	audit_seccomp(this_syscall, 0, action);
 	return SECCOMP_PHASE1_SKIP;
 }
@@ -1139,6 +1149,11 @@ static long seccomp_add_checker_group(unsigned int flags, const char __user *gro
 	unsigned long group_size, kcheckers_size, full_group_size;
 	long result;
 
+	/* FIXME: Deny unsecure path evaluation (i.e. without audit_names) for
+	 * the entire task life.
+	 */
+	if (!current->audit_context)
+		return -EPERM;
 	if (!task_no_new_privs(current) &&
 	    security_capable_noaudit(current_cred(),
 				     current_user_ns(), CAP_SYS_ADMIN) != 0)
-- 
2.8.0.rc3
