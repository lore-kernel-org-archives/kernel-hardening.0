Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 10 Feb 2012 18:36:17 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20120210143616.GA6100@albatros>
References: <20120210020658.GA17709@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210020658.GA17709@dztty>
Subject: Re: [kernel-hardening] procfs: infoleaks and DAC permissions
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Solar Designer <solar@openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Fri, Feb 10, 2012 at 03:06 +0100, Djalal Harouni wrote:
> At least there are two issues for the procfs:
> 
> 1) Infoleaks via self-read by a suid/guid:
>    As noted in the thread [1], this probably affects most of the procfs
>    seq files.
>    - fd = open(/proc/self/maps...)
>    - exec a setuid program
>    - fd = /proc/pid_of_setuid/maps
>      (due to the 'task_struct' and 'mm_struct' lookup logic).
>    - read data from fd, this will pass ptrace_may_access() check.
>    - setuid program gives data.

AFAICS, it affects not only seq files, but every file: you can open
/proc/self/* and pass it to a setuid binary.

> 2) DAC permissions and suid/guid/privileged programs (userspace):
>    This is a list of files that are supposed to be protected:
>    /proc/<pid>/maps
>    /proc/<pid>/numa_maps
>    /proc/<pid>/smaps
>    /proc/<pid>/pagemap      Page table
>    /proc/<pid>/personality
>    /proc/<pid>/stack        Enbled by CONFIG_STACKTRACE
>    /proc/<pid>/syscall
>    more... ?
[...]
> A partial fix for this (2):
> Procfs 'hidepid=' mount option which can be used to restrict access to
> arbitrary /proc/<pid>/ files, Vasiliy commit [3], congrats.
> But if the procfs 'gid=' mount option is used then it can give permissions
> back to read these files if the user is part of the 'gid' group. IOW this
> will just restore the previous vulnerable situation.

It is even weaker - you could trick setuid $SPID to open /proc/$PID/maps,
do exec(setuid_app) as $PID and read setuid_app's maps as $SPID.

> These files should just follow DAC and be 0400, I know about glibc
> breakage. At least files that do not break glibc should be 0400 and
> prevent self-read infoleak.

It doesn't work as I've showed above.


I think the solution of (1) should follow the rule:

Any procfs file which has a ptrace check at open() time must not be
readable by any process unless both the target process and the reader
are the same as at open() time.  The reader check is needed for
[open - reader process exec to SUID - read] vuln.  The target check is
needed for [open - target process exec to SUID - read] vuln.

For mm-related files it is possible to store target->mm, but IMO it is
more universal to store task->exec_id for both source and target
processes as in Spender's patch [1].

I cannot find any solution of (2) except actually add ptrace check at
open() time...  Looks like we have to check what specific action glibc 
does with /proc/$pid/maps and whitelist these idiotic actions.  I hope
it is not arbitrary reads :-)


[1] http://grsecurity.net/~spender/dev_patches/distros_should_sponsor_me_for_doing_their_jobs.patch

Thanks,

--
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
