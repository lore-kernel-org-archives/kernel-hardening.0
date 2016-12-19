Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Dec 2016 14:34:00 +0100 (CET)
From: Jiri Kosina <jikos@kernel.org>
In-Reply-To: <20161216124913.GB31485@kroah.com>
Message-ID: <alpine.LRH.2.00.1612191428060.15543@gjva.wvxbf.pm>
References: <20161214185000.GA3930@kroah.com> <87k2b0wus6.fsf@notabene.neil.brown.name> <20161216124913.GB31485@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC 0/4] make call_usermodehelper a bit more "safe"
To: Greg KH <gregkh@linuxfoundation.org>
Cc: NeilBrown <neilb@suse.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 16 Dec 2016, Greg KH wrote:

> > You seem to be targeting a situation where the kernel memory can be
> > easily changed, but filesystem content cannot (if it could - the
> > attacker would simply replace /sbin/hotplug).
> 
> Correct, like an embedded system with a read-only system partition, or
> for when some kernel bug allows for random memory writes, yet privilege
> escalation is hard to achieve for your process.

Sorry, I really don't get this.

If kernel memory can be easily changed (which is assumed here), why bother 
with all this? I'll just set current->uid to 0 and be done.

-- 
Jiri Kosina
SUSE Labs
