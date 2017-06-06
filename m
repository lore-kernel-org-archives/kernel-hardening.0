Date: Wed, 7 Jun 2017 00:57:39 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170606225739.GA14682@openwall.com>
References: <20170606215534.GA13126@openwall.com> <20170606221617.GA14451@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606221617.GA14451@openwall.com>
Subject: Re: [kernel-hardening] symlink/hardlink/FIFO restrictions
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 07, 2017 at 12:16:17AM +0200, Solar Designer wrote:
> So we're only protecting against bad symlinks for the last pathname
> component - not for upper directories in the path.  Indeed, for typical
> vulnerable programs it's the last pathname component that would be
> attacked, but I am not sure if it's always the case nor whether we
> needed this limitation in this security feature for some desirable uses.
> 
> Does this mean symlink attacks against not-yet-created directories like
> /tmp/.X11-unix (so perhaps during the system's bootup, maybe when it
> already started sshd but not yet X) are still possible even with the
> feature enabled?

Confirmed this by testing (with a dummy user-owned directory in /tmp).

I think this is actually fine, because we were not protecting against a
variation of those attacks anyway: where the attacker could have created
a non-+t directory of their own in place of /tmp/.X11-unix or the like.
Then symlinks placed in that directory wouldn't be protected anyway.

If we tried to protect against such "directory attacks", it'd be very
similar to the "no unsafe writes" policy (and maybe "no unsafe reads"
too) I mentioned in the thread about TPE here.  (Even though I admit
it's out of scope / off-topic for TPE.)

Alexander
