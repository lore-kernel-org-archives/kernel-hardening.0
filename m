Sender: Christoffer Dall <christofferdall@christofferdall.dk>
Date: Mon, 9 Apr 2018 21:03:24 +0200
From: Christoffer Dall <cdall@kernel.org>
Subject: Re: [PATCHv2 09/12] arm64/kvm: preserve host HCR_EL2 value
Message-ID: <20180409190324.GG10904@cbox>
References: <20171127163806.31435-1-mark.rutland@arm.com>
 <20171127163806.31435-10-mark.rutland@arm.com>
 <20180206123915.GA21802@cbox>
 <20180409145709.dneotb6xaznw44c4@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180409145709.dneotb6xaznw44c4@lakrids.cambridge.arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 09, 2018 at 03:57:09PM +0100, Mark Rutland wrote:
> On Tue, Feb 06, 2018 at 01:39:15PM +0100, Christoffer Dall wrote:
> > On Mon, Nov 27, 2017 at 04:38:03PM +0000, Mark Rutland wrote:
> > > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > > index 525c01f48867..2205f0be3ced 100644
> > > --- a/arch/arm64/kvm/hyp/switch.c
> > > +++ b/arch/arm64/kvm/hyp/switch.c
> > > @@ -71,6 +71,8 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
> > >  {
> > >  	u64 val;
> > >  
> > > +	vcpu->arch.host_hcr_el2 = read_sysreg(hcr_el2);
> > > +
> > 
> > Looking back at this, it seems excessive to switch this at every
> > round-trip.  I think it should be possible to have this as a single
> > global (or per-CPU) variable that gets restored directly when returning
> > from the VM.
> 
> I suspect this needs to be per-cpu, to account for heterogeneous
> systems.
> 
> I guess if we move hcr_el2 into kvm_cpu_context, that gives us a
> per-vcpu copy for guests, and a per-cpu copy for the host (in the global
> kvm_host_cpu_state).
> 
> I'll have a look at how gnarly that turns out. I'm not sure how we can
> initialise that sanely for the !VHE case to match whatever el2_setup
> did.

There's no harm in jumping down to EL2 to read a register during the
initialization phase.  All it requires is an annotation of the callee
function, and a kvm_call_hyp(), and it's actually quite fast unless you
start saving/restoring a bunch of additional system registers.  See how
we call __kvm_set_tpidr_el2() for example.

Thanks,
-Christoffer
