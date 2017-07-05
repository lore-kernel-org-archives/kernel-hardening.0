From: Igor Stoppa <igor.stoppa@huawei.com>
Date: Wed, 5 Jul 2017 16:46:28 +0300
Message-ID: <20170705134628.3803-4-igor.stoppa@huawei.com>
In-Reply-To: <20170705134628.3803-1-igor.stoppa@huawei.com>
References: <20170705134628.3803-1-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] [PATCH 3/3] Make LSM Writable Hooks a command line option
To: keescook@chromium.org, mhocko@kernel.org, jmorris@namei.org, labbott@redhat.com, hch@infradead.org
Cc: penguin-kernel@I-love.SAKURA.ne.jp, paul@paul-moore.com, sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Igor
 Stoppa <igor.stoppa@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patch shows how it is possible to take advantage of pmalloc:
instead of using the build-time option __lsm_ro_after_init, to decide if
it is possible to keep the hooks modifiable, now this becomes a
boot-time decision, based on the kernel command line.

This patch relies on:

"Convert security_hook_heads into explicit array of struct list_head"
Author: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

to break free from the static constraint imposed by the previous
hardening model, based on __ro_after_init.

The default value is disabled, unless SE Linux debugging is turned on.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/security.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/security/security.c b/security/security.c
index 44c47b6..c7b4670 100644
--- a/security/security.c
+++ b/security/security.c
@@ -27,6 +27,7 @@
 #include <linux/personality.h>
 #include <linux/backing-dev.h>
 #include <linux/string.h>
+#include <linux/pmalloc.h>
 #include <net/flow.h>
 
 #define MAX_LSM_EVM_XATTR	2
@@ -34,10 +35,19 @@
 /* Maximum number of letters for an LSM name string */
 #define SECURITY_NAME_MAX	10
 
-static struct list_head hook_heads[LSM_MAX_HOOK_INDEX]
-	__lsm_ro_after_init;
 static ATOMIC_NOTIFIER_HEAD(lsm_notifier_chain);
 
+static int dynamic_lsm = IS_ENABLED(CONFIG_SECURITY_SELINUX_DISABLE);
+
+static __init int set_dynamic_lsm(char *str)
+{
+	get_option(&str, &dynamic_lsm);
+	return 0;
+}
+early_param("dynamic_lsm", set_dynamic_lsm);
+
+static struct list_head *hook_heads;
+static struct gen_pool *sec_pool;
 char *lsm_names;
 /* Boot-time LSM user choice */
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
@@ -62,6 +72,11 @@ int __init security_init(void)
 {
 	enum security_hook_index i;
 
+	sec_pool = pmalloc_create_pool("security", PMALLOC_DEFAULT_ALLOC_ORDER);
+	BUG_ON(!sec_pool);
+	hook_heads = pmalloc(sec_pool,
+			     sizeof(struct list_head) * LSM_MAX_HOOK_INDEX);
+	BUG_ON(!hook_heads);
 	for (i = 0; i < LSM_MAX_HOOK_INDEX; i++)
 		INIT_LIST_HEAD(&hook_heads[i]);
 	pr_info("Security Framework initialized\n");
@@ -77,7 +92,8 @@ int __init security_init(void)
 	 * Load all the remaining security modules.
 	 */
 	do_security_initcalls();
-
+	if (!dynamic_lsm)
+		pmalloc_protect_pool(sec_pool);
 	return 0;
 }
 
-- 
2.9.3
