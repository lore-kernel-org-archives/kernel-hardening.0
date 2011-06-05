Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 6 Jun 2011 00:10:25 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110605201025.GA9541@openwall.com>
References: <20110603191153.GB514@openwall.com> <20110604054758.GA4063@albatros> <20110604132054.GC2583@openwall.com> <20110604200948.GA5850@shinshilla> <20110604205955.GA5972@openwall.com> <20110605182430.GA5789@albatros> <20110605192641.GA9240@openwall.com> <20110605194746.GA6484@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605194746.GA6484@albatros>
Subject: Re: [kernel-hardening] [RFC v1] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 05, 2011 at 11:47:46PM +0400, Vasiliy Kulikov wrote:
> On Sun, Jun 05, 2011 at 23:26 +0400, Solar Designer wrote:
> > On Sun, Jun 05, 2011 at 10:24:31PM +0400, Vasiliy Kulikov wrote:
> > > TODO/thoughs:
> > >   - /proc/pid/net/ currently doesn't show ANYTHING, even "." and "..".
> > >     This is confusing :)
> > 
> > Ouch.  Can't you simply restrict its perms such that this directory
> > can't be listed unless you have privs?
> 
> Well, yes, but it would touch too many code - currently it is handled as
> an entry in a static table.  Changing this would touch many high level
> loops of the table handling.  Hiding its contents is just simplier.
> 
> Another solution - create a fake net namespace and process this
> namespace if not enough permissions :)  It also removes weird netstat
> errors like "seems like networking was disabled for this kernel".

This sounds good to me, although I am not familiar with namespaces.

> > It should act as a normal mode 550 directory on a regular filesystem.
> 
> What 550 perms would give?  /proc/pid/net/ contains all network
> information about _all_ network connections in current net namespace.
> So, /proc/1/net and /proc/2/net are logically the same directory.
> 
> However, changing the mode to 550 _and_ changing uid and gid will help.

I implied that the gid would be the one set by our gid option.

> > >   - what if one keeps open /proc/PID/ while executing set*id/capable
> > >     binary?
> > 
> > Then they deliberately grant this privilege to this process (and maybe
> > to its heirs).  I see no problem with that.
> 
> Ehh...  I mean another thing:
> 
> Process A with UID=1000 opens /proc/123/, while 123 has UID=1000.
> 
> 123 exec's setuid binary, /proc/123/ becomes unaccessible to A.
> 
> However, A still keeps the directory opened and may read its contents.

Oh, this is a valid concern.  Please research this.  Perhaps there
should be a may-ptrace check (or maybe more than one).

As it relates to privacy, there's little need for this, because the user
started those processes on their own (in fact, this is a reason why the
user may want to be able to see those processes, despite of procfs perms).

However, if our concern is that the processes may leak sensitive data
the user is not supposed to see, then we need to restrict this.

Overall, it makes sense either to relax things such that /proc/PID have
real UID rather than effective UID as their owner (so we make such
access to almost-own processes legitimate) or to have the proper
may-ptrace checks in place (such that permissions are actually enforced).
Maybe this should be another mount option.  But this feels like too much
complexity for an obscure option that few people will understand and use.

Thanks,

Alexander
