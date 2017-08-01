Date: Tue, 1 Aug 2017 10:02:19 -0700
From: Christoffer Dall <christoffer.dall@linaro.org>
Message-ID: <20170801170219.GB4033@lvm>
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
Cc: Christoffer Dall <cdall@linaro.org>, linux-arm-kernel@lists.infradead.org, arnd@arndb.de, catalin.marinas@arm.com, Dave.Martin@arm.com, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
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
> 
> > > hide the feature from the guest's view of the ID registers.
> > 
> > I think the work Drew is pondering to allow userspace more control of
> > what we emulate to the guest can semi-automatically take care of this as
> > well.
> 
> I'll take a look.
> 
> [...]
> 
> > > +static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
> > > +{
> > > +	kvm_arm_vcpu_ptrauth_disable(vcpu);
> > > +}
> > > +
> > 
> > why sched_in and not vcpu_load?  (vcpu_load happens whenever you're
> > returning from userspace for example, and not only when you've been
> > scheduled away and are coming back).
> 
> I think this is the result of going searching for similar lazy context
> switching, and stumbling on some (fairly different) code on x86.
> 
> It looks like I can use vcpu_load() instead, so I'll give that a shot
> for v2.
> 
> > And why do we want to 'reset' the behavior of KVM when the host
> > schedules a VCPU thread?
> > 
> > If I understand the logic correctly, what you're establishing with the
> > appraoch of initially trapping use of ptrauth is to avoid
> > saving/restoring the state if the guest dosn't use ptrauth, but then if
> > the guest starts using it, it's likely to keep using it, and therefore
> > we start saving/restoring the registers.
> 
> Yes.
> 
> > Why is the host's decision to schedule something else on this physical
> > CPU a good indication that we should no longer save/restore these
> > registers for the VCPU?
> 
> I guess it's not.
> 
> Initially, I was followed the same approach we take for fpsimd, leaving
> the feature trapped until we take a shallow trap to hyp. Handing all the
> sysreg traps in hyp was unwieldy, so I moved that down to the kernel
> proper. That meant I couldn't enable the trap when switching from host
> to guest, and doing so in the regular context switch seemed like the
> next best option.
> 
> > Wouldn't it make more sense to have a flag on the VCPU, and
> > potentially a counter, so that if you switch X times without ever
> > touching the registers again, you can stop saving/restoring the state,
> > if that's even something we care about?
> 
> Something like that could make more sense. It should be fairly simple to
> implement a decaying counter to determine when to trap.
> 
> I'd steered clear of optimising the lazy heuristic as I'm testing with
> models, and I don't have numbers that would be representative of real
> HW.
> 
> > Another thing that comes to mind; does the kernel running a KVM's VCPU
> > thread (and handling softirqs, ISRs, etc.) ever use the ptrauth system,
> > or does that only happen when we go to userspace? 
> 
> Today, only userspace uses pointer auth, and the kernel does not.
> However, in-kernel usage is on the cards.
> 
> > If the latter, we could handle the save/restore entirely in
> > vcpu_put/vcpu_load instead. I don't mind picking up that bit as part
> > of my ongoing optimization work later though, if you're eager to get
> > these patches merged.
> 
> I'd avoided that so far, since it would be undone when in-kernel usage
> is implemented. If you prefer, I can implement that for now.
> 
> [...]
> 

I think we should just do a simple flag for now, and once we have
hardware and can measure things, we can add more advanced support like a
decaying counter or a doing this at vcpu_put/vcpu_load instead.

I can then deal with the headache of making sure this performs well on
systems that don't have the hardware support once things are merged,
because I'm looking at that already.

> > > +/*
> > > + * Handle the guest trying to use a ptrauth instruction, or trying to access a
> > > + * ptrauth register.
> > > + */
> > > +void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
> > > +{
> > > +	if (cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH) &&
> > > +	    cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH)) {
> > > +		kvm_arm_vcpu_ptrauth_enable(vcpu);
> > > +	} else {
> > > +		kvm_inject_undefined(vcpu);
> > 
> > How can we trap here without having ARM64_HAS_[ADDRESS,GENERIC]_AUTH ?
> 
> We'll trap if the current CPU supports one of the two (with an
> architected algorithm), but some other CPU does not (or uses an IMP DEF
> algorithm). Note that we're checking that all CPUs have the feature.
> 
> > If this to cover the case if we only have one of the two or is there a
> > case where we trap ptrauth registers/instructions even though the CPU
> > doesn't have the support?
> 
> It's there to cater for the case that some CPUs lack a feature that
> others have, so that we expose a uniform view to guests.
> 
> There's a single control to trap both address/generic authentication, so
> it has to check that support is uniform for both. 
> 
> I'd meant to fix this up to not be so pessimistic -- we could support
> one without that other, so long as it is uniformly absent. e.g. if all
> CPUs support address auth and all CPUs have no support for generic auth.
> 
> I'll need to add negative cpucaps to detect that. I'll try to sort that
> out for v2.
> 
> [...]
> 
> > > +static void __hyp_text __ptrauth_save_state(struct kvm_cpu_context *ctxt)
> > > +{
> > > +	if (cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH)) {
> > > +		__ptrauth_save_key(ctxt->sys_regs, APIA);
> > > +		__ptrauth_save_key(ctxt->sys_regs, APIB);
> > > +		__ptrauth_save_key(ctxt->sys_regs, APDA);
> > > +		__ptrauth_save_key(ctxt->sys_regs, APDB);
> > > +	}
> > > +
> > > +	if (cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH)) {
> > > +		__ptrauth_save_key(ctxt->sys_regs, APGA);
> > > +	}
> > 
> > Aren't we ever only enabling the save/restore if we have both caps, so
> > why are we checking it here again?
> 
> Sorry; I'd meant to fix things up so that we could support one without
> the other. Likewise for __ptrauth_restore_state().
> 
> I'll try to fix this up for v2.
> 

Sounds good.  Thanks for otherwise producing a well-readable patch.

-Christoffer
