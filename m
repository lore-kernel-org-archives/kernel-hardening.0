Date: Thu, 30 Nov 2017 20:05:39 +0100
From: Solar Designer <solar@openwall.com>
Message-ID: <20171130190539.GA4360@openwall.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com> <20171127011441.GA15063@openwall.com> <CAJHCu1+wC1BsW2r77aoibFth_qtjozKZFJTaD4xCuGBzHp2s4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHCu1+wC1BsW2r77aoibFth_qtjozKZFJTaD4xCuGBzHp2s4w@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 0/2] Restrict dangerous open in sticky directories
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 30, 2017 at 03:37:29PM +0100, Salvatore Mesoraca wrote:
> 2017-11-27 2:14 GMT+01:00 Solar Designer <solar@openwall.com>:
> > When I suggested the O_CREAT-without-O_EXCL checks, I didn't mean you'd
> > try to introduce them at the same time with the restrictions on FIFOs
> > and regular files.  I think that bundling these together might be a
> > recipe for never getting any of them in, or for getting in the latter
> > with unnecessarily limited scope.
> 
> Yes, I think you are right. I'll split them.

Thanks.

> > I think we need an optional policy
> > against O_CREAT-without-O_EXCL not only for sticky directories, but also
> > for other directories writable by other than the current fsuid - there
> > may be several levels or individual flags here.
> >
> > So maybe unbundle these or at least avoid forever limiting them to
> > sticky directories (don't include "sticky" in the sysctl name).
> 
> Actually I never liked that sysctl name :) I'll try to come up with something
> less ugly and that doesn't include the "sticky" word.

So the current name is "protected_sticky_child_create" (I couldn't even
recall it, had to look it up for this reply).  This unnecessarily
bundles this potentially more general policy stuff with the existing
"protections" against specific attacks, unnecessarily limits scope to
"sticky" and "create", and talks about some "child".  How about we use
something totally different, focusing on "policy"?  It could be simply
"policy" (we're already in "fs"), or if that won't fly then how about
"security_policy" or "dac_policy"?  We will be imposing extra
restrictions on top of usual Unix discretionary access control
permission bits while not going all the way to mandatory access control
(not tying objects to subjects).  So in a sense we'll have an extension
of Unix DAC.

BTW, this and all of fs.protected* should be configurable per-container.

> If I implement something like what Matthew proposed[1] it will be easy to
> extend scope and functionalities of this feature without complicating too much
> the interface.

> [1] https://lkml.org/lkml/2017/11/22/319

Right.  I tried thinking of a way to specify all reasonable combinations
without the likely unreasonable ones, but couldn't come up with anything
elegant.  So I'm fine with Matthew's proposal as-is.

A new thought: a directory that has someone else as its owner is for our
purposes effectively the same as a group-writable directory.  So maybe
whatever we'll implement for group-writable directories should also be
done for directories that have other than the current fsuid as their
owner.  It's currently very uncommon to have directories with the sticky
bit set that are not at least group-writable, so this will rarely make a
difference (and when it does, that's just right), but also it provides a
way to explicitly include any directory under this monitoring (if the
group-writable protection is on) - e.g., if a sysadmin wants this
monitoring for users' home directories, they can change permissions for
those from e.g. 700 to 1700.  This could be handy for development and
auditing of software, even though in production it could be easily
circumvented by the directory owner (who can remove the sticky bit,
which we should document to avoid providing a false sense of security)
and it won't automatically apply to subdirectories.  It'd also cover
part of what we intend to achieve later by possibly extending the
feature to non-sticky directories, where we might also want to treat
different owner the same as group-writable (without the circumvention).

> > Meanwhile, here's a scenario where I think the FIFO restrictions are
> > most obviously still worthwhile: attacks on system bootup scripts, where
> > the attacker would plant a FIFO on a persistent /tmp or the like and the
> > system would access it on next bootup.  The attacker's exploit program
> > would not yet be running during the bootup, so it wouldn't be able to
> > even try winning a race, but a FIFO would be able to keep the vulnerable
> > service (or its startup script, etc.) stuck until the attacker has
> > access again.  On the other hand, /tmp is commonly on tmpfs these days,
> > whereas some other shared writable directories (not necessarily world
> > writable and not necessarily sticky) are persistent (mail and cron job
> > spools, preformatted man page cache, etc.)  So maybe this, too, is a
> > reason to eventually extend these protections beyond sticky directories
> > (of course, only as an option).  We shouldn't using naming that would be
> > against such extension, or/and we shouldn't think of the
> > O_CREAT-without-O_EXCL checks as permanently only for extra detection
> > and reporting - they may also prevent more attacks if we eventually
> > extend them to non-sticky, but not (yet) similarly extent the file type
> > specific protections.
> 
> So, are you suggesting that I should extend "O_CREAT-without-O_EXCL"
> and "FIFOs restrictions" to work (optionally) on non-sticky directories too,
> while leaving untouched (for the moment) "normal files restrictions"?

No, I think all of these and the existing symlink restrictions should
potentially be extended "to work (optionally) on non-sticky directories
too", but perhaps with separate patches later.

An even further extension may be to cover non-O_CREAT: writing or/and
reading an existing file in an untrusted directory is also potentially
unsafe.  Unfortunately, we can't reliably know whether the program
possibly takes precautions by using lstat() and fstat() and comparing
st_dev/st_ino, so we won't be able to distinguish likely unsafe and
likely mostly safe accesses, but we'll be able to flag all of them for
manual analysis on a developer's or an auditor's system.  A reasonable
strict policy one might want to follow is to have all accesses done as
the right fsuid, without needing those unreliable st_dev/st_ino checks.
(They're unreliable because of potential side-effects on open() and
inode reuse.)  For example, we chose this strict policy in Openwall's
"tcb suite" and shadow suite patches: http://www.openwall.com/tcb/

Of course, then there's the question on whether something exotic(?) like
this should be in the kernel.

To me, it's like a "gcc -Wall" for filesystem accesses.  Sure it can
"falsely" detect many technically valid uses, but it's also helpful to
improve our filesystem access safety.

Alexander
