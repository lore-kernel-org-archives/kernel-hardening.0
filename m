Return-Path: <SRS0=q/80=77=lists.openwall.com=kernel-hardening-return-19016-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B74BC433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jun 2020 11:55:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C7A5520706
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jun 2020 11:55:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7A5520706
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19016-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20454 invoked by uid 550); 18 Jun 2020 11:55:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13534 invoked from network); 18 Jun 2020 05:12:12 -0000
IronPort-SDR: FNJZPExPebZmUON3mxCwHu5viLM9YE6Fbw6JQ6OI0yzIReQV5YtyS8+mTf35gI4WqCDNdtBb4N
 bU/oI32VtxDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="160505069"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="160505069"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: OXb5NSzxB72WuZdRrvbctj70C73fuOeVrJ6QxUt24UBMGvFTvMuuEJ1flE6DRi0OJkAkchjRd8
 K2gj1Lab20dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="277506375"
Date: Thu, 18 Jun 2020 05:08:34 +0000
From: "Andersen, John" <john.s.andersen@intel.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: corbet@lwn.net, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
	bp <bp@alien8.de>, hpa@zytor.com, shuah@kernel.org,
	sean.j.christopherson@intel.com, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [kvm-unit-tests PATCH] x86: Add control register pinning tests
Message-ID: <20200618050834.GA23@0d4958db2004>
References: <20200617224606.27954-1-john.s.andersen@intel.com>
 <ACCCF382-0077-4B08-8CF1-73C561F930CD@gmail.com>
 <5D576A1A-AD52-4BB1-A514-1E6641982465@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D576A1A-AD52-4BB1-A514-1E6641982465@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)

On Wed, Jun 17, 2020 at 08:18:39PM -0700, Nadav Amit wrote:
> > On Jun 17, 2020, at 3:52 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
> > 
> >> On Jun 17, 2020, at 3:46 PM, John Andersen <john.s.andersen@intel.com> wrote:
> >> 
> >> Paravirutalized control register pinning adds MSRs guests can use to
> >> discover which bits in CR0/4 they may pin, and MSRs for activating
> >> pinning for any of those bits.
> > 
> > [ sni[
> > 
> >> +static void vmx_cr_pin_test_guest(void)
> >> +{
> >> +	unsigned long i, cr0, cr4;
> >> +
> >> +	/* Step 1. Skip feature detection to skip handling VMX_CPUID */
> >> +	/* nop */
> > 
> > I do not quite get this comment. Why do you skip checking whether the
> > feature is enabled? What happens if KVM/bare-metal/other-hypervisor that
> > runs this test does not support this feature?
> 
> My bad, I was confused between the nested checks and the non-nested ones.
> 
> Nevertheless, can we avoid situations in which
> rdmsr(MSR_KVM_CR0_PIN_ALLOWED) causes #GP when the feature is not
> implemented? Is there some protocol for detection that this feature is
> supported by the hypervisor, or do we need something like rdmsr_safe()?
> 

Ah, yes we can. By checking the CPUID for the feature bit. Thanks for pointing
this out, I was confused about this. I was operating under the assumption that
the unit tests assume the features in the latest kvm/next are present and
available when the unit tests are being run.

I'm happy to add the check, but I haven't see anywhere else where a
KVM_FEATURE_ was checked for. Which is why it doesn't check in this patch. As
soon as I get an answer from you or anyone else as to if the unit tests assume
that the features in the latest kvm/next are present and available or not when
the unit tests are being run I'll modify if necessary.

Thanks,
John
