Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 20 Jun 2011 15:07:48 +1000 (EST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org>
Message-ID: <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

[please cc: the lsm list with this kind of thing]

> This patch adds support of mount options to restrict access to
> /proc/PID/ directories.  The default backward-compatible 'relaxed'
> behaviour is left untouched.

Can you provide evidence that this is a useful feature?  e.g. examples of 
exploits / techniques which would be _usefully_ hampered or blocked.

> The first mount option is called "hidepid" and its value defines how much
> info about processes we want to be available for non-owners:
> 
> hidepid=0 (default) means the current behaviour - anybody may read all
> world-readable /proc/PID/* files.

Why not utilize unix perms on the proc files?  Perhaps via stricter 
overall defaults which are selected at kernel build or runtime.

> hidepid=1 means users may not access any /proc/<pid>/ directories, but their
> own.  Sensitive files like cmdline, io, sched*, status, wchan are now
> protected against other users.  As permission checking done in
> proc_pid_permission() and files' permissions are left untouched,
> programs expecting specific files' permissions are not confused.

IMHO such programs are beyond broken and have voided their kernel 
warranty.


-- 
James Morris
<jmorris@namei.org>
