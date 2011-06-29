Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 29 Jun 2011 23:16:15 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110629191615.GA9343@albatros>
References: <1308163895-5963-1-git-send-email-segoon@openwall.com>
 <20110621153102.762557f3.akpm@linux-foundation.org>
 <20110622064545.GA3605@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622064545.GA3605@albatros>
Subject: [kernel-hardening] Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount
 options
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, Alexey Dobriyan <adobriyan@gmail.com>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 22, 2011 at 10:45 +0400, Vasiliy Kulikov wrote:
> > This all seems highly specific to one particular set of requirements. 
> 
> Yes, I admit this.  The problem with procfs is that it's possible to
> chmod/chown some procfs files, but not /proc/PID/*.  Even if make it
> possible to chmod/chown them (and introducing an inodes revalidation on
> execve() setuid and similar binaries) it is still racy - new processes
> would have /proc/PID/ and some files inside with perms=0555.  So, for
> more generic mechanism something like umask is needed.  The patch in
> question implements 2 border cases:
> 
> 1) relaxed.  umask=0555.
> 
> 2) restricted.  umask=0550 (with tricky gid) and files are still not
> chmod'able.
> 
> 
> More generic solution (I'm not suggesting it, but merely discussing)
> would use some user-supplied set of files to restrict access to (or,
> better, the set of allowed files because white list is almost always
> better than black list).  Maybe this one:
> 
>     mount -t proc -o "pid_allow=exe,status,comm,oom_*" proc /proc

Does this scheme make sense?  Should I rensend the patch with these
architecture?

pid_allow=, tid_allow=, attr_allow= and watch_gid= or smth like that.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
