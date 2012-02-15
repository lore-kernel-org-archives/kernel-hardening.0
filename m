Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 14 Feb 2012 16:48:09 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20120215004809.GO20420@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] Yama: add PR_SET_PTRACER_ANY
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, John Johansen <john.johansen@canonical.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

For a process to entirely disable Yama ptrace restrictions, it can use
the special PR_SET_PTRACER_ANY pid to indicate that any otherwise allowed
process may ptrace it. This is stronger than calling PR_SET_PTRACER with
pid "1" because it includes processes in external pid namespaces. This is
currently needed by the Chrome renderer, since its crash handler (Breakpad)
runs external to the renderer's pid namespace.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/security/Yama.txt |    7 ++++++-
 include/linux/prctl.h           |    1 +
 security/yama/yama_lsm.c        |    8 ++++++--
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/security/Yama.txt b/Documentation/security/Yama.txt
index 4f0b789..a9511f1 100644
--- a/Documentation/security/Yama.txt
+++ b/Documentation/security/Yama.txt
@@ -41,7 +41,12 @@ other process (and its descendents) are allowed to call PTRACE_ATTACH
 against it. Only one such declared debugging process can exists for
 each inferior at a time. For example, this is used by KDE, Chromium, and
 Firefox's crash handlers, and by Wine for allowing only Wine processes
-to ptrace each other.
+to ptrace each other. If a process wishes to entirely disable these ptrace
+restrictions, it can call prctl(PR_SET_PTRACER, PR_SET_PTRACER_ANY, ...)
+so that any otherwise allowed process (even those in external pid namespaces)
+may attach.
+
+The sysctl settings are:
 
 0 - classic ptrace permissions: a process can PTRACE_ATTACH to any other
     process running under the same uid, as long as it is dumpable (i.e.
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 4d0e5bc..a0413ac 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -119,5 +119,6 @@
  * A value of 0 mean "no process".
  */
 #define PR_SET_PTRACER 0x59616d61
+# define PR_SET_PTRACER_ANY ((unsigned long)-1)
 
 #endif /* _LINUX_PRCTL_H */
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index dd4d360..5737238 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -84,7 +84,7 @@ static void yama_ptracer_del(struct task_struct *tracer,
 	spin_lock_bh(&ptracer_relations_lock);
 	list_for_each_entry_safe(relation, safe, &ptracer_relations, node)
 		if (relation->tracee == tracee ||
-		    relation->tracer == tracer) {
+		    (tracer && relation->tracer == tracer)) {
 			list_del(&relation->node);
 			kfree(relation);
 		}
@@ -138,6 +138,8 @@ static int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 		if (arg2 == 0) {
 			yama_ptracer_del(NULL, myself);
 			rc = 0;
+		} else if (arg2 == PR_SET_PTRACER_ANY) {
+			rc = yama_ptracer_add(NULL, myself);
 		} else {
 			struct task_struct *tracer;
 
@@ -208,6 +210,7 @@ static int ptracer_exception_found(struct task_struct *tracer,
 	int rc = 0;
 	struct ptrace_relation *relation;
 	struct task_struct *parent = NULL;
+	bool found = false;
 
 	spin_lock_bh(&ptracer_relations_lock);
 	rcu_read_lock();
@@ -216,10 +219,11 @@ static int ptracer_exception_found(struct task_struct *tracer,
 	list_for_each_entry(relation, &ptracer_relations, node)
 		if (relation->tracee == tracee) {
 			parent = relation->tracer;
+			found = true;
 			break;
 		}
 
-	if (task_is_descendant(parent, tracer))
+	if (found && (parent == NULL || task_is_descendant(parent, tracer)))
 		rc = 1;
 	rcu_read_unlock();
 	spin_unlock_bh(&ptracer_relations_lock);
-- 
1.7.0.4

-- 
Kees Cook
ChromeOS Security
