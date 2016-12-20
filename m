Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 20 Dec 2016 10:27:34 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161220092734.GA12200@kroah.com>
References: <20161214185000.GA3930@kroah.com>
 <87k2b0wus6.fsf@notabene.neil.brown.name>
 <20161216124913.GB31485@kroah.com>
 <alpine.LRH.2.00.1612191428060.15543@gjva.wvxbf.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1612191428060.15543@gjva.wvxbf.pm>
Subject: [kernel-hardening] Re: [RFC 0/4] make call_usermodehelper a bit more "safe"
To: Jiri Kosina <jikos@kernel.org>
Cc: NeilBrown <neilb@suse.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 19, 2016 at 02:34:00PM +0100, Jiri Kosina wrote:
> On Fri, 16 Dec 2016, Greg KH wrote:
> 
> > > You seem to be targeting a situation where the kernel memory can be
> > > easily changed, but filesystem content cannot (if it could - the
> > > attacker would simply replace /sbin/hotplug).
> > 
> > Correct, like an embedded system with a read-only system partition, or
> > for when some kernel bug allows for random memory writes, yet privilege
> > escalation is hard to achieve for your process.
> 
> Sorry, I really don't get this.
> 
> If kernel memory can be easily changed (which is assumed here), why bother 
> with all this? I'll just set current->uid to 0 and be done.

Because you don't want your current process to uid 0, you want some
other program to run as root.  It's quite common for exploits to work
this way, take a look at how the p0wn-to-own "contests" usually break
out of sandboxed systems like browsers.

thanks,

greg k-h
