Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 29 Aug 2011 16:00:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20110829160000.9e14f8b8.akpm@linux-foundation.org>
In-Reply-To: <20110829180011.GA8839@albatros>
References: <20110804162009.GA2469@albatros>
	<20110823144430.75315ce8.akpm@linux-foundation.org>
	<20110826132909.GA8266@albatros>
	<20110826124021.15f8e20c.akpm@linux-foundation.org>
	<20110827190147.GA3015@albatros>
	<20110828092520.GA8537@sun>
	<20110828093156.GA6291@albatros>
	<20110829180011.GA8839@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3] proc: fix races against execve() of /proc/PID/fd**
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 29 Aug 2011 22:00:11 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> fd* files are restricted to the task's owner, and other users may not
> get direct access to them.  But one may open any of these files and run
> any setuid program, keeping opened file descriptors.  As there are
> permission checks on open(), but not on readdir() and read(), operations
> on the kept file descriptors will not be checked.  It makes it possible
> to violate procfs permission model.
> 
> Reading fdinfo/* may disclosure current fds' position and flags, reading
> directory contents of fdinfo/ and fd/ may disclosure the number of opened
> files by the target task.  This information is not sensible per se, but
> it can reveal some private information (like length of a password stored in
> a file) under certain conditions.
> 
> Used existing (un)lock_trace functions to check for ptrace_may_access(),
> but instead of using EPERM return code from it use EACCES to be
> consistent with existing proc_pid_follow_link()/proc_pid_readlink()
> return code.  If they differ, attacker can guess what fds exist by
> analyzing stat() return code.  Patched handlers: stat() for fd/*, stat()
> and read() for fdindo/*, readdir() and lookup() for fd/ and fdinfo/.
> 
> +	rc = -EACCES;
> +	if (lock_trace(task))
> +		goto out_task;
> +
>
> ...
>
> +	rc = -EACCES;
> +	if (lock_trace(task))
> +		goto out_task;
> +
>
> ...
>
> +	result = ERR_PTR(-EACCES);
> +	if (lock_trace(task))
> +		goto out;
> +
>
> ...
>
> +
> +	retval = -EACCES;
> +	if (lock_trace(p))
> +		goto out;
> +
>
> ...
>

lock_trace() can return -EPERM, and it can return whatever
mutex_lock_killable() returned (-EINTR, perhaps other things?).

The patch simply overwrites this return value with -EACCES.  Is this
deliberate and correct?  If so, please explain?
