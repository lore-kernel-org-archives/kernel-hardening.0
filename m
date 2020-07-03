Return-Path: <SRS0=LGFX=AO=lists.openwall.com=kernel-hardening-return-19213-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED56C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Jul 2020 21:52:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ED0FF2145D
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Jul 2020 21:52:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED0FF2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19213-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32068 invoked by uid 550); 3 Jul 2020 21:52:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32046 invoked from network); 3 Jul 2020 21:52:00 -0000
IronPort-SDR: /mDfp86hH6jz5WwpJU+tnFcL/UXxHyslrxQjnznFuRD2mRtfuQ5KB868yllcqaR3tYsG6Rzpkn
 zZHUuKyHOG6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9671"; a="208719130"
X-IronPort-AV: E=Sophos;i="5.75,309,1589266800"; 
   d="scan'208";a="208719130"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: gaU4VT34QuPfGir0q6IPf5xgGynQHvqGIU4X2zuJsg907nbT3IOqyOq2GXWmUNG7y4mTdaNYuf
 JMcfPOCcT6QQ==
X-IronPort-AV: E=Sophos;i="5.75,309,1589266800"; 
   d="scan'208";a="456007914"
Date: Fri, 3 Jul 2020 21:48:14 +0000
From: "Andersen, John" <john.s.andersen@intel.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Shuah Khan <shuah@kernel.org>,
	"Christopherson, Sean J" <sean.j.christopherson@intel.com>,
	Liran Alon <liran.alon@oracle.com>,
	Andrew Jones <drjones@redhat.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
	mchehab+huawei@kernel.org, Greg KH <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	pawan.kumar.gupta@linux.intel.com, Juergen Gross <jgross@suse.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Oliver Neukum <oneukum@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Fenghua Yu <fenghua.yu@intel.com>, reinette.chatre@intel.com,
	vineela.tummalapalli@intel.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>, caoj.fnst@cn.fujitsu.com,
	Baoquan He <bhe@redhat.com>, Arvind Sankar <nivedita@alum.mit.edu>,
	Kees Cook <keescook@chromium.org>,
	Geremy Condra <geremy.condra@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, eric.auger@redhat.com,
	aaronlewis@google.com, Peter Xu <peterx@redhat.com>,
	makarandsonare@google.com,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 4/4] X86: Use KVM CR pin MSRs
Message-ID: <20200703214814.GA25@0e1a9e0069b7>
References: <20200617190757.27081-1-john.s.andersen@intel.com>
 <20200617190757.27081-5-john.s.andersen@intel.com>
 <CALCETrXwzQDDd1rfBW+ptmijEjc2cMqfWGvJu-qqrqia5Ls=Uw@mail.gmail.com>
 <20200623200334.GA23@6540770db1d7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623200334.GA23@6540770db1d7>
User-Agent: Mutt/1.5.24 (2015-08-30)

> > Is there a plan for fixing this for real?  I'm wondering if there is a
> > sane weakening of this feature that still allows things like kexec.
> > 
> 
> I'm pretty sure kexec can be fixed. I had it working at one point, I'm
> currently in the process of revalidating this. The issue was though that
> kexec only worked within the guest, not on the physical host, which I suspect
> is related to the need for supervisor pages to be mapped, which seems to be
> required before enabling SMAP (based on what I'd seen with the selftests and
> unittests). I was also just blindly turning on the bits without checking for
> support when I'd tried this, so that could have been the issue too.
> 
> I think most of the changes for just blindly enabling the bits were in
> relocate_kernel, secondary_startup_64, and startup_32.
> 

So I have a naive fix for kexec which has only been tested to work under KVM.
When tested on a physical host, it did not boot when SMAP or UMIP were set.
Undoubtedly it's not the correct way to do this, as it skips CPU feature
identification, opting instead for blindly setting the bits. The physical host
I tested this on does not have UMIP so that's likely why it failed to boot when
UMIP gets set blindly. Within kvm-unit-tests, the test for SMAP maps memory as
supervisor pages before enabling SMAP. I suspect this is why setting SMAP
blindly causes the physical host not to boot.

Within trampoline_32bit_src() if I add more instructions I get an error
about "attempt to move .org backwards", which as I understand it means
there are only so many instructions allowed in each of those functions.

My suspicion is that someone with more knowledge of this area has a good
idea on how best to handle this. Feedback would be much appreciated.

> > There's no SMEP or SMAP in real mode, and real mode has basically no security
> > mitigations at all.
> > 
> 
> We'd thought about the switch to real mode being a case where we'd want to drop
> pinning. However, we weren't sure how much weaker, if at all, it makes this
> protection.
> 
> Unless someone knows, I'll probably need to do some digging into what an
> exploit might look like that tries switching to real mode and switching back as
> a way around this protection.
> 

TL;DR We probably shouldn't use the switch to real mode as a trigger to drop
pinning.

This protection assumes that the attacker is at the point where they have the
ability to write a payload for a ROP/JOP attack and gain control of execution.

For this case where we are going to switch to real mode we need to add an
assumption that the attacker has a write primitive that allows them to write
part of their payload to memory that will be addressable within 16 bit mode.

If the attacker has this write primitive, the attack becomes write payloads,
within the first stage, switch to real mode, use stage two within real mode via
JOP or just machine code (since there's we don't have to worry NX) to setup
protected mode and jump back into the kernel with protections disabled.

> > PCID is an odd case.  I see no good reason to pin it, and pinning PCID
> > on prevents use of 32-bit mode.
> 
> Maybe it makes sense to default to the values we have, but allow host userspace
> to overwrite the allowed values, in case some other guest OS wants to do
> something that Linux doesn't with PCID or other bits.

In the next version of this patchset I've made it so that the default allowed
values are WP, SMEP, SMAP, and UMIP. However, a write to the allowed MSR from
the host VMM (QEMU) can change which bits are allowed.
