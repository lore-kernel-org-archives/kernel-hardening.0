Return-Path: <SRS0=g5H0=GN=lists.openwall.com=kernel-hardening-return-20626-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC18CC433E0
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 Jan 2021 17:35:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E0EE3221E7
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 Jan 2021 17:35:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0EE3221E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20626-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11412 invoked by uid 550); 10 Jan 2021 17:35:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11298 invoked from network); 10 Jan 2021 17:35:03 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Alexey Gladkov <legion@kernel.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>,
	Christian Brauner <christian@brauner.io>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC PATCH v2 2/8] Add a reference to ucounts for each user
Date: Sun, 10 Jan 2021 18:33:41 +0100
Message-Id: <5cef3f3b60e9cda7f4a42820ee333fa2d171a58b.1610299857.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610299857.git.gladkov.alexey@gmail.com>
References: <cover.1610299857.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Sun, 10 Jan 2021 17:34:51 +0000 (UTC)

Before this, only the owner of the user namespace had an entry in ucounts.
This entry addressed the user in the given user namespace.

Now we create such an entry in ucounts for all users in the user namespace.
Each user has only one entry for each user namespace.

This commit is in preparation for migrating rlimits to ucounts.

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 include/linux/cred.h           |  1 +
 include/linux/user_namespace.h |  2 ++
 kernel/cred.c                  | 17 +++++++++++++++--
 kernel/ucount.c                | 12 +++++++++++-
 kernel/user_namespace.c        |  1 +
 5 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 18639c069263..307744fcc387 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -144,6 +144,7 @@ struct cred {
 #endif
 	struct user_struct *user;	/* real user ID subscription */
 	struct user_namespace *user_ns; /* user_ns the caps and keyrings are relative to. */
+	struct ucounts *ucounts;
 	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
 	/* RCU deletion */
 	union {
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 84fefa9247c4..483568a56f7f 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -102,6 +102,8 @@ bool setup_userns_sysctls(struct user_namespace *ns);
 void retire_userns_sysctls(struct user_namespace *ns);
 struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid, enum ucount_type type);
 void dec_ucount(struct ucounts *ucounts, enum ucount_type type);
+void put_ucounts(struct ucounts *ucounts);
+void set_cred_ucounts(const struct cred *cred, struct user_namespace *ns, kuid_t uid);
 
 #ifdef CONFIG_USER_NS
 
diff --git a/kernel/cred.c b/kernel/cred.c
index 421b1149c651..d19e2e97092c 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -119,6 +119,7 @@ static void put_cred_rcu(struct rcu_head *rcu)
 	if (cred->group_info)
 		put_group_info(cred->group_info);
 	free_uid(cred->user);
+	put_ucounts(cred->ucounts);
 	put_user_ns(cred->user_ns);
 	kmem_cache_free(cred_jar, cred);
 }
@@ -144,6 +145,9 @@ void __put_cred(struct cred *cred)
 	BUG_ON(cred == current->cred);
 	BUG_ON(cred == current->real_cred);
 
+	BUG_ON(cred->ucounts == NULL);
+	BUG_ON(cred->ucounts->ns != cred->user_ns);
+
 	if (cred->non_rcu)
 		put_cred_rcu(&cred->rcu);
 	else
@@ -271,6 +275,9 @@ struct cred *prepare_creds(void)
 	get_uid(new->user);
 	get_user_ns(new->user_ns);
 
+	new->ucounts = NULL;
+	set_cred_ucounts(new, new->user_ns, new->euid);
+
 #ifdef CONFIG_KEYS
 	key_get(new->session_keyring);
 	key_get(new->process_keyring);
@@ -363,6 +370,7 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 		ret = create_user_ns(new);
 		if (ret < 0)
 			goto error_put;
+		set_cred_ucounts(new, new->user_ns, new->euid);
 	}
 
 #ifdef CONFIG_KEYS
@@ -485,8 +493,11 @@ int commit_creds(struct cred *new)
 	 * in set_user().
 	 */
 	alter_cred_subscribers(new, 2);
-	if (new->user != old->user)
-		atomic_inc(&new->user->processes);
+	if (new->user != old->user || new->user_ns != old->user_ns) {
+		if (new->user != old->user)
+			atomic_inc(&new->user->processes);
+		set_cred_ucounts(new, new->user_ns, new->euid);
+	}
 	rcu_assign_pointer(task->real_cred, new);
 	rcu_assign_pointer(task->cred, new);
 	if (new->user != old->user)
@@ -661,6 +672,7 @@ void __init cred_init(void)
 	/* allocate a slab in which we can store credentials */
 	cred_jar = kmem_cache_create("cred_jar", sizeof(struct cred), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
+	set_cred_ucounts(&init_cred, &init_user_ns, GLOBAL_ROOT_UID);
 }
 
 /**
@@ -704,6 +716,7 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	get_uid(new->user);
 	get_user_ns(new->user_ns);
 	get_group_info(new->group_info);
+	set_cred_ucounts(new, new->user_ns, new->euid);
 
 #ifdef CONFIG_KEYS
 	new->session_keyring = NULL;
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 0f2c7c11df19..80a39073bcef 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -161,7 +161,7 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
 	return ucounts;
 }
 
-static void put_ucounts(struct ucounts *ucounts)
+void put_ucounts(struct ucounts *ucounts)
 {
 	unsigned long flags;
 
@@ -175,6 +175,16 @@ static void put_ucounts(struct ucounts *ucounts)
 	kfree(ucounts);
 }
 
+void set_cred_ucounts(const struct cred *cred, struct user_namespace *ns, kuid_t uid)
+{
+	if (cred->ucounts) {
+		if (cred->ucounts->ns == ns && uid_eq(cred->ucounts->uid, uid))
+			return;
+		put_ucounts(cred->ucounts);
+	}
+	((struct cred *) cred)->ucounts = get_ucounts(ns, uid);
+}
+
 static inline bool atomic_inc_below(atomic_t *v, int u)
 {
 	int c, old;
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index af612945a4d0..4b8a4468d391 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1280,6 +1280,7 @@ static int userns_install(struct nsset *nsset, struct ns_common *ns)
 
 	put_user_ns(cred->user_ns);
 	set_cred_user_ns(cred, get_user_ns(user_ns));
+	set_cred_ucounts(cred, user_ns, cred->euid);
 
 	return 0;
 }
-- 
2.29.2

