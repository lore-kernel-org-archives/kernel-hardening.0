Date: Thu, 7 Dec 2017 23:23:34 +0100
From: Solar Designer <solar@openwall.com>
Message-ID: <20171207222334.GA8632@openwall.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com> <20171127011441.GA15063@openwall.com> <CAJHCu1+wC1BsW2r77aoibFth_qtjozKZFJTaD4xCuGBzHp2s4w@mail.gmail.com> <20171130190539.GA4360@openwall.com> <CAJHCu1JkNJxXHXgrYLMA3Z9V_ekUCb370eG0WCUattR3AzBquA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHCu1JkNJxXHXgrYLMA3Z9V_ekUCb370eG0WCUattR3AzBquA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 0/2] Restrict dangerous open in sticky directories
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Matthew Wilcox <willy@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

CC: Matthew Wilcox

On Tue, Dec 05, 2017 at 11:13:50AM +0100, Salvatore Mesoraca wrote:
> 2017-11-30 20:05 GMT+01:00 Solar Designer <solar@openwall.com>:
> > So the current name is "protected_sticky_child_create" (I couldn't even
> > recall it, had to look it up for this reply).  This unnecessarily
> > bundles this potentially more general policy stuff with the existing
> > "protections" against specific attacks, unnecessarily limits scope to
> > "sticky" and "create", and talks about some "child".  How about we use
> > something totally different, focusing on "policy"?  It could be simply
> > "policy" (we're already in "fs"), or if that won't fly then how about
> > "security_policy" or "dac_policy"?  We will be imposing extra
> > restrictions on top of usual Unix discretionary access control
> > permission bits while not going all the way to mandatory access control
> > (not tying objects to subjects).  So in a sense we'll have an extension
> > of Unix DAC.
> 
> Yea, I like "dac_policy" very much.

OK.  Thinking of this further, what we might want to have is a generic
policy against file accesses that would negate a privilege boundary
between Unix (pseudo-)users.  And one of those would be execve(2) of a
file writable by someone else, or with any of its parent directories
writable by someone else (unless that's root, indeed).  I think the name
"dac_policy" still fits this well, but anything with "create" or even
"open" in the name would not fit it.

Another way of looking at this is that we'd be creating a reverse DAC -
optionally blocking unsafe accesses made possible by too permissive DAC.
But I don't have a good sysctl name suggestion along these lines.

> > BTW, this and all of fs.protected* should be configurable per-container.
> 
> This would be a nice thing to do in the future.

OK.

> > > If I implement something like what Matthew proposed[1] it will be easy to
> > > extend scope and functionalities of this feature without complicating too much
> > > the interface.
> >
> > > [1] https://lkml.org/lkml/2017/11/22/319
> >
> > Right.  I tried thinking of a way to specify all reasonable combinations
> > without the likely unreasonable ones, but couldn't come up with anything
> > elegant.  So I'm fine with Matthew's proposal as-is.
> 
> Great.

Thinking of this further, maybe it'd be friendlier to further expansion
if we separate the policy and notify vs. block into two bitmasks, in
separate sysctl's.  If a sysadmin wants only notifications or only
blocking, that would then be easier to achieve, by setting the notify
vs. block sysctl to 0 or to all 1's (to -1 maybe, although this would
give the wrong impression of being "below 0").  Then the sysadmin would
be able to focus on the actual policy bits separately, without the
distraction of the notify vs. block bits inbetween.

The names could then be "dac_policy" and "dac_policy_enforce" maybe?
Any other suggestions?

BTW, if we negate the integers corresponding to these, then two 1's
would mean full enforcement of the strictest policy, and negative
bitmask values could be used to specify fine-grained policy and/or
enforcement.  Good idea or too unusual/confusing?  I'm afraid it is
indeed confusing.  dac_policy_enforce=1 meaning full enforcement makes
more sense to me, but negating only one of these two integers would also
be confusing.  So we probably shouldn't do any of this.  I just thought
I'd share the idea anyway.

> > A new thought: a directory that has someone else as its owner is for our
> > purposes effectively the same as a group-writable directory.  So maybe
> > whatever we'll implement for group-writable directories should also be
> > done for directories that have other than the current fsuid as their
> > owner. It's currently very uncommon to have directories with the sticky
> > bit set that are not at least group-writable, so this will rarely make a
> > difference (and when it does, that's just right), but also it provides a
> > way to explicitly include any dibrectory under this monitoring (if the
> > group-writable protection is on) - e.g., if a sysadmin wants this
> > monitoring for users' home directories, they can change permissions for
> > those from e.g. 700 to 1700.  This could be handy for development and
> > auditing of software, even though in production it could be easily
> > circumvented by the directory owner (who can remove the sticky bit,
> > which we should document to avoid providing a false sense of security)
> > and it won't automatically apply to subdirectories.  It'd also cover
> > part of what we intend to achieve later by possibly extending the
> > feature to non-sticky directories, where we might also want to treat
> > different owner the same as group-writable (without the circumvention).
> 
> Agreed. I'll extend it to also check for the directory owner.
> Maybe I could use another bit and make this additional restriction
> independent from the "group-writable" one.

I'd prefer not to waste a bit on this.  We'll need plenty of bits later
on, perhaps also in pairs or (with your suggestion to separate this one)
in triplets, and every extra bit complicates the calculation of the
bitmask value.

> > > So, are you suggesting that I should extend "O_CREAT-without-O_EXCL"
> > > and "FIFOs restrictions" to work (optionally) on non-sticky directories too,
> > > while leaving untouched (for the moment) "normal files restrictions"?
> >
> > No, I think all of these and the existing symlink restrictions should
> > potentially be extended "to work (optionally) on non-sticky directories
> > too", but perhaps with separate patches later.
> 
> OK.
> 
> > An even further extension may be to cover non-O_CREAT: writing or/and
> > reading an existing file in an untrusted directory is also potentially
> > unsafe.  Unfortunately, we can't reliably know whether the program
> > possibly takes precautions by using lstat() and fstat() and comparing
> > st_dev/st_ino, so we won't be able to distinguish likely unsafe and
> > likely mostly safe accesses, but we'll be able to flag all of them for
> > manual analysis on a developer's or an auditor's system.  A reasonable
> > strict policy one might want to follow is to have all accesses done as
> > the right fsuid, without needing those unreliable st_dev/st_ino checks.
> > (They're unreliable because of potential side-effects on open() and
> > inode reuse.)  For example, we chose this strict policy in Openwall's
> > "tcb suite" and shadow suite patches: http://www.openwall.com/tcb/
> >
> > Of course, then there's the question on whether something exotic(?) like
> > this should be in the kernel.
> >
> > To me, it's like a "gcc -Wall" for filesystem accesses.  Sure it can
> > "falsely" detect many technically valid uses, but it's also helpful to
> > improve our filesystem access safety.
> 
> Yes, this could be a useful improvement for the future.
> 
> Salvatore

Alexander
