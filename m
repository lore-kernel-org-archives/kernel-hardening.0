Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 4 Jun 2011 22:19:11 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110604181911.GC5034@openwall.com>
References: <20110518150601.GA2921@albatros> <20110524023409.GC12486@openwall.com> <20110524151246.GA3401@albatros> <4DE139FE.8050808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE139FE.8050808@gmail.com>
Subject: [kernel-hardening] /proc/PID directory hiding (was: [owl-dev] segoon's status report - #1 of 15)
To: kernel-hardening@lists.openwall.com
Cc: Pavel Labushev <p.labushev@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Pavel, Vasiliy -

On Sun, May 29, 2011 at 02:07:58AM +0800, Pavel Labushev wrote:
> 24.05.2011 23:12, Vasiliy Kulikov wrote:
> 
> > I've implemented restricted perms, but didn't do actual hiding
> > directories.  In grsecurity it is implemented by hiding directories from
> > processes that cannot access them.
> > 
> > I think it may be defective by design because there are many other ways
> 
> It is:
> $ python -c 'import os; print os.stat("/proc/1")'
> posix.stat_result(st_mode=16744, st_ino=535821L, st_dev=3L, st_nlink=6,
> st_uid=0, st_gid=0, st_size=0L, st_atime=1306605485, st_mtime=1306605485,
> st_ctime=1306605485)
> 
> It's a known flaw and AFAIR it was considered irrelevant.

Is the above on grsecurity?

I think we may choose to restrict more than just directory listing -
that is, have these entries invisible even when referenced by full
pathnames.

As to probing for PIDs with syscalls such as kill(2), we may deal with
that as well (but we'd need to consider potential performance impact, as
well as timing attacks), or may choose not to do it.  Arguably, we
primarily want to hide UIDs/GIDs of running processes, not their PIDs.

Alexander
