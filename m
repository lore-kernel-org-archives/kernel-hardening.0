Return-Path: <SRS0=+Hh9=4Q=lists.openwall.com=kernel-hardening-return-18019-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6FCC3F2D2
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 22:36:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5BB0F246B0
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 22:36:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BB0F246B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18019-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9677 invoked by uid 550); 28 Feb 2020 22:36:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9651 invoked from network); 28 Feb 2020 22:36:42 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,  Kernel Hardening
 <kernel-hardening@lists.openwall.com>,  Linux API
 <linux-api@vger.kernel.org>,  Linux FS Devel
 <linux-fsdevel@vger.kernel.org>,  Linux Security Module
 <linux-security-module@vger.kernel.org>,  Akinobu Mita
 <akinobu.mita@gmail.com>,  Alexey Dobriyan <adobriyan@gmail.com>,  Andrew
 Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,
  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,
  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce
 Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,
  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,
  Oleg Nesterov <oleg@redhat.com>,  Alexey Gladkov
 <gladkov.alexey@gmail.com>,  Linus Torvalds
 <torvalds@linux-foundation.org>,  Jeff Dike <jdike@addtoit.com>,  Richard
 Weinberger <richard@nod.at>,  Anton Ivanov
 <anton.ivanov@cambridgegreys.com>
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
	<878skmsbyy.fsf_-_@x220.int.ebiederm.org>
Date: Fri, 28 Feb 2020 16:34:20 -0600
In-Reply-To: <878skmsbyy.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Fri, 28 Feb 2020 14:17:41 -0600")
Message-ID: <878skmpcib.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j7oF9-0002E6-6T;;;mid=<878skmpcib.fsf_-_@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+NbByb1lQfJAk+7olBYMa3XlQf2trYP+A=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 4/3] pid: Improve the comment about waiting in zap_pid_ns_processes
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)


Oleg wrote a very informative comment, but with the removal of
proc_cleanup_work it is no longer accurate.

Rewrite the comment so that it only talks about the details
that are still relevant, and hopefully is a little clearer.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/pid_namespace.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 318fcc6ba301..01f8ba32cc0c 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -224,20 +224,27 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	} while (rc != -ECHILD);
 
 	/*
-	 * kernel_wait4() above can't reap the EXIT_DEAD children but we do not
-	 * really care, we could reparent them to the global init. We could
-	 * exit and reap ->child_reaper even if it is not the last thread in
-	 * this pid_ns, free_pid(pid_allocated == 0) calls proc_cleanup_work(),
-	 * pid_ns can not go away until proc_kill_sb() drops the reference.
+	 * kernel_wait4() misses EXIT_DEAD children, and EXIT_ZOMBIE
+	 * process whose parents processes are outside of the pid
+	 * namespace.  Such processes are created with setns()+fork().
 	 *
-	 * But this ns can also have other tasks injected by setns()+fork().
-	 * Again, ignoring the user visible semantics we do not really need
-	 * to wait until they are all reaped, but they can be reparented to
-	 * us and thus we need to ensure that pid->child_reaper stays valid
-	 * until they all go away. See free_pid()->wake_up_process().
+	 * If those EXIT_ZOMBIE processes are not reaped by their
+	 * parents before their parents exit, they will be reparented
+	 * to pid_ns->child_reaper.  Thus pidns->child_reaper needs to
+	 * stay valid until they all go away.
 	 *
-	 * We rely on ignored SIGCHLD, an injected zombie must be autoreaped
-	 * if reparented.
+	 * The code relies on the the pid_ns->child_reaper ignoring
+	 * SIGCHILD to cause those EXIT_ZOMBIE processes to be
+	 * autoreaped if reparented.
+	 *
+	 * Semantically it is also desirable to wait for EXIT_ZOMBIE
+	 * processes before allowing the child_reaper to be reaped, as
+	 * that gives the invariant that when the init process of a
+	 * pid namespace is reaped all of the processes in the pid
+	 * namespace are gone.
+	 *
+	 * Once all of the other tasks are gone from the pid_namespace
+	 * free_pid() will awaken this task.
 	 */
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-- 
2.20.1

