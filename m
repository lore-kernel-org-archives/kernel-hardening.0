From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Mar 2017 11:16:03 -0700
Message-Id: <1490811363-93944-12-git-send-email-keescook@chromium.org>
In-Reply-To: <1490811363-93944-1-git-send-email-keescook@chromium.org>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC v2][PATCH 11/11] cgroups: force all struct cftype const
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

As found in PaX, mark struct cftype with __do_const and add helpers
to deal with rare writes. This is a more complex example of a write-rarely
structure, which needs to use list helpers and blocks of begin/end pairs
to perform the needed updates.

With this change and the constify plugin enabled, the before/after
section byte sizes show:

before:
    rodata: 0x2cc2f0
    data:   0x130d00

after:
    rodata: 0x2cf2f0 (+74478)
    data:   0x12e5c0 (-65710)

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/cgroup-defs.h |  2 +-
 kernel/cgroup/cgroup.c      | 35 +++++++++++++++++++++++------------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 6a3f850cabab..67563a80d01f 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -434,7 +434,7 @@ struct cftype {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lock_class_key	lockdep_key;
 #endif
-};
+} __do_const;
 
 /*
  * Control Group subsystem type.
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 48851327a15e..94188df45f96 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3058,11 +3058,11 @@ static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
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
 
@@ -3165,11 +3165,16 @@ static void cgroup_exit_cftypes(struct cftype *cfts)
 		/* free copy for custom atomic_write_len, see init_cftypes() */
 		if (cft->max_write_len && cft->max_write_len != PAGE_SIZE)
 			kfree(cft->kf_ops);
-		cft->kf_ops = NULL;
-		cft->ss = NULL;
+
+		rare_write_begin();
+		__rare_write(cft->kf_ops, NULL);
+		__rare_write(cft->ss, NULL);
 
 		/* revert flags set by cgroup core while adding @cfts */
-		cft->flags &= ~(__CFTYPE_ONLY_ON_DFL | __CFTYPE_NOT_ON_DFL);
+		__rare_write(cft->flags,
+			     cft->flags & ~(__CFTYPE_ONLY_ON_DFL |
+					    __CFTYPE_NOT_ON_DFL));
+		rare_write_end();
 	}
 }
 
@@ -3200,8 +3205,10 @@ static int cgroup_init_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 			kf_ops->atomic_write_len = cft->max_write_len;
 		}
 
-		cft->kf_ops = kf_ops;
-		cft->ss = ss;
+		rare_write_begin();
+		__rare_write(cft->kf_ops, kf_ops);
+		__rare_write(cft->ss, ss);
+		rare_write_end();
 	}
 
 	return 0;
@@ -3214,7 +3221,7 @@ static int cgroup_rm_cftypes_locked(struct cftype *cfts)
 	if (!cfts || !cfts[0].ss)
 		return -ENOENT;
 
-	list_del(&cfts->node);
+	rare_list_del(&cfts->node);
 	cgroup_apply_cftypes(cfts, false);
 	cgroup_exit_cftypes(cfts);
 	return 0;
@@ -3271,7 +3278,7 @@ static int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 
 	mutex_lock(&cgroup_mutex);
 
-	list_add_tail(&cfts->node, &ss->cfts);
+	rare_list_add_tail(&cfts->node, &ss->cfts);
 	ret = cgroup_apply_cftypes(cfts, true);
 	if (ret)
 		cgroup_rm_cftypes_locked(cfts);
@@ -3292,8 +3299,10 @@ int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	struct cftype *cft;
 
+	rare_write_begin();
 	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
-		cft->flags |= __CFTYPE_ONLY_ON_DFL;
+		__rare_write(cft->flags, cft->flags | __CFTYPE_ONLY_ON_DFL);
+	rare_write_end();
 	return cgroup_add_cftypes(ss, cfts);
 }
 
@@ -3309,8 +3318,10 @@ int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	struct cftype *cft;
 
+	rare_write_begin();
 	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
-		cft->flags |= __CFTYPE_NOT_ON_DFL;
+		__rare_write(cft->flags, cft->flags | __CFTYPE_NOT_ON_DFL);
+	rare_write_end();
 	return cgroup_add_cftypes(ss, cfts);
 }
 
-- 
2.7.4
