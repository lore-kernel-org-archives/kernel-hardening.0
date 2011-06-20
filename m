Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 20 Jun 2011 20:43:57 +1000 (EST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <20110620103917.GA5230@albatros>
Message-ID: <alpine.LRH.2.00.1106202040400.10448@tundra.namei.org>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org> <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org> <20110620103917.GA5230@albatros>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 20 Jun 2011, Vasiliy Kulikov wrote:

> > Can you provide evidence that this is a useful feature?  e.g. examples of 
> > exploits / techniques which would be _usefully_ hampered or blocked.
> 
> First, most of these files are usefull in sense of statistics gathering
> and debugging.  There is no reason to provide this information to the
> world.
> 
> Second, yes, it blocks one source of information used in timing attacks,
> just use reading the counters as more or less precise time measurement
> when actual timing measurements are not precise enough.

Can you provide concrete examples?

> > > hidepid=1 means users may not access any /proc/<pid>/ directories, but their
> > > own.  Sensitive files like cmdline, io, sched*, status, wchan are now
> > > protected against other users.  As permission checking done in
> > > proc_pid_permission() and files' permissions are left untouched,
> > > programs expecting specific files' permissions are not confused.
> > 
> > IMHO such programs are beyond broken and have voided their kernel 
> > warranty.
> 
> Policykit, Debian's start-stop-daemon, util-linux use /proc/PID's uid.
> procps use both /proc/PID's uid and gid.  Are all of them totally broken?

If they depend on specific permissions, yes.

To access the information, why not just create a group with Unix read 
access to these files?



- James
-- 
James Morris 
<jmorris@namei.org>
