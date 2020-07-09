Return-Path: <SRS0=+GgZ=AU=lists.openwall.com=kernel-hardening-return-19271-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225E5C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Jul 2020 16:08:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 735E320767
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Jul 2020 16:08:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZAynSmU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 735E320767
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19271-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20221 invoked by uid 550); 9 Jul 2020 16:08:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20192 invoked from network); 9 Jul 2020 16:08:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594310877;
	bh=JUmw1X/O2J1u9wpP6OEH/aowCY0moHlf7P1wrYc/PLc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gZAynSmUWzClCmnP92CBYaVxcvm5NxtnoJvUPPGv2r6++mOzNV2dBq+EXB0hHN1Ve
	 14Kyh4cmo9zS9zORxL2XuhSqcwtaHKFdZqAWVmRD7wd9uz1CGtrpzlj179bOBbbWyE
	 w8cGeUIaA3QEb7KmOBhtJSyrRalmrqXhk6jTMgWU=
X-Gm-Message-State: AOAM533noxaGSZElILux0EM6RPtWZwl80dqHApsyt6elNKyifPTWJY+M
	g4In0QdUmqwkvWNGtaH7tu6p2r1mjFjhw+kZ+4smiw==
X-Google-Smtp-Source: ABdhPJzeuWpwJQXd990G5HE+lgBGJL7ORKXzdC9iOL5uTi4APckVRdjlVL8lNAeZ1ZemRIE7UjTTNv31fnVgTjN7kPY=
X-Received: by 2002:adf:a111:: with SMTP id o17mr63323403wro.257.1594310874827;
 Thu, 09 Jul 2020 09:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200617190757.27081-1-john.s.andersen@intel.com>
 <20200617190757.27081-3-john.s.andersen@intel.com> <0fa9682e-59d4-75f7-366f-103d6b8e71b8@intel.com>
 <20200618144314.GB23@258ff54ff3c0> <124a59a3-a603-701b-e3bb-61e83d70b20d@intel.com>
 <20200707211244.GN20096@linux.intel.com> <19b97891-bbb0-1061-5971-549a386f7cfb@intel.com>
 <31eb5b00-9e2a-aa10-0f20-4abc3cd35112@redhat.com> <20200709154412.GA25@64c96d3be97b>
 <af6ac772-318d-aab0-ce5f-55cf92f6e96d@intel.com>
In-Reply-To: <af6ac772-318d-aab0-ce5f-55cf92f6e96d@intel.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 9 Jul 2020 09:07:43 -0700
X-Gmail-Original-Message-ID: <CALCETrWxt0CHUoonWX1fgbM46ydJPQZhj8Q=G+45EG4wW3wZqQ@mail.gmail.com>
Message-ID: <CALCETrWxt0CHUoonWX1fgbM46ydJPQZhj8Q=G+45EG4wW3wZqQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: x86: Introduce paravirt feature CR0/CR4 pinning
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Andersen, John" <john.s.andersen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, 
	Liran Alon <liran.alon@oracle.com>, Andrew Jones <drjones@redhat.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, 
	Joerg Roedel <joro@8bytes.org>, Mauro Carvalho Chehab <mchehab+huawei@kernel.org>, 
	Greg KH <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Juergen Gross <jgross@suse.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Oliver Neukum <oneukum@suse.com>, 
	Andrew Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Fenghua Yu <fenghua.yu@intel.com>, reinette.chatre@intel.com, 
	vineela.tummalapalli@intel.com, Dave Hansen <dave.hansen@linux.intel.com>, 
	Arjan van de Ven <arjan@linux.intel.com>, caoj.fnst@cn.fujitsu.com, 
	Baoquan He <bhe@redhat.com>, Arvind Sankar <nivedita@alum.mit.edu>, 
	Kees Cook <keescook@chromium.org>, Dan Williams <dan.j.williams@intel.com>, eric.auger@redhat.com, 
	aaronlewis@google.com, Peter Xu <peterx@redhat.com>, makarandsonare@google.com, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	kvm list <kvm@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 9, 2020 at 8:56 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 7/9/20 8:44 AM, Andersen, John wrote:
> >
> >         Bits which are allowed to be pinned default to WP for CR0 and SMEP,
> >         SMAP, and UMIP for CR4.
>
> I think it also makes sense to have FSGSBASE in this set.
>
> I know it hasn't been tested, but I think we should do the legwork to
> test it.  If not in this set, can we agree that it's a logical next step?

I have no objection to pinning FSGSBASE, but is there a clear
description of the threat model that this whole series is meant to
address?  The idea is to provide a degree of protection against an
attacker who is able to convince a guest kernel to write something
inappropriate to CR4, right?  How realistic is this?
