Date: Mon, 21 Jan 2019 20:15:41 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC] x86/speculation: add L1 Terminal Fault / Foreshadow demo
Message-ID: <20190121191541.GB4026@kroah.com>
References: <1548076208-6442-1-git-send-email-jsteckli@amazon.de>
 <20190121183618.GP6118@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190121183618.GP6118@tassilo.jf.intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Julian Stecklina <jsteckli@amazon.de>, linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>, Liran Alon <liran.alon@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 21, 2019 at 10:36:18AM -0800, Andi Kleen wrote:
> > + 	/* Check the start address: needs to be page-aligned.. */
> > +-	if (start & ~PAGE_MASK)
> > ++	if (start & ~PAGE_MASK) {
> > ++
> > ++		/*
> > ++		 * XXX Hack
> > ++		 *
> > ++		 * We re-use this error case to show case a cache load gadget:
> > ++		 * There is a mispredicted branch, which leads to prefetching
> > ++		 * the cache with attacker controlled data.
> > ++		 */
> > ++		asm volatile (
> 
> Obviously that can never be added to a standard kernel.

No, that's why it is a patch, right?  People want to test things, it's
nice to have a way to easily do this.

> And I don't see much point in shipping test cases that require non
> standard kernel patching. The idea of shipping test cases is that
> you can easily test them, but in this form it can't.

It's better than having nothing at all, which is what we have today.  So
I see no harm in it, only benefits.

thanks,

greg k-h
