Return-Path: <SRS0=aNA8=4M=lists.openwall.com=kernel-hardening-return-17895-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE65C11D2F
	for <kernel-hardening@archiver.kernel.org>; Mon, 24 Feb 2020 16:30:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A76372080D
	for <kernel-hardening@archiver.kernel.org>; Mon, 24 Feb 2020 16:30:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A76372080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17895-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24089 invoked by uid 550); 24 Feb 2020 16:30:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24047 invoked from network); 24 Feb 2020 16:30:39 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,  LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux Security Module <linux-security-module@vger.kernel.org>,  Akinobu Mita <akinobu.mita@gmail.com>,  Alexey Dobriyan <adobriyan@gmail.com>,  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Oleg Nesterov <oleg@redhat.com>,  Solar Designer <solar@openwall.com>,  Alexey Gladkov <gladkov.alexey@gmail.com>
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
	<871rqk2brn.fsf_-_@x220.int.ebiederm.org>
Date: Mon, 24 Feb 2020 10:28:22 -0600
In-Reply-To: <871rqk2brn.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Mon, 24 Feb 2020 10:25:16 -0600")
Message-ID: <87eeuk0x21.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j6Gcj-00087b-GZ;;;mid=<87eeuk0x21.fsf_-_@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/swQCQNy2YwWznsTE8zPB0PTznWyDneD8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH v2 4/6] proc: Use d_invalidate in proc_prune_siblings_dcache
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)


The function d_prune_aliases has the problem that it will only prune
aliases thare are completely unused.  It will not remove aliases for
the dcache or even think of removing mounts from the dcache.  For that
behavior d_invalidate is needed.

To use d_invalidate replace d_prune_aliases with d_find_alias followed
by d_invalidate and dput.

For completeness the directory and the non-directory cases are
separated because in theory (although not in currently in practice for
proc) directories can only ever have a single dentry while
non-directories can have hardlinks and thus multiple dentries.
As part of this separation use d_find_any_alias for directories
to spare d_find_alias the extra work of doing that.

Plus the differences between d_find_any_alias and d_find_alias makes
it clear why the directory and non-directory code and not share code.

To make it clear these routines now invalidate dentries rename
proc_prune_siblings_dache to proc_invalidate_siblings_dcache, and rename
proc_sys_prune_dcache proc_sys_invalidate_dcache.

V2: Split the directory and non-directory cases.  To make this
    code robust to future changes in proc.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/inode.c       | 16 ++++++++++++++--
 fs/proc/internal.h    |  2 +-
 fs/proc/proc_sysctl.c |  8 ++++----
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index fa2dc732cd77..ba6acd300ce1 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -103,7 +103,7 @@ void __init proc_init_kmemcache(void)
 	BUILD_BUG_ON(sizeof(struct proc_dir_entry) >= SIZEOF_PDE);
 }
 
-void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock)
+void proc_invalidate_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock)
 {
 	struct inode *inode;
 	struct proc_inode *ei;
@@ -137,7 +137,19 @@ void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock)
 			continue;
 		}
 
-		d_prune_aliases(inode);
+		if (S_ISDIR(inode->i_mode)) {
+			struct dentry *dir = d_find_any_alias(inode);
+			if (dir) {
+				d_invalidate(dir);
+				dput(dir);
+			}
+		} else {
+			struct dentry *dentry;
+			while ((dentry = d_find_alias(inode))) {
+				d_invalidate(dentry);
+				dput(dentry);
+			}
+		}
 		iput(inode);
 
 		rcu_read_lock();
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index ba9a991824a5..fd470172675f 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -210,7 +210,7 @@ extern const struct inode_operations proc_pid_link_inode_operations;
 extern const struct super_operations proc_sops;
 
 void proc_init_kmemcache(void);
-void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock);
+void proc_invalidate_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock);
 void set_proc_pid_nlink(void);
 extern struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
 extern void proc_entry_rundown(struct proc_dir_entry *);
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 5da9d7f7ae34..b6f5d459b087 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -267,9 +267,9 @@ static void unuse_table(struct ctl_table_header *p)
 			complete(p->unregistering);
 }
 
-static void proc_sys_prune_dcache(struct ctl_table_header *head)
+static void proc_sys_invalidate_dcache(struct ctl_table_header *head)
 {
-	proc_prune_siblings_dcache(&head->inodes, &sysctl_lock);
+	proc_invalidate_siblings_dcache(&head->inodes, &sysctl_lock);
 }
 
 /* called under sysctl_lock, will reacquire if has to wait */
@@ -291,10 +291,10 @@ static void start_unregistering(struct ctl_table_header *p)
 		spin_unlock(&sysctl_lock);
 	}
 	/*
-	 * Prune dentries for unregistered sysctls: namespaced sysctls
+	 * Invalidate dentries for unregistered sysctls: namespaced sysctls
 	 * can have duplicate names and contaminate dcache very badly.
 	 */
-	proc_sys_prune_dcache(p);
+	proc_sys_invalidate_dcache(p);
 	/*
 	 * do not remove from the list until nobody holds it; walking the
 	 * list in do_sysctl() relies on that.
-- 
2.25.0

