Return-Path: <SRS0=4XlL=DB=lists.openwall.com=kernel-hardening-return-20007-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5F3C4346E
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Sep 2020 23:44:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 69F3822208
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Sep 2020 23:44:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SRS+3ztW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69F3822208
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20007-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1615 invoked by uid 550); 24 Sep 2020 23:44:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1595 invoked from network); 24 Sep 2020 23:44:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+T95pP0uGxIm5Hz5QWTAjFs5Yw5r7ZYnLnu32ktfF3g=;
        b=SRS+3ztWImIJz5ak5a8R2YUyAT3cOcKWla/DfSAbwA5EsQXf6lTgaBbOhFfu5VRAMx
         EBRH7dn0NSJYoCVohXXTd3AMFraMiAcZml1GyPB3z58QN07wqG9zoJivG2DgcQaQXRMb
         pWz1g3b2BP0i/X6v4wphLB+1NOv2S5Y2UonuWaD/OVTEuBAvqkQRTMfKw/959ClbM9aG
         aBdpSP0+xY/OxvAAtmGW3n2mOviHfCjFeRdI2E3xoJCVzhoPhpxVTCaqKyS10a3SpZZs
         WFJE9UifKsyVMPXz0QZXmvh6FqqjyMtTPWKuNF6a/pmAJT3YNgidThcGIy1lLmEKypUh
         CFyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=+T95pP0uGxIm5Hz5QWTAjFs5Yw5r7ZYnLnu32ktfF3g=;
        b=g0z2G+nvmW+WHLIzIZGQLHDPyVcCOVknx9DnCmSJYtI9Ahibrt3MFmyY4PFpkr+USJ
         mTXeNJQrudIEoV5ACvkFXVQnhWFNlfHSAmTtW7lOZzsCywQibteRfeE48WWH9CQdPsg5
         lBzt+9kOCHpznqwMRVcB0CVjg4AmHHtcKSuvhJFCRMZflaS11PPE+ANOi7XoWvlVLTyC
         kV/cqAqiasu4/uElw3v++muLGoj7oSQuv/yvJgfQs0J65/zjLLuoKpVR1zyyUOYt21AW
         Ca5K1P/Llc5KeAyPjPo2mzH5Av/feD39z4eEc7JqwXyzvHfp04MTxvDonfvjpBKqjuRH
         psLg==
X-Gm-Message-State: AOAM530hxyfYLF8bVgr2QKTZ+eDqrL2bY72xbhsQU5ffcpFR+OBmuIef
	TYWfvo6itQRVzT48NWJd8mw=
X-Google-Smtp-Source: ABdhPJwOU/cF0q6NGU9SSXHvmok6uvYBc/rMxoHf5l0kEVkV0CgcegrS+4efhWf0u0ngCNKQHRuDUQ==
X-Received: by 2002:aed:2e26:: with SMTP id j35mr1773028qtd.377.1600991030270;
        Thu, 24 Sep 2020 16:43:50 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Thu, 24 Sep 2020 19:43:47 -0400
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>,
	Florian Weimer <fw@deneb.enyo.de>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, oleg@redhat.com,
	x86@kernel.org, libffi-discuss@sourceware.org, luto@kernel.org,
	David.Laight@ACULAB.COM, mark.rutland@arm.com, mic@digikod.net,
	pavel@ucw.cz
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200924234347.GA341645@rani.riverdale.lan>
References: <20200916150826.5990-1-madvenka@linux.microsoft.com>
 <87v9gdz01h.fsf@mid.deneb.enyo.de>
 <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
 <20200923014616.GA1216401@rani.riverdale.lan>
 <20200923091125.GB1240819@rani.riverdale.lan>
 <a742b9cd-4ffb-60e0-63b8-894800009700@linux.microsoft.com>
 <20200923195147.GA1358246@rani.riverdale.lan>
 <2ed2becd-49b5-7e76-9836-6a43707f539f@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2ed2becd-49b5-7e76-9836-6a43707f539f@linux.microsoft.com>

On Thu, Sep 24, 2020 at 03:23:52PM -0500, Madhavan T. Venkataraman wrote:
> 
> 
> > Which ISA does not support PIC objects? You mentioned i386 below, but
> > i386 does support them, it just needs to copy the PC into a GPR first
> > (see below).
> 
> Position Independent Code needs PC-relative branches. I was referring
> to PC-relative data references. Like RIP-relative data references in
> X64. i386 ISA does not support this.

I was talking about PC-relative data references too: they are a
requirement for PIC code that wants to access any global data. They can
be implemented easily on i386 even though it doesn't have an addressing
mode that uses the PC.

> Otherwise, using an ABI quirk or a calling convention side effect to load the
> PC into a GPR is, IMO, non-standard or non-compliant or non-approved or
> whatever you want to call it. I would be conservative and not use it. Who knows
> what incompatibility there will be with some future software or hardware
> features?
> 
> For instance, in the i386 example, we do a call without a matching return.
> Also, we use a pop to undo the call. Can anyone tell me if this kind of use
> is an ABI approved one?

This doesn't have anything to do with the ABI, since what happened here
isn't visible to any caller or callee. Any machine instruction sequence
that has the effect of copying the PC into a GPR is acceptable, but this
is basically the only possible solution on i386. If you don't like the
call/pop mismatch (though that's supported by the hardware, and is what
clang likes to use), you can use the slightly different technique used
in my example, which copies the top of stack into a GPR after a call.

This is how all i386 PIC code has always worked.

> Standard API for all userland for all architectures
> ---------------------------------------------------
> 
> The next advantage in using the kernel is standardization.
> 
> If the kernel supplies this, then all applications and libraries can use
> it for all architectures with one single, simple API. Without this, each
> application/library has to roll its own solution for every architecture-ABI
> combo it wants to support.

But you can get even more standardization out of a userspace library,
because that can work even on non-linux OS's, as well as versions of
linux where the new syscall isn't available.

> 
> Furthermore, if this work gets accepted, I plan to add a glibc wrapper for
> the kernel API. The glibc API would look something like this:
> 
> 	Allocate a trampoline
> 	---------------------
> 
> 	tramp = alloc_tramp();
> 
> 	Set trampoline parameters
> 	-------------------------
> 
> 	init_tramp(tramp, code, data);
> 
> 	Free the trampoline
> 	-------------------
> 
> 	free_tramp(tramp);
> 
> glibc will allocate and manage the code and data tables, handle kernel API
> details and manage the trampoline table.

glibc could do this already if it wants, even without the syscall,
because this can be done in userspace already.

> 
> Secure vs Performant trampoline
> -------------------------------
> 
> If you recall, in version 1, I presented a trampoline type that is
> implemented in the kernel. When an application invokes the trampoline,
> it traps into the kernel and the kernel performs the work of the trampoline.
> 
> The disadvantage is that a trip to the kernel is needed. That can be
> expensive.
> 
> The advantage is that the kernel can add security checks before doing the
> work. Mainly, I am looking at checks that might prevent the trampoline
> from being used in an ROP/BOP chain. Some half-baked ideas:
> 
> 	- Check that the invocation is at the starting point of the
> 	  trampoline
> 
> 	- Check if the trampoline is jumping to an allowed PC
> 
> 	- Check if the trampoline is being invoked from an allowed
> 	  calling PC or PC range
> 
> Allowed PCs can be input using the trampfd API mentioned in version 1.
> Basically, an array of PCs is written into trampfd.

The source PC will generally not be available if the compiler decided to
tail-call optimize the call to the trampoline into a jump.

What's special about these trampolines anyway? Any indirect function
call could have these same problems -- an attacker could have
overwritten the pointer the same way, whether it's supposed to point to
a normal function or it is the target of this trampoline.

For making them a bit safer, userspace could just map the page holding
the data pointers/destination address(es) as read-only after
initialization.

> 
> Suggestions for other checks are most welcome!
> 
> I would like to implement an option in the trampfd API. The user can
> choose a secure trampoline or a performant trampoline. For a performant
> trampoline, the kernel will generate the code. For a secure trampoline,
> the kernel will do the work itself.
> 
> In order to address the FFI_REGISTER ABI in libffi, we could use the secure
> trampoline. In FFI_REGISTER, the data is pushed on the stack and the code
> is jumped to without using any registers.
> 
> As outlined in version 1, the kernel can push the data address on the stack
> and write the code address into the PC and return to userland.
> 
> For doing all of this, we need trampfd.

We don't need this for FFI_REGISTER. I presented a solution that works
in userspace. Even if you want to use a trampoline created by the
kernel, there's no reason it needs to trap into the kernel at trampoline
execution time. libffi's trampolines already handle this case today.

> 
> Permitting the use of trampfd
> -----------------------------
> 
> An "exectramp" setting can be implemented in SELinux to selectively allow the
> use of trampfd for applications.
> 
> Madhavan

Applications can use their own userspace trampolines regardless of this
setting, so it doesn't provide any additional security benefit by
preventing usage of trampfd.
