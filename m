Date: Wed, 12 Jul 2017 23:47:26 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170712224726.GA10559@leverpostej>
References: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [RFC PATCH 00/10] arm64: allow virtually mapped stacks to be
 enabled
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, labbott@fedoraproject.org, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Ard,

On Wed, Jul 12, 2017 at 03:44:13PM +0100, Ard Biesheuvel wrote:
> This is a fairly quick'n'dirty attempt at enabling virtually mapped
> stacks for arm64, after learning from Mark yesterday that progress
> had more or less stalled on that front.

Thanks for putting this together. If nothing else, this work needed a
good kick.

I had some rought comments on this, but in the process of wiring those
up, I ended up writing an alternative [1] by cobblnig together prior
attempts. Apologies for the NIH.

> Since having actual patches to poke at is infinitely better than having
> abstract discussions about how to approach it, I threw some code together
> that:
> 1. frees up sp_el0 by promoting register x18 to 'current' pointer while in
>    the kernel; flames welcome :-) (#7)
> 2. preparatory work to allow 1., i.e., to free up x18 and preserve/restore it
>    correctly as a platform register (#2, #3, #4, #5, #6)

>From past experience [2], I know that Will is not a fan of reserving a
GPR like this. There are a couple of other ways we can free up SP_EL0,
though, so that isn't the end of the world.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-July/518434.html
[2] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/this-cpu-reg

> 3. dump the entire task stack if regs->sp points elsewhere (#8)

This sounds useful, but it's liable to fill a scrollbuffer and/or take a
while to dump (especially with 64K stacks), so we might want a boot-time
option to turn that on/off. 

Thanks,
Mark.
