Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 10 Aug 2011 16:04:39 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110810120439.GA7008@albatros>
References: <20110605201025.GA9541@openwall.com>
 <20110606180806.GA3986@albatros>
 <20110606183358.GA14711@openwall.com>
 <20110608172307.GA3380@albatros>
 <20110612023916.GC14976@openwall.com>
 <20110724185036.GC3510@albatros>
 <20110726145016.GA8583@albatros>
 <20110729174725.GA2339@albatros>
 <20110804112331.GA2563@albatros>
 <20110810112522.GB30492@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810112522.GB30492@openwall.com>
Subject: Re: [kernel-hardening] procfs {tid,tgid,attr}_allowed mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Wed, Aug 10, 2011 at 15:25 +0400, Solar Designer wrote:
> On Thu, Aug 04, 2011 at 03:23:31PM +0400, Vasiliy Kulikov wrote:
> > New version.  Cleanups/fixes here and there.
> > 
> > It lacks net/ restriction, but IMO it is already complicated enough
> > (more than 500 new lines).  Such (relatively) simple thing as
> > net_allowed= is an additional care.  I'd achieve at least processes
> > restrictions in upstream, after it will come networking.
> 
> That's a lot of code already.

Yes, so I'd try to get comments from net-less and gid-less patch first.
Probably the whole way of permissions handling would be ridicules for
kernel forlk :)

> I tried reviewing it, but I felt that I
> need an English description of its functionality first.  Perhaps you're
> preparing one for posting to LKML anyway - can you please post it in
> here first?

Something like this:


This patch adds support of pid_allowed=XX and attr_allowed=YY mount
options for procfs.  When set, all /proc/PID/ files are restricted to
the owner, except filenames passed via pid_allowed= argument.  E.g. with
pid_allowed=sched sched file would be world readable and other files
would be restricted to the task owner.  The same for /proc/PID/attr/
files and attr_allowed=YY.

The new struct file_operations proc_pid_perms_fops was created to deal
with permissions keeping in mind pid_allowed=.  It is a wrapper for all
/proc/PID/* and /proc/PID/task/TID/* file_operations.  It checks
current task permissions against the target task on each struct file
access to avoid races against execve().

All pid_entry's gain the following permission checking algorithm by
default:

1) if the filename is not passed via pid_allowed= then ptrace check is
applied.

2) Otherwise, if file POSIX permissions deny access to the world, ptrace
check is applied.

3) Otherwise, generic permission checking scheme is applied.  For procfs
files it additionally includes ptrace check if current euid and the
procfs inode uid are equal.

For the simplicity meta values are allowed: "none" and "all".  "all"
means all files are a subject of (2) and (3) checks.  "none" means all
files are a subject of (1) check.  "none" additionally restricts access
to the /proc/PID/ directory itself.

Old ptrace checks are removed from the handlers as they are now obsoleted by
proc_pid_perms_fops checks.  Handlers may further restrict the
permission model by introducing additional checks.  For some files the
ptrace check is too strong (environ, auxv, maps, numa_maps, and smaps),
so no implicit permission checking is applied for them.  These files
should use pid_entry macros with "_PERMS" suffix.

Only /proc/PID/, /proc/PID/*, /proc/PID/task/TID/, /proc/PID/task/TID/*,
/proc/PID/attr/* files' permission checking is changed.  fd/ and fdinfo/
are outstanding files and check the permissions on their own.

Thanks,

---
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
