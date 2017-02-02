From: Djalal Harouni <tixxdz@gmail.com>
Date: Thu,  2 Feb 2017 18:04:52 +0100
Message-Id: <1486055094-4532-2-git-send-email-djalal@gmail.com>
In-Reply-To: <1486055094-4532-1-git-send-email-djalal@gmail.com>
References: <1486055094-4532-1-git-send-email-djalal@gmail.com>
Subject: [kernel-hardening] [RFC/PATCH 1/3] security: add the security_task_copy() hook
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lafcadio Wluiki <wluikil@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Dongsu Park <dongsu@endocode.com>, Andy Lutomirski <luto@kernel.org>, James Morris <james.l.morris@oracle.com>, serge@hallyn.com, Al Viro <viro@zeniv.linux.org.uk>, Daniel Mack <daniel@zonque.org>, Jann Horn <jann@thejh.net>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Djalal Harouni <tixxdz@gmail.com>

This hook is needed by Timgad LSM. Timgad uses a sysctl and a
per-process prctl() interface to control which processes are allowed to
load and unload modules. However to achieve that we need new hooks to
save the context of tasks.

Sadly there is no way, if we want to add new LSMs we are faced with two
choices:

1) Either fight and collide we other major LSMs since all of them
   they do save their context on the same shared security structs.

2) If we want our module to be a minor stackable LSM, that can be used
   easily without any pain, we have to find a new way to store our context.

Our use case is more in the seccomp logic, we want to add or fix a gap
that seccomp can not handle. At the same time we want to keep the
interface as easy as possible for userspace sandboxing. After some
years it seems like a good easy security feature for userspace should
apply at the same time when we apply: seccomp filters and the
no_new_privs flag.

To achieve the above we add the security_task_copy() hook that allows us
to clone the Timgad context of parent into child task_struct.

The security hook can also be used by new LSMs after the child task has
done some initialization, this way they won't clash with the major LSMs.
The situation is not really well, this hook allows us to introduce a
stackable LSM that can be easily used with all other LSMs.

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 include/linux/lsm_hooks.h | 2 ++
 include/linux/security.h  | 6 ++++++
 kernel/fork.c             | 4 ++++
 security/security.c       | 6 ++++++
 4 files changed, 18 insertions(+)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 558adfa..b37e35e 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1479,6 +1479,7 @@ union security_list_options {
 	int (*file_open)(struct file *file, const struct cred *cred);
 
 	int (*task_create)(unsigned long clone_flags);
+	int (*task_copy)(struct task_struct *task);
 	void (*task_free)(struct task_struct *task);
 	int (*cred_alloc_blank)(struct cred *cred, gfp_t gfp);
 	void (*cred_free)(struct cred *cred);
@@ -1745,6 +1746,7 @@ struct security_hook_heads {
 	struct list_head file_receive;
 	struct list_head file_open;
 	struct list_head task_create;
+	struct list_head task_copy;
 	struct list_head task_free;
 	struct list_head cred_alloc_blank;
 	struct list_head cred_free;
diff --git a/include/linux/security.h b/include/linux/security.h
index c2125e9..748058e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -305,6 +305,7 @@ int security_file_send_sigiotask(struct task_struct *tsk,
 int security_file_receive(struct file *file);
 int security_file_open(struct file *file, const struct cred *cred);
 int security_task_create(unsigned long clone_flags);
+int security_task_copy(struct task_struct *task);
 void security_task_free(struct task_struct *task);
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp);
 void security_cred_free(struct cred *cred);
@@ -857,6 +858,11 @@ static inline int security_task_create(unsigned long clone_flags)
 	return 0;
 }
 
+static inline int security_task_copy(struct task_struct *task)
+{
+	return 0;
+}
+
 static inline void security_task_free(struct task_struct *task)
 { }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 11c5c8a..81c29d8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1746,6 +1746,10 @@ static __latent_entropy struct task_struct *copy_process(
 	if (retval)
 		goto bad_fork_free_pid;
 
+	retval = security_task_copy(p);
+	if (retval)
+		goto bad_fork_cancel_cgroup;
+
 	/*
 	 * Make it visible to the rest of the system, but dont wake it up yet.
 	 * Need tasklist lock for parent etc handling!
diff --git a/security/security.c b/security/security.c
index f825304..5c699c8 100644
--- a/security/security.c
+++ b/security/security.c
@@ -892,6 +892,11 @@ int security_task_create(unsigned long clone_flags)
 	return call_int_hook(task_create, 0, clone_flags);
 }
 
+int security_task_copy(struct task_struct *task)
+{
+	return call_int_hook(task_copy, 0, task);
+}
+
 void security_task_free(struct task_struct *task)
 {
 	call_void_hook(task_free, task);
@@ -1731,6 +1736,7 @@ struct security_hook_heads security_hook_heads = {
 	.file_receive =	LIST_HEAD_INIT(security_hook_heads.file_receive),
 	.file_open =	LIST_HEAD_INIT(security_hook_heads.file_open),
 	.task_create =	LIST_HEAD_INIT(security_hook_heads.task_create),
+	.task_copy =    LIST_HEAD_INIT(security_hook_heads.task_copy),
 	.task_free =	LIST_HEAD_INIT(security_hook_heads.task_free),
 	.cred_alloc_blank =
 		LIST_HEAD_INIT(security_hook_heads.cred_alloc_blank),
-- 
2.5.5
