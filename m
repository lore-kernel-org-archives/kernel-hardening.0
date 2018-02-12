Date: Mon, 12 Feb 2018 16:00:39 +0000
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCHv2 05/12] arm64: Don't trap host pointer auth use to EL2
Message-ID: <20180212160039.br2emy3zt6ftmwfu@lakrids.cambridge.arm.com>
References: <20171127163806.31435-1-mark.rutland@arm.com>
 <20171127163806.31435-6-mark.rutland@arm.com>
 <20180206123906.GZ21802@cbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180206123906.GZ21802@cbox>
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, catalin.marinas@arm.com, cdall@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 06, 2018 at 01:39:06PM +0100, Christoffer Dall wrote:
> Hi Mark,
> 
> On Mon, Nov 27, 2017 at 04:37:59PM +0000, Mark Rutland wrote:
> > To allow EL0 (and/or EL1) to use pointer authentication functionality,
> > we must ensure that pointer authentication instructions and accesses to
> > pointer authentication keys are not trapped to EL2 (where we will not be
> > able to handle them).
> 
> ...on non-VHE systems, presumably?

For EL0 usage, we don't want to trap even in the absence of VHE, so I'll
drop the bit in brackets entirely.

> > This patch ensures that HCR_EL2 is configured appropriately when the
> > kernel is booted at EL2. For non-VHE kernels we set HCR_EL2.{API,APK},
> > ensuring that EL1 can access keys and permit EL0 use of instructions.
> > For VHE kernels, EL2 access is controlled by EL3, and we need not set
> > anything.
> 
> 
> for VHE kernels host EL0 (TGE && E2H) is unaffected by these settings,
> and it doesn't matter how we configure HCR_EL2.{API,APK}.
> 
> (Because you do actually set these bits when the features are present if
> I read the code correctly).

Ah, true. I've taken your proposed wording.

> > This does not enable support for KVM guests, since KVM manages HCR_EL2
> > itself.
> 
>         (...when running VMs.)
> 
> 
> Besides the nits:
> 
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Cheers!

Mark.
