Return-Path: <SRS0=gwlE=77=lists.openwall.com=kernel-hardening-return-19017-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A94DCC433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jun 2020 14:01:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0F38320656
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jun 2020 14:01:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F38320656
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19017-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20317 invoked by uid 550); 18 Jun 2020 14:01:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9268 invoked from network); 18 Jun 2020 13:35:35 -0000
IronPort-SDR: SJRLd7JE/zGfCGulauuW6IeYTn5jLQEJFP+CWtBW6iI5UKqyTYvE2Ma0gWovLv3tyVe61DAowy
 8jL/xiIYkX6w==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="129909413"
X-IronPort-AV: E=Sophos;i="5.73,526,1583222400"; 
   d="scan'208";a="129909413"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: dC+UKz9z8EPRe5pE9bo991HFfRGNF1ADcjBGu33/TZvtX24g1aacuLygl1/kwlAWN8EbY8nhny
 MLRZQvUSQ3Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,526,1583222400"; 
   d="scan'208";a="421500098"
Date: Thu, 18 Jun 2020 13:31:57 +0000
From: "Andersen, John" <john.s.andersen@intel.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: corbet@lwn.net, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
	bp <bp@alien8.de>, hpa@zytor.com, shuah@kernel.org,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	rick.p.edgecombe@intel.com, kvm <kvm@vger.kernel.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: [kvm-unit-tests PATCH] x86: Add control register pinning tests
Message-ID: <20200618133157.GA23@258ff54ff3c0>
References: <20200617224606.27954-1-john.s.andersen@intel.com>
 <ACCCF382-0077-4B08-8CF1-73C561F930CD@gmail.com>
 <5D576A1A-AD52-4BB1-A514-1E6641982465@gmail.com>
 <20200618050834.GA23@0d4958db2004>
 <FAFB5DA6-FA6F-4A1A-AB10-4B99F314B23D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FAFB5DA6-FA6F-4A1A-AB10-4B99F314B23D@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)

On Wed, Jun 17, 2020 at 11:59:10PM -0700, Nadav Amit wrote:
> > On Jun 17, 2020, at 10:08 PM, Andersen, John <john.s.andersen@intel.com> wrote:
> > 
> > On Wed, Jun 17, 2020 at 08:18:39PM -0700, Nadav Amit wrote:
> >>> On Jun 17, 2020, at 3:52 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
> >>> 
> >>>> On Jun 17, 2020, at 3:46 PM, John Andersen <john.s.andersen@intel.com> wrote:
> >>>> 
> >>>> Paravirutalized control register pinning adds MSRs guests can use to
> >>>> discover which bits in CR0/4 they may pin, and MSRs for activating
> >>>> pinning for any of those bits.
> >>> 
> >>> [ sni[
> >>> 
> >>>> +static void vmx_cr_pin_test_guest(void)
> >>>> +{
> >>>> +	unsigned long i, cr0, cr4;
> >>>> +
> >>>> +	/* Step 1. Skip feature detection to skip handling VMX_CPUID */
> >>>> +	/* nop */
> >>> 
> >>> I do not quite get this comment. Why do you skip checking whether the
> >>> feature is enabled? What happens if KVM/bare-metal/other-hypervisor that
> >>> runs this test does not support this feature?
> >> 
> >> My bad, I was confused between the nested checks and the non-nested ones.
> >> 
> >> Nevertheless, can we avoid situations in which
> >> rdmsr(MSR_KVM_CR0_PIN_ALLOWED) causes #GP when the feature is not
> >> implemented? Is there some protocol for detection that this feature is
> >> supported by the hypervisor, or do we need something like rdmsr_safe()?
> > 
> > Ah, yes we can. By checking the CPUID for the feature bit. Thanks for pointing
> > this out, I was confused about this. I was operating under the assumption that
> > the unit tests assume the features in the latest kvm/next are present and
> > available when the unit tests are being run.
> > 
> > I'm happy to add the check, but I haven't see anywhere else where a
> > KVM_FEATURE_ was checked for. Which is why it doesn't check in this patch. As
> > soon as I get an answer from you or anyone else as to if the unit tests assume
> > that the features in the latest kvm/next are present and available or not when
> > the unit tests are being run I'll modify if necessary.
> 
> I would appreciate if you add a check of CPUID and not run the test if the 
> feature is not supported.
> 
> I run the tests on bare-metal (and other non-KVM environment) from time to
> time. Doing so allows to find bugs in tests due to wrong assumptions of KVM
> test developers. Liran runs the tests using QEMU/WHPX (non-KVM). So allowing
> the tests to run on non-KVM environments is important, at least for some of
> us, and benefits KVM as well.
> 
> While I can disable this specific test using the test parameters, I prefer
> that the test will first check the environment they run on. Debugging test
> failures on bare-metal is hard enough without the paravirt stuff noise.
> 

Great point! I'll add the check
