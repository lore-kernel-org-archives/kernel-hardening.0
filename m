Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 5 Jun 2011 00:59:56 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110604205955.GA5972@openwall.com>
References: <20110603191153.GB514@openwall.com> <20110604054758.GA4063@albatros> <20110604132054.GC2583@openwall.com> <20110604200948.GA5850@shinshilla>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110604200948.GA5850@shinshilla>
Subject: Re: [kernel-hardening] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 05, 2011 at 12:09:51AM +0400, Vasiliy Kulikov wrote:
> While implementing this PID permissions restricting mount opt (don't
> know how to call it better), I've noticed that only 2 modes make sense -
> full view (current behaviour) and restricted view (similar to umask=07).
> So, I propose to implement & call the options as follows:
> 
>     (no)safepid - instead of umask/mode; if it is on, only
> owner/root/special group may read /proc/PID.
> 
>     (no)hidepid - hide restricted /proc/PID from *stat*(2), getdents*()
> and similar.  Needs safepid.
> 
>     (no)hidenet - hide /proc/PID/net contents (restricting /proc/PID/net
> itself is a bit more difficult to implement).
> 
>     gid - group to evade safepid,hidepid,hidenet.
> 
> Also as hidepid needs safepid, maybe it makes sense to implement one
> option instead of safepid and hidepid: hidepid=X where:
> 
>  X = 0 means nohidepid,nosafepid above
>  X = 1 means safepid,nohidepid above
>  X = 2 means safepid,hidepid above

This makes sense to me, and I like the tri-state option better.

> On Sat, Jun 04, 2011 at 17:20 +0400, Solar Designer wrote:
> > A possible approach is to implement mount options gid=... and restricted
> > (name suggested by spender), where the latter would enable a hard-coded
> > set of permissions.
> 
> To what files?  All /proc/* files or recursively?  Is there a white list
> of o=r/o=rw files or all of them would be chmod'ed "o="?

Oh, that's not what I was referring to.  The restricted option would
essentially be the same as your hidepid=2 - enabling whatever grsecurity
normally does.  But having a tri-state option as you propose makes more
sense to me.

> > This is not generic, but at least it's simple, not
> > confusing, and it allows for future changes (we may change what exactly
> > restricted means).
> 
> Changing what some option means after implementing it is a ABI breakage,
> which is terrible for upstream.

This depends on how the option is defined initially.  It is possible to
define the option as "enabling unspecified version-dependent restrictions,
which are subject to change across kernel versions and builds". ;-)  OK,
the word "unspecified" may be dropped.

> > Ideally, I'd have umask apply to each instance of sysfs (and other
> > special filesystems) individually, affecting all files under that
> > instance
> 
> What instance?  All files (=kobjects) are global, there is almost no
> division among mount points.  The only division is among net namespaces,
> but it is mostly the exception than the rule and there will be always
> files global to all namespaces (e.g. modules list, devices list, etc.)
> 
> > (both those already existing in the kernel at the time of mount
> > and those appearing after mount).  But perhaps that's not how the kernel
> > keeps track of permissions for those filesystems currently?
> 
> I'd not change permissions of all currently existing files.  What would
> you do with already created and chmod'ed files?

The reality (kobjects being global) doesn't quite match my desired
behavior (being able to mount more than one instance of procfs, etc.
and set their mount options affecting perms differently).  However, this
is not important enough to warrant changing the reality. ;-)

Here's a related thought: if these mount options happen to affect all
instances of the filesystem (in the same container), maybe they should
be sysctl's instead?

Here's another thought: if the gid is not specified but hidepid is
enabled, maybe the perms should be 700 rather than 750 (don't grant any
privs to group root).

> And what you suggest is strictly speaking not "umask".  "umask" is for newly
> created files.  "mode" is almost everything judging by mount(8) :)

mount(8) mentions both "umask" and "mode" for different filesystems,
with slightly different semantics.

> Currently I have only one TODO in my list for procfs - restricted
> /proc/PID/net returns -EINVAL instead of -ENOENT as it is done in
> grsecurity :)  Need to make it say true.

Do you mean you have already implemented the mount options as you have
proposed above?

Thanks,

Alexander
