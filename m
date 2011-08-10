Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 10 Aug 2011 20:42:25 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110810164225.GA32177@openwall.com>
References: <20110807110025.GA3778@albatros> <20110808173913.GA16028@albatros> <20110810095200.GA2377@albatros> <20110810130333.GA31122@openwall.com> <20110810132715.GA8993@albatros> <20110810142609.GA31434@openwall.com> <20110810150257.GA12198@albatros> <20110810154059.GA31860@openwall.com> <20110810162101.GA2833@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810162101.GA2833@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 10, 2011 at 08:21:01PM +0400, Vasiliy Kulikov wrote:
> On Wed, Aug 10, 2011 at 19:40 +0400, Solar Designer wrote:
> > > 1) vzctl start - a process creates an environment, does prctl() and
> > > execve's init.
> > > 
> > > 2) vzctl enter - a process does some ioctl() magic to enter already
> > > created namespaces and vz environment.
> > > 
> > > For (1) prctl() is just what is needed.  For (2) IMO it's better to lock
> > > the process in this ioctl() (keep it ovz-specific for now) as I don't
> > > see how upstream can handle this kind of namespace shift.
> > 
> > Why not use the same prctl() for both?  (There's also vzctl exec, but
> > it's similar to vzctl enter for the purpose of this discussion.)
> > 
> > There's not much of a difference between execve() of /sbin/init and of
> > the shell.
> 
> There is - if we exec init, there is no process in the namespace yet.
> If exec the shell, an already existing root process may ptrace vzctl
> process, which hasn't exec'ed and hasn't locked itself yet.  I don't
> know how vzctl is protected against such races.

Good point, but I think it is protected against ptrace by the guest, or
at least it was.  My OpenVZ audit report from late 2005 includes this:

2.2. Testing and review of "strace" logs revealed that only the first 16
fd's were being closed on VPS entry.  This needs to be corrected.  Also,
the fd's are being closed _after_ the ioctl call, which is not great,
although the risk is now mitigated by having the VPS-entering process
protected from ptrace(2).

Of course, mainline code / LXC might differ from OpenVZ in this respect,
and the OpenVZ code might have changed.  So this is something to revisit
when we add the bitness restriction.

Alexander
