Reply-To: kernel-hardening@lists.openwall.com
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Wed, 14 Sep 2016 09:24:02 +0200
Message-Id: <20160914072415.26021-10-mic@digikod.net>
In-Reply-To: <20160914072415.26021-1-mic@digikod.net>
References: <20160914072415.26021-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [RFC v3 09/22] seccomp: Move struct seccomp_filter in seccomp.h
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, netdev@vger.kernel.org, cgroups@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Set struct seccomp_filter public because of the next use of
the new field thread_prev added for Landlock LSM.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
---
 include/linux/seccomp.h | 27 ++++++++++++++++++++++++++-
 kernel/seccomp.c        | 26 --------------------------
 2 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index ecc296c137cd..a0459a7315ce 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -10,7 +10,32 @@
 #include <linux/thread_info.h>
 #include <asm/seccomp.h>
 
-struct seccomp_filter;
+/**
+ * struct seccomp_filter - container for seccomp BPF programs
+ *
+ * @usage: reference count to manage the object lifetime.
+ *         get/put helpers should be used when accessing an instance
+ *         outside of a lifetime-guarded section.  In general, this
+ *         is only needed for handling filters shared across tasks.
+ * @prev: points to a previously installed, or inherited, filter
+ * @prog: the BPF program to evaluate
+ *
+ * seccomp_filter objects are organized in a tree linked via the @prev
+ * pointer.  For any task, it appears to be a singly-linked list starting
+ * with current->seccomp.filter, the most recently attached or inherited filter.
+ * However, multiple filters may share a @prev node, by way of fork(), which
+ * results in a unidirectional tree existing in memory.  This is similar to
+ * how namespaces work.
+ *
+ * seccomp_filter objects should never be modified after being attached
+ * to a task_struct (other than @usage).
+ */
+struct seccomp_filter {
+	atomic_t usage;
+	struct seccomp_filter *prev;
+	struct bpf_prog *prog;
+};
+
 /**
  * struct seccomp - the state of a seccomp'ed process
  *
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index dccfc05cb3ec..1867bbfa7c6c 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -33,32 +33,6 @@
 #include <linux/tracehook.h>
 #include <linux/uaccess.h>
 
-/**
- * struct seccomp_filter - container for seccomp BPF programs
- *
- * @usage: reference count to manage the object lifetime.
- *         get/put helpers should be used when accessing an instance
- *         outside of a lifetime-guarded section.  In general, this
- *         is only needed for handling filters shared across tasks.
- * @prev: points to a previously installed, or inherited, filter
- * @prog: the BPF program to evaluate
- *
- * seccomp_filter objects are organized in a tree linked via the @prev
- * pointer.  For any task, it appears to be a singly-linked list starting
- * with current->seccomp.filter, the most recently attached or inherited filter.
- * However, multiple filters may share a @prev node, by way of fork(), which
- * results in a unidirectional tree existing in memory.  This is similar to
- * how namespaces work.
- *
- * seccomp_filter objects should never be modified after being attached
- * to a task_struct (other than @usage).
- */
-struct seccomp_filter {
-	atomic_t usage;
-	struct seccomp_filter *prev;
-	struct bpf_prog *prog;
-};
-
 /* Limit any path through the tree to 256KB worth of instructions. */
 #define MAX_INSNS_PER_PATH ((1 << 18) / sizeof(struct sock_filter))
 
-- 
2.9.3
