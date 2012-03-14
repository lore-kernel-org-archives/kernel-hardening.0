Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Mar 2012 19:55:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20120314185538.GB14172@redhat.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <20120311172512.GA2729@redhat.com> <20120311174953.GB2729@redhat.com> <CA+55aFx43nZmhRg5Qv5x-4BdgcM-y80ECrgC8mCWc0RqU+_8rQ@mail.gmail.com> <20120314185510.GA14172@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314185510.GA14172@redhat.com>
Subject: [kernel-hardening] [PATCH 1/1] CLONE_PARENT shouldn't allow to set ->exit_signal
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Djalal Harouni <tixxdz@opendz.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Roland McGrath <roland@hack.frob.com>
List-ID: <kernel-hardening.lists.openwall.com>

The child must not control its ->exit_signal, it is the parent who
decides which signal the child should use for notification.

This means that CLONE_PARENT should not use "clone_flags & CSIGNAL",
the forking task is the sibling of the new process and their parent
doesn't control exit_signal in this case.

This patch uses ->exit_signal of the forking process, but perhaps
we should simply use SIGCHLD.

We read group_leader->exit_signal lockless, this can race with the
ORIGINAL_SIGNAL -> SIGCHLD transition, but this is fine.

Potentially this change allows to kill self_exec_id/parent_exec_id.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/fork.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index b77fd55..34d7ed1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1310,7 +1310,13 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	clear_all_latency_tracing(p);
 
 	/* ok, now we should be set up.. */
-	p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
+	if (clone_flags & CLONE_THREAD)
+		p->exit_signal = -1;
+	else if (clone_flags & CLONE_PARENT)
+		p->exit_signal = current->group_leader->exit_signal;
+	else
+		p->exit_signal = (clone_flags & CSIGNAL);
+
 	p->pdeath_signal = 0;
 	p->exit_state = 0;
 
-- 
1.5.5.1
