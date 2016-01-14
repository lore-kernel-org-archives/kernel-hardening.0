Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 14 Jan 2016 11:11:00 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160114111059.GD2071@e104818-lin.cambridge.arm.com>
References: <20151210002651.GC99337@davidb.org>
 <CAGXu5jJYRCZ1-frx3+pUPabm3XRFFU8T4gsCQaSc73aA4Q--3g@mail.gmail.com>
 <CAB9W1A0veUktvSrdwMSaN=kqypGdE6_RLXFGkD79scfkPPevpw@mail.gmail.com>
 <CAGXu5j+0oBHdS7vTQp_0ubuwvUftosYZCx8RJPXh7v7eYQncEQ@mail.gmail.com>
 <20151210184211.GH26759@e104818-lin.cambridge.arm.com>
 <CAGXu5j+LHBaZ12+zsiK+tt3R83+uTHKO_og3AJRhWP+tHDxUOA@mail.gmail.com>
 <20160111183305.GA27217@davidb.org>
 <CAGXu5jLaAUnJosaw4Wxi+=uZ1GSfu9KZHAmwG4ewpgHLOh1YPg@mail.gmail.com>
 <20160113113102.GB2071@e104818-lin.cambridge.arm.com>
 <1452733478.26227.10.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452733478.26227.10.camel@codethink.co.uk>
Subject: Re: [kernel-hardening] Self Introduction
To: Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc: Kees Cook <keescook@chromium.org>, David Brown <david.brown@linaro.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 14, 2016 at 01:04:38AM +0000, Ben Hutchings wrote:
> On Wed, 2016-01-13 at 11:31 +0000, Catalin Marinas wrote:
> > On Tue, Jan 12, 2016 at 11:31:50AM -0800, Kees Cook wrote:
> > > On Mon, Jan 11, 2016 at 10:33 AM, David Brown <david.brown@linaro.org> wrote:
> > > > On Thu, Dec 10, 2015 at 03:52:16PM -0800, Kees Cook wrote:
> > > >
> > > >>> I haven't done any further improvements to them, nor have I received any
> > > >>> feedback. I'll rebase them against latest kernel if anyone else is
> > > >>> willing to test. I had a plan to run some benchmarks and see how
> > > >>> performance is affected (including the CPU_SW_DOMAIN_PAN) before pushing
> > > >>> again for upstreaming but I haven't had the time.
> > > >>
> > > >>
> > > >> David, getting back to something that might good to get your help
> > > >> with: would you be able to test Catalin's LPAE TTBR0 PAN series on
> > > >> real hardware? (Are you familiar with the LKDTM tests for this[1]?)
> > > >
> > > >
> > > > Sorry for the delay in getting back to you.  Been both moving and
> > > > taking vacation.
> > > >
> > > > I'd like to test this.  I'm just trying to see if I can track down
> > > > some hardware that'll boot LPAE.
> > > 
> > > Awesome! Thanks for the update.
> > > 
> > > Catalin, did you end up figuring out if your TTBR0 stuff was correct?
> > > You'd mentioned you needed to check something about the
> > > implementation?
> > 
> > Unfortunately, I checked with the ARM architecture folk. While the trick
> > is probably fine on existing hardware, the architecture allows caching
> > of the TTBCR bits (or their effect) in the TLB. Therefore changing the
> > TTBCR.EPD0 (or A1) to disable TTBR0 page table walks is not guaranteed
> > to have an effect until the TLBs are invalidated. CPU implementations
> > are allowed to rely on this, so we can't safely use it in Linux.
> [...]
> 
> Could you whitelist the cores where this is known to work as intended?

Even this information is hard to get accurately. You would have to ask
the micro-architects (and not all are ARM Ltd) about the details as
these are not usually publicly available. So in Linux we aim as much as
possible to stick to the architecture specification rather than
individual implementations, with a few exceptions for features
documented in the CPU TRM (or errata docs).

> Or is it not practical to enable/disable this PAN implementation at boot
> time?

Some boot-time code patching may do but we should rather do it properly
by using a reserved TTBR0.

-- 
Catalin
