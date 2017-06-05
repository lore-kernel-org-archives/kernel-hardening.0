Date: Mon, 5 Jun 2017 17:23:28 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170605152327.GA4174@openwall.com>
References: <20170603055351.16080-1-matt@nmatt.com> <20170603154707.GA19161@openwall.com> <f260f3fd-7fb7-7354-0830-204336004aca@nmatt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f260f3fd-7fb7-7354-0830-204336004aca@nmatt.com>
Subject: Re: [kernel-hardening] [PATCH v1 1/1] Add Trusted Path Execution as a stackable LSM
To: Matt Brown <matt@nmatt.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 05, 2017 at 10:41:30AM -0400, Matt Brown wrote:
> On 6/3/17 11:47 AM, Solar Designer wrote:
> > On Sat, Jun 03, 2017 at 01:53:51AM -0400, Matt Brown wrote:
> >> 2. Attacker on system replaces binary used by a privileged user with a
> >>    malicious one
> >>
> >> *  This situation arises when administrator of a system leaves a binary
> >>    as world writable.
> >>
> >> *  TPE is very effective against this threat model
> > 
> > This makes more sense to me.  It's known-bypassable policy enforcement
> > by the sysadmin against one's own human error and such.  However, for
> > this to be effective the exception "NOTE: root is never restricted by
> > TPE" should be removed or made an option.
> 
> OK so a sysctl, kernel.tpe.restrict_root, that toggles if root is also
> restricted?

Maybe.  Up to you and others.  I really don't intend to discuss this in
detail.  I merely pointed out what I knew and had thought of before wrt
TPE and related functionality.

> > In a similar spirit, it'd also make sense to have a policy disallowing
> > at least root to write into directories writable by other users without
> > setting the O_EXCL flag.  I actually had this in a kernel module, which
> > I used to find issues of this kind in Postfix in 2006 or so (Wietse
> > promptly patched those), but I didn't try running this in production.
> 
> Could you expand on what you think the threat model is for root not
> writing into directories writable by other users? symlink issues?

Mostly yes, but also hard links, and attacks on logic of the programs
themselves via FIFOs and even pre-created regular files (e.g., create a
mode 666 file where the program would write some of its own data and
then read it back - e.g., a queued message - and then you can modify
that data even if the file's permissions as normally created by the
program wouldn't have allowed that and e.g. the directory's sticky bit
wouldn't have allowed replacing the file).  Some of this overlaps with
the usual symlink-in-+t and hard-link-to-non-owned-files restrictions,
some of it is separate/additional (e.g., mostly not limited to +t
directories and mostly intended to find and fix policy violations rather
than to provide hardening on production systems).  It's non-obvious
whether this is more closely related to TPE (certainly not as it relates
to its more usual threat model 1 from your original message) or possibly
to the link restrictions, or is separate (as I had it for my testing).

> > Summary: I see little value in TPE, but I don't intend to argue against
> > it any further (and I deliberately dropped the CC list on this reply,
> > not to hamper your efforts much).  If you choose to proceed with trying
> > to upstream it anyway, I suggest the above changes to the description of
> > the threat models and the tiny code change to allow for restricting root
> > as well.

Alexander
