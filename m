Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 10 Aug 2011 19:02:57 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110810150257.GA12198@albatros>
References: <20110807110025.GA3778@albatros>
 <20110808173913.GA16028@albatros>
 <20110810095200.GA2377@albatros>
 <20110810130333.GA31122@openwall.com>
 <20110810132715.GA8993@albatros>
 <20110810142609.GA31434@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810142609.GA31434@openwall.com>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 10, 2011 at 18:26 +0400, Solar Designer wrote:
> I feel that your patch works fine for an RFC posting to LKML, so please
> do that.

OK!

> > > Alternatively, you may do the test/jnz thing on some syscall mechanisms
> > > (legacy), but do something more efficient on others (meant to be fast).
> > 
> > Sorry, I don't understand what you're trying to say.  What legacy
> > syscall mechanisms?
> 
> int 0x80 (IDT) vs. syscall/sysenter (MSRs).

All three mechanisms are already guarded.

> > > How would we actually configure it, say, for an OpenVZ container before
> > > we let any program in the container run (including /sbin/init, because
> > > we assume that the container's root account may have been compromised
> > > and is now trying to attack the kernel to escape)?  With OpenVZ, this
> > > setting will need to be in /etc/vz/conf/100.conf, etc. - and vzctl will
> > > need to configure it in the kernel.  Will it have to mount the
> > > container's procfs early for this?  Currently, this step is left for
> > > the guest Linux distro's startup scripts.
> > 
> > Hm, if we assume root is _already_ compromized, then I see one way (a
> > hack, actually): open sysctl file, create container environment, write 1
> > to the file and execve() init image.  I don't know whether vzctl already
> > use procfs for any internal things, I have to investigate it.
> 
> Isn't this what I wrote above - having vzctl mount the container's
> procfs early?  I think it's better to avoid this.

No, no early procfs mounting.  I mean keeping fd from the HW' procfs
mount point.  Writing to bitness_locked is equivalent regardless a used
mount point.  However, prctl() is much cleaner.

> > No, two-state.  I tried to make it as simple as possible.  As there is
> > at least one process in current pid ns - init - and it already has some
> > specific bitness, locking procedure locks the whole container to the
> > init's bitness.  Otherwise, init would die on the next syscall.
> 
> This is a desired mode as well, yes.  I suspect OpenVZ may even make
> this their default.  However, we also need a way to control this
> pre-init, in case /sbin/init is already replaced by the attacker.
> I think we need a prctl() that will let us configure things in one of
> four ways for the very next execve() call:
> 
> 0. Don't lock bitness.
> 
> 1. Lock bitness to that of the next binary invoked.
> 
> 2. Lock bitness to 32-bit, fail the next execve() if not 32-bit.
> 
> 3. Lock bitness to 64-bit, fail the next execve() if not 64-bit.

Is there any need for 2 and 3?  I feel 0 and 1 are fine.  KISS :)


I don't know whether it is OK to have 2 mechanisms for a rather limited
thing.  For OpenVZ prctl() should be OK as there are 2 ways to enter the
container:

1) vzctl start - a process creates an environment, does prctl() and
execve's init.

2) vzctl enter - a process does some ioctl() magic to enter already
created namespaces and vz environment.

For (1) prctl() is just what is needed.  For (2) IMO it's better to lock
the process in this ioctl() (keep it ovz-specific for now) as I don't
see how upstream can handle this kind of namespace shift.

(In 3.1 there is a possibility to change net/ipc/uts namespace, but it
is far from pid ns changing AFAICS.)


The clean mechanism for (2) can be simply added in the future.

-- 
Vasiliy
