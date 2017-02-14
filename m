Date: Wed, 15 Feb 2017 00:24:19 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
Message-ID: <alpine.LRH.2.20.1702150023070.768@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] [RFC v2 PATCH 2/2] security: mark LSM hooks as __ro_after_init
To: linux-security-module@vger.kernel.org
Cc: selinux@tycho.nsa.gov, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Mark LSM hooks as __ro_after_init (via the __lsm_ro_after_init macro).

Signed-off-by: James Morris <james.l.morris@oracle.com>
---
 security/apparmor/lsm.c    |    2 +-
 security/commoncap.c       |    2 +-
 security/loadpin/loadpin.c |    2 +-
 security/security.c        |    2 +-
 security/selinux/hooks.c   |    2 +-
 security/smack/smack_lsm.c |    2 +-
 security/tomoyo/tomoyo.c   |    2 +-
 security/yama/yama_lsm.c   |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 709eacd..e287b69 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -587,7 +587,7 @@ static int apparmor_task_setrlimit(struct task_struct *task,
 	return error;
 }
 
-static struct security_hook_list apparmor_hooks[] = {
+static struct security_hook_list apparmor_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(ptrace_access_check, apparmor_ptrace_access_check),
 	LSM_HOOK_INIT(ptrace_traceme, apparmor_ptrace_traceme),
 	LSM_HOOK_INIT(capget, apparmor_capget),
diff --git a/security/commoncap.c b/security/commoncap.c
index 6d4d586..a9db18c 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -1070,7 +1070,7 @@ int cap_mmap_file(struct file *file, unsigned long reqprot,
 
 #ifdef CONFIG_SECURITY
 
-struct security_hook_list capability_hooks[] = {
+struct security_hook_list capability_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(capable, cap_capable),
 	LSM_HOOK_INIT(settime, cap_settime),
 	LSM_HOOK_INIT(ptrace_access_check, cap_ptrace_access_check),
diff --git a/security/loadpin/loadpin.c b/security/loadpin/loadpin.c
index 1d82eae..dbe6efd 100644
--- a/security/loadpin/loadpin.c
+++ b/security/loadpin/loadpin.c
@@ -174,7 +174,7 @@ static int loadpin_read_file(struct file *file, enum kernel_read_file_id id)
 	return 0;
 }
 
-static struct security_hook_list loadpin_hooks[] = {
+static struct security_hook_list loadpin_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(sb_free_security, loadpin_sb_free_security),
 	LSM_HOOK_INIT(kernel_read_file, loadpin_read_file),
 };
diff --git a/security/security.c b/security/security.c
index d0e07f2..75ed309 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1622,7 +1622,7 @@ int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
 }
 #endif /* CONFIG_AUDIT */
 
-struct security_hook_heads security_hook_heads = {
+struct security_hook_heads security_hook_heads __lsm_ro_after_init = {
 	.binder_set_context_mgr =
 		LIST_HEAD_INIT(security_hook_heads.binder_set_context_mgr),
 	.binder_transaction =
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9bc12bc..b1a9916 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6104,7 +6104,7 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 
 #endif
 
-static struct security_hook_list selinux_hooks[] = {
+static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(binder_set_context_mgr, selinux_binder_set_context_mgr),
 	LSM_HOOK_INIT(binder_transaction, selinux_binder_transaction),
 	LSM_HOOK_INIT(binder_transfer_binder, selinux_binder_transfer_binder),
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 60b4217..71e24d8 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4633,7 +4633,7 @@ static int smack_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
 	return 0;
 }
 
-static struct security_hook_list smack_hooks[] = {
+static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(ptrace_access_check, smack_ptrace_access_check),
 	LSM_HOOK_INIT(ptrace_traceme, smack_ptrace_traceme),
 	LSM_HOOK_INIT(syslog, smack_syslog),
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index edc52d6..b5fb930 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -496,7 +496,7 @@ static int tomoyo_socket_sendmsg(struct socket *sock, struct msghdr *msg,
  * tomoyo_security_ops is a "struct security_operations" which is used for
  * registering TOMOYO.
  */
-static struct security_hook_list tomoyo_hooks[] = {
+static struct security_hook_list tomoyo_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(cred_alloc_blank, tomoyo_cred_alloc_blank),
 	LSM_HOOK_INIT(cred_prepare, tomoyo_cred_prepare),
 	LSM_HOOK_INIT(cred_transfer, tomoyo_cred_transfer),
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 88271a3..8298e09 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -428,7 +428,7 @@ int yama_ptrace_traceme(struct task_struct *parent)
 	return rc;
 }
 
-static struct security_hook_list yama_hooks[] = {
+static struct security_hook_list yama_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(ptrace_access_check, yama_ptrace_access_check),
 	LSM_HOOK_INIT(ptrace_traceme, yama_ptrace_traceme),
 	LSM_HOOK_INIT(task_prctl, yama_task_prctl),
-- 
1.7.1
