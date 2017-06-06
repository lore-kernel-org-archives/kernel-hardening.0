Date: Tue, 6 Jun 2017 23:55:34 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170606215534.GA13126@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] symlink/hardlink/FIFO restrictions
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

FWIW, I happened to compare the implementations of symlink and hardlink
restrictions in -ow patches vs. grsecurity vs. mainline.  Here are some
observations:

The symlink restrictions in -ow vs. grsecurity look similar to me, but
Kees' patches that eventually got merged upstream introduce an extra
limitation on when the restrictions (do not) apply.  In Kees' patches as
posted in here, it was the "bool sensitive" parameter to follow_link(),
which one of the calls set to false.  In upstream code, the check is now
only in the new trailing_symlink() function, which I guess is called in
similar cases.  As the name suggests, this probably means the symlink
restrictions are only applied to last ("trailing") symlinks in a chain
(and hopefully to symlinks on their own as well, without a chain).
I guess this was suggested at some point, perhaps with some rationale
given, but I didn't watch those many threads closely and missed it.
Why wouldn't a "nested" symlink be used for a successful attack?  The
attacker can then provide their own "trailing" symlink in a non-+t
directory pointing to the ultimate target.  But maybe I misunderstand
what is called "trailing" vs. "nested" in there?

The hardlink restrictions differ between -ow vs. grsecurity and upstream.
In -ow, I had the check in vfs_link().  In grsecurity (oldest I checked
now is grsecurity-2.1.11-2.4.35-200708071800), it's in sys_link() and
later in sys_linkat(), which is also called by sys_link().  Upstream
also has it right in the linkat() syscall function.  Maybe there were
good reasons not to do it in vfs_link(), but I am unaware of those.
We need to know what currently happens and what we'd like to happen for
other callers to vfs_link(), such as kernel nfsd and CRIU - do we want
the restrictions to apply there?  Maybe for some of those other callers,
but not for all?  Do the same checks work correctly when called from
those other contexts or do we need revised checks there?

As to the FIFO restrictions, those don't appear to have been merged
upstream yet.

There are probably many other subtle differences, but I thought I'd post
whatever I happened to notice now.

Alexander
