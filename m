Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 12 Feb 2012 16:36:12 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120212153612.GA15621@dztty>
References: <20120210020658.GA17709@dztty>
 <20120211100709.GA18767@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120211100709.GA18767@openwall.com>
Subject: Re: [kernel-hardening] procfs: infoleaks and DAC permissions
To: kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 11, 2012 at 02:07:09PM +0400, Solar Designer wrote:
> On Fri, Feb 10, 2012 at 03:06:58AM +0100, Djalal Harouni wrote:
> > 1) Infoleaks via self-read by a suid/guid:
> ...
> >    I believe to fix this we should just let 'mm_struct' point to the old
> >    one (as done by Linus' commit [2] for the /proc/self/mem)
> 
> I dislike this approach because it introduces a resource limits bypass.
> When you hold an mm, you hold all data of the old process in VM, right?
I guess, but that code can be considered semantically correct since we did
not release it.

Oleg's patch [1] makes sure that 'mm->mm_users' holds the right value, if
the process drops the 'fd' the next read/write call will fail, so it will
not be visible to userspace if the original process exits. It will fail
at:
if (!atomic_inc_not_zero(&mm->mm_users))
  return NULL;

It will be freed only by the release function.


Can you elaborate more on the resource limits bypass please ?


I guess we can try this:
self_pid = getpid()
open("/proc/self_pid/mem")
execv("/proc/self_pid/comm",...)

A quick slabtop shows that mm_struct objects keep increasing...
But the 'fd' limit will kill the program, what about others ?


BTW NOMMU code fs/proc/task_nommu.c seems also affected by these issues.

> > 2) DAC permissions and suid/guid/privileged programs (userspace):
> >    This is a list of files that are supposed to be protected:
> ...
> > Now if we manage to:
> > - Find a setuid/privileged program that reads user specified files.
> > - setuid program drops privileges temporarily.
> > - setuid program opens user file: '/proc/1/maps' to _get_ the fd.
> >   open() will succeed
> > - setuid program restores privileges
> > - setuid program calls lseek,read... on the previous fd.
> > - Information leakage...
> 
> Oh, my ideas from the previous message don't deal with this attack.
> There will be a PID match and an exec_id match here.
> 
> Looks like the program can't be trusted to read its own proc files,
> then. %-)  It could be trusted to obtain the same info via other means
> where the request is definitely hard-coded rather than user triggered
> (such as via a user-passed filename or fd).
Yes.

>
> Hmm, how about allowing self-reads only if the passed filename is in
> .rodata?  Would this satisfy glibc's needs?  Sounds awfully hackish,
> though.  I am just brainstorming.
> 
> Maybe what we really need in the long term is a prctl() option that
> will deliver whatever glibc needs to know.  Or we can have this info
> in the auxiliary vector passed on execve().  Then we'd be able to setup
> proper DAC perms on the proc files and not introduce any bypass.
> Of course, this will require a glibc patch and a transition period of
> some years.
IMHO right now we should just avoid the idea of a glibc patch.

> > A partial fix for this (2):
> > Procfs 'hidepid=' mount option which can be used to restrict access to
> > arbitrary /proc/<pid>/ files, Vasiliy commit [3], congrats.
> 
> This works against fd passing to a privileged process (you need to be
> able to open() the proc file first, which will fail for someone else's
> process), but not for SUID self-reads.
Right.

> BTW, what about SGIDs and processes with fscaps?  The invoking user
> remains the owner of the /proc/<pid> directory, yet the process is
> somewhat privileged.  Maybe we need to harden that.
To pass the ptrace check: uid and gid of current and target are checked,
if it fails then there is the CAP_SYS_PTRACE check on current.

> > ... these days '%n' should be just banned.
> 
> "%n" is a useful and safe feature in some rare cases.  I don't really
> mind it slowly going away, but while it's there and not planned for
> removal (as far as I'm aware), I also don't mind using it in my code.
> An URL detector:
> 
> 	start = domain = path = end = -1; slash = '.';
> 	n = sscanf(data, " %n%*4[fhtp]://%n%*[.a-zA-Z0-9-]%n%c%*[a-zA-Z0-9._~%!$&'()*+,;=:@?#/-]%n", &start, &domain, &path, &slash, &end);
> 	if (n >= 1 && start >= 0 && domain > start && path > domain &&
> 	    slash != '.' &&
> 	    (!strncmp(data + start, "ftp", 3) ||
> 	    !strncmp(data + start, "http", 4))) {
> 		if (slash != '/' || end < path)
> 			end = path;
> 
> Four uses of "%n" here. ;-)  This is unreleased code, though, and I've
> since replaced it with a much longer implementation that uses more
> explicit checks and does not depend on "%n".
What I can say ? ... impressive ;)

> Alexander

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6d08f2c7139790c268820a2e590795cb8333181a

-- 
tixxdz
http://opendz.org
