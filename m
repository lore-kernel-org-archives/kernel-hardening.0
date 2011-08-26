Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 26 Aug 2011 12:40:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20110826124021.15f8e20c.akpm@linux-foundation.org>
In-Reply-To: <20110826132909.GA8266@albatros>
References: <20110804162009.GA2469@albatros>
	<20110823144430.75315ce8.akpm@linux-foundation.org>
	<20110826132909.GA8266@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] proc: fix races against execve() of
 /proc/PID/{fd/,fdinfo/,fdinfo/*}
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 26 Aug 2011 17:29:09 +0400
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
> Used existing (un)lock_trace functions to deal with the issue by calling
> ptrace_may_access() permission checks.

This doesn't apply to current mainline.  Please redo, retest, resend?
