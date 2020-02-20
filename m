Return-Path: <SRS0=AigN=4I=lists.openwall.com=kernel-hardening-return-17861-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A5CC11D20
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 20:50:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D667720801
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 20:50:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D667720801
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17861-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30626 invoked by uid 550); 20 Feb 2020 20:50:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30580 invoked from network); 20 Feb 2020 20:50:41 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,  LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux Security Module <linux-security-module@vger.kernel.org>,  Akinobu Mita <akinobu.mita@gmail.com>,  Alexey Dobriyan <adobriyan@gmail.com>,  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Oleg Nesterov <oleg@redhat.com>,  Solar Designer <solar@openwall.com>
References: <20200210150519.538333-8-gladkov.alexey@gmail.com>
	<87v9odlxbr.fsf@x220.int.ebiederm.org>
	<20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
	<87tv3vkg1a.fsf@x220.int.ebiederm.org>
	<CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
	<87v9obipk9.fsf@x220.int.ebiederm.org>
	<CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
	<20200212200335.GO23230@ZenIV.linux.org.uk>
	<CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
	<20200212203833.GQ23230@ZenIV.linux.org.uk>
	<20200212204124.GR23230@ZenIV.linux.org.uk>
	<CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
	<87lfp7h422.fsf@x220.int.ebiederm.org>
	<CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
	<87pnejf6fz.fsf@x220.int.ebiederm.org>
	<871rqpaswu.fsf_-_@x220.int.ebiederm.org>
Date: Thu, 20 Feb 2020 14:48:28 -0600
In-Reply-To: <871rqpaswu.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 20 Feb 2020 14:46:25 -0600")
Message-ID: <87mu9d9e8z.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j4smC-0008QU-FZ;;;mid=<87mu9d9e8z.fsf_-_@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19U9wTJM2ZK4ftSyO914HE9nIIpH9k5Pfg=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 2/7] proc: Generalize proc_sys_prune_dcache into proc_prune_siblings_dcache
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)


This prepares the way for allowing the pid part of proc to use this
dcache pruning code as well.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/inode.c       | 38 ++++++++++++++++++++++++++++++++++++++
 fs/proc/internal.h    |  1 +
 fs/proc/proc_sysctl.c | 35 +----------------------------------
 3 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index bdae442d5262..74ce4a8d05eb 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -103,6 +103,44 @@ void __init proc_init_kmemcache(void)
 	BUILD_BUG_ON(sizeof(struct proc_dir_entry) >= SIZEOF_PDE);
 }
 
+void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock)
+{
+	struct inode *inode;
+	struct proc_inode *ei;
+	struct hlist_node *node;
+	struct super_block *sb;
+
+	rcu_read_lock();
+	for (;;) {
+		node = hlist_first_rcu(inodes);
+		if (!node)
+			break;
+		ei = hlist_entry(node, struct proc_inode, sibling_inodes);
+		spin_lock(lock);
+		hlist_del_init_rcu(&ei->sibling_inodes);
+		spin_unlock(lock);
+
+		inode = &ei->vfs_inode;
+		sb = inode->i_sb;
+		if (!atomic_inc_not_zero(&sb->s_active))
+			continue;
+		inode = igrab(inode);
+		rcu_read_unlock();
+		if (unlikely(!inode)) {
+			deactivate_super(sb);
+			rcu_read_lock();
+			continue;
+		}
+
+		d_prune_aliases(inode);
+		iput(inode);
+		deactivate_super(sb);
+
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
+}
+
 static int proc_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct super_block *sb = root->d_sb;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 366cd3aa690b..ba9a991824a5 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -210,6 +210,7 @@ extern const struct inode_operations proc_pid_link_inode_operations;
 extern const struct super_operations proc_sops;
 
 void proc_init_kmemcache(void);
+void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock);
 void set_proc_pid_nlink(void);
 extern struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
 extern void proc_entry_rundown(struct proc_dir_entry *);
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 42fbb7f3c587..5da9d7f7ae34 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -269,40 +269,7 @@ static void unuse_table(struct ctl_table_header *p)
 
 static void proc_sys_prune_dcache(struct ctl_table_header *head)
 {
-	struct inode *inode;
-	struct proc_inode *ei;
-	struct hlist_node *node;
-	struct super_block *sb;
-
-	rcu_read_lock();
-	for (;;) {
-		node = hlist_first_rcu(&head->inodes);
-		if (!node)
-			break;
-		ei = hlist_entry(node, struct proc_inode, sibling_inodes);
-		spin_lock(&sysctl_lock);
-		hlist_del_init_rcu(&ei->sibling_inodes);
-		spin_unlock(&sysctl_lock);
-
-		inode = &ei->vfs_inode;
-		sb = inode->i_sb;
-		if (!atomic_inc_not_zero(&sb->s_active))
-			continue;
-		inode = igrab(inode);
-		rcu_read_unlock();
-		if (unlikely(!inode)) {
-			deactivate_super(sb);
-			rcu_read_lock();
-			continue;
-		}
-
-		d_prune_aliases(inode);
-		iput(inode);
-		deactivate_super(sb);
-
-		rcu_read_lock();
-	}
-	rcu_read_unlock();
+	proc_prune_siblings_dcache(&head->inodes, &sysctl_lock);
 }
 
 /* called under sysctl_lock, will reacquire if has to wait */
-- 
2.20.1

