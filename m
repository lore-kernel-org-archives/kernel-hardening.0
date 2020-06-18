Return-Path: <SRS0=CCNu=77=lists.openwall.com=kernel-hardening-return-19026-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC619C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jun 2020 15:53:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 54E962070A
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jun 2020 15:53:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54E962070A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19026-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14102 invoked by uid 550); 18 Jun 2020 15:53:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14081 invoked from network); 18 Jun 2020 15:53:09 -0000
IronPort-SDR: cIqy8XnQ55bmbiD71Ml1SxiOd+fNhcMT+6iFqfuI7Y+deFEI9UBMepNQsuWfMkyInxjzbbeGs2
 4Mhm3kz3xgzA==
X-IronPort-AV: E=McAfee;i="6000,8403,9656"; a="122385482"
X-IronPort-AV: E=Sophos;i="5.75,251,1589266800"; 
   d="scan'208";a="122385482"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: Rz7wj+h3c6y5PnE7mt0HLs+WCimZP8shyO9jjYR92TH5XPP+l4Rs1D7su9MB1R/gF705XCWoaj
 /weqIcFrTVQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,251,1589266800"; 
   d="scan'208";a="277665815"
Date: Thu, 18 Jun 2020 15:49:32 +0000
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
Message-ID: <20200618154931.GD23@258ff54ff3c0>
References: <20200617190757.27081-1-john.s.andersen@intel.com>
 <20200617190757.27081-5-john.s.andersen@intel.com>
 <b5d791f9-1708-9715-e03d-4618d1b27d05@intel.com>
 <20200618152649.GC23@258ff54ff3c0>
 <5706af0c-e426-91bc-4c38-d1203cf1b3b7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5706af0c-e426-91bc-4c38-d1203cf1b3b7@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)

On Thu, Jun 18, 2020 at 08:38:06AM -0700, Dave Hansen wrote:
> On 6/18/20 8:26 AM, Andersen, John wrote:
> > On Thu, Jun 18, 2020 at 07:41:04AM -0700, Dave Hansen wrote:
> >>> +config PARAVIRT_CR_PIN
> >>> +       bool "Paravirtual bit pinning for CR0 and CR4"
> >>> +       depends on KVM_GUEST
> >>> +       help
> >>> +         Select this option to have the virtualised guest request that the
> >>> +         hypervisor disallow it from disabling protections set in control
> >>> +         registers. The hypervisor will prevent exploits from disabling
> >>> +         features such as SMEP, SMAP, UMIP, and WP.
> >>
> >> I'm confused.  Does this add support for ""Paravirtual bit pinning", or
> >> actually tell the guest to request pinning by default?
> >>
> >> It says "Select this option to have the virtualised guest request...",
> >> which makes it sound like it affects the default rather than the
> >> availability of the option.
> > 
> > How about this
> > 
> > Select this option to request protection of SMEP, SMAP, UMIP, and WP
> > control register bits when running paravirtualized under KVM. Protection will
> > be active provided the feature is available host side and kexec is disabled via
> > kconfig or the command line for the guest requesting protection.
> 
> It still isn't very clear to me.
> 
> Let's pull the config option out of this patch.  Enable the feature by
> default and do the command-line processing in this patch.
> 
> If you still think a Kconfig option is helpful, add it in a separate
> patch calling out the deficiencies with the boot-time options.

That's right we're going to pull it out anyway and just disable if the
disable_pv_cr_pin command line option is set. Oops. That solves that.

Thank you very much for your review Dave
