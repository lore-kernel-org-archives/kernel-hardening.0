Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 12 Jun 2011 17:09:54 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
Message-ID: <20110612130953.GA3709@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] RLIMIT_NPROC check in set_user()
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>, Neil Brown <neilb@suse.de>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

I'd want to start a discussion of RLIMIT_NPROC check in set_user().
8 years ago set_user() was forced to check whether RLIMIT_NPROC limit is
reached, and, if so, abort set_user():

http://lkml.org/lkml/2003/7/13/226 [1]

Before the patch setuid() and similar were not able to fail because
of the reached limit.  So, some daemons running as root, dropping root
and switching uid/gid to some user were able to greatly exceed the limit
of processes running as this user.

The patch has solved this problem.  But it also unexpectedly created new
security threat.  Many poorly written programs running as root (or
owning CAP_SYS_ADMIN) don't expect setuid() failure and don't check its
return code.  If it fails, they still assume the uid has changed, but
actually it has not, which leads to very sad consequences.

In times of Linux 2.4 the initial problem (the lack of RLIMIT_NPROC
check) was solved in -ow patches by introducing the check in execve(),
not in setuid()/setuid() helpers as a process after dropping privileges
usually does execve() call.  While strictly speaking it is not a full
fix (it doesn't limit the number of not-execve'd but setuid'ed
processes) it works just fine for most of programs.

Another possible workaround is not moving the check from setuid() to
execve(), but sending SIGSEGV to the current process if setuid() failed [2].
This should solve the problem of poor programs and looks like not
breaking legitimate applications that handle setuid() failure as they
usually just print error message to the logfile/stderr and exit.  Also
as it is a horribly rare case (setuid() failure), more complicated code
path might be not tested very well.

I want to repeat myself: I don't consider checking RLIMIT_NPROC in
setuid() as a bug (a lack of syscalls return code checking is a real
bug), but as a pouring oil on the flames of programs doing poorly
written privilege dropping.  I believe the situation may be improved by
relatively small ABI changes that shouldn't be visible to normal
programs.

The first solution is reverting [1] and introducing similar check in
execve(), just like in -ow patch for 2.4.  The second solution is
applying [2] and sending SIGSEGV in case of privileges dropping failure.

I'd be happy to hear opinions about improving the fixes above or
alternative fixes.

Related references:
[1] - http://lkml.org/lkml/2003/7/13/226
[2] - https://lkml.org/lkml/2006/8/19/129 

Thanks,

-- 
Vasiliy
