Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 5 Jun 2011 00:09:51 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110604200948.GA5850@shinshilla>
References: <20110603191153.GB514@openwall.com>
 <20110604054758.GA4063@albatros>
 <20110604132054.GC2583@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110604132054.GC2583@openwall.com>
Subject: Re: [kernel-hardening] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sat, Jun 04, 2011 at 17:20 +0400, Solar Designer wrote:
> On Sat, Jun 04, 2011 at 09:47:58AM +0400, Vasiliy Kulikov wrote:
> > I think it should be done with separate mount options for /proc/self/net
> > (/proc/net is a symlink to /proc/self/net since net namespaces
> > introduction) and for /proc/PID.
> 
> OK.  What do we call these?  pmask (for "p"rocesses) and nmask (for
> "n"etwork)?  Doesn't this deviation from umask reduce the chances of the
> patch getting accepted?..  And is there really much reason to let a user
> see others' processes, but not network connections, or vice versa?
> (Maybe there is.)

While implementing this PID permissions restricting mount opt (don't
know how to call it better), I've noticed that only 2 modes make sense -
full view (current behaviour) and restricted view (similar to umask=07).
So, I propose to implement & call the options as follows:

    (no)safepid - instead of umask/mode; if it is on, only
owner/root/special group may read /proc/PID.

    (no)hidepid - hide restricted /proc/PID from *stat*(2), getdents*()
and similar.  Needs safepid.

    (no)hidenet - hide /proc/PID/net contents (restricting /proc/PID/net
itself is a bit more difficult to implement).

    gid - group to evade safepid,hidepid,hidenet.

Also as hidepid needs safepid, maybe it makes sense to implement one
option instead of safepid and hidepid: hidepid=X where:

 X = 0 means nohidepid,nosafepid above
 X = 1 means safepid,nohidepid above
 X = 2 means safepid,hidepid above

> > All other files should be e.g.
> > chmod'ed go= and then some white list should be chmod'ed to the relaxed
> > perms.
> 
> Where would this logic be implemented - hard-coded in the kernel
> (enabled with some mount option?) or done by a script in the userspace
> post-mount?

I'm sure if we try to implement it in kernel, we'd surely get NAK
because it may be implemented much simplier in userspace.  Compare:
a single chmod -R vs. some in-kernel filtering of core procfs files and
driver-specific files (yes, there are rare driver files in /proc, it is
blamed, but anyway).

> > > Indeed, we could set some of these perms with chmod post-mount, but as
> > > discussed this has drawbacks.
> > 
> > Where its drawbacks were discussed?
> 
> IIRC, you, I, and some others discussed them via Jabber.

Ah, OK ;)

> > I cannot find anything on
> > owl-dev.  Do you mean some possible diffirences between procfs files
> > among different kernel versions?  If so, white list instead of black
> > list should partly solve it.
> 
> No, I meant race conditions, which you had to deal with by mounting
> under a parent directory with restricted perms, then mount --move'ing.
> Part of the intent of us patching the kernel is to avoid having to do
> things like that.

For distros with sysv init there is no race if it is implemented in a
boot script before any login/cron/etc.  It's a rare situation now,
though :)

>  Also, an admin might just "mount /proc", not knowing
> that special userspace magic was implemented by the distro.

Agreed, but I still don't think it is a good argument for upstream...

> A possible approach is to implement mount options gid=... and restricted
> (name suggested by spender), where the latter would enable a hard-coded
> set of permissions.

To what files?  All /proc/* files or recursively?  Is there a white list
of o=r/o=rw files or all of them would be chmod'ed "o="?

>  This is not generic, but at least it's simple, not
> confusing, and it allows for future changes (we may change what exactly
> restricted means).

Changing what some option means after implementing it is a ABI breakage,
which is terrible for upstream.  However, it might be acceptable for Owl.

> > > So ideally our preferred configuration
> > > (which will be the default on Owl) should be achievable with mount
> > > options alone.
> > 
> > At least for sysfs it is unreachable if we go in the current direction -
> > umask doesn't change perms of already created files, and additional
> > "chmod -R" is needed anyway.
> 
> Hmm.  I guess I still don't understand your umask vs. mode stuff.
> 
> Ideally, I'd have umask apply to each instance of sysfs (and other
> special filesystems) individually, affecting all files under that
> instance

What instance?  All files (=kobjects) are global, there is almost no
division among mount points.  The only division is among net namespaces,
but it is mostly the exception than the rule and there will be always
files global to all namespaces (e.g. modules list, devices list, etc.)

> (both those already existing in the kernel at the time of mount
> and those appearing after mount).  But perhaps that's not how the kernel
> keeps track of permissions for those filesystems currently?

I'd not change permissions of all currently existing files.  What would
you do with already created and chmod'ed files?

And what you suggest is strictly speaking not "umask".  "umask" is for newly
created files.  "mode" is almost everything judging by mount(8) :)


Currently I have only one TODO in my list for procfs - restricted
/proc/PID/net returns -EINVAL instead of -ENOENT as it is done in
grsecurity :)  Need to make it say true.

Thanks,

Vasiliy.
