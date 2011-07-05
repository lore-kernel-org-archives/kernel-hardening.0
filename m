Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 5 Jul 2011 14:13:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20110705141301.0d3594e0.akpm@linux-foundation.org>
In-Reply-To: <20110704201339.GA5645@albatros>
References: <20110703103925.GA2283@albatros>
	<CA+55aFwfr-oAa-2L9O_rd9iZDyVr0b+gFQS=_R5PUxmhh3JEsg@mail.gmail.com>
	<20110704201339.GA5645@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] proc: fix a race in do_io_accounting()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, security@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

<wakes up>

On Tue, 5 Jul 2011 00:13:39 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> There is a ptrace_may_access() check in do_io_accounting() to prevent
> gathering information of setuid'ed and similar binaries.  However, there
> is a race against execve().  Holding task->signal->cred_guard_mutex
> while gathering the information should protect against the race.
> 
> The order of locking is similar to the one inside of
> ptrace_attach(): first goes cred_guard_mutex, then lock_task_sighand().
> 
> v2 - use mutex_lock_killable() instead of mutex_lock().
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> Cc: stable@kernel.org

If a patch is to be backported into -stable then its changelog had
better explain why such a thing is needed.  This one doesn't.

Please provide a full description of the conseuqences of the bug.  One
which will permit the -stable maintainers to understand why they're
merging the patch, and one which will help distribution maintainers
decide whether they want to merge it as well.
