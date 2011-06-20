Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 20 Jun 2011 18:25:55 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110620142555.GA31234@openwall.com>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org> <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org> <20110620103917.GA5230@albatros> <BANLkTimb==tuDKQ2jyYS+Py0FfNxKVc+Pg@mail.gmail.com> <20110620141137.GA31044@openwall.com> <20110620141951.GA11607@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620141951.GA11607@albatros>
Subject: Re: [kernel-hardening] [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Mon, Jun 20, 2011 at 06:19:51PM +0400, Vasiliy Kulikov wrote:
> On Mon, Jun 20, 2011 at 18:11 +0400, Solar Designer wrote:
> > On Mon, Jun 20, 2011 at 04:58:10PM +0300, Alexey Dobriyan wrote:
> > > gid= is bad choice because
> > > a) e. g. VFAT uses uid=/gid= mount options to make all inodes to have
> > > certain uid/gid
> > > b) uid=/gid=, IIRC, will be added as generic VFS mount options (like ro)
> > >    with semantics described in a)
> > > 
> > > so having different semantics for /proc won't be good.
> > 
> > I lost track of your proposals/patches.  Aren't you currently proposing
> > that gid= would make all inodes have the specified gid?  If not, why
> > not?  Such semantics sound fine to me.  That's what gid= does on procfs
> > on Linux 2.4.x-ow.
> 
> With taskstats and similar mechanisms IMO it's better to use sysctls
> instead of procfs mount options as it would influence not only on procfs
> files.

OK, but why did we receive a comment about the gid= mount option then
(quote above)?  Are you still proposing it or not anymore?  Is the
question "outdated" (resulting from your earlier proposal, not the
latest one)?

Thanks,

Alexander
