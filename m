Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 24 Jul 2011 18:27:10 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110724142710.GB18345@openwall.com>
References: <20110723162251.GA11485@openwall.com> <20110724084200.GB3659@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724084200.GB3659@albatros>
Subject: Re: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy, all -

On Sun, Jul 24, 2011 at 12:51:42PM +0400, Vasiliy Kulikov wrote:
> On Sat, Jul 23, 2011 at 20:22 +0400, Solar Designer wrote:
> > At least on rhel5/openvz kernels, 32-bit processes get their shared libs
> > loaded at different kinds of addresses on i686 vs. x86_64 kernels.
> [...]
> > Can you please look into this and likely fix it for mainline, as well as
> > for rhel6/openvz when we're ready to move to those kernels?  A fix for
> > rhel5/openvz would also be welcome if it's easy to do.
> 
> I'll look into it.  However, I don't know whether upstream is OK with
> force zeroing high order byte of libs address and artificially limiting
> effective task's vm size.  If not, it's probably should be made
> configurable via kernel.randomize_va_space sysctl.

I think you misunderstood me.  I don't suggest forcing the high order
byte to be zero; I merely suggest that the starting address should be
0x00110000.  If the combined size of shared libs plus the random offset
exceed 15 MB - 64 KB, then some addresses won't have their high order
byte at NUL, and that's life.  I think this is what happens on i686
kernels now, and I'd like the same to be happening with x86_64 kernels
running 32-bit programs.

I think something like 8 MB may be used for randomization (11 bits at
4 KB page size), which leaves almost 7 MB for shared libs until we no
longer have NULs on some of their addresses.  So programs with
relatively few shared libs will benefit not only from randomization, but
also from the NULs.

A drawback is that we'd be unnecessarily limiting the amount of
randomization for programs that have lots of shared libs (way beyond 7 MB).

Or maybe we should use 4 MB for randomization (10 bits), leaving almost
11 MB for NUL-protected shared libs.

Oh, when vm86 is disallowed, I think we can start at mmap_min_addr,
which gives us an extra megabyte (if mmap_min_addr is relatively low,
like 96 KB, which is what we use on Owl).  Similarly, when mmap_min_addr
is not 0 and we're not running with CAP_SYS_RAWIO, perhaps we can start
at mmap_min_addr because some low addresses would not be available to
the process anyway (even if it wanted to use them to run DOS).

I'd appreciate comments and other opinions on all of the above.

What does PaX do here?

Thanks,

Alexander
