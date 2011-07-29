Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 29 Jul 2011 22:00:49 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110729180049.GA2623@albatros>
References: <20110723162703.GA11631@openwall.com>
 <20110729090053.GA7274@albatros>
 <20110729173037.GA12284@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729173037.GA12284@openwall.com>
Subject: Re: [kernel-hardening] -ow features
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 29, 2011 at 21:30 +0400, Solar Designer wrote:
> > HARDEN_LINK
> > HARDEN_FIFO
> > 
> > These are implemented in YAMA LSM.  Kees Cook's last attempt (AFAIK) is:
> > 
> > http://marc.info/?l=linux-security-module&m=130023775422255&w=2
> > 
> > James Morris' reaction:
> > 
> > http://marc.info/?l=linux-security-module&m=130032319219333&w=2
> > 
> > So, the issue is that LSM guys say that LSM is the place where only
> > enhanced access control schemes may be located, but VFS folks
> > say that all similar non-POSIX restrictions should go into LSM as a
> > configurable security feature (extern relative to VFS).  This
> > inconsistency is really nasty :(
> 
> So do you intend to skip HARDEN_LINK and HARDEN_FIFO, and work on them
> for RHEL6/OpenVZ kernels for Owl only (well, maybe also for OpenVZ and
> Red Hat if they choose accept this into their trees)?

Yes, I don't see how can I improve the situation with upstream.  Kees
Cook tried to push it several times, providing various good arguments.


> I just recalled that in -ow I also patched the added RLIMIT_NPROC check
> into copies of the execve() code in 32-bit syscall wrappers on 64-bit
> systems - e.g., do_execve32() in arch/mips64/kernel/linux32.c.  To give
> credit where it's due, per my notes it was Brad Spengler who noticed
> that these had been overlooked and informed me in 2003 or so.  Is this
> still relevant to current kernels?

No, grep shows no usage in arch/.


> > Special handling of fd 0,1,2 (Linux 2.0/2.2) for set*id
> > 
> > It is handled in glibc now by opening /dev/{null,full}, however, I see
> > (minor) drawbacks:
> > 
> > 1) It's possible to have a chroot without polluted /dev/, so setuid
> > inside of chroot might fail to reopen fds.
> > 
> > 2) It's not handled in other libc implementations.
> > 
> > Other than that, it already works.
> 
> Right.  Is the glibc implementation fail-close or fail-open - that is,
> what happens if e.g. /dev/{null,full} don't exist?  Does the program
> continue to start up, but without this safety measure?

No, it crashes (tries to execute "hlt" in a loop).


> Either way, I think we should propose this for the kernel - post an RFC.

OK.  However, I think it will be rejected with a reason "it is a
doubtful feature, which breaks POSIX and it is already implemented in
a userspace libc".

Thanks,

-- 
Vasiliy
