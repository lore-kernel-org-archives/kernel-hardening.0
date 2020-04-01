Return-Path: <SRS0=mHzG=5R=lists.openwall.com=kernel-hardening-return-18359-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6245DC2D0F0
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 20:50:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 91EC820658
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 20:50:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91EC820658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18359-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7768 invoked by uid 550); 1 Apr 2020 20:50:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7743 invoked from network); 1 Apr 2020 20:50:41 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adam Zabrocki <pi3@pi3.com.pl>,  linux-kernel@vger.kernel.org,
 kernel-hardening@lists.openwall.com,  Jann Horn <jannh@google.com>,
 Oleg Nesterov <oleg@redhat.com>,
 Andy Lutomirski <luto@amacapital.net>,
 Bernd Edlinger <bernd.edlinger@hotmail.de>,
 Kees Cook <keescook@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 stable@vger.kernel.org
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
Date: Wed, 01 Apr 2020 15:47:44 -0500
In-Reply-To: <202003291528.730A329@keescook> (Kees Cook's message of "Sun, 29
	Mar 2020 15:43:14 -0700")
Message-ID: <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jJkJe-0003w0-Tr;;;mid=<87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/iP2nOzCWzLlWWGEU0hzNrQQ1l/LvCoWo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH] signal: Extend exec_id to 64bits
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)


Replace the 32bit exec_id with a 64bit exec_id to make it impossible
to wrap the exec_id counter.  With care an attacker can cause exec_id
wrap and send arbitrary signals to a newly exec'd parent.  This
bypasses the signal sending checks if the parent changes their
credentials during exec.

The severity of this problem can been seen that in my limited testing
of a 32bit exec_id it can take as little as 19s to exec 65536 times.
Which means that it can take as little as 14 days to wrap a 32bit
exec_id.  Adam Zabrocki has succeeded wrapping the self_exe_id in 7
days.  Even my slower timing is in the uptime of a typical server.
Which means self_exec_id is simply a speed bump today, and if exec
gets noticably faster self_exec_id won't even be a speed bump.

Extending self_exec_id to 64bits introduces a problem on 32bit
architectures where reading self_exec_id is no longer atomic and can
take two read instructions.  Which means that is is possible to hit
a window where the read value of exec_id does not match the written
value.  So with very lucky timing after this change this still
remains expoiltable.

I have updated the update of exec_id on exec to use WRITE_ONCE
and the read of exec_id in do_notify_parent to use READ_ONCE
to make it clear that there is no locking between these two
locations.

Link: https://lore.kernel.org/kernel-hardening/20200324215049.GA3710@pi3.com.pl
Fixes: 2.3.23pre2
Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

Linus would you prefer to take this patch directly or I could put it in
a brach and send you a pull request.
 
 fs/exec.c             | 2 +-
 include/linux/sched.h | 4 ++--
 kernel/signal.c       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 0e46ec57fe0a..d55710a36056 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1413,7 +1413,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
-	current->self_exec_id++;
+	WRITE_ONCE(current->self_exec_id, current->self_exec_id + 1);
 	flush_signal_handlers(current, 0);
 }
 EXPORT_SYMBOL(setup_new_exec);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 04278493bf15..0323e4f0982a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -939,8 +939,8 @@ struct task_struct {
 	struct seccomp			seccomp;
 
 	/* Thread group tracking: */
-	u32				parent_exec_id;
-	u32				self_exec_id;
+	u64				parent_exec_id;
+	u64				self_exec_id;
 
 	/* Protection against (de-)allocation: mm, files, fs, tty, keyrings, mems_allowed, mempolicy: */
 	spinlock_t			alloc_lock;
diff --git a/kernel/signal.c b/kernel/signal.c
index 9ad8dea93dbb..5383b562df85 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1926,7 +1926,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 		 * This is only possible if parent == real_parent.
 		 * Check if it has changed security domain.
 		 */
-		if (tsk->parent_exec_id != tsk->parent->self_exec_id)
+		if (tsk->parent_exec_id != READ_ONCE(tsk->parent->self_exec_id))
 			sig = SIGCHLD;
 	}
 
-- 
2.20.1

