Date: Wed, 7 Jun 2017 00:16:17 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170606221617.GA14451@openwall.com>
References: <20170606215534.GA13126@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606215534.GA13126@openwall.com>
Subject: Re: [kernel-hardening] symlink/hardlink/FIFO restrictions
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 11:55:34PM +0200, Solar Designer wrote:
> The symlink restrictions in -ow vs. grsecurity look similar to me, but
> Kees' patches that eventually got merged upstream introduce an extra
> limitation on when the restrictions (do not) apply.  In Kees' patches as
> posted in here, it was the "bool sensitive" parameter to follow_link(),
> which one of the calls set to false.  In upstream code, the check is now
> only in the new trailing_symlink() function, which I guess is called in
> similar cases.  As the name suggests, this probably means the symlink
> restrictions are only applied to last ("trailing") symlinks in a chain
> (and hopefully to symlinks on their own as well, without a chain).
> I guess this was suggested at some point, perhaps with some rationale
> given, but I didn't watch those many threads closely and missed it.
> Why wouldn't a "nested" symlink be used for a successful attack?  The
> attacker can then provide their own "trailing" symlink in a non-+t
> directory pointing to the ultimate target.  But maybe I misunderstand
> what is called "trailing" vs. "nested" in there?

I spoke too soon - should read code rather than derive meaning from
names.  Looks like it's nested vs. trailing components in a pathname.
So we're only protecting against bad symlinks for the last pathname
component - not for upper directories in the path.  Indeed, for typical
vulnerable programs it's the last pathname component that would be
attacked, but I am not sure if it's always the case nor whether we
needed this limitation in this security feature for some desirable uses.

Does this mean symlink attacks against not-yet-created directories like
/tmp/.X11-unix (so perhaps during the system's bootup, maybe when it
already started sshd but not yet X) are still possible even with the
feature enabled?

Alexander
