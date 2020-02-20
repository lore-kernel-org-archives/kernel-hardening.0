Return-Path: <SRS0=wOjg=4I=lists.openwall.com=kernel-hardening-return-17864-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB243C11D20
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 20:53:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5148320679
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 20:53:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5148320679
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17864-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3883 invoked by uid 550); 20 Feb 2020 20:53:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3846 invoked from network); 20 Feb 2020 20:53:51 -0000
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
Date: Thu, 20 Feb 2020 14:51:38 -0600
In-Reply-To: <871rqpaswu.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 20 Feb 2020 14:46:25 -0600")
Message-ID: <8736b59e3p.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j4spG-0005x1-BZ;;;mid=<8736b59e3p.fsf_-_@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19DTetfpqNyVK1RVE7gBNaoSNIVSGPjvlE=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 5/7] proc: Clear the pieces of proc_inode that proc_evict_inode cares about
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)


This just keeps everything tidier, and allows for using flags like
SLAB_TYPESAFE_BY_RCU where slabs are not always cleared before reuse.
I don't see reuse without reinitializing happening with the proc_inode
but I had a false alarm while reworking flushing of proc dentries and
indoes when a process dies that caused me to tidy this up.

The code is a little easier to follow and reason about this
way so I figured the changes might as well be kept.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/inode.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index c4528c419876..3c9082cd257b 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -33,21 +33,27 @@ static void proc_evict_inode(struct inode *inode)
 {
 	struct proc_dir_entry *de;
 	struct ctl_table_header *head;
+	struct proc_inode *ei = PROC_I(inode);
 
 	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 
 	/* Stop tracking associated processes */
-	put_pid(PROC_I(inode)->pid);
+	if (ei->pid) {
+		put_pid(ei->pid);
+		ei->pid = NULL;
+	}
 
 	/* Let go of any associated proc directory entry */
-	de = PDE(inode);
-	if (de)
+	de = ei->pde;
+	if (de) {
 		pde_put(de);
+		ei->pde = NULL;
+	}
 
-	head = PROC_I(inode)->sysctl;
+	head = ei->sysctl;
 	if (head) {
-		RCU_INIT_POINTER(PROC_I(inode)->sysctl, NULL);
+		RCU_INIT_POINTER(ei->sysctl, NULL);
 		proc_sys_evict_inode(inode, head);
 	}
 }
-- 
2.20.1

