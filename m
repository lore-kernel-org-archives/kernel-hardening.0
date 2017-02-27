From: Kees Cook <keescook@chromium.org>
Date: Mon, 27 Feb 2017 12:43:06 -0800
Message-Id: <1488228186-110679-9-git-send-email-keescook@chromium.org>
In-Reply-To: <1488228186-110679-1-git-send-email-keescook@chromium.org>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC][PATCH 8/8] cgroups: force all struct cftype const
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

As found in PaX, mark struct cftype with __do_const and add helpers
to deal with rare writes. This is a more complex example of a write-rarely
structure, which needs to use list helpers and blocks of enable/disable
pairs to perform the needed updates.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/cgroup-defs.h |  2 +-
 kernel/cgroup.c             | 35 +++++++++++++++++++++++------------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 861b4677fc5b..aa15b3132bce 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -431,7 +431,7 @@ struct cftype {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lock_class_key	lockdep_key;
 #endif
-};
+} __do_const;
 
 /*
  * Control Group subsystem type.
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b794bcadefa4..19a8e1baeb6b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3653,11 +3653,11 @@ static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
 	int ret;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-	key = &cft->lockdep_key;
+	key = (struct lock_class_key *)&cft->lockdep_key;
 #endif
 	kn = __kernfs_create_file(cgrp->kn, cgroup_file_name(cgrp, cft, name),
-				  cgroup_file_mode(cft), 0, cft->kf_ops, cft,
-				  NULL, key);
+				  cgroup_file_mode(cft), 0, cft->kf_ops,
+				  (void *)cft, NULL, key);
 	if (IS_ERR(kn))
 		return PTR_ERR(kn);
 
@@ -3760,11 +3760,16 @@ static void cgroup_exit_cftypes(struct cftype *cfts)
 		/* free copy for custom atomic_write_len, see init_cftypes() */
 		if (cft->max_write_len && cft->max_write_len != PAGE_SIZE)
 			kfree(cft->kf_ops);
-		cft->kf_ops = NULL;
-		cft->ss = NULL;
+
+		rare_write_enable();
+		__rare_write(cft->kf_ops, NULL);
+		__rare_write(cft->ss, NULL);
 
 		/* revert flags set by cgroup core while adding @cfts */
-		cft->flags &= ~(__CFTYPE_ONLY_ON_DFL | __CFTYPE_NOT_ON_DFL);
+		__rare_write(cft->flags,
+			     cft->flags & ~(__CFTYPE_ONLY_ON_DFL |
+					    __CFTYPE_NOT_ON_DFL));
+		rare_write_disable();
 	}
 }
 
@@ -3795,8 +3800,10 @@ static int cgroup_init_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 			kf_ops->atomic_write_len = cft->max_write_len;
 		}
 
-		cft->kf_ops = kf_ops;
-		cft->ss = ss;
+		rare_write_enable();
+		__rare_write(cft->kf_ops, kf_ops);
+		__rare_write(cft->ss, ss);
+		rare_write_disable();
 	}
 
 	return 0;
@@ -3809,7 +3816,7 @@ static int cgroup_rm_cftypes_locked(struct cftype *cfts)
 	if (!cfts || !cfts[0].ss)
 		return -ENOENT;
 
-	list_del(&cfts->node);
+	rare_list_del(&cfts->node);
 	cgroup_apply_cftypes(cfts, false);
 	cgroup_exit_cftypes(cfts);
 	return 0;
@@ -3866,7 +3873,7 @@ static int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 
 	mutex_lock(&cgroup_mutex);
 
-	list_add_tail(&cfts->node, &ss->cfts);
+	rare_list_add_tail(&cfts->node, &ss->cfts);
 	ret = cgroup_apply_cftypes(cfts, true);
 	if (ret)
 		cgroup_rm_cftypes_locked(cfts);
@@ -3887,8 +3894,10 @@ int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	struct cftype *cft;
 
+	rare_write_enable();
 	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
-		cft->flags |= __CFTYPE_ONLY_ON_DFL;
+		__rare_write(cft->flags, cft->flags | __CFTYPE_ONLY_ON_DFL);
+	rare_write_disable();
 	return cgroup_add_cftypes(ss, cfts);
 }
 
@@ -3904,8 +3913,10 @@ int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	struct cftype *cft;
 
+	rare_write_enable();
 	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
-		cft->flags |= __CFTYPE_NOT_ON_DFL;
+		__rare_write(cft->flags, cft->flags | __CFTYPE_NOT_ON_DFL);
+	rare_write_disable();
 	return cgroup_add_cftypes(ss, cfts);
 }
 
-- 
2.7.4
