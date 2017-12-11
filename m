Date: Mon, 11 Dec 2017 16:33:31 +0100
From: Solar Designer <solar@openwall.com>
Message-ID: <20171211153331.GA22993@openwall.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com> <20171127011441.GA15063@openwall.com> <CAJHCu1+wC1BsW2r77aoibFth_qtjozKZFJTaD4xCuGBzHp2s4w@mail.gmail.com> <20171130190539.GA4360@openwall.com> <CAJHCu1JkNJxXHXgrYLMA3Z9V_ekUCb370eG0WCUattR3AzBquA@mail.gmail.com> <20171207222334.GA8632@openwall.com> <20171208121719.GA10889@openwall.com> <CAJHCu1LEF1cToDrqSh8tvZ3QG0d-0pm+VcrxqMZ8y-CvuhnAyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHCu1LEF1cToDrqSh8tvZ3QG0d-0pm+VcrxqMZ8y-CvuhnAyg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 0/2] Restrict dangerous open in sticky directories
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Matthew Wilcox <willy@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 11, 2017 at 01:07:36PM +0100, Salvatore Mesoraca wrote:
> 2017-12-08 13:17 GMT+01:00 Solar Designer <solar@openwall.com>:
> > On Thu, Dec 07, 2017 at 11:23:34PM +0100, Solar Designer wrote:
> > > On Tue, Dec 05, 2017 at 11:13:50AM +0100, Salvatore Mesoraca wrote:
> > > > 2017-11-30 20:05 GMT+01:00 Solar Designer <solar@openwall.com>:
> > > > > So the current name is "protected_sticky_child_create" (I couldn't even
> > > > > recall it, had to look it up for this reply).  This unnecessarily
> > > > > bundles this potentially more general policy stuff with the existing
> > > > > "protections" against specific attacks, unnecessarily limits scope to
> > > > > "sticky" and "create", and talks about some "child".  How about we use
> > > > > something totally different, focusing on "policy"?  It could be simply
> > > > > "policy" (we're already in "fs"), or if that won't fly then how about
> > > > > "security_policy" or "dac_policy"?  We will be imposing extra
> > > > > restrictions on top of usual Unix discretionary access control
> > > > > permission bits while not going all the way to mandatory access control
> > > > > (not tying objects to subjects).  So in a sense we'll have an extension
> > > > > of Unix DAC.
> > > >
> > > > Yea, I like "dac_policy" very much.
> > >
> > > OK.  Thinking of this further, what we might want to have is a generic
> > > policy against file accesses that would negate a privilege boundary
> > > between Unix (pseudo-)users.  And one of those would be execve(2) of a
> > > file writable by someone else, or with any of its parent directories
> > > writable by someone else (unless that's root, indeed).
> 
> This looks similar to what grsecurity calls TPE,

Related, but not very similar.  The goal is almost the opposite.

TPE aims to prevent the user from bringing and running their own (and
other non-root users') binaries, so it restricts the invoking user.

[ FWIW, it's restrictive tendencies like this that led to the name
Openwall at the time when TPE was new (it was already called that in a
1998 Phrack article, pre-dating grsecurity), meaning we'd focus on
security without restricting the user's reasonable use of the system.
In late 1990s and early 2000s, it almost looked like e.g. shared web
hosting providers would forbid convenient and full Unix shell access
(while nevertheless allowing PHP script uploads, etc.)  Some did.
But then this trend reversed. ]

The potential inclusion of execve(2) in our safety policy would prevent
the user from invoking binaries that are under another non-root user's
control.

So the similarity to TPE is that either policy would allow invoking
binaries that are part of the system.  The difference, roughly speaking,
is that TPE would disallow the user's own binaries whereas we would
disallow only someone else's binaries.

> I think that there is
> already some ongoing work to port it upstream as an LSM.

Yes, this was discussed in here and I criticized it, but not CC'ing LKML
not to obstruct that effort.

> I don't know
> if it's still under development, I didn't heard about it in a while.

I also don't know what its current status is.

> Actually what you are proposing here is a bit different, because it will
> never prevent the user from running its own executables,

Exactly.

> so its usefulness
> isn't completely defeated by language interpreters etc. Still, scripts that
> are directly "sourced" will escape this protection, but at least we'll
> cover many other cases.

We should indeed consider the limitations of our approach, but I think
without reference to TPE (and its bypasses) as TPE's goal is different.

For scripts that are directly "sourced", we could have a policy on
open(2), where I suggested optionally including even O_RDONLY.  There's
no fundamental difference between (interpreted) code and data input to a
program - either may control that program.  This is why merely reading a
file under someone else's control is a risk.

However, as I suggested so far, for open(2) we'd only potentially
restrict file access in unsafe directories (eventually including their
chain of parent directories).  To deal with the risk of someone
"sourcing" a script or reading a crucial configuration file directly
writable by someone else, yet located in a safe directory, we'd have to
extend those restrictions to target file permissions, like I suggested
we do for execve(2).  Unfortunately, this will probably cover many more
reasonable and safe uses (where the program reading either knows to
distrust the file contents or deliberately trusts whoever else can write
the file).  So if we go for this policy extension at all (perhaps for
special-purpose/embedded distros that are developed to meet the
policy?), we should probably have a separate bit to control it.

> We should add a restriction on executable mmaps, too.

We're focusing on accesses via pathnames, and that would be a
restriction on what can be done on an open fd (what file permissions
would we use? as of when?)  It'd make some sense if we were to add
restrictions on open(2) of files with unsafe permissions (on the file
itself, not the directories), as I mentioned in the paragraph above.
Then it'd allow us to make that restriction more fine-grained: apply it
separately to shared libraries and such vs. arbitrary other files.  But
it's tricky.  So while we may have it in mind and not rule it out with
the interface we design now, it's not something we should decide on now.

Another drawback of these policy extensions (including some from my
previous message) is that we'd be getting into restricting the user (not
our goal) rather than just preventing the user from doing things
unsafely yet having a (preferably safe) way to achieve their goal (this
is our goal).  Sometimes a user will deliberately share a file with
another user, and the other user should ideally have a way to read that
file, even if by knowingly accepting a risk (although that's not ideal).

This makes me sad, but I don't have a good suggestion except to ensure
we're not forcing a sysadmin to enable these parts of the policy along
with those parts that do not have such unfortunate user-restrictive
properties.  So this should affect our decisions on the grouping of
potential policy bits.

> > > I think the name
> > > "dac_policy" still fits this well, but anything with "create" or even
> > > "open" in the name would not fit it.
> > >
> > > Another way of looking at this is that we'd be creating a reverse DAC -
> > > optionally blocking unsafe accesses made possible by too permissive DAC.
> > > But I don't have a good sysctl name suggestion along these lines.
> >
> > Yet another thought is that while we won't go for MAC ("not tying
> > objects to subjects") in our additional policy against unsafe file
> > accesses, it could reasonably be extended to cover not only accesses
> > made possible by too permissive DAC, but also those made possible by too
> > permissive ACLs.  I doubt we'd want to actually add ACL support in
> > there (too obscure, unnecessary when auditing software), but if someone
> > eventually does that would fit in with our general approach (and
> > wouldn't even require separate flags, as it's conceptually similar to
> > group-writable).
> 
> I'm not sure if I understood what you meant, but the "group-writable" check
> implicitly checks for permissive ACLs, because they force the group bits on.

Are you referring to how ACLs are currently implemented in the kernel?
I'm not familiar with that.  If you like and have time, you might want
to illustrate your point by a code snippet (if I understood you right,
that would be code already in the kernel), although I think it's not
essential to the rest of this discussion now (we should prefer sysctl
names not conflicting with this potential goal either way).

> > So an ideal name would not conflict with that.
> >
> > What would be a good short name for "file access safety policy"?  Maybe
> > we can omit "file" considering we're in "fs".  "access_safety_policy"?
> >
> > The individual flags might correspond to detecting and/or blocking:
> >
> > O_CREAT w/o O_EXCL in +t world-writable directory except if file exists
> > and is owned by root or by current fsuid and the directory owner is root
> > or current fsuid
> >
> > O_CREAT w/o O_EXCL in +t group-writable directory except if file exists
> > and is owned by root or by current fsuid and the directory owner is root
> > or current fsuid, or O_CREAT w/o O_EXCL in +t directory owned by another
> > non-root user (regardless of whether the file exists and its ownership)
> >
> > (Note: the "+t directory owned by another non-root user" case is for
> > consistency and for software testing only, not for enforcing a policy
> > like this in production, because the directory owner can remove the +t.)
> >
> > O_CREAT w/o O_EXCL in -t world-writable directory (no exceptions)
> >
> > O_CREAT w/o O_EXCL in -t group-writable directory (no exceptions), or
> > O_CREAT w/o O_EXCL in any directory owned by another non-root user
> > (regardless of the sticky bit, and also without exceptions)
> >
> > Same as above for O_WRONLY or O_RDWR, so 4 more flags.
> >
> > Same as above for O_RDONLY, so 4 more flags.
> >
> > Other unsafe file accesses via pathname, including execve(2) (would
> > consider permissions on the file itself, as well as the directory),
> 
> I'll use the same bit used to restrict execve to restrict also
> executable mmaps.
> What do you think?

I think we're not ready to discuss that.

execve(2) itself more obviously fits in with what we were discussing so
far because of relevance of directory permissions and because of access
via pathname in this very syscall.

> > chmod(2), chown(2).  That's maybe 6 more flags if we continue to
> > separate world vs. group/user, even if we don't separate by +t (but we
> > could nevertheless trust a pre-existing file in +t under the same
> > conditions listed for "O_CREAT w/o O_EXCL in +t").
> >
> > Then we could want to eventually add checking of all parent directories,
> > and this in turn would make more syscalls relevant (in the sense of
> > being usable for an immediate attack on the invoking user, making them
> > do something unintended) in the special case when an upper level
> > directory is unsafe: symlink(2), link(2), unlink(2), rename(2),
> > mkdir(2), rmdir(2), perhaps more.  Just for these 6 I quickly
> > identified, and if we continue to separate world vs. group/user, this
> > could be 12 more flags.
> >
> > So this would be 4+4+6+12 = 26 flags already.  This feels like way too
> > many, as well as not leaving enough bits e.g. in a 32-bit mask in case
> > we end up identifying many more relevant syscalls.  So perhaps the
> > approach above is too fine-grained and should be revised.  If so, maybe
> > our start with two bits for "O_CREAT w/o O_EXCL in +t" is already too
> > fine-grained and should be revised as well.
> >
> > What do you think?
> >
> > How to group these categories in fewer flags best?  Perhaps less
> > separation of the open(2) flags and/or of the syscalls relevant only
> > with unsafe upper-level directories (one flag for all of them?)
> >
> > Drop the +t / -t separation for open(2)?  (But nevertheless trust a
> > pre-existing file in +t under the same conditions as I listed for
> > "O_CREAT w/o O_EXCL in +t".)
> >
> > Drop the world vs. group/user separation?
> >
> > Introduce more sysctl's - separate for open(2) vs. other syscalls?
> >
> > And/or maybe separate for world vs. group/user-writable?  This would be
> > convenient in that the same bit positions would refer to the same
> > open(2) modes in the same directory categories, or the same syscalls.
> > Extending a previously tested policy for world-writable to cover also
> > group/user-writable would be as simple as setting the other sysctl to
> > the same value.
> >
> > Any other ideas?
> 
> I'd group some of those restrictions to be controlled by the same bit,
> something like:
>  - open(2)

I think at least writes vs. reads are very different.

>  - execve(2), mmap(2)
>  - chmod(2), chown(2)
>  - mkdir(2), rmdir(2)
>  - symlink(2), link(2), unlink(2), rename(2)

Maybe, perhaps except for mmap(2).

> And I'd use the same bitmasks in the following sysctls:
>  - access_control_policy
>  - access_control_policy_notify
>  - access_control_policy_group
>  - access_control_policy_group_notify

Our policy is not about access control - it is about access safety.
(It's the same confusion with the comparison to TPE again.  We should
actually try and avoid getting into the access control territory here.)

Also, in your list "access_control_policy" feels like it's the main
thing, whereas actually it's just one of the four (for world-writable
directories, right?)

We need something like:

safety_world_enforce
safety_world_notify
safety_group_enforce
safety_group_notify

but I'm afraid these are not self-explanatory at all.

> What do you think?

This will probably need even further discussion, implementation, some
usage experience, then changes or maybe even a redesign before we
possibly propose it for inclusion upstream.  For now, we're just
thinking out loud, and appear unready to propose anything upstream.

As discussed previously, you should nevertheless submit the FIFO and
regular file protections in +t as a separate patch.

> Anyway, given that the scope of this feature is growing bigger and bigger,
> should it be reimplemented as an LSM?

I had this thought, too.  I think we should consider possible races (are
there races that would apply in an LSM but would be avoided in a patch?),
maintenance (which implementation would likely be better maintained?),
and easy availability (so that e.g. someone developing software on e.g.
Ubuntu could easily partially turn this on temporarily, even if Ubuntu
itself does not fully conform to the policy and thus wouldn't normally
ship with these features - and would likely not include an LSM then?)

Alexander
