Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 5 Jun 2011 00:20:47 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110604202018.GA8019@shinshilla>
References: <20110518150601.GA2921@albatros>
 <20110524023409.GC12486@openwall.com>
 <20110524151246.GA3401@albatros>
 <4DE139FE.8050808@gmail.com>
 <20110604181911.GC5034@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110604181911.GC5034@openwall.com>
Subject: Re: [kernel-hardening] /proc/PID directory hiding (was: [owl-dev]
 segoon's status report - #1 of 15)
To: kernel-hardening@lists.openwall.com
Cc: Pavel Labushev <p.labushev@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 04, 2011 at 22:19 +0400, Solar Designer wrote:
> > It is:
> > $ python -c 'import os; print os.stat("/proc/1")'
> > posix.stat_result(st_mode=16744, st_ino=535821L, st_dev=3L, st_nlink=6,
> > st_uid=0, st_gid=0, st_size=0L, st_atime=1306605485, st_mtime=1306605485,
> > st_ctime=1306605485)
> > 
> > It's a known flaw and AFAIR it was considered irrelevant.
> 
> Is the above on grsecurity?

No, grsecurity hides uid/gid from both *stat*(2) and getdents*(2) functions
(implemented as proc_pid_readdir() and pid_getattr()).

> As to probing for PIDs with syscalls such as kill(2), we may deal with
> that as well

I'd not do this.  There are too many paths using pids, I don't think
there is some universal way (read: a bottleneck) to filter all accesses.
And the award is not too high to bother.

Thanks,

Vasiliy.
