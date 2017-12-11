MIME-Version: 1.0
In-Reply-To: <20171208121719.GA10889@openwall.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
 <20171127011441.GA15063@openwall.com> <CAJHCu1+wC1BsW2r77aoibFth_qtjozKZFJTaD4xCuGBzHp2s4w@mail.gmail.com>
 <20171130190539.GA4360@openwall.com> <CAJHCu1JkNJxXHXgrYLMA3Z9V_ekUCb370eG0WCUattR3AzBquA@mail.gmail.com>
 <20171207222334.GA8632@openwall.com> <20171208121719.GA10889@openwall.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Mon, 11 Dec 2017 13:07:36 +0100
Message-ID: <CAJHCu1LEF1cToDrqSh8tvZ3QG0d-0pm+VcrxqMZ8y-CvuhnAyg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 0/2] Restrict dangerous open in sticky directories
To: Solar Designer <solar@openwall.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Matthew Wilcox <willy@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

2017-12-08 13:17 GMT+01:00 Solar Designer <solar@openwall.com>:
> On Thu, Dec 07, 2017 at 11:23:34PM +0100, Solar Designer wrote:
> > On Tue, Dec 05, 2017 at 11:13:50AM +0100, Salvatore Mesoraca wrote:
> > > 2017-11-30 20:05 GMT+01:00 Solar Designer <solar@openwall.com>:
> > > > So the current name is "protected_sticky_child_create" (I couldn't even
> > > > recall it, had to look it up for this reply).  This unnecessarily
> > > > bundles this potentially more general policy stuff with the existing
> > > > "protections" against specific attacks, unnecessarily limits scope to
> > > > "sticky" and "create", and talks about some "child".  How about we use
> > > > something totally different, focusing on "policy"?  It could be simply
> > > > "policy" (we're already in "fs"), or if that won't fly then how about
> > > > "security_policy" or "dac_policy"?  We will be imposing extra
> > > > restrictions on top of usual Unix discretionary access control
> > > > permission bits while not going all the way to mandatory access control
> > > > (not tying objects to subjects).  So in a sense we'll have an extension
> > > > of Unix DAC.
> > >
> > > Yea, I like "dac_policy" very much.
> >
> > OK.  Thinking of this further, what we might want to have is a generic
> > policy against file accesses that would negate a privilege boundary
> > between Unix (pseudo-)users.  And one of those would be execve(2) of a
> > file writable by someone else, or with any of its parent directories
> > writable by someone else (unless that's root, indeed).

This looks similar to what grsecurity calls TPE, I think that there is
already some ongoing work to port it upstream as an LSM. I don't know
if it's still under development, I didn't heard about it in a while.
Actually what you are proposing here is a bit different, because it will
never prevent the user from running its own executables, so its usefulness
isn't completely defeated by language interpreters etc. Still, scripts that
are directly "sourced" will escape this protection, but at least we'll
cover many other cases.
We should add a restriction on executable mmaps, too.

> > I think the name
> > "dac_policy" still fits this well, but anything with "create" or even
> > "open" in the name would not fit it.
> >
> > Another way of looking at this is that we'd be creating a reverse DAC -
> > optionally blocking unsafe accesses made possible by too permissive DAC.
> > But I don't have a good sysctl name suggestion along these lines.
>
> Yet another thought is that while we won't go for MAC ("not tying
> objects to subjects") in our additional policy against unsafe file
> accesses, it could reasonably be extended to cover not only accesses
> made possible by too permissive DAC, but also those made possible by too
> permissive ACLs.  I doubt we'd want to actually add ACL support in
> there (too obscure, unnecessary when auditing software), but if someone
> eventually does that would fit in with our general approach (and
> wouldn't even require separate flags, as it's conceptually similar to
> group-writable).

I'm not sure if I understood what you meant, but the "group-writable" check
implicitly checks for permissive ACLs, because they force the group bits on.

> So an ideal name would not conflict with that.
>
> What would be a good short name for "file access safety policy"?  Maybe
> we can omit "file" considering we're in "fs".  "access_safety_policy"?
>
> The individual flags might correspond to detecting and/or blocking:
>
> O_CREAT w/o O_EXCL in +t world-writable directory except if file exists
> and is owned by root or by current fsuid and the directory owner is root
> or current fsuid
>
> O_CREAT w/o O_EXCL in +t group-writable directory except if file exists
> and is owned by root or by current fsuid and the directory owner is root
> or current fsuid, or O_CREAT w/o O_EXCL in +t directory owned by another
> non-root user (regardless of whether the file exists and its ownership)
>
> (Note: the "+t directory owned by another non-root user" case is for
> consistency and for software testing only, not for enforcing a policy
> like this in production, because the directory owner can remove the +t.)
>
> O_CREAT w/o O_EXCL in -t world-writable directory (no exceptions)
>
> O_CREAT w/o O_EXCL in -t group-writable directory (no exceptions), or
> O_CREAT w/o O_EXCL in any directory owned by another non-root user
> (regardless of the sticky bit, and also without exceptions)
>
> Same as above for O_WRONLY or O_RDWR, so 4 more flags.
>
> Same as above for O_RDONLY, so 4 more flags.
>
> Other unsafe file accesses via pathname, including execve(2) (would
> consider permissions on the file itself, as well as the directory),

I'll use the same bit used to restrict execve to restrict also
executable mmaps.
What do you think?

> chmod(2), chown(2).  That's maybe 6 more flags if we continue to
> separate world vs. group/user, even if we don't separate by +t (but we
> could nevertheless trust a pre-existing file in +t under the same
> conditions listed for "O_CREAT w/o O_EXCL in +t").
>
> Then we could want to eventually add checking of all parent directories,
> and this in turn would make more syscalls relevant (in the sense of
> being usable for an immediate attack on the invoking user, making them
> do something unintended) in the special case when an upper level
> directory is unsafe: symlink(2), link(2), unlink(2), rename(2),
> mkdir(2), rmdir(2), perhaps more.  Just for these 6 I quickly
> identified, and if we continue to separate world vs. group/user, this
> could be 12 more flags.
>
> So this would be 4+4+6+12 = 26 flags already.  This feels like way too
> many, as well as not leaving enough bits e.g. in a 32-bit mask in case
> we end up identifying many more relevant syscalls.  So perhaps the
> approach above is too fine-grained and should be revised.  If so, maybe
> our start with two bits for "O_CREAT w/o O_EXCL in +t" is already too
> fine-grained and should be revised as well.
>
> What do you think?
>
> How to group these categories in fewer flags best?  Perhaps less
> separation of the open(2) flags and/or of the syscalls relevant only
> with unsafe upper-level directories (one flag for all of them?)
>
> Drop the +t / -t separation for open(2)?  (But nevertheless trust a
> pre-existing file in +t under the same conditions as I listed for
> "O_CREAT w/o O_EXCL in +t".)
>
> Drop the world vs. group/user separation?
>
> Introduce more sysctl's - separate for open(2) vs. other syscalls?
>
> And/or maybe separate for world vs. group/user-writable?  This would be
> convenient in that the same bit positions would refer to the same
> open(2) modes in the same directory categories, or the same syscalls.
> Extending a previously tested policy for world-writable to cover also
> group/user-writable would be as simple as setting the other sysctl to
> the same value.
>
> Any other ideas?

I'd group some of those restrictions to be controlled by the same bit,
something like:
 - open(2)
 - execve(2), mmap(2)
 - chmod(2), chown(2)
 - mkdir(2), rmdir(2)
 - symlink(2), link(2), unlink(2), rename(2)

And I'd use the same bitmasks in the following sysctls:
 - access_control_policy
 - access_control_policy_notify
 - access_control_policy_group
 - access_control_policy_group_notify

If those names are too long we could change "access_control" to just "ac".

What do you think?

Anyway, given that the scope of this feature is growing bigger and bigger,
should it be reimplemented as an LSM?

Salvatore
