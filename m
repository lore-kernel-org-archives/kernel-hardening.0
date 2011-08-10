Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 10 Aug 2011 18:26:09 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110810142609.GA31434@openwall.com>
References: <20110807110025.GA3778@albatros> <20110808173913.GA16028@albatros> <20110810095200.GA2377@albatros> <20110810130333.GA31122@openwall.com> <20110810132715.GA8993@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810132715.GA8993@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

I feel that your patch works fine for an RFC posting to LKML, so please
do that.  As to potential further changes, see below:

On Wed, Aug 10, 2011 at 05:27:17PM +0400, Vasiliy Kulikov wrote:
> On Wed, Aug 10, 2011 at 17:03 +0400, Solar Designer wrote:
> > On Wed, Aug 10, 2011 at 01:52:01PM +0400, Vasiliy Kulikov wrote:
> > > +++ b/arch/x86/ia32/ia32entry.S
> > > @@ -151,6 +151,8 @@ ENTRY(ia32_sysenter_target)
> > >   	.quad 1b,ia32_badarg
> > >   	.previous	
> > >  	GET_THREAD_INFO(%r10)
> > > +	testl  $_TIF_SYSCALL32_DENIED,TI_flags(%r10)
> > > +	jnz ia32_deniedsys
> > 
> > Things like this work for the initial RFC posting, but something will
> > need to be done to eliminate the performance impact later.
> 
> IMO a single check is awfully cheap.

I agree, but not everyone will.

> Look at audit checks - the same one
> bit check.  (btw, I'll guard it with #ifdef CONFIG_IA32_EMULATION for
> 64-bit syscall.)

Yes, "#ifdef CONFIG_IA32_EMULATION" will be good, although almost all
distro kernels will include CONFIG_IA32_EMULATION.

> > Perhaps bitness-restricted processes will need to be switched to
> > directly use different syscall entry code.
> 
> Then the check is moved from a syscall to a switch plus additional cost
> of IDT changing, which is IIRC very expensive.  And I bet it would cause
> numerous complains from LKML folks.

Right.  Maybe you could have separate IDTs for each processor, and then
you'd be patching them rather than invoking the costly lidt instruction.

Also, this switching on context switch would only occur when the bitness
restriction of the two processes differs.  So systems that don't make
use of this hardening feature would see almost no performance impact
(just one check on context switch).

And syscalls are expected to be far more frequent than context switches.

Anyway, I agree with you that a simple check may be better.

> > Alternatively, you may do the test/jnz thing on some syscall mechanisms
> > (legacy), but do something more efficient on others (meant to be fast).
> 
> Sorry, I don't understand what you're trying to say.  What legacy
> syscall mechanisms?

int 0x80 (IDT) vs. syscall/sysenter (MSRs).

> > How would we actually configure it, say, for an OpenVZ container before
> > we let any program in the container run (including /sbin/init, because
> > we assume that the container's root account may have been compromised
> > and is now trying to attack the kernel to escape)?  With OpenVZ, this
> > setting will need to be in /etc/vz/conf/100.conf, etc. - and vzctl will
> > need to configure it in the kernel.  Will it have to mount the
> > container's procfs early for this?  Currently, this step is left for
> > the guest Linux distro's startup scripts.
> 
> Hm, if we assume root is _already_ compromized, then I see one way (a
> hack, actually): open sysctl file, create container environment, write 1
> to the file and execve() init image.  I don't know whether vzctl already
> use procfs for any internal things, I have to investigate it.

Isn't this what I wrote above - having vzctl mount the container's
procfs early?  I think it's better to avoid this.  Maybe we need a
prctl() that will tell a subsequent execve() to lock bitness (and fail
if the /sbin/init binary being loaded is of the wrong bitness).

> > Also, what are the possible settings?  Is this tri-state - any bitness
> > allowed, 32-bit only, or 64-bit only?
> 
> No, two-state.  I tried to make it as simple as possible.  As there is
> at least one process in current pid ns - init - and it already has some
> specific bitness, locking procedure locks the whole container to the
> init's bitness.  Otherwise, init would die on the next syscall.

This is a desired mode as well, yes.  I suspect OpenVZ may even make
this their default.  However, we also need a way to control this
pre-init, in case /sbin/init is already replaced by the attacker.
I think we need a prctl() that will let us configure things in one of
four ways for the very next execve() call:

0. Don't lock bitness.

1. Lock bitness to that of the next binary invoked.

2. Lock bitness to 32-bit, fail the next execve() if not 32-bit.

3. Lock bitness to 64-bit, fail the next execve() if not 64-bit.

> And it is one way ticket (like modules_disabled) - once set to 1 it
> can never be cleared (and there is no code for it ;).

Right.

Thanks,

Alexander
