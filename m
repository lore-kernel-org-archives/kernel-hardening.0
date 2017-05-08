Date: Mon, 8 May 2017 11:21:01 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170508102100.GA5480@leverpostej>
References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
 <CAJcbSZHcAi37FfFBKF4MsC3WM-RY5ar_e1pgMScb=S3+_-wqVQ@mail.gmail.com>
 <55fa194e-69bd-fe39-f915-6f77673aea36@iaik.tugraz.at>
 <CAJcbSZEOMssjUoMUBmArNeuOPoZ0gQJmEQ_WQaSOPiHp1XcNaQ@mail.gmail.com>
 <01ebda5d918d9cbfd36d8ec4e6c12f55@cs.tu-darmstadt.de>
 <a7cc85fd-b261-0c83-8636-eb57c9ba71f9@iaik.tugraz.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7cc85fd-b261-0c83-8636-eb57c9ba71f9@iaik.tugraz.at>
Subject: Re: [kernel-hardening] [RFC, PATCH] x86_64: KAISER - do not map
 kernel in user mode
To: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Cc: David Gens <david.gens@cs.tu-darmstadt.de>, Thomas Garnier <thgarnie@google.com>, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, clementine.maurice@iaik.tugraz.at, moritz.lipp@iaik.tugraz.at, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, anders.fogh@gdata-adan.de
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Sat, May 06, 2017 at 10:38:23AM +0200, Daniel Gruss wrote:
> On 2017-05-06 06:02, David Gens wrote:
> >Assuming that their patch indeed leaks per-cpu addresses.. it might not
> >necessarily
> >be required to change it.
> 
> I think we're not leaking them (unless we still have some bug in our code).
> The basic idea is that any part that is required for the context switch is
> at a fixed location (unrelated to the location of code / data / per-cpu data
> / ...) and thus does not reveal any randomized offsets. Then the attacker
> cannot gain any knowledge through the side channel anymore.
> For any attack the attacker could then only use the few KBs of memory that
> cannot be unmapped because of the way x86 works. Hardening these few KBs
> seems like an easier task than doing the same for the entire kernel.
> 
> (The best solution would of course be Intel introducing CR3A and CR3B just
> like ARM has TTBR0 and TTBR1 - on ARM this entirely prevents any prefetch /
> double-fault side-channel attacks.)

While it may be the case that in practice ARM systems do not have such a
side channel, I think that it is erroneous to believe that the
architectural TTBR{0,1} split ensures this.

The use of TTBR0 for user and TTBR1 for kernel is entirely a SW policy,
and not an architectural requirement. It is possible to map data in
TTBR1 which is accessible to userspace, and data in TTBR0 which is only
accessible by the kernel. In either case, this is determined by the page
tables themselves.

Given this, I think that the statements in the KAISER paper regarding
the TTBRs (in section 2.1) are not quite right. Architecturally,
permission checks and lookups cannot be elided based on the TTBR used.

Having two TTBRs does make it simpler to change the user/kernel address
spaces independently, however.

Thanks,
Mark.
