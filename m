Return-Path: <SRS0=S0M0=77=lists.openwall.com=kernel-hardening-return-19024-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67736C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jun 2020 15:31:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 95D7920888
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jun 2020 15:31:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95D7920888
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19024-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32544 invoked by uid 550); 18 Jun 2020 15:31:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32282 invoked from network); 18 Jun 2020 15:30:51 -0000
IronPort-SDR: nmJEerFXfbu0hcsk5fVTAm9JhI2d68DwJFV9Avtsf/VG4tSxSovr/lgG8SV/Sr+6RPu6WYMeML
 KVPkZErMAW5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9656"; a="129976633"
X-IronPort-AV: E=Sophos;i="5.75,251,1589266800"; 
   d="scan'208";a="129976633"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: WROgerYzKmTQH4UQXU0nCZWlLMiHJodkq1CEw2NG8m6g1SuQ6bhFSRp7Haddsr6Frx9rjS1xy5
 adv9/LVS/Lgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,251,1589266800"; 
   d="scan'208";a="262954355"
Date: Thu, 18 Jun 2020 15:26:49 +0000
From: "Andersen, John" <john.s.andersen@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: corbet@lwn.net, pbonzini@redhat.com, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
	shuah@kernel.org, sean.j.christopherson@intel.com,
	liran.alon@oracle.com, drjones@redhat.com,
	rick.p.edgecombe@intel.com, kristen@linux.intel.com,
	vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
	joro@8bytes.org, mchehab+huawei@kernel.org,
	gregkh@linuxfoundation.org, paulmck@kernel.org,
	pawan.kumar.gupta@linux.intel.com, jgross@suse.com,
	mike.kravetz@oracle.com, oneukum@suse.com, luto@kernel.org,
	peterz@infradead.org, fenghua.yu@intel.com,
	reinette.chatre@intel.com, vineela.tummalapalli@intel.com,
	dave.hansen@linux.intel.com, arjan@linux.intel.com,
	caoj.fnst@cn.fujitsu.com, bhe@redhat.com, nivedita@alum.mit.edu,
	keescook@chromium.org, dan.j.williams@intel.com,
	eric.auger@redhat.com, aaronlewis@google.com, peterx@redhat.com,
	makarandsonare@google.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH 4/4] X86: Use KVM CR pin MSRs
Message-ID: <20200618152649.GC23@258ff54ff3c0>
References: <20200617190757.27081-1-john.s.andersen@intel.com>
 <20200617190757.27081-5-john.s.andersen@intel.com>
 <b5d791f9-1708-9715-e03d-4618d1b27d05@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5d791f9-1708-9715-e03d-4618d1b27d05@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)

On Thu, Jun 18, 2020 at 07:41:04AM -0700, Dave Hansen wrote:
> On 6/17/20 12:07 PM, John Andersen wrote:
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index 89386f6f3ab6..54fb2b5ab8fc 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -3926,6 +3926,17 @@
> >  			[KNL] Number of legacy pty's. Overwrites compiled-in
> >  			default number.
> >  
> > +	pv_cr_pin	[SECURITY,X86]
> > +			Enable paravirtualized control register pinning. When
> > +			running paravirutalized under KVM, request that KVM not
> > +			allow the guest to disable kernel protection features
> > +			set in CPU control registers. Specifying this option
> > +			will disable kexec (and crashkernel). If kexec support
> > +			has not been compiled into the kernel and host KVM
> > +			supports paravirtualized control register pinning, it
> > +			will be active by default without the need to specify
> > +			this parameter.
> 
> I'm writing this last in my review.  I guess I should have read this
> first.  You'll see later in my review how this confused me.  This
> behavior needs to be documented elsewhere.  Code comments would be best.
> 

Will do. Sorry for the confusion.

> Let's say kexec is config'd off.  This feature is enabled by default and
> crashes the kernel in early boot.  I have no way to disable this fancy
> new feature.  Is that what we want?
> 
> I also think that instead of having to *enable* this explicitly when
> kexec is present, maybe we should have a "disable_kexec" parameter.  If
> kexec is configured out or disabled on the command-line, then you can
> turn CR pinning on.
> 
> If someone fails to kexec() because of this feature, there's no way in
> hell they'll ever track down "pv_cr_pin" on the command-line as the
> cause.  The might have a chance of finding disable_kexec, though.
> 
> Wouldn't it also be nice to add a single printk() the first time a kexec
> fails because of this feature being present?
> 

That sounds like a good plan. I'll change pv_cr_pin to disable_kexec, and add a
disable_pv_cr_pin option in case it's being on by default via the compile time
option breaks a users workflow at runtime.

In this case, I'm assuming we can do away with the kconfig option then.

Just have it enabled by default. If kexec is present, it's disabled by default,
unless kexec is disabled, in which case, pinning is enabled unless
disable_pv_cr_pin is set.

> >  	quiet		[KNL] Disable most log messages
> >  
> >  	r128=		[HW,DRM]
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 67f6a40b5e93..bc0b27483001 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -800,6 +800,7 @@ config KVM_GUEST
> >  	bool "KVM Guest support (including kvmclock)"
> >  	depends on PARAVIRT
> >  	select PARAVIRT_CLOCK
> > +	select PARAVIRT_CR_PIN
> >  	select ARCH_CPUIDLE_HALTPOLL
> >  	default y
> >  	---help---
> > @@ -835,6 +836,15 @@ config PARAVIRT_TIME_ACCOUNTING
> >  config PARAVIRT_CLOCK
> >  	bool
> >  
> > +config PARAVIRT_CR_PIN
> > +       bool "Paravirtual bit pinning for CR0 and CR4"
> > +       depends on KVM_GUEST
> > +       help
> > +         Select this option to have the virtualised guest request that the
> > +         hypervisor disallow it from disabling protections set in control
> > +         registers. The hypervisor will prevent exploits from disabling
> > +         features such as SMEP, SMAP, UMIP, and WP.
> 
> I'm confused.  Does this add support for ""Paravirtual bit pinning", or
> actually tell the guest to request pinning by default?
> 
> It says "Select this option to have the virtualised guest request...",
> which makes it sound like it affects the default rather than the
> availability of the option.
> 

How about this

Select this option to request protection of SMEP, SMAP, UMIP, and WP
control register bits when running paravirtualized under KVM. Protection will
be active provided the feature is available host side and kexec is disabled via
kconfig or the command line for the guest requesting protection.

> > +#ifdef CONFIG_PARAVIRT_CR_PIN
> > +void __init kvm_paravirt_cr_pinning_init(void);
> > +void kvm_setup_paravirt_cr_pinning(unsigned long cr0_pinned_bits,
> > +				   unsigned long cr4_pinned_bits);
> > +#else
> > +static inline void kvm_paravirt_cr_pinning_init(void)
> > +{
> > +	return;
> > +}
> > +
> > +static inline void kvm_setup_paravirt_cr_pinning(unsigned long cr0_pinned_bits,
> > +						 unsigned long cr4_pinned_bits)
> > +{
> > +	return;
> > +}
> > +#endif /* CONFIG_PARAVIRT_CR_PIN */
> 
> For stuff like this that isn't the least bit performance sensitive, I
> usually don't bother with header stubs.  Just do the function
> declaration and then check the config option in the .c code.  It saves
> #ifdef noise in the header.
> 

Sounds good

> >  #endif /* _ASM_X86_KVM_PARA_H */
> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index 921e67086a00..ee17223b1fa8 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -21,6 +21,7 @@
> >  #include <linux/smp.h>
> >  #include <linux/io.h>
> >  #include <linux/syscore_ops.h>
> > +#include <linux/kvm_para.h>
> >  
> >  #include <asm/stackprotector.h>
> >  #include <asm/perf_event.h>
> > @@ -416,6 +417,8 @@ static void __init setup_cr_pinning(void)
> >  	mask = (X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP);
> >  	cr4_pinned_bits = this_cpu_read(cpu_tlbstate.cr4) & mask;
> >  	static_key_enable(&cr_pinning.key);
> > +
> > +	kvm_setup_paravirt_cr_pinning(X86_CR0_WP, cr4_pinned_bits);
> >  }
> >  
> >  /*
> > @@ -1551,6 +1554,8 @@ void identify_secondary_cpu(struct cpuinfo_x86 *c)
> >  	mtrr_ap_init();
> >  	validate_apic_and_package_id(c);
> >  	x86_spec_ctrl_setup_ap();
> > +
> > +	kvm_setup_paravirt_cr_pinning(X86_CR0_WP, cr4_pinned_bits);
> >  }
> 
> WP looks like it get special handling here.  But, why it is special goes
> unmentioned in the changelog or comments.
> 
> Why is it special?
> 

We're copying the behavior of native_write_cr0() which assumes we always have
WP and can set it / it always must be set.

With CR4 we leverage the fact that setup_cr_pinning() initializes
cr4_pinned_bits that contains bits enabled during feature identification
and masked with what native pinning cares about. This ensures we pin the same
bits with paravirtualized pinning that we're already pinning natively.

I'll mention it in the commit message for v2.

> > +#ifdef CONFIG_PARAVIRT_CR_PIN
> > +static int kvm_paravirt_cr_pinning_enabled __ro_after_init;
> > +
> > +void __init kvm_paravirt_cr_pinning_init(void)
> > +{
> > +#ifdef CONFIG_KEXEC_CORE
> > +	if (!cmdline_find_option_bool(boot_command_line, "pv_cr_pin"))
> > +		return;
> > +
> > +	/* Paravirtualized CR pinning is currently incompatible with kexec */
> > +	kexec_load_disabled = 1;
> > +#endif
> > +
> > +	kvm_paravirt_cr_pinning_enabled = 1;
> > +}
> 
> This is why we don't like #ifdefs in .c files.  The CONFIG_KEXEC_CORE
> one really makes this unreadable.
> 
> This is really confusing because it says, if "CONFIG_KEXEC_CORE" is off,
> don't bother with looking for "pv_cr_pin" on the command-line before
> setting kvm_paravirt_cr_pinning_enabled=1.  That doesn't make any sense
> to me.
> 

I think this will be clearer when we change the command like options to
disable_. I'll be sure to use IS_ENABLED next time, my bad I forgot here.

> > +void kvm_setup_paravirt_cr_pinning(unsigned long cr0_pinned_bits,
> > +				   unsigned long cr4_pinned_bits)
> > +{
> > +	u64 mask;
> > +
> > +	if (!kvm_paravirt_cr_pinning_enabled)
> > +		return;
> > +
> > +	if (!kvm_para_has_feature(KVM_FEATURE_CR_PIN))
> > +		return;
> 
> So, if we compiled this whole mess in and got the new command-line
> parameter and we got all the way here and the host doesn't support it,
> we silently return?
> 
> Seems like it would at least deserve a pr_info().
> 

Will do. I'll probably use a rate limited variant because this happens for each
CPU.

> > +	rdmsrl(MSR_KVM_CR0_PIN_ALLOWED, mask);
> > +	wrmsrl(MSR_KVM_CR0_PINNED_HIGH, cr0_pinned_bits & mask);
> > +
> > +	rdmsrl(MSR_KVM_CR4_PIN_ALLOWED, mask);
> > +	wrmsrl(MSR_KVM_CR4_PINNED_HIGH, cr4_pinned_bits & mask);
> > +}
> > +#endif
> > +
> >  #ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
> >  
> >  static void kvm_disable_host_haltpoll(void *i)
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index d9c678b37a9b..ed3bcc85d40d 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -27,6 +27,9 @@
> >  #include <asm/apic.h>
> >  #include <asm/bios_ebda.h>
> >  #include <asm/bugs.h>
> > +#include <asm/kasan.h>
> > +#include <asm/cmdline.h>
> > +
> >  #include <asm/cpu.h>
> >  #include <asm/efi.h>
> >  #include <asm/gart.h>
> > @@ -502,6 +505,11 @@ static void __init reserve_crashkernel(void)
> >  		return;
> >  	}
> >  
> > +	if (cmdline_find_option_bool(boot_command_line, "pv_cr_pin")) {
> > +		pr_info("Ignoring crashkernel since pv_cr_pin present in cmdline\n");
> > +		return;
> > +	}
> 
> Isn't it a bit mean to ignore crashkernel if the kernel has
> CONFIG_PARAVIRT_CR_PIN=n?
> 

Yes that is mean :) I will change this. There is of course no need to check for
this option if the config isn't enabled.
