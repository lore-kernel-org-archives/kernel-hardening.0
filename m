Date: Mon, 21 Jan 2019 10:36:18 -0800
From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC] x86/speculation: add L1 Terminal Fault / Foreshadow demo
Message-ID: <20190121183618.GP6118@tassilo.jf.intel.com>
References: <1548076208-6442-1-git-send-email-jsteckli@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548076208-6442-1-git-send-email-jsteckli@amazon.de>
To: Julian Stecklina <jsteckli@amazon.de>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>, Liran Alon <liran.alon@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

> + 	/* Check the start address: needs to be page-aligned.. */
> +-	if (start & ~PAGE_MASK)
> ++	if (start & ~PAGE_MASK) {
> ++
> ++		/*
> ++		 * XXX Hack
> ++		 *
> ++		 * We re-use this error case to show case a cache load gadget:
> ++		 * There is a mispredicted branch, which leads to prefetching
> ++		 * the cache with attacker controlled data.
> ++		 */
> ++		asm volatile (

Obviously that can never be added to a standard kernel.

And I don't see much point in shipping test cases that require non
standard kernel patching. The idea of shipping test cases is that
you can easily test them, but in this form it can't.

Also even without that problem, not sure what benefit including such a thing 
would have.

If you want to improve regression test coverage, it would be far better to have
test cases which do more directed unit testing against specific software 
parts of the mitigation.

For example some automated testing that the host page tables are inverted as
expected for different scenarios. I checked that manually during development,
but something automated would be great as a regression test. It would
need some way to translate VA->PA in user space.

Or have some tests that run test cases with PT or the MSR tracer with
a guest and automatically check that the MSR writes for VM entries are in
the right location.

-Andi
