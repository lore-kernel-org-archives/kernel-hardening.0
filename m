Date: Mon, 8 May 2017 14:22:35 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170508132235.GC5480@leverpostej>
References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
 <CAJcbSZHcAi37FfFBKF4MsC3WM-RY5ar_e1pgMScb=S3+_-wqVQ@mail.gmail.com>
 <55fa194e-69bd-fe39-f915-6f77673aea36@iaik.tugraz.at>
 <CAJcbSZEOMssjUoMUBmArNeuOPoZ0gQJmEQ_WQaSOPiHp1XcNaQ@mail.gmail.com>
 <01ebda5d918d9cbfd36d8ec4e6c12f55@cs.tu-darmstadt.de>
 <a7cc85fd-b261-0c83-8636-eb57c9ba71f9@iaik.tugraz.at>
 <20170508102100.GA5480@leverpostej>
 <db80ae9d-15bc-5d32-afce-ea98a6059fb8@iaik.tugraz.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db80ae9d-15bc-5d32-afce-ea98a6059fb8@iaik.tugraz.at>
Subject: Re: [kernel-hardening] [RFC, PATCH] x86_64: KAISER - do not map
 kernel in user mode
To: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Cc: David Gens <david.gens@cs.tu-darmstadt.de>, Thomas Garnier <thgarnie@google.com>, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, clementine.maurice@iaik.tugraz.at, moritz.lipp@iaik.tugraz.at, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, anders.fogh@gdata-adan.de
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 08, 2017 at 12:51:27PM +0200, Daniel Gruss wrote:
> >While it may be the case that in practice ARM systems do not have such a
> >side channel, I think that it is erroneous to believe that the
> >architectural TTBR{0,1} split ensures this.
> >
> >The use of TTBR0 for user and TTBR1 for kernel is entirely a SW policy,
> >and not an architectural requirement. It is possible to map data in
> >TTBR1 which is accessible to userspace, and data in TTBR0 which is only
> >accessible by the kernel. In either case, this is determined by the page
> >tables themselves.
> 
> Absolutely right, but TTBR0 and TTBR1 are usually used in this way.

Sure; if we consider Linux, while userspace is executing, TTBR1 will
(only) contain kernel page tables and TTBR0 will (only) contain user
page tables.

However, as this is not an architectural requirement, the CPU cannot
know that a user access that gets translated via TTBR1 will fault, and
at some point must determine the permissions from the page tables as
required by the architecture.

> >Given this, I think that the statements in the KAISER paper regarding
> >the TTBRs (in section 2.1) are not quite right. Architecturally,
> >permission checks and lookups cannot be elided based on the TTBR used.
> 
> As we say in section 2.1, they are "typically" used in this way, and
> this prevents the attacks. Not just the presence of a second
> register, but the way how the two registers are used to split the
> translation tables for user and kernel.

In practice, while userspace is executing, TTBR1 still points to kernel
page tables. If a user program attempts to access an address mapped via
TTBR1, the CPU has to attempt this translation via the TTBR1 page tables
and/or associated TLB entries.

Specifically, I think this does not align with the statement in 2.1
regarding the two TTBRs:

  This simplifies privilege checks and does not require any address
  translation for invalid memory accesses and thus no cache lookups.

... since the use of the TTBRs is orthogonal to privilege checks and/or
the design of the TLBs.

Thanks,
Mark.
