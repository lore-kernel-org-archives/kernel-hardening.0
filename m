Date: Tue, 1 Aug 2017 15:32:27 +0100
From: Will Deacon <will.deacon@arm.com>
Message-ID: <20170801143227.GC11534@arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
 <1500480092-28480-11-git-send-email-mark.rutland@arm.com>
 <20170801110014.GA5176@cbox>
 <20170801142603.GE9347@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170801142603.GE9347@leverpostej>
Subject: [kernel-hardening] Re: [PATCH 10/11] arm64/kvm: context-switch ptrauth registers
To: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <cdall@linaro.org>, linux-arm-kernel@lists.infradead.org, arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@linaro.org, Dave.Martin@arm.com, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, suzuki.poulose@arm.com, yao.qi@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 01, 2017 at 03:26:07PM +0100, Mark Rutland wrote:
> On Tue, Aug 01, 2017 at 01:00:14PM +0200, Christoffer Dall wrote:
> > On Wed, Jul 19, 2017 at 05:01:31PM +0100, Mark Rutland wrote:
> > > When pointer authentication is supported, a guest may wish to use it.
> > > This patch adds the necessary KVM infrastructure for this to work, with
> > > a semi-lazy context switch of the pointer auth state.
> > > 
> > > When we schedule a vcpu, we disable guest usage of pointer
> > > authentication instructions and accesses to the keys. While these are
> > > disabled, we avoid context-switching the keys. When we trap the guest
> > > trying to use pointer authentication functionality, we change to eagerly
> > > context-switching the keys, and enable the feature. The next time the
> > > vcpu is scheduled out/in, we start again.
> > > 
> > > This is sufficient for systems with uniform pointer authentication
> > > support. For systems with mismatched support, it will be necessary to
> > 
> > What is mismatched support?  You mean systems where one CPU has ptrauth
> > and another one doesn't (or if they both have it but in different ways)?
> 
> Both! Any case where the support is not uniform across all CPUs.
> 
> A CPU can implement address auth and/or generic auth, and either may use
> an architected algorithm or an IMP DEF algorithm.
> 
> Even if all CPUs report an IMP DEF algorithm, the particular algorithm
> may differ across CPUs.

I know you don't like it, but I think we should resort to MIDR at that point
because otherwise IMP DEF algorithms will never be used by Linux and people
will complain.

Will
