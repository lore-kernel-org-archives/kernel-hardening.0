Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 16 Dec 2016 04:49:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161216124913.GB31485@kroah.com>
References: <20161214185000.GA3930@kroah.com>
 <87k2b0wus6.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k2b0wus6.fsf@notabene.neil.brown.name>
Subject: [kernel-hardening] Re: [RFC 0/4] make call_usermodehelper a bit more "safe"
To: NeilBrown <neilb@suse.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 16, 2016 at 12:02:33PM +1100, NeilBrown wrote:
> On Thu, Dec 15 2016, Greg KH wrote:
> 
> > Hi all,
> >
> > Here's a proof-of-concept patch series that tries to work to address the
> > issue of call_usermodehelper being abused to have the kernel call any
> > userspace binary with full root permissions.
> >
> > The issue is that if you end up getting write access to kernel memory,
> > if you change the string '/sbin/hotplug' to point to
> > '/home/hacked/my_binary', then the next uevent that the system makes
> > will call this binary instead of the "trusted" one.
> 
> You seem to be targeting a situation where the kernel memory can be
> easily changed, but filesystem content cannot (if it could - the
> attacker would simply replace /sbin/hotplug).

Correct, like an embedded system with a read-only system partition, or
for when some kernel bug allows for random memory writes, yet privilege
escalation is hard to achieve for your process.

> If that is a credible threat scenario, it seems to me that the simplest
> mitigation is to have call_usermodehelper always call a single
> compiled-in path - e.g. /sbin/usermode-helper - and rely on that
> program to validate argv[0] and call it if it is deemed safe.
> 
> i.e. get the policy out of the kernel.

Ah, that's a nice idea.  It's one step more flexible than the "just
disable usermodehelper entirely", which is what I was going to do after
this all got reworked, while still allowing a system that relied on only
one or two of these usermodehelper apps to still operate normally.  And
it allows for all of those future users of the api to not have to be
manually audited.  Punting the issue to userspace is something I always
love to do :)

I'll try that out on an Android system after the holiday break to see
how feasible that would be, thanks for the idea!

greg k-h
