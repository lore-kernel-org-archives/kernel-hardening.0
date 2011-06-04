Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 4 Jun 2011 17:20:54 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110604132054.GC2583@openwall.com>
References: <20110603191153.GB514@openwall.com> <20110604054758.GA4063@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110604054758.GA4063@albatros>
Subject: Re: [kernel-hardening] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Sat, Jun 04, 2011 at 09:47:58AM +0400, Vasiliy Kulikov wrote:
> I think it should be done with separate mount options for /proc/self/net
> (/proc/net is a symlink to /proc/self/net since net namespaces
> introduction) and for /proc/PID.

OK.  What do we call these?  pmask (for "p"rocesses) and nmask (for
"n"etwork)?  Doesn't this deviation from umask reduce the chances of the
patch getting accepted?..  And is there really much reason to let a user
see others' processes, but not network connections, or vice versa?
(Maybe there is.)

> All other files should be e.g.
> chmod'ed go= and then some white list should be chmod'ed to the relaxed
> perms.

Where would this logic be implemented - hard-coded in the kernel
(enabled with some mount option?) or done by a script in the userspace
post-mount?

> > Indeed, we could set some of these perms with chmod post-mount, but as
> > discussed this has drawbacks.
> 
> Where its drawbacks were discussed?

IIRC, you, I, and some others discussed them via Jabber.

> I cannot find anything on
> owl-dev.  Do you mean some possible diffirences between procfs files
> among different kernel versions?  If so, white list instead of black
> list should partly solve it.

No, I meant race conditions, which you had to deal with by mounting
under a parent directory with restricted perms, then mount --move'ing.
Part of the intent of us patching the kernel is to avoid having to do
things like that.  Also, an admin might just "mount /proc", not knowing
that special userspace magic was implemented by the distro.

A possible approach is to implement mount options gid=... and restricted
(name suggested by spender), where the latter would enable a hard-coded
set of permissions.  This is not generic, but at least it's simple, not
confusing, and it allows for future changes (we may change what exactly
restricted means).

> > So ideally our preferred configuration
> > (which will be the default on Owl) should be achievable with mount
> > options alone.
> 
> At least for sysfs it is unreachable if we go in the current direction -
> umask doesn't change perms of already created files, and additional
> "chmod -R" is needed anyway.

Hmm.  I guess I still don't understand your umask vs. mode stuff.

Ideally, I'd have umask apply to each instance of sysfs (and other
special filesystems) individually, affecting all files under that
instance (both those already existing in the kernel at the time of mount
and those appearing after mount).  But perhaps that's not how the kernel
keeps track of permissions for those filesystems currently?  (Sorry, I
haven't played with this since Linux 2.4, which didn't even have sysfs.)

Thanks,

Alexander
