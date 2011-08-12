Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 12 Aug 2011 08:21:35 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110812042135.GA5149@openwall.com>
References: <20110723162251.GA11485@openwall.com> <20110724084200.GB3659@albatros> <20110724142710.GB18345@openwall.com> <20110725192048.GA21675@albatros> <20110811083259.GA5429@albatros> <20110812035729.GB4964@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812035729.GB4964@openwall.com>
Subject: Re: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Fri, Aug 12, 2011 at 07:57:29AM +0400, Solar Designer wrote:
> On Thu, Aug 11, 2011 at 12:32:59PM +0400, Vasiliy Kulikov wrote:
> > Or even use 16 bits as PaX does and don't use ASCII-armor at all.
> 
> I think it'd be great to have this as an option.  In fact, the code
> could simply try to do ASCII-armor, but also allow one to configure more
> than 11 bits of entropy, in which case the ASCII-armor would be usually
> ineffective.  That is, start at max(0x00110000, mmap_min_addr), but add
> to this a random page-aligned offset in a configurable range
> (configurable as number of entropy bits).  When the setting is 11 or
> less (and mmap_min_addr is not set unusually high), ASCII-armor is
> guaranteed for libs not exceeding a certain size.  When the setting is
> 12 to 14, ASCII-armor is not guaranteed in any case (but may happen in
> some cases nevertheless).  For 15+, you have to use a different starting
> address or use two ranges (if the random number has no "1" bits beyond
> bits 0-13, then use the low range, otherwise use a high range).

I think this should be configurable in the 0 to 19 bits range.  The
default might be 15, which would mostly fit under the starting address
of non-PIE binaries, taking up only a megabyte above them (you'd need to
use two ranges - 127 MB and 1 MB).  So the cost in reduction of maximum
continuous allocation size would be negligible for non-PIE (just 1 MB).

The starting address of 0x00110000 could also be configurable.  When
dosemu and Win16 apps in Wine are not needed (are these the users of
this range?), you could simply start at mmap_min_addr and fit all 128 MB
before the binary start.

Alexander
