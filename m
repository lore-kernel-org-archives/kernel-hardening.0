Date: Sun, 21 Jan 2018 10:40:19 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20180121104019.GS17719@n2100.armlinux.org.uk>
References: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151648236968.34747.390507912161115784.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151648236968.34747.390507912161115784.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [kernel-hardening] Re: [PATCH v4.1 02/10] asm/nospec, array_ptr: sanitize speculative
 array de-references
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@redhat.com>, gregkh@linuxfoundation.org, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jan 20, 2018 at 01:06:09PM -0800, Dan Williams wrote:
> +/*
> + * If idx is negative or if idx > size then bit 63 is set in the mask,
> + * and the value of ~(-1L) is zero. When the mask is zero, bounds check
> + * failed, array_ptr will return NULL.

The more times I see this the more times I'm unhappy with this comment:

1. does this really mean "idx > size" or "idx >= size" ?  The code
   implements the latter not the former.

2. is "bit 63" relevant here - what if longs are 32-bit?  "the top bit"
   or "the sign bit" would be better.

3. "and the value of ~(-1L) is zero."  So does this mean that when
   0 <= idx < size, somehow the rules of logic change and ~(-1L)
   magically becomes no longer zero!

I'd suggest changing the description to something like:

  * If 0 <= idx < size, return a mask of ~0UL, otherwise return zero.

or:

  * When idx is out of bounds (iow, is negative or idx >= sz), the sign
  * bit will be set. Extend the sign bit to all bits and invert, giving
  * a result of zero for an out of bounds idx, or ~0UL if within bounds.

depending on how deeply you want to describe what's going on here.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
