Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 29 Jul 2011 21:30:37 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110729173037.GA12284@openwall.com>
References: <20110723162703.GA11631@openwall.com> <20110729090053.GA7274@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729090053.GA7274@albatros>
Subject: Re: [kernel-hardening] -ow features
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Fri, Jul 29, 2011 at 01:00:53PM +0400, Vasiliy Kulikov wrote:
> HARDEN_STACK*
> 
> The code similar to -ow patch is ready, but it doesn't handle DSO cases
> of stack usage.  I've described the problem here:
> 
> http://www.openwall.com/lists/kernel-hardening/2011/07/18/8

Right.

> HARDEN_VM86
> 
> The code similar to -ow patch is ready, but I don't know how it should
> be implemented relative to LSM/seccomp/etc.  It looks like a small
> feature, which is not consistent with current upstream security
> architecture.  I've described the problem here:
> 
> http://www.openwall.com/lists/kernel-hardening/2011/06/19/2
> 
> Without the major change of the configuration mechanism it's impossible
> to get it applied.

In -ow, there's also CONFIG_BINFMT_ELF_AOUT.  When it is not enabled -
and by default it is not - uselib(2) is disabled (returns -ENOSYS) and
parts of binfmt_elf.c responsible for loading a.out libraries for ELF
binaries are also disabled (truly ancient stuff).  We need something
like this for 3.x and RHEL6 kernels too.

Maybe the CONFIG_BINFMT_ELF_AOUT option may be accepted upstream on the
grounds that it's similar to other CONFIG_BINFMT_* options?

> HARDEN_PAGE0
> 
> It is a part of Linux for many years.  Distros may setup their own
> mmap_min_addr limit and the default is 64K.  So, I don't see what can be
> improved here.

Sure.  Historically, I introduced it into 2.4.x-ow before there was
mmap_min_addr, then when mainline went with mmap_min_addr and it got
into upstream 2.4.x kernels, I dropped my code and made the HARDEN_PAGE0
option merely change the default for mmap_min_addr (it was 0 in 2.4.x by
default, IIRC).  Now that the default has also changed upstream, there's
no need for this option anymore.

> HARDEN_LINK
> HARDEN_FIFO
> 
> These are implemented in YAMA LSM.  Kees Cook's last attempt (AFAIK) is:
> 
> http://marc.info/?l=linux-security-module&m=130023775422255&w=2
> 
> James Morris' reaction:
> 
> http://marc.info/?l=linux-security-module&m=130032319219333&w=2
> 
> So, the issue is that LSM guys say that LSM is the place where only
> enhanced access control schemes may be located, but VFS folks
> say that all similar non-POSIX restrictions should go into LSM as a
> configurable security feature (extern relative to VFS).  This
> inconsistency is really nasty :(

So do you intend to skip HARDEN_LINK and HARDEN_FIFO, and work on them
for RHEL6/OpenVZ kernels for Owl only (well, maybe also for OpenVZ and
Red Hat if they choose accept this into their trees)?

> HARDEN_PROC
> 
> The patch as in -ow received negative response from Andrew Morton as too
> limited:
> 
> http://www.openwall.com/lists/kernel-hardening/2011/06/21/3
> 
> I'm working on it.  The demonstration is:
> 
> http://www.openwall.com/lists/kernel-hardening/2011/07/26/5

OK.

> HARDEN_NLIMIT_NPROC
> 
> The discussion:
> 
> http://www.openwall.com/lists/kernel-hardening/2011/06/12/9
> 
> The latest patch:
> 
> http://www.openwall.com/lists/kernel-hardening/2011/07/29/3
> 
> (It has already got a Reviewed-by from James, which is very good.)

Great.

I just recalled that in -ow I also patched the added RLIMIT_NPROC check
into copies of the execve() code in 32-bit syscall wrappers on 64-bit
systems - e.g., do_execve32() in arch/mips64/kernel/linux32.c.  To give
credit where it's due, per my notes it was Brad Spengler who noticed
that these had been overlooked and informed me in 2003 or so.  Is this
still relevant to current kernels?

> HARDEN_SHM
> 
> The patch:
> 
> http://www.openwall.com/lists/kernel-hardening/2011/06/22/4
> 
> It was applied first to -mm tree, now it is merged into Linus' linux-2.6
> tree (it will be part of Linux 3.1).

Great.

> Special handling of fd 0,1,2 (Linux 2.0/2.2) for set*id
> 
> It is handled in glibc now by opening /dev/{null,full}, however, I see
> (minor) drawbacks:
> 
> 1) It's possible to have a chroot without polluted /dev/, so setuid
> inside of chroot might fail to reopen fds.
> 
> 2) It's not handled in other libc implementations.
> 
> Other than that, it already works.

Right.  Is the glibc implementation fail-close or fail-open - that is,
what happens if e.g. /dev/{null,full} don't exist?  Does the program
continue to start up, but without this safety measure?

Either way, I think we should propose this for the kernel - post an RFC.

> Privileged IP aliases (Linux 2.0)
> 
> I think it was fully obsoleted with network namespaces.

Yes, this is not needed anymore (for different reasons, though).

Thanks,

Alexander
