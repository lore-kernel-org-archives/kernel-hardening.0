Return-Path: <SRS0=0pIT=4I=lists.openwall.com=kernel-hardening-return-17866-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4F3C11D20
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 20:55:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 298A5208CD
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 20:55:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 298A5208CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17866-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7603 invoked by uid 550); 20 Feb 2020 20:55:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7556 invoked from network); 20 Feb 2020 20:55:01 -0000
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
Date: Thu, 20 Feb 2020 14:52:47 -0600
In-Reply-To: <871rqpaswu.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 20 Feb 2020 14:46:25 -0600")
Message-ID: <87r1yp7zhc.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j4sqN-00069Y-Au;;;mid=<87r1yp7zhc.fsf_-_@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/YvfDt9LJUlANZXt5NnLd7OKfeCre6VOM=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 7/7] proc: Ensure we see the exit of each process tid exactly once
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)


When the thread group leader changes during exec and the old leaders
thread is reaped proc_flush_pid will flush the dentries for the entire
process because the leader still has it's original pid.

Fix this by exchanging the pids in an rcu safe manner,
and wrapping the code to do that up in a helper exchange_tids.

When I removed switch_exec_pids and introduced this behavior
in d73d65293e3e ("[PATCH] pidhash: kill switch_exec_pids") there
really was nothing that cared as flushing happened with
the cached dentry and de_thread flushed both of them on exec.

This lack of fully exchanging pids became a problem a few months later
when I introduced 48e6484d4902 ("[PATCH] proc: Rewrite the proc dentry
flush on exit optimization").  Which overlooked the de_thread case
was no longer swapping pids, and I was looking up proc dentries
by task->pid.

The current behavior isn't properly a bug as everything in proc will
continue to work correctly just a little bit less efficiently.  Fix
this just so there are no little surprise corner cases waiting to bite
people.

Fixes: 48e6484d4902 ("[PATCH] proc: Rewrite the proc dentry flush on exit optimization").
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/exec.c           |  5 +----
 include/linux/pid.h |  1 +
 kernel/pid.c        | 16 ++++++++++++++++
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index db17be51b112..3f0bc293442e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1148,11 +1148,8 @@ static int de_thread(struct task_struct *tsk)
 
 		/* Become a process group leader with the old leader's pid.
 		 * The old leader becomes a thread of the this thread group.
-		 * Note: The old leader also uses this pid until release_task
-		 *       is called.  Odd but simple and correct.
 		 */
-		tsk->pid = leader->pid;
-		change_pid(tsk, PIDTYPE_PID, task_pid(leader));
+		exchange_tids(tsk, leader);
 		transfer_pid(leader, tsk, PIDTYPE_TGID);
 		transfer_pid(leader, tsk, PIDTYPE_PGID);
 		transfer_pid(leader, tsk, PIDTYPE_SID);
diff --git a/include/linux/pid.h b/include/linux/pid.h
index 01a0d4e28506..0f40b5f1c32c 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -101,6 +101,7 @@ extern void attach_pid(struct task_struct *task, enum pid_type);
 extern void detach_pid(struct task_struct *task, enum pid_type);
 extern void change_pid(struct task_struct *task, enum pid_type,
 			struct pid *pid);
+extern void exchange_tids(struct task_struct *task, struct task_struct *old);
 extern void transfer_pid(struct task_struct *old, struct task_struct *new,
 			 enum pid_type);
 
diff --git a/kernel/pid.c b/kernel/pid.c
index 0f4ecb57214c..0085b15478fb 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -359,6 +359,22 @@ void change_pid(struct task_struct *task, enum pid_type type,
 	attach_pid(task, type);
 }
 
+void exchange_tids(struct task_struct *ntask, struct task_struct *otask)
+{
+	/* pid_links[PIDTYPE_PID].next is always NULL */
+	struct pid *npid = READ_ONCE(ntask->thread_pid);
+	struct pid *opid = READ_ONCE(otask->thread_pid);
+
+	rcu_assign_pointer(opid->tasks[PIDTYPE_PID].first, &ntask->pid_links[PIDTYPE_PID]);
+	rcu_assign_pointer(npid->tasks[PIDTYPE_PID].first, &otask->pid_links[PIDTYPE_PID]);
+	rcu_assign_pointer(ntask->thread_pid, opid);
+	rcu_assign_pointer(otask->thread_pid, npid);
+	WRITE_ONCE(ntask->pid_links[PIDTYPE_PID].pprev, &opid->tasks[PIDTYPE_PID].first);
+	WRITE_ONCE(otask->pid_links[PIDTYPE_PID].pprev, &npid->tasks[PIDTYPE_PID].first);
+	WRITE_ONCE(ntask->pid, pid_nr(opid));
+	WRITE_ONCE(otask->pid, pid_nr(npid));
+}
+
 /* transfer_pid is an optimization of attach_pid(new), detach_pid(old) */
 void transfer_pid(struct task_struct *old, struct task_struct *new,
 			   enum pid_type type)
-- 
2.20.1

