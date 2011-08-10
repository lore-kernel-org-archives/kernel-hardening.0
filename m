Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 10 Aug 2011 17:03:33 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110810130333.GA31122@openwall.com>
References: <20110807110025.GA3778@albatros> <20110808173913.GA16028@albatros> <20110810095200.GA2377@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810095200.GA2377@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
Cc: Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 10, 2011 at 01:52:01PM +0400, Vasiliy Kulikov wrote:
> +++ b/arch/x86/ia32/ia32entry.S
> @@ -151,6 +151,8 @@ ENTRY(ia32_sysenter_target)
>   	.quad 1b,ia32_badarg
>   	.previous	
>  	GET_THREAD_INFO(%r10)
> +	testl  $_TIF_SYSCALL32_DENIED,TI_flags(%r10)
> +	jnz ia32_deniedsys

Things like this work for the initial RFC posting, but something will
need to be done to eliminate the performance impact later.

Perhaps bitness-restricted processes will need to be switched to
directly use different syscall entry code.  Maybe you'll have to do such
switching on context switches, which is hopefully a lower performance
impact than the check on syscall entry.  On the other hand, this is more
complicated and may have extra risks.

Alternatively, you may do the test/jnz thing on some syscall mechanisms
(legacy), but do something more efficient on others (meant to be fast).

You'll need to research this and propose something.  Or maybe folks on
LKML will propose something.

> +ia32_deniedsys:
> +	/* FIXME: need SIGSEGV delivery or similar */

I think the action on error should be exactly the same as if the kernel
is compiled without CONFIG_IA32_EMULATION.

> +static struct ctl_table abi_syscall_restrict[] = {
> +	{
> +		.procname = "bitness_locked",
> +		.mode = 0644,
> +		.proc_handler = bitness_locked_handler
> +	},
> +	{}
> +};

How would we actually configure it, say, for an OpenVZ container before
we let any program in the container run (including /sbin/init, because
we assume that the container's root account may have been compromised
and is now trying to attack the kernel to escape)?  With OpenVZ, this
setting will need to be in /etc/vz/conf/100.conf, etc. - and vzctl will
need to configure it in the kernel.  Will it have to mount the
container's procfs early for this?  Currently, this step is left for
the guest Linux distro's startup scripts.

Also, what are the possible settings?  Is this tri-state - any bitness
allowed, 32-bit only, or 64-bit only?

Thanks,

Alexander
