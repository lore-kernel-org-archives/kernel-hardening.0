Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 20 Jun 2011 17:31:48 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110620133148.GA30680@openwall.com>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org> <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org>
Subject: [kernel-hardening] Re: [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
To: James Morris <jmorris@namei.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

I am reading this discussion via the kernel-hardening list.

On Mon, Jun 20, 2011 at 03:07:48PM +1000, James Morris wrote:
> [please cc: the lsm list with this kind of thing]
> 
> > This patch adds support of mount options to restrict access to
> > /proc/PID/ directories.  The default backward-compatible 'relaxed'
> > behaviour is left untouched.
> 
> Can you provide evidence that this is a useful feature?  e.g. examples of 
> exploits / techniques which would be _usefully_ hampered or blocked.

To me, this is primarily a privacy feature on multi-user servers.  This
was the primary intent behind my original implementation for Linux 2.0,
for which there was demand.  Then I forward-ported this (still as an
unofficial patch) to 2.2 and later to 2.4, and Brad Spengler
forward-ported it to 2.4 and 2.6 in grsecurity.  There was always
demand, primarily for privacy.

On shared web hosts that run users' scripts as the users (for greater
security and resource limits separation), process lists reveal website
access activity of each hosting user to others.

Network connections reveal where other users are connecting from and to,
which may be a privacy leak and it may allow for more focused attacks.

As to attacks not limited to reduced privacy for the users, but allowing
for unauthorized access as a next step, real-world'ish examples include
capturing passwords and filenames that another user (or their script)
passes via a command line.  Yes, it is wrong to pass sensitive info like
that, yet it is sometimes done.  Partial countermeasures such as mysql
overwriting -pXXX in argv (which it does) leave race conditions.
Restricting access to other users' process info is a more complete
countermeasure.  Even if a bypass is ever found, it may be fixed as a
bug.  Thus, the countermeasure is not as fundamentally flawed as
zeroizing of argv (yet I have nothing against that being done as well, I
find it just fine as long as its limitations are understood).
Then there are things such as usernames to other resources (databases,
etc.), which may allow for more focused attacks.  As to filenames, it is
quite common for users to share semi-private files via a mode 711
directory, so the filenames become somewhat sensitive.  (Of course, I am
aware of ways for users to avoid that, but security hardening, which is
what we're doing here, is about reducing risks assuming that user
behavior stays the same.  This does not imply that it should stay the
same.  We may be advocating for changes in behavior towards best
practices.  This is just multi-layered security, where one layer does
not depend on another.)

> > The first mount option is called "hidepid" and its value defines how much
> > info about processes we want to be available for non-owners:
> > 
> > hidepid=0 (default) means the current behaviour - anybody may read all
> > world-readable /proc/PID/* files.
> 
> Why not utilize unix perms on the proc files?  Perhaps via stricter 
> overall defaults which are selected at kernel build or runtime.

My original patches used stricter permissions only.  However, in this
discussion it was pointed out that this could be bypassed via netlink.
[ I am curious to know when this became possible - that is, whether some
of my old patches were similarly insufficient in that respect or not. ]
I did not follow the discussion closely, but my understanding is that
Vasiliy started changing things in response to that finding.

> > hidepid=1 means users may not access any /proc/<pid>/ directories, but their
> > own.  Sensitive files like cmdline, io, sched*, status, wchan are now
> > protected against other users.  As permission checking done in
> > proc_pid_permission() and files' permissions are left untouched,
> > programs expecting specific files' permissions are not confused.
> 
> IMHO such programs are beyond broken and have voided their kernel 
> warranty.

My understanding is that they (at least start-stop-daemon) check owner
info (for good reasons), but not permissions.  So we're free to change
permissions.

Thanks,

Alexander
