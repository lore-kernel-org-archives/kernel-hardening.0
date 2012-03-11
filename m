Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 11 Mar 2012 18:49:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20120311174953.GB2729@redhat.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <20120311172512.GA2729@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120311172512.GA2729@redhat.com>
Subject: [kernel-hardening] self_exec_id/parent_exec_id && CLONE_PARENT
To: Djalal Harouni <tixxdz@opendz.org>, Linus Torvalds <torvalds@linux-foundation.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

(change subject)

On 03/11, Oleg Nesterov wrote:
>
> Well, I don't think it is right to add this counter into task_struct.
>
> It should be per-process, signal_struct makes more sense. Or may be
> mm_struct.
>
> Btw this is also true for parent_exec_id/self_exec_id, but this is
> another story.

In fact I think it would be nice to kill parent_exec_id/self_exec_id.

Afaics, this only problem is clone(CLONE_PARENT | SIGXXX). I expect
the answer is "no, can break existing applications", but I'll ask
anyway.

Can't we change this? IOW, can't we modify copy_process

	- p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
	+ p->exit_signal =
	+	(clone_flags & CLONE_THREAD) ? -1 :
	+	(clobe_flags & CLONE_PARENT) ? current->group_leader->exit_signal :
	+	(clone_flags & CSIGNAL);

(or simply use SIGCHLD instead of group_leader->exit_signal).

Then we can kill parent_exec_id/self_exec_id if me modify de_thread()
to set ->exit_signal = SIGCHLD for every child.

I am also asking because the change above looks like the fix to me.
The child must not control its ->exit_signal, it is the parent who
decides which signal the child should use for notification.

And to me, clone(CLONE_PARENT | SIGXXX) looks like a violation of
rule above.

Oleg.
