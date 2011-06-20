Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 20 Jun 2011 14:39:18 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110620103917.GA5230@albatros>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org>
 <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org>
Subject: [kernel-hardening] Re: [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
To: James Morris <jmorris@namei.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 20, 2011 at 15:07 +1000, James Morris wrote:
> > This patch adds support of mount options to restrict access to
> > /proc/PID/ directories.  The default backward-compatible 'relaxed'
> > behaviour is left untouched.
> 
> Can you provide evidence that this is a useful feature?  e.g. examples of 
> exploits / techniques which would be _usefully_ hampered or blocked.

First, most of these files are usefull in sense of statistics gathering
and debugging.  There is no reason to provide this information to the
world.

Second, yes, it blocks one source of information used in timing attacks,
just use reading the counters as more or less precise time measurement
when actual timing measurements are not precise enough.

Third, such level of privacy (especially cmdline and comm) may be the
goal itself, where users may be anxious whether anybody knows what they
do.


> > The first mount option is called "hidepid" and its value defines how much
> > info about processes we want to be available for non-owners:
> > 
> > hidepid=0 (default) means the current behaviour - anybody may read all
> > world-readable /proc/PID/* files.
> 
> Why not utilize unix perms on the proc files?  Perhaps via stricter 
> overall defaults which are selected at kernel build or runtime.
> 
> > hidepid=1 means users may not access any /proc/<pid>/ directories, but their
> > own.  Sensitive files like cmdline, io, sched*, status, wchan are now
> > protected against other users.  As permission checking done in
> > proc_pid_permission() and files' permissions are left untouched,
> > programs expecting specific files' permissions are not confused.
> 
> IMHO such programs are beyond broken and have voided their kernel 
> warranty.

Policykit, Debian's start-stop-daemon, util-linux use /proc/PID's uid.
procps use both /proc/PID's uid and gid.  Are all of them totally broken?

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
