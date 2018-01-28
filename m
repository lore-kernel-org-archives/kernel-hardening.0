Date: Sun, 28 Jan 2018 12:36:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20180128085500.djlm5rlbhjlpfj4i@gmail.com>
Message-ID: <alpine.DEB.2.20.1801281232130.2126@nanos>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com> <151703972396.26578.7326612698912543866.stgit@dwillia2-desk3.amr.corp.intel.com> <20180128085500.djlm5rlbhjlpfj4i@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v5 02/12] array_idx: sanitize speculative array
 de-references
To: Ingo Molnar <mingo@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-arch@vger.kernel.org, Cyril Novikov <cnovikov@lynx.com>, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, gregkh@linuxfoundation.org, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 28 Jan 2018, Ingo Molnar wrote:
> * Dan Williams <dan.j.williams@intel.com> wrote:
> > +
> > +#ifndef __NOSPEC_H__
> > +#define __NOSPEC_H__

_LINUX_NOSPEC_H

We have an established practice for those header guards...

> > +/*
> > + * When idx is out of bounds (idx >= sz), the sign bit will be set.
> > + * Extend the sign bit to all bits and invert, giving a result of zero
> > + * for an out of bounds idx, or ~0UL if within bounds [0, sz).
> > + */
> > +#ifndef array_idx_mask
> > +static inline unsigned long array_idx_mask(unsigned long idx, unsigned long sz)
> > +{
> > +	/*
> > +	 * Warn developers about inappropriate array_idx usage.
> > +	 *
> > +	 * Even if the cpu speculates past the WARN_ONCE branch, the
> 
> s/cpu/CPU
> 
> > +	 * sign bit of idx is taken into account when generating the
> > +	 * mask.
> > +	 *
> > +	 * This warning is compiled out when the compiler can infer that
> > +	 * idx and sz are less than LONG_MAX.
> 
> Please use 'idx' and 'sz' in quotes, to make sure they stand out more in free 
> flowing comment text. Also please use '()' to denote functions/methods.
> 
> I.e. something like:
> 
> 	 * Warn developers about inappropriate array_idx() usage.
> 	 *
> 	 * Even if the CPU speculates past the WARN_ONCE() branch, the
> 	 * sign bit of 'idx' is taken into account when generating the
> 	 * mask.
> 	 *
> 	 * This warning is compiled out when the compiler can infer that
> 	 * 'idx' and 'sz' are less than LONG_MAX.

I rather prefer to have a proper kernel doc instead of the comment above
the function and then use @idx and @sz in the code comments.

Thanks,

	tglx
