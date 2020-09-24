Return-Path: <SRS0=+u/u=DB=lists.openwall.com=kernel-hardening-return-20004-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A7CC4363D
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Sep 2020 20:53:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 94A69221EB
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Sep 2020 20:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94A69221EB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=deneb.enyo.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20004-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10208 invoked by uid 550); 24 Sep 2020 20:53:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10185 invoked from network); 24 Sep 2020 20:53:00 -0000
From: Florian Weimer <fw@deneb.enyo.de>
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>,  kernel-hardening@lists.openwall.com,  linux-api@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,  linux-fsdevel@vger.kernel.org,  linux-integrity@vger.kernel.org,  linux-kernel@vger.kernel.org,  linux-security-module@vger.kernel.org,  oleg@redhat.com,  x86@kernel.org,  libffi-discuss@sourceware.org,  luto@kernel.org,  David.Laight@ACULAB.COM,  mark.rutland@arm.com,  mic@digikod.net,  pavel@ucw.cz
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
References: <20200916150826.5990-1-madvenka@linux.microsoft.com>
	<87v9gdz01h.fsf@mid.deneb.enyo.de>
	<96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
	<20200923014616.GA1216401@rani.riverdale.lan>
	<20200923091125.GB1240819@rani.riverdale.lan>
	<a742b9cd-4ffb-60e0-63b8-894800009700@linux.microsoft.com>
	<20200923195147.GA1358246@rani.riverdale.lan>
	<2ed2becd-49b5-7e76-9836-6a43707f539f@linux.microsoft.com>
Date: Thu, 24 Sep 2020 22:52:38 +0200
In-Reply-To: <2ed2becd-49b5-7e76-9836-6a43707f539f@linux.microsoft.com>
	(Madhavan T. Venkataraman's message of "Thu, 24 Sep 2020 15:23:52
	-0500")
Message-ID: <87o8luvqw9.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain

* Madhavan T. Venkataraman:

> Otherwise, using an ABI quirk or a calling convention side effect to
> load the PC into a GPR is, IMO, non-standard or non-compliant or
> non-approved or whatever you want to call it. I would be
> conservative and not use it. Who knows what incompatibility there
> will be with some future software or hardware features?

AArch64 PAC makes a backwards-incompatible change that touches this
area, but we'll see if they can actually get away with it.

In general, these things are baked into the ABI, even if they are not
spelled out explicitly in the psABI supplement.

> For instance, in the i386 example, we do a call without a matching return.
> Also, we use a pop to undo the call. Can anyone tell me if this kind of use
> is an ABI approved one?

Yes, for i386, this is completely valid from an ABI point of view.
It's equally possible to use a regular function call and just read the
return address that has been pushed to the stack.  Then there's no
stack mismatch at all.  Return stack predictors (including the one
used by SHSTK) also recognize the CALL 0 construct, so that's fine as
well.  The i386 psABI does not use function descriptors, and either
approach (out-of-line thunk or CALL 0) is in common use to materialize
the program counter in a register and construct the GOT pointer.

> If the kernel supplies this, then all applications and libraries can use
> it for all architectures with one single, simple API. Without this, each
> application/library has to roll its own solution for every architecture-ABI
> combo it wants to support.

Is there any other user for these type-generic trampolines?
Everything else I've seen generates machine code specific to the
function being called.  libffi is quite the outlier in my experience
because the trampoline calls a generic data-driven
marshaller/unmarshaller.  The other trampoline generators put this
marshalling code directly into the generated trampoline.

I'm still not convinced that this can't be done directly in libffi,
without kernel help.  Hiding the architecture-specific code in the
kernel doesn't reduce overall system complexity.

> As an example, in libffi:
>
> 	ffi_closure_alloc() would call alloc_tramp()
>
> 	ffi_prep_closure_loc() would call init_tramp()
>
> 	ffi_closure_free() would call free_tramp()
>
> That is it! It works on all the architectures supported in the kernel for
> trampfd.

ffi_prep_closure_loc would still need to check whether the trampoline
has been allocated by alloc_tramp because some applications supply
their own (executable and writable) mapping.  ffi_closure_alloc would
need to support different sizes (not matching the trampoline).  It's
also unclear to me to what extent software out there writes to the
trampoline data directly, bypassing the libffi API (the structs are
not opaque, after all).  And all the existing libffi memory management
code (including the embedded dlmalloc copy) would be needed to support
kernels without trampfd for years to come.

I very much agree that we have a gap in libffi when it comes to
JIT-less operation.  But I'm not convinced that kernel support is
needed to close it, or that it is even the right design.
