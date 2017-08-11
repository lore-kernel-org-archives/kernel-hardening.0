Date: Fri, 11 Aug 2017 12:29:23 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170811112922.GE12985@leverpostej>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
 <20170721170509.GC1538@e103592.cambridge.arm.com>
 <20170725120630.GA8116@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170725120630.GA8116@leverpostej>
Subject: [kernel-hardening] Re: [PATCH 00/11] ARMv8.3 pointer authentication userspace support
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, arnd@arndb.de, jiong.wang@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, yao.qi@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 25, 2017 at 01:06:43PM +0100, Mark Rutland wrote:
> On Fri, Jul 21, 2017 at 06:05:09PM +0100, Dave Martin wrote:
> > On Wed, Jul 19, 2017 at 05:01:21PM +0100, Mark Rutland wrote:
> > > This series adds support for the ARMv8.3 pointer authentication extension.
> 
> > > Open questions
> > > ==============
> > > 
> > > * Should keys be per-thread rather than per-process?
> > > 
> > >   My understanding is that glibc can't (currently) handle threads having
> > >   different keys, but it might be that another libc would prefer per-thread
> > 
> > Can you elaborate?
> > 
> > It's not valid to do a function return from one thread to another.
> 
> Regardless of whether it's valid per the C spec or POSIX, some people
> use {set,get}context and {set,long}jmp in this manner (IIRC, QEMU does
> this), and my understanding is that similar tricks are in use in the
> bowels of glibc.
> 
> Otherwise, my preference would be to have per-thread keys from day one.

Having considered comments I've received elsewhere, I've reversed my
position here. I think per-process keys are the more
sensible default since:

* This will allow us to protect function pointers in shared
  datastructures such as vtables.

* Tasks have their own stacks, and values leaked from one stack cannot
  be used to spoof return addresses on another.

* If an attacker can take control of one thread, they've already gained
  code execution and/or primitives that can be used to attack the
  process by other means.

Thanks,
Mark.
