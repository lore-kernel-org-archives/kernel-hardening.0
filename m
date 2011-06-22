Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 22 Jun 2011 10:45:45 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110622064545.GA3605@albatros>
References: <1308163895-5963-1-git-send-email-segoon@openwall.com>
 <20110621153102.762557f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621153102.762557f3.akpm@linux-foundation.org>
Subject: [kernel-hardening] Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount
 options
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, Alexey Dobriyan <adobriyan@gmail.com>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

First of all, to make it clear, this specific patch is not proposed
anymore because it doesn't restrict taskstats which can be used to
gather similar information.  The patch working with taskstats (and
without hidepid=2) was not yet posted on LKML, but is available here:

http://www.openwall.com/lists/kernel-hardening/2011/06/19/3

On Tue, Jun 21, 2011 at 15:31 -0700, Andrew Morton wrote:
> > This patch series adds support of procfs mount options and adds
> > mount options to restrict /proc/<pid>/ directories to owners and
> > /proc/<pid>/net/* to root.  Additional group may be defined via
> > gid=, and this group will be privileged to study others /proc/<pid>/
> > and networking information.
> > 
> > Similar features are implemented for old kernels in -ow patches (for
> > Linux 2.2 and 2.4) and for Linux 2.6 in -grsecurity, but both of them
> > are implemented as configure options, not cofigurable in runtime, with
> > changes of gid of /proc/<pid>/, and without backward-compatible
> > /proc/<pid>/net/* handling.
> 
> This all seems highly specific to one particular set of requirements. 

Yes, I admit this.  The problem with procfs is that it's possible to
chmod/chown some procfs files, but not /proc/PID/*.  Even if make it
possible to chmod/chown them (and introducing an inodes revalidation on
execve() setuid and similar binaries) it is still racy - new processes
would have /proc/PID/ and some files inside with perms=0555.  So, for
more generic mechanism something like umask is needed.  The patch in
question implements 2 border cases:

1) relaxed.  umask=0555.

2) restricted.  umask=0550 (with tricky gid) and files are still not
chmod'able.


More generic solution (I'm not suggesting it, but merely discussing)
would use some user-supplied set of files to restrict access to (or,
better, the set of allowed files because white list is almost always
better than black list).  Maybe this one:

    mount -t proc -o "pid_allow=exe,status,comm,oom_*" proc /proc

And without pid_allow it would behave like pid_allow=*.  "pid_allow=."
would deny access to the whole /proc/PID.

This would be a bit inconsistent with current permissions because e.g.
if use pid_allow=environ then environ file would not be accessible
because of posix permissions.  Hierarchical mode (pid_allow=fd/1) is not
allowed too.


But it wouldn't work with taskstats.  It needs its own set of allowed
fields or field sets like delayacct,csw,bacct,xacct.


> IOW is there some more general way of doing all this?  <handwaving>Like
> better permissions/chmod support in procfs and an inherited-across-fork
> per-process procfs permissions mask.</handwaving>

I don't know such way, but it would ease procfs logic.


> Does all this code support `mount -o remount' as expected?

Yes.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
