Return-Path: <SRS0=hZ/X=EI=lists.openwall.com=kernel-hardening-return-20315-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2715C00A89
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Nov 2020 16:53:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0B1C522277
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Nov 2020 16:53:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B1C522277
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20315-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17624 invoked by uid 550); 2 Nov 2020 16:52:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16326 invoked from network); 2 Nov 2020 16:52:42 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Alexey Gladkov <legion@kernel.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>,
	Christian Brauner <christian@brauner.io>
Subject: [RFC PATCH v1 3/4] Do not allow fork if RLIMIT_NPROC is exceeded in the user namespace tree
Date: Mon,  2 Nov 2020 17:50:32 +0100
Message-Id: <a6a6b015b18b83eeaa5b237b4377f178015847c9.1604335819.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1604335819.git.gladkov.alexey@gmail.com>
References: <cover.1604335819.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Mon, 02 Nov 2020 16:52:31 +0000 (UTC)

Since RLIMIT_NPROC is counted per user namespace, the existing over-limit
check in the current user namespace is not sufficient. We must consider
exceeding this limit in parent user namespaces.

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 fs/exec.c             |  6 ++++++
 fs/io-wq.c            | 12 ++++++++----
 include/linux/sched.h |  3 +++
 kernel/cred.c         | 17 ++++++++++-------
 kernel/fork.c         |  6 +++++-
 5 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 3f2071f7b9c7..c45dfc716394 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1831,6 +1831,12 @@ static int __do_execve_file(int fd, struct filename *filename,
 	if (IS_ERR(filename))
 		return PTR_ERR(filename);
 
+	if (current->flags & PF_NPROC_UNS_EXCEEDED) {
+		current->flags &= ~PF_NPROC_UNS_EXCEEDED;
+		retval = -EAGAIN;
+		goto out_ret;
+	}
+
 	processes = get_rlimit_counter(&init_user_ns, current_euid(), UCOUNT_RLIMIT_NPROC);
 
 	/*
diff --git a/fs/io-wq.c b/fs/io-wq.c
index 6170aee986db..c3b0843abc9b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -352,10 +352,11 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
 			wqe->acct[IO_WQ_ACCT_BOUND].nr_workers++;
 			dec_rlimit_counter(&init_user_ns, wqe->wq->user->uid, UCOUNT_RLIMIT_NPROC);
 		} else {
+			if (!inc_rlimit_counter(&init_user_ns, wqe->wq->user->uid, UCOUNT_RLIMIT_NPROC))
+				return;
 			worker->flags &= ~IO_WORKER_F_BOUND;
 			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers++;
 			wqe->acct[IO_WQ_ACCT_BOUND].nr_workers--;
-			inc_rlimit_counter(&init_user_ns, wqe->wq->user->uid, UCOUNT_RLIMIT_NPROC);
 		}
 		io_wqe_inc_running(wqe, worker);
 	 }
@@ -660,6 +661,12 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		return false;
 	}
 
+	if (index == IO_WQ_ACCT_UNBOUND &&
+	    !inc_rlimit_counter(&init_user_ns, wq->user->uid, UCOUNT_RLIMIT_NPROC)) {
+		kfree(worker);
+		return false;
+	}
+
 	spin_lock_irq(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
 	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
@@ -671,9 +678,6 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	acct->nr_workers++;
 	spin_unlock_irq(&wqe->lock);
 
-	if (index == IO_WQ_ACCT_UNBOUND)
-		inc_rlimit_counter(&init_user_ns, wq->user->uid, UCOUNT_RLIMIT_NPROC);
-
 	wake_up_process(worker->task);
 	return true;
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 683372943093..c3cf034b4aa7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1506,6 +1506,9 @@ extern struct pid *cad_pid;
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
 #define PF_SWAPWRITE		0x00800000	/* Allowed to write to swap */
+#define PF_NPROC_UNS_EXCEEDED	0x01000000	/* It means that we have reached the RLIMIT_NPROC
+						 * in the current user namespace or in one of
+						 * the parent's and we can't fork */
 #define PF_UMH			0x02000000	/* I'm an Usermodehelper process */
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
 #define PF_MCE_EARLY		0x08000000      /* Early kill for mce process policy */
diff --git a/kernel/cred.c b/kernel/cred.c
index b6694700e760..748704db1f6b 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -345,13 +345,14 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 #endif
 		clone_flags & CLONE_THREAD
 	    ) {
+		if (!inc_rlimit_counter(&init_user_ns, task_euid(p), UCOUNT_RLIMIT_NPROC))
+			return -EACCES;
 		p->real_cred = get_cred(p->cred);
 		get_cred(p->cred);
 		alter_cred_subscribers(p->cred, 2);
 		kdebug("share_creds(%p{%d,%d})",
 		       p->cred, atomic_read(&p->cred->usage),
 		       read_cred_subscribers(p->cred));
-		inc_rlimit_counter(&init_user_ns, task_euid(p), UCOUNT_RLIMIT_NPROC);
 		return 0;
 	}
 
@@ -384,7 +385,8 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 	}
 #endif
 
-	inc_rlimit_counter(&init_user_ns, new->euid, UCOUNT_RLIMIT_NPROC);
+	if (!inc_rlimit_counter(&init_user_ns, new->euid, UCOUNT_RLIMIT_NPROC))
+		return -EACCES;
 	p->cred = p->real_cred = get_cred(new);
 	alter_cred_subscribers(new, 2);
 	validate_creds(new);
@@ -480,13 +482,14 @@ int commit_creds(struct cred *new)
 	if (!gid_eq(new->fsgid, old->fsgid))
 		key_fsgid_changed(new);
 
-	/* do it
-	 * RLIMIT_NPROC limits on user->processes have already been checked
-	 * in set_user().
+	/*
+	 * The RLIMIT_NPROC limits have already been checked in set_user(), but
+	 * perhaps this limit is exceeded in the parent user namespace.
 	 */
 	alter_cred_subscribers(new, 2);
-	if (new->user != old->user)
-		inc_rlimit_counter(&init_user_ns, new->euid, UCOUNT_RLIMIT_NPROC);
+	if (new->user != old->user &&
+	    !inc_rlimit_counter(&init_user_ns, new->euid, UCOUNT_RLIMIT_NPROC))
+		task->flags |= PF_NPROC_UNS_EXCEEDED;
 	rcu_assign_pointer(task->real_cred, new);
 	rcu_assign_pointer(task->cred, new);
 	if (new->user != old->user)
diff --git a/kernel/fork.c b/kernel/fork.c
index 2bc8bd45179f..d2b28634dc8f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1958,9 +1958,13 @@ static __latent_entropy struct task_struct *copy_process(
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
+	retval = -EAGAIN;
+	if (current->flags & PF_NPROC_UNS_EXCEEDED) {
+		current->flags &= ~PF_NPROC_UNS_EXCEEDED;
+		goto bad_fork_free;
+	}
 	processes = get_rlimit_counter(&init_user_ns, p->real_cred->euid,
 			UCOUNT_RLIMIT_NPROC);
-	retval = -EAGAIN;
 	if (processes >= task_rlimit(p, RLIMIT_NPROC)) {
 		if (p->real_cred->user != INIT_USER &&
 		    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
-- 
2.25.4

