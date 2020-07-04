Return-Path: <SRS0=R7UB=AP=lists.openwall.com=kernel-hardening-return-19216-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC374C433E0
	for <kernel-hardening@archiver.kernel.org>; Sat,  4 Jul 2020 15:11:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 36BB5214F1
	for <kernel-hardening@archiver.kernel.org>; Sat,  4 Jul 2020 15:11:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SSCGTrxS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36BB5214F1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19216-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16078 invoked by uid 550); 4 Jul 2020 15:11:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16052 invoked from network); 4 Jul 2020 15:11:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OOkooQcgZT8G2WjNcK+Cq5ASRRPbRLgNwU0mUCZTWZI=;
        b=SSCGTrxShtNJIdkHMwubUtEAPLob65gZ9Nz5GIsi4JTIzZCXrLS/99iaMWNLeILZZh
         dUCTc3VZFmhBFFLd6jSGUcZoz4xga8nOBy81G/6qLO+eDQFVHxsn45Hc+A2nfJbxQLQ3
         F/yWQeimUTBDQsKwVTH3jhKYtwL7xOf7lN40MjPuRNoNjMdHcoy12/g+hDD3lKHj4+yW
         4w2ihNFDM1x8cwKAZcSDup2S5B+BdcBesMzzm3szOfZD3uGB51X/o6qFL+ZwB749hzBe
         DWEjqvR/fDIzJeaw5zs0M8WY8K+4iXiLIzARk5Sn76TMP5jOkhrKt6AE/QYT8GXmRlM/
         0w3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=OOkooQcgZT8G2WjNcK+Cq5ASRRPbRLgNwU0mUCZTWZI=;
        b=j9jcCwZzT2qnObC9tshvazRTyhLmSO4qrGcm70syE5WbO5Xk7gA3wi5FJUTtEtymZ3
         itgNpnJsQZAFa34Di5TKVuM6T9ULBFjOxFe+3uudCNGE9Zskm8sum7vVC6L16FpkdjWx
         Hcea3ya0Fc+30QCJsAWEOLjlOsOA55K2CcPNJN41G4lSFMMOYJTuNLH0qz17+nWk+kvT
         i0sEnPQ1weU/gmU/luT3v2LTvNzfaMPagM00UcPvc+tTTgDP9knjFvw280BgFjho22sg
         3BKOAmOQfHWQpbpojcTXJiCfqpscGGubHvB6fLMCMUJtM6ls+zH/MLOYVIeYlN6VQE96
         YikA==
X-Gm-Message-State: AOAM5302zjf4JfNS1WppGGN6kF8L81M/Ol/Rne5GiRyS2lVu7lSLeZn7
	n37ImD3HPT31X6ENsT188Ns=
X-Google-Smtp-Source: ABdhPJyYWEY9xvrLxysif9VMRbbPNXdpPaaf7cVFq/ebirldMeLAaEYpHqI6t21b12ayi2VmWj4t2Q==
X-Received: by 2002:aed:2492:: with SMTP id t18mr42182035qtc.353.1593875484322;
        Sat, 04 Jul 2020 08:11:24 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Sat, 4 Jul 2020 11:11:21 -0400
To: "Andersen, John" <john.s.andersen@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Paolo Bonzini <pbonzini@redhat.com>,
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
Message-ID: <20200704151121.GA1611291@rani.riverdale.lan>
References: <20200617190757.27081-1-john.s.andersen@intel.com>
 <20200617190757.27081-5-john.s.andersen@intel.com>
 <CALCETrXwzQDDd1rfBW+ptmijEjc2cMqfWGvJu-qqrqia5Ls=Uw@mail.gmail.com>
 <20200623200334.GA23@6540770db1d7>
 <20200703214814.GA25@0e1a9e0069b7>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200703214814.GA25@0e1a9e0069b7>

On Fri, Jul 03, 2020 at 09:48:14PM +0000, Andersen, John wrote:
> > > Is there a plan for fixing this for real?  I'm wondering if there is a
> > > sane weakening of this feature that still allows things like kexec.
> > > 
> > 
> > I'm pretty sure kexec can be fixed. I had it working at one point, I'm
> > currently in the process of revalidating this. The issue was though that
> > kexec only worked within the guest, not on the physical host, which I suspect
> > is related to the need for supervisor pages to be mapped, which seems to be
> > required before enabling SMAP (based on what I'd seen with the selftests and
> > unittests). I was also just blindly turning on the bits without checking for
> > support when I'd tried this, so that could have been the issue too.
> > 
> > I think most of the changes for just blindly enabling the bits were in
> > relocate_kernel, secondary_startup_64, and startup_32.
> > 
> 
> So I have a naive fix for kexec which has only been tested to work under KVM.
> When tested on a physical host, it did not boot when SMAP or UMIP were set.
> Undoubtedly it's not the correct way to do this, as it skips CPU feature
> identification, opting instead for blindly setting the bits. The physical host
> I tested this on does not have UMIP so that's likely why it failed to boot when
> UMIP gets set blindly. Within kvm-unit-tests, the test for SMAP maps memory as
> supervisor pages before enabling SMAP. I suspect this is why setting SMAP
> blindly causes the physical host not to boot.
> 
> Within trampoline_32bit_src() if I add more instructions I get an error
> about "attempt to move .org backwards", which as I understand it means
> there are only so many instructions allowed in each of those functions.
> 
> My suspicion is that someone with more knowledge of this area has a good
> idea on how best to handle this. Feedback would be much appreciated.

You can simply increase the value of TRAMPOLINE_32BIT_CODE_SIZE in
pgtable.h, assuming you don't need a very large increase. There's one
page available for code + stack at present.
