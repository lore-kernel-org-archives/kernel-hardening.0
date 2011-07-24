Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 24 Jul 2011 22:18:55 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110724181657.GA6429@albatros>
References: <20110723162251.GA11485@openwall.com>
 <20110724084200.GB3659@albatros>
 <20110724142710.GB18345@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724142710.GB18345@openwall.com>
Subject: Re: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sun, Jul 24, 2011 at 18:27 +0400, Solar Designer wrote:
> On Sun, Jul 24, 2011 at 12:51:42PM +0400, Vasiliy Kulikov wrote:
> > On Sat, Jul 23, 2011 at 20:22 +0400, Solar Designer wrote:
> > > At least on rhel5/openvz kernels, 32-bit processes get their shared libs
> > > loaded at different kinds of addresses on i686 vs. x86_64 kernels.
> > [...]
> > > Can you please look into this and likely fix it for mainline, as well as
> > > for rhel6/openvz when we're ready to move to those kernels?  A fix for
> > > rhel5/openvz would also be welcome if it's easy to do.
> > 
> > I'll look into it.  However, I don't know whether upstream is OK with
> > force zeroing high order byte of libs address and artificially limiting
> > effective task's vm size.  If not, it's probably should be made
> > configurable via kernel.randomize_va_space sysctl.
> 
> I think you misunderstood me.  I don't suggest forcing the high order
> byte to be zero; I merely suggest that the starting address should be
> 0x00110000.

Ah, sure.  Best effort vs. enforcement.


> Oh, when vm86 is disallowed,

BTW, vm86 support is not even compiled on x86-64, even for x86-32
compatibility:

config VM86
	bool "Enable VM86 support" if EXPERT
	default y
	depends on X86_32


> What does PaX do here?

I didn't hear PaX does some NUL protection of lib addresses.  I'll look
into this.

Thanks,

-- 
Vasiliy
