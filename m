Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 10 Aug 2011 17:27:17 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110810132715.GA8993@albatros>
References: <20110807110025.GA3778@albatros>
 <20110808173913.GA16028@albatros>
 <20110810095200.GA2377@albatros>
 <20110810130333.GA31122@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810130333.GA31122@openwall.com>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
Cc: Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Wed, Aug 10, 2011 at 17:03 +0400, Solar Designer wrote:
> On Wed, Aug 10, 2011 at 01:52:01PM +0400, Vasiliy Kulikov wrote:
> > +++ b/arch/x86/ia32/ia32entry.S
> > @@ -151,6 +151,8 @@ ENTRY(ia32_sysenter_target)
> >   	.quad 1b,ia32_badarg
> >   	.previous	
> >  	GET_THREAD_INFO(%r10)
> > +	testl  $_TIF_SYSCALL32_DENIED,TI_flags(%r10)
> > +	jnz ia32_deniedsys
> 
> Things like this work for the initial RFC posting, but something will
> need to be done to eliminate the performance impact later.

IMO a single check is awfully cheap.  Look at audit checks - the same one
bit check.  (btw, I'll guard it with #ifdef CONFIG_IA32_EMULATION for
64-bit syscall.)


> Perhaps bitness-restricted processes will need to be switched to
> directly use different syscall entry code.

Then the check is moved from a syscall to a switch plus additional cost
of IDT changing, which is IIRC very expensive.  And I bet it would cause
numerous complains from LKML folks.


> Alternatively, you may do the test/jnz thing on some syscall mechanisms
> (legacy), but do something more efficient on others (meant to be fast).

Sorry, I don't understand what you're trying to say.  What legacy
syscall mechanisms?


> > +ia32_deniedsys:
> > +	/* FIXME: need SIGSEGV delivery or similar */
> 
> I think the action on error should be exactly the same as if the kernel
> is compiled without CONFIG_IA32_EMULATION.

OK, but then it needs the stack preparation in asm code (at least to get
struct pt_regs from C code).


> > +static struct ctl_table abi_syscall_restrict[] = {
> > +	{
> > +		.procname = "bitness_locked",
> > +		.mode = 0644,
> > +		.proc_handler = bitness_locked_handler
> > +	},
> > +	{}
> > +};
> 
> How would we actually configure it, say, for an OpenVZ container before
> we let any program in the container run (including /sbin/init, because
> we assume that the container's root account may have been compromised
> and is now trying to attack the kernel to escape)?  With OpenVZ, this
> setting will need to be in /etc/vz/conf/100.conf, etc. - and vzctl will
> need to configure it in the kernel.  Will it have to mount the
> container's procfs early for this?  Currently, this step is left for
> the guest Linux distro's startup scripts.

Hm, if we assume root is _already_ compromized, then I see one way (a
hack, actually): open sysctl file, create container environment, write 1
to the file and execve() init image.  I don't know whether vzctl already
use procfs for any internal things, I have to investigate it.


> Also, what are the possible settings?  Is this tri-state - any bitness
> allowed, 32-bit only, or 64-bit only?

No, two-state.  I tried to make it as simple as possible.  As there is
at least one process in current pid ns - init - and it already has some
specific bitness, locking procedure locks the whole container to the
init's bitness.  Otherwise, init would die on the next syscall.

And it is one way ticket (like modules_disabled) - once set to 1 it
can never be cleared (and there is no code for it ;).


Thanks,

-- 
Vasiliy
