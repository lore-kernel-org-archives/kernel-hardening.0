Return-Path: <SRS0=sT+x=AU=lists.openwall.com=kernel-hardening-return-19276-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A266EC433DF
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Jul 2020 23:38:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F246C20672
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Jul 2020 23:37:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="d1fhruaq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F246C20672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19276-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30241 invoked by uid 550); 9 Jul 2020 23:37:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30221 invoked from network); 9 Jul 2020 23:37:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=49nvohObD7NIzUF0BfwI36tqxmTFWboJS8SYsz0QQGI=;
        b=d1fhruaq3iAgLLhUtayeHvRegHINeqtG7TBQnzxSkGDJxNJfqFuwBJvMmZzBA8RONW
         3EWhHxsZlCQudvK8/fMc0kPEU+vuxkCxX/cWcbSfPQuI2x2MFgBmsRwJSfUOp2JxxBB7
         5QyFewNxU0UWUNDkYBxZQ7ozqL4/qf61sjw2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=49nvohObD7NIzUF0BfwI36tqxmTFWboJS8SYsz0QQGI=;
        b=pvt+Fhm8SIMXGgxJTtS+KVuimDC/uKg7IFYW/FR1HCqGD+wpwa6HiH5Ye9ZfySB9BD
         w8eTscOiz/YniSgEqeM32yT/gNWt3RAnt3WNa4j1bY4AvGxWFyo3R0kXuB3zRhqXrMh+
         d+UGP2gx1FyYsIQBemIPZbMu1U/jwRjwSBpC1mUTg3ckmlwE0z+ds3XQfhm0JggaEgoh
         jgkAGT44pgKqbSZogaVmyFaBZ6wHSzgNdag3ORmcZkzODq8NALjNxtKTMLTVcIR7Z6rP
         l2errD9fxlKXUK+hwEP5mWTMF07lsfwSVWBII3yDyeoTL8EB6Iwrosy6WAubg0hVPjqL
         xPJw==
X-Gm-Message-State: AOAM5327RMsQFyPkBWcQFmGjlHvLVyAVJ+Qo/bpbtOjXLaIJmNrZ2q7b
	AJs3I1mBZjcVVltBjT1t2EZR/A==
X-Google-Smtp-Source: ABdhPJyMVLjQTkrAT893hzGYB34NF584FlAsBE8NVHx+rx9CzStVPpQjoezHz1rmqBiAMWCaH7OGyQ==
X-Received: by 2002:a63:3c09:: with SMTP id j9mr54205575pga.206.1594337859635;
        Thu, 09 Jul 2020 16:37:39 -0700 (PDT)
Date: Thu, 9 Jul 2020 16:37:37 -0700
From: Kees Cook <keescook@chromium.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	"Andersen, John" <john.s.andersen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
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
	Baoquan He <bhe@redhat.com>, Arvind Sankar <nivedita@alum.mit.edu>,
	Dan Williams <dan.j.williams@intel.com>, eric.auger@redhat.com,
	aaronlewis@google.com, Peter Xu <peterx@redhat.com>,
	makarandsonare@google.com,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 2/4] KVM: x86: Introduce paravirt feature CR0/CR4 pinning
Message-ID: <202007091634.528B6641@keescook>
References: <0fa9682e-59d4-75f7-366f-103d6b8e71b8@intel.com>
 <20200618144314.GB23@258ff54ff3c0>
 <124a59a3-a603-701b-e3bb-61e83d70b20d@intel.com>
 <20200707211244.GN20096@linux.intel.com>
 <19b97891-bbb0-1061-5971-549a386f7cfb@intel.com>
 <31eb5b00-9e2a-aa10-0f20-4abc3cd35112@redhat.com>
 <20200709154412.GA25@64c96d3be97b>
 <af6ac772-318d-aab0-ce5f-55cf92f6e96d@intel.com>
 <CALCETrWxt0CHUoonWX1fgbM46ydJPQZhj8Q=G+45EG4wW3wZqQ@mail.gmail.com>
 <6040c3b3-cac9-cc0e-f0de-baaa274920a2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6040c3b3-cac9-cc0e-f0de-baaa274920a2@intel.com>

On Thu, Jul 09, 2020 at 09:22:09AM -0700, Dave Hansen wrote:
> On 7/9/20 9:07 AM, Andy Lutomirski wrote:
> > On Thu, Jul 9, 2020 at 8:56 AM Dave Hansen <dave.hansen@intel.com> wrote:
> >> On 7/9/20 8:44 AM, Andersen, John wrote:
> >>>         Bits which are allowed to be pinned default to WP for CR0 and SMEP,
> >>>         SMAP, and UMIP for CR4.
> >> I think it also makes sense to have FSGSBASE in this set.
> >>
> >> I know it hasn't been tested, but I think we should do the legwork to
> >> test it.  If not in this set, can we agree that it's a logical next step?
> > I have no objection to pinning FSGSBASE, but is there a clear
> > description of the threat model that this whole series is meant to
> > address?  The idea is to provide a degree of protection against an
> > attacker who is able to convince a guest kernel to write something
> > inappropriate to CR4, right?  How realistic is this?
> 
> If a quick search can find this:
> 
> > https://googleprojectzero.blogspot.com/2017/05/exploiting-linux-kernel-via-packet.html
> 
> I'd pretty confident that the guys doing actual bad things have it in
> their toolbox too.

Right, it's common (see my commit log in 873d50d58f67), and having this
enforced by the hypervisor is WAY better since it'll block gadgets or
ROP.

-- 
Kees Cook
