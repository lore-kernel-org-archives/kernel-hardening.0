Date: Wed, 18 Apr 2018 14:47:30 +0100
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCHv3 03/11] arm64/kvm: hide ptrauth from guests
Message-ID: <20180418134729.fzu4r7rvgdzlckw7@lakrids.cambridge.arm.com>
References: <20180417183735.56985-1-mark.rutland@arm.com>
 <20180417183735.56985-4-mark.rutland@arm.com>
 <20180418131926.pbjlbcjspg7azq2j@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418131926.pbjlbcjspg7azq2j@kamzik.brq.redhat.com>
To: Andrew Jones <drjones@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, catalin.marinas@arm.com, cdall@kernel.org, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, ramana.radhakrishnan@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 18, 2018 at 03:19:26PM +0200, Andrew Jones wrote:
> On Tue, Apr 17, 2018 at 07:37:27PM +0100, Mark Rutland wrote:
> > @@ -1000,6 +1000,15 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
> >  				    task_pid_nr(current));
> >  
> >  		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> > +	} else if (id == SYS_ID_AA64ISAR1_EL1) {
> > +		const u64 ptrauth_mask = (0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> > +					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> > +					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> > +					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
> > +		if (val & ptrauth_mask)
> > +			pr_err_once("kvm [%i]: ptrauth unsupported for guests, suppressing\n",
> > +					task_pid_nr(current));
> 
> Marc just changed the equivalent SVE pr_err_once() to kvm_debug().
> So we probably want to do the same here.

Good point. Done.

> > +		val &= ~ptrauth_mask;
> >  	} else if (id == SYS_ID_AA64MMFR1_EL1) {
> >  		if (val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))
> >  			pr_err_once("kvm [%i]: LORegions unsupported for guests, suppressing\n",
> > -- 
> > 2.11.0
> >
> 
> Otherwise
>  
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Cheers!

Mark.
