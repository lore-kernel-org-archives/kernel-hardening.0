Return-Path: <SRS0=TKfF=AS=lists.openwall.com=kernel-hardening-return-19243-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A70AC433DF
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jul 2020 21:13:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D60B720672
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jul 2020 21:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D60B720672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19243-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11479 invoked by uid 550); 7 Jul 2020 21:12:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11457 invoked from network); 7 Jul 2020 21:12:56 -0000
IronPort-SDR: 451z+ICTrI5Ka6fo/ekfiL0ECiRgEI9Pwf3OgqDTTu2nDgxS1CU2KgrTGV+Ehi13KE8d7dFI3P
 4M5VWrbl839w==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="232559719"
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="232559719"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: JTcQq4O8pgB/WDWxc4jQef5Ro2nDaeHPpTG34Y0JkkFdPUSm/D+lUIgdm39EQVE4KKKPmr10aY
 4I46+pIegejw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="279735787"
Date: Tue, 7 Jul 2020 14:12:44 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Andersen, John" <john.s.andersen@intel.com>, corbet@lwn.net,
	pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, x86@kernel.org, hpa@zytor.com, shuah@kernel.org,
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
Subject: Re: [PATCH 2/4] KVM: x86: Introduce paravirt feature CR0/CR4 pinning
Message-ID: <20200707211244.GN20096@linux.intel.com>
References: <20200617190757.27081-1-john.s.andersen@intel.com>
 <20200617190757.27081-3-john.s.andersen@intel.com>
 <0fa9682e-59d4-75f7-366f-103d6b8e71b8@intel.com>
 <20200618144314.GB23@258ff54ff3c0>
 <124a59a3-a603-701b-e3bb-61e83d70b20d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <124a59a3-a603-701b-e3bb-61e83d70b20d@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)

On Thu, Jun 18, 2020 at 07:51:10AM -0700, Dave Hansen wrote:
> On 6/18/20 7:43 AM, Andersen, John wrote:
> > On Thu, Jun 18, 2020 at 07:18:09AM -0700, Dave Hansen wrote:
> >> On 6/17/20 12:07 PM, John Andersen wrote:
> >>> +#define KVM_CR0_PIN_ALLOWED	(X86_CR0_WP)
> >>> +#define KVM_CR4_PIN_ALLOWED	(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP)
> >>
> >> Why *is* there an allowed set?  Why don't we just allow everything?
> >>
> >> Shouldn't we also pin any unknown bits?  The CR4.FSGSBASE bit is an
> >> example of something that showed up CPUs without Linux knowing about it.
> >>  If set, it causes problems.  This set couldn't have helped FSGSBASE
> >> because it is not in the allowed set.
> >>
> >> Let's say Intel loses its marbles and adds a CR4 bit that lets userspace
> >> write to kernel memory.  Linux won't set it, but an attacker would go
> >> after it, first thing.

That's an orthogonal to pinning.  KVM never lets the guest set CR4 bits that
are unknown to KVM.  Supporting CR4.NO_MARBLES would require an explicit KVM
change to allow it to be set by the guest, and would also require a userspace
VMM to expose NO_MARBLES to the guest.

That being said, this series should supporting pinning as much as possible,
i.e. if the bit can be exposed to the guest and doesn't require special
handling in KVM, allow it to be pinned.  E.g. TS is a special case because
pinning would require additional emulator support and IMO isn't interesting
enough to justify the extra complexity.  At a glance, I don't see anything
that would prevent pinning FSGSBASE.
