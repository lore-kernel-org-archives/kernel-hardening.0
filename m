Return-Path: <SRS0=SL8+=GN=lists.openwall.com=kernel-hardening-return-20632-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410F4C433DB
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 Jan 2021 17:36:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5D7FA221E5
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 Jan 2021 17:36:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D7FA221E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20632-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13319 invoked by uid 550); 10 Jan 2021 17:35:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12118 invoked from network); 10 Jan 2021 17:35:14 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Alexey Gladkov <legion@kernel.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>,
	Christian Brauner <christian@brauner.io>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC PATCH v2 5/8] Move RLIMIT_MSGQUEUE counter to ucounts
Date: Sun, 10 Jan 2021 18:33:44 +0100
Message-Id: <7e2f9debd5e84a137874ffa8e5e042fa1b93ebfa.1610299857.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610299857.git.gladkov.alexey@gmail.com>
References: <cover.1610299857.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Sun, 10 Jan 2021 17:34:52 +0000 (UTC)

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 include/linux/sched/user.h     |  4 ----
 include/linux/user_namespace.h |  8 ++++++++
 ipc/mqueue.c                   | 29 +++++++++++++++--------------
 kernel/fork.c                  |  1 +
 kernel/ucount.c                |  1 +
 kernel/user_namespace.c        |  1 +
 6 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index d33d867ad6c1..8a34446681aa 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -18,10 +18,6 @@ struct user_struct {
 #endif
 #ifdef CONFIG_EPOLL
 	atomic_long_t epoll_watches; /* The number of file descriptors currently watched */
-#endif
-#ifdef CONFIG_POSIX_MQUEUE
-	/* protected by mq_lock	*/
-	unsigned long mq_bytes;	/* How many bytes can be allocated to mqueue? */
 #endif
 	unsigned long locked_shm; /* How many pages of mlocked shm ? */
 	unsigned long unix_inflight;	/* How many files in flight in unix sockets */
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 43c83ed2fc61..2980afed6fb7 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -51,6 +51,7 @@ enum ucount_type {
 	UCOUNT_INOTIFY_WATCHES,
 #endif
 	UCOUNT_RLIMIT_NPROC,
+	UCOUNT_RLIMIT_MSGQUEUE,
 	UCOUNT_COUNTS,
 };
 
@@ -113,6 +114,13 @@ static inline long get_ucounts_value(struct ucounts *ucounts, enum ucount_type t
 	return atomic_long_read(&ucounts->ucount[type]);
 }
 
+static inline struct ucounts *get_ucount(struct ucounts *ucounts)
+{
+	if (ucounts)
+		atomic_inc(&ucounts->count);
+	return ucounts;
+}
+
 bool inc_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v);
 bool inc_rlimit_ucounts_and_test(struct ucounts *ucounts, enum ucount_type type, long v, long max);
 void dec_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v);
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index beff0cfcd1e8..67088f1aa6b0 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -144,7 +144,7 @@ struct mqueue_inode_info {
 	struct pid *notify_owner;
 	u32 notify_self_exec_id;
 	struct user_namespace *notify_user_ns;
-	struct user_struct *user;	/* user who created, for accounting */
+	struct ucounts *ucounts;	/* user who created, for accounting */
 	struct sock *notify_sock;
 	struct sk_buff *notify_cookie;
 
@@ -292,7 +292,6 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		struct ipc_namespace *ipc_ns, umode_t mode,
 		struct mq_attr *attr)
 {
-	struct user_struct *u = current_user();
 	struct inode *inode;
 	int ret = -ENOMEM;
 
@@ -309,6 +308,8 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 	if (S_ISREG(mode)) {
 		struct mqueue_inode_info *info;
 		unsigned long mq_bytes, mq_treesize;
+		struct ucounts *ucounts;
+		bool overlimit;
 
 		inode->i_fop = &mqueue_file_operations;
 		inode->i_size = FILENT_SIZE;
@@ -321,7 +322,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		info->notify_owner = NULL;
 		info->notify_user_ns = NULL;
 		info->qsize = 0;
-		info->user = NULL;	/* set when all is ok */
+		info->ucounts = NULL;	/* set when all is ok */
 		info->msg_tree = RB_ROOT;
 		info->msg_tree_rightmost = NULL;
 		info->node_cache = NULL;
@@ -371,19 +372,19 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		if (mq_bytes + mq_treesize < mq_bytes)
 			goto out_inode;
 		mq_bytes += mq_treesize;
+		ucounts = current_ucounts();
 		spin_lock(&mq_lock);
-		if (u->mq_bytes + mq_bytes < u->mq_bytes ||
-		    u->mq_bytes + mq_bytes > rlimit(RLIMIT_MSGQUEUE)) {
+		overlimit = inc_rlimit_ucounts_and_test(ucounts, UCOUNT_RLIMIT_MSGQUEUE,
+				mq_bytes, rlimit(RLIMIT_MSGQUEUE));
+		if (overlimit) {
+			dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MSGQUEUE, mq_bytes);
 			spin_unlock(&mq_lock);
 			/* mqueue_evict_inode() releases info->messages */
 			ret = -EMFILE;
 			goto out_inode;
 		}
-		u->mq_bytes += mq_bytes;
 		spin_unlock(&mq_lock);
-
-		/* all is ok */
-		info->user = get_uid(u);
+		info->ucounts = get_ucount(ucounts);
 	} else if (S_ISDIR(mode)) {
 		inc_nlink(inode);
 		/* Some things misbehave if size == 0 on a directory */
@@ -497,7 +498,7 @@ static void mqueue_free_inode(struct inode *inode)
 static void mqueue_evict_inode(struct inode *inode)
 {
 	struct mqueue_inode_info *info;
-	struct user_struct *user;
+	struct ucounts *ucounts;
 	struct ipc_namespace *ipc_ns;
 	struct msg_msg *msg, *nmsg;
 	LIST_HEAD(tmp_msg);
@@ -520,8 +521,8 @@ static void mqueue_evict_inode(struct inode *inode)
 		free_msg(msg);
 	}
 
-	user = info->user;
-	if (user) {
+	ucounts = info->ucounts;
+	if (ucounts) {
 		unsigned long mq_bytes, mq_treesize;
 
 		/* Total amount of bytes accounted for the mqueue */
@@ -533,7 +534,7 @@ static void mqueue_evict_inode(struct inode *inode)
 					  info->attr.mq_msgsize);
 
 		spin_lock(&mq_lock);
-		user->mq_bytes -= mq_bytes;
+		dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MSGQUEUE, mq_bytes);
 		/*
 		 * get_ns_from_inode() ensures that the
 		 * (ipc_ns = sb->s_fs_info) is either a valid ipc_ns
@@ -543,7 +544,7 @@ static void mqueue_evict_inode(struct inode *inode)
 		if (ipc_ns)
 			ipc_ns->mq_queues_count--;
 		spin_unlock(&mq_lock);
-		free_uid(user);
+		put_ucounts(ucounts);
 	}
 	if (ipc_ns)
 		put_ipc_ns(ipc_ns);
diff --git a/kernel/fork.c b/kernel/fork.c
index ef7936daeeda..f61a5a3dc02f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -824,6 +824,7 @@ void __init fork_init(void)
 	}
 
 	init_user_ns.ucount_max[UCOUNT_RLIMIT_NPROC] = task_rlimit(&init_task, RLIMIT_NPROC);
+	init_user_ns.ucount_max[UCOUNT_RLIMIT_MSGQUEUE] = task_rlimit(&init_task, RLIMIT_MSGQUEUE);
 
 #ifdef CONFIG_VMAP_STACK
 	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "fork:vm_stack_cache",
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 4222470ca0d1..865fd66c48c4 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -75,6 +75,7 @@ static struct ctl_table user_table[] = {
 	UCOUNT_ENTRY("max_inotify_instances"),
 	UCOUNT_ENTRY("max_inotify_watches"),
 #endif
+	{ },
 	{ },
 	{ }
 };
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 974f10da072c..9ace2a45a25d 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -122,6 +122,7 @@ int create_user_ns(struct cred *new)
 		ns->ucount_max[i] = INT_MAX;
 	}
 	ns->ucount_max[UCOUNT_RLIMIT_NPROC] = rlimit(RLIMIT_NPROC);
+	ns->ucount_max[UCOUNT_RLIMIT_MSGQUEUE] = rlimit(RLIMIT_MSGQUEUE);
 	ns->ucounts = ucounts;
 
 	/* Inherit USERNS_SETGROUPS_ALLOWED from our parent */
-- 
2.29.2

