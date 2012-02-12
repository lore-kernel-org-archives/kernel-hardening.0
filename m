Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 12 Feb 2012 01:19:52 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120212001952.GA1574@dztty>
References: <20120210020658.GA17709@dztty>
 <20120210143616.GA6100@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210143616.GA6100@albatros>
Subject: Re: [kernel-hardening] procfs: infoleaks and DAC permissions
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Solar Designer <solar@openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 10, 2012 at 06:36:17PM +0400, Vasiliy Kulikov wrote:
> Hi,
> 
> On Fri, Feb 10, 2012 at 03:06 +0100, Djalal Harouni wrote:
> > At least there are two issues for the procfs:
> > 
> > 1) Infoleaks via self-read by a suid/guid:
> >    As noted in the thread [1], this probably affects most of the procfs
> >    seq files.
> >    - fd = open(/proc/self/maps...)
> >    - exec a setuid program
> >    - fd = /proc/pid_of_setuid/maps
> >      (due to the 'task_struct' and 'mm_struct' lookup logic).
> >    - read data from fd, this will pass ptrace_may_access() check.
> >    - setuid program gives data.
> 
> AFAICS, it affects not only seq files, but every file: you can open
> /proc/self/* and pass it to a setuid binary.
Yes, brobably.

> > 2) DAC permissions and suid/guid/privileged programs (userspace):
> >    This is a list of files that are supposed to be protected:
> >    /proc/<pid>/maps
> >    /proc/<pid>/numa_maps
> >    /proc/<pid>/smaps
> >    /proc/<pid>/pagemap      Page table
> >    /proc/<pid>/personality
> >    /proc/<pid>/stack        Enbled by CONFIG_STACKTRACE
> >    /proc/<pid>/syscall
> >    more... ?
> [...]
> > A partial fix for this (2):
> > Procfs 'hidepid=' mount option which can be used to restrict access to
> > arbitrary /proc/<pid>/ files, Vasiliy commit [3], congrats.
> > But if the procfs 'gid=' mount option is used then it can give permissions
> > back to read these files if the user is part of the 'gid' group. IOW this
> > will just restore the previous vulnerable situation.
> 
> It is even weaker - you could trick setuid $SPID to open /proc/$PID/maps,
> do exec(setuid_app) as $PID and read setuid_app's maps as $SPID.
Well, if I understand that patch correctly, when procfs is mounted with
'hidepid' and without 'gid', the fix should be in the setuid application
which opens arbitrary files, right ?

My point is that open() is called by unprivileged code and it will
succeed.

>> These files should just follow DAC and be 0400, I know about glibc
>> breakage. At least files that do not break glibc should be 0400 and
>> prevent self-read infoleak.

> It doesn't work as I've showed above.
I think that I'm missing something.

> [...]
> I cannot find any solution of (2) except actually add ptrace check at
> open() time...  Looks like we have to check what specific action glibc 
> does with /proc/$pid/maps and whitelist these idiotic actions.  I hope
Seems fine with ptrace, perhaps we can also make some files 'S_IRUSR'.

> it is not arbitrary reads :-)
Currently it is:

# chmod u+s /usr/bin/wall
$ ./procfs_leak /usr/bin/wall /proc/1/maps
...
7fcf6930b000-7fcf69328000 r-xp 00000000 08:06 652945
/sbin/
init                                                                           
7fcf69527000-7fcf69529000 r--p 0001c000 08:06 652945
/sbin/
init                                                                           
7fcf69529000-7fcf6952a000 rw-p 0001e000 08:06 652945
/sbin/
init                                                                           
7fcf6b226000-7fcf6b2c4000 rw-p 00000000 00:00 0
[heap]
7fff0e916000-7fff0e937000 rw-p 00000000 00:00 0
[stack]
...

As I've said, one just need to find the appropriate program (not especially
setuid root), I did not bother to search.

> [1] http://grsecurity.net/~spender/dev_patches/distros_should_sponsor_me_for_doing_their_jobs.patch
Yes this patch should protect current configs of distros from (1).
Still some files, especially the writable ones.

Thank you for your input.

> Thanks,
> 
> --
> Vasiliy Kulikov
> http://www.openwall.com - bringing security into open computing environments

-- 
tixxdz
http://opendz.org
