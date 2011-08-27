Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 27 Aug 2011 23:08:12 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110827190812.GA3804@albatros>
References: <20110804162009.GA2469@albatros>
 <20110823144430.75315ce8.akpm@linux-foundation.org>
 <20110826132909.GA8266@albatros>
 <20110826124021.15f8e20c.akpm@linux-foundation.org>
 <20110827190147.GA3015@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110827190147.GA3015@albatros>
Subject: [kernel-hardening] Re: [PATCH v2] proc: fix races against execve() of /proc/PID/fd**
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Aug 27, 2011 at 23:01 +0400, Vasiliy Kulikov wrote:
> fd* files are restricted to the task's owner, and other users may not
> get direct access to them.  But one may open any of these files and run
> any setuid program, keeping opened file descriptors.  As there are
> permission checks on open(), but not on stat(), readdir(), and read(),
> operations on the kept file descriptors will not be checked.  It makes
> it possible to violate procfs permission model.
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
> return codes.  If they'd differ, attacker can guess what fds exist by
> analyzing stat() return code.  Patched handlers: stat() for fd/*, stat()
> and read() for fdindo/*, readdir() and lookup() for fd/ and fdinfo/.
> 
> v2 - Rebased to v3.1-rc3.
>    - Handle stat() case.
> 
> CC: Stable Tree <stable@kernel.org>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
...
> @@ -2187,6 +2243,7 @@ static int proc_fd_permission(struct inode *inode, int mask)
>  /*
>   * proc directories can do almost nothing..
>   */
> +
>  static const struct inode_operations proc_fd_inode_operations = {
>  	.lookup		= proc_lookupfd,
>  	.permission	= proc_fd_permission,

Oops, odd blank line.  Andrew, should I resend the patch to fix it?

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
