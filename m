Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 10 Aug 2011 19:40:59 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110810154059.GA31860@openwall.com>
References: <20110807110025.GA3778@albatros> <20110808173913.GA16028@albatros> <20110810095200.GA2377@albatros> <20110810130333.GA31122@openwall.com> <20110810132715.GA8993@albatros> <20110810142609.GA31434@openwall.com> <20110810150257.GA12198@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810150257.GA12198@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 10, 2011 at 07:02:57PM +0400, Vasiliy Kulikov wrote:
> On Wed, Aug 10, 2011 at 18:26 +0400, Solar Designer wrote:
> > > > Alternatively, you may do the test/jnz thing on some syscall mechanisms
> > > > (legacy), but do something more efficient on others (meant to be fast).
> > > 
> > > Sorry, I don't understand what you're trying to say.  What legacy
> > > syscall mechanisms?
> > 
> > int 0x80 (IDT) vs. syscall/sysenter (MSRs).
> 
> All three mechanisms are already guarded.

Yes.  I meant that when adding optimizations, it might make sense to do
so for some of these only.  Or it might not.

> > > > How would we actually configure it, say, for an OpenVZ container before
> > > > we let any program in the container run (including /sbin/init, because
> > > > we assume that the container's root account may have been compromised
> > > > and is now trying to attack the kernel to escape)?  With OpenVZ, this
> > > > setting will need to be in /etc/vz/conf/100.conf, etc. - and vzctl will
> > > > need to configure it in the kernel.  Will it have to mount the
> > > > container's procfs early for this?  Currently, this step is left for
> > > > the guest Linux distro's startup scripts.
> > > 
> > > Hm, if we assume root is _already_ compromized, then I see one way (a
> > > hack, actually): open sysctl file, create container environment, write 1
> > > to the file and execve() init image.  I don't know whether vzctl already
> > > use procfs for any internal things, I have to investigate it.
> > 
> > Isn't this what I wrote above - having vzctl mount the container's
> > procfs early?  I think it's better to avoid this.
> 
> No, no early procfs mounting.  I mean keeping fd from the HW' procfs
> mount point.  Writing to bitness_locked is equivalent regardless a used
> mount point.

Oh, I did not realize this.

> However, prctl() is much cleaner.

> > > No, two-state.  I tried to make it as simple as possible.  As there is
> > > at least one process in current pid ns - init - and it already has some
> > > specific bitness, locking procedure locks the whole container to the
> > > init's bitness.  Otherwise, init would die on the next syscall.
> > 
> > This is a desired mode as well, yes.  I suspect OpenVZ may even make
> > this their default.  However, we also need a way to control this
> > pre-init, in case /sbin/init is already replaced by the attacker.
> > I think we need a prctl() that will let us configure things in one of
> > four ways for the very next execve() call:
> > 
> > 0. Don't lock bitness.
> > 
> > 1. Lock bitness to that of the next binary invoked.
> > 
> > 2. Lock bitness to 32-bit, fail the next execve() if not 32-bit.
> > 
> > 3. Lock bitness to 64-bit, fail the next execve() if not 64-bit.
> 
> Is there any need for 2 and 3?  I feel 0 and 1 are fine.  KISS :)

Yes, we also need 2 and 3, for the reason I mentioned: /sbin/init might
be already replaced by the attacker during the guest system's previous
uptime, specifically to bypass our restriction and attack the other
bitness' syscalls.

> I don't know whether it is OK to have 2 mechanisms for a rather limited
> thing.  For OpenVZ prctl() should be OK as there are 2 ways to enter the
> container:
> 
> 1) vzctl start - a process creates an environment, does prctl() and
> execve's init.
> 
> 2) vzctl enter - a process does some ioctl() magic to enter already
> created namespaces and vz environment.
> 
> For (1) prctl() is just what is needed.  For (2) IMO it's better to lock
> the process in this ioctl() (keep it ovz-specific for now) as I don't
> see how upstream can handle this kind of namespace shift.

Why not use the same prctl() for both?  (There's also vzctl exec, but
it's similar to vzctl enter for the purpose of this discussion.)

There's not much of a difference between execve() of /sbin/init and of
the shell.

I agree that your proposed procfs/sysctl interface seems excessive if we
add the prctl().

Alexander
