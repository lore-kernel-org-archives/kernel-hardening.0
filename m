Return-Path: <SRS0=nTuq=A2=lists.openwall.com=kernel-hardening-return-19323-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A38C433E5
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Jul 2020 04:41:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EFAD0206F4
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Jul 2020 04:41:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFAD0206F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19323-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16149 invoked by uid 550); 15 Jul 2020 04:41:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16127 invoked from network); 15 Jul 2020 04:41:43 -0000
IronPort-SDR: 7+gbHk9TGl0TnuAGPwjjxCqN8gS0Xty5krmKvEJ1QWDwuTmGBeLLIaxR30Tg3h+c/3FB6EZFRe
 LeW2XCz1C3YQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="136537831"
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="136537831"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: tPAxt0Zb++8MhxgPdx85urOug4eGehmIUtSsXwHJnIU25SvJTEXBjkPDzwgnNFwqot1XcoyHDU
 qgn6I8SLpFow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="326050554"
Date: Tue, 14 Jul 2020 21:41:29 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: "Andersen, John" <john.s.andersen@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	Arvind Sankar <nivedita@alum.mit.edu>,
	Dave Hansen <dave.hansen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Shuah Khan <shuah@kernel.org>, Liran Alon <liran.alon@oracle.com>,
	Andrew Jones <drjones@redhat.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Juergen Gross <jgross@suse.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Oliver Neukum <oneukum@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Fenghua Yu <fenghua.yu@intel.com>, reinette.chatre@intel.com,
	vineela.tummalapalli@intel.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>, caoj.fnst@cn.fujitsu.com,
	Baoquan He <bhe@redhat.com>, Kees Cook <keescook@chromium.org>,
	Dan Williams <dan.j.williams@intel.com>, eric.auger@redhat.com,
	aaronlewis@google.com, Peter Xu <peterx@redhat.com>,
	makarandsonare@google.com,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 2/4] KVM: x86: Introduce paravirt feature CR0/CR4 pinning
Message-ID: <20200715044129.GA11248@linux.intel.com>
References: <124a59a3-a603-701b-e3bb-61e83d70b20d@intel.com>
 <20200707211244.GN20096@linux.intel.com>
 <19b97891-bbb0-1061-5971-549a386f7cfb@intel.com>
 <31eb5b00-9e2a-aa10-0f20-4abc3cd35112@redhat.com>
 <20200709154412.GA25@64c96d3be97b>
 <af6ac772-318d-aab0-ce5f-55cf92f6e96d@intel.com>
 <CALCETrWxt0CHUoonWX1fgbM46ydJPQZhj8Q=G+45EG4wW3wZqQ@mail.gmail.com>
 <6040c3b3-cac9-cc0e-f0de-baaa274920a2@intel.com>
 <CALCETrUHcpqjDfAM9SbrZUM7xcS2wkVm=r1Nb1JmxV7A-KAeUQ@mail.gmail.com>
 <20200714053930.GC25@760745902f30>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714053930.GC25@760745902f30>
User-Agent: Mutt/1.5.24 (2015-08-30)

On Tue, Jul 14, 2020 at 05:39:30AM +0000, Andersen, John wrote:
> With regards to FSGSBASE, are we open to validating and adding that to the
> DEFAULT set as a part of a separate patchset? This patchset is focused on
> replicating the functionality we already have natively.

Kees added FSGSBASE pinning in commit a13b9d0b97211 ("x86/cpu: Use pinning
mask for CR4 bits needing to be 0"), so I believe it's a done deal already.
