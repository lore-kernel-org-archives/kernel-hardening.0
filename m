Return-Path: <SRS0=xEYx=32=lists.openwall.com=kernel-hardening-return-17717-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9032C33CAC
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 16:58:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 278F220838
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 16:58:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 278F220838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17717-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19584 invoked by uid 550); 6 Feb 2020 16:58:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19561 invoked from network); 6 Feb 2020 16:58:34 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="220497571"
Message-ID: <2da7c2370b1bd5474ce51a22b04d81e2734232b1.camel@linux.intel.com>
Subject: Re: [RFC PATCH 03/11] x86/boot: Allow a "silent" kaslr random byte
 fetch
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, 
	arjan@linux.intel.com, keescook@chromium.org, rick.p.edgecombe@intel.com, 
	x86@kernel.org, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com
Date: Thu, 06 Feb 2020 08:58:22 -0800
In-Reply-To: <B173D69E-DC6C-4658-B5CB-391D3C6A6597@amacapital.net>
References: <20200205223950.1212394-4-kristen@linux.intel.com>
	 <B173D69E-DC6C-4658-B5CB-391D3C6A6597@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2020-02-05 at 17:08 -0800, Andy Lutomirski wrote:
> > On Feb 5, 2020, at 2:39 PM, Kristen Carlson Accardi <
> > kristen@linux.intel.com> wrote:
> > 
> > ﻿From: Kees Cook <keescook@chromium.org>
> > 
> > Under earlyprintk, each RNG call produces a debug report line. When
> > shuffling hundreds of functions, this is not useful information
> > (each
> > line is identical and tells us nothing new). Instead, allow for a
> > NULL
> > "purpose" to suppress the debug reporting.
> 
> Have you counted how many RDRAND calls this causes?  RDRAND is
> exceedingly slow on all CPUs I’ve looked at. The whole “RDRAND has
> great bandwidth” marketing BS actually means that it has decent
> bandwidth if all CPUs hammer it at the same time. The latency is
> abysmal.  I have asked Intel to improve this, but the latency of that
> request will be quadrillions of cycles :)
> 
> It wouldn’t shock me if just the RDRAND calls account for a
> respectable fraction of total time. The RDTSC fallback, on the other
> hand, may be so predictable as to be useless.

I think at the moment the calls to rdrand are really not the largest
contributor to the latency. The relocations are the real bottleneck -
each address must be inspected to see if it is in the list of function
sections that have been randomized, and the value at that address must
also be inspected to see if it's in the list of function sections.
That's a lot of lookups. That said, I tried to measure the difference
between using Kees' prng vs. the rdrand calls and found little to no
measurable difference. I think at this point it's in the noise -
hopefully we will get to a point where this matters more.

> 
> I would suggest adding a little ChaCha20 DRBG or similar to the KASLR
> environment instead. What crypto primitives are available there?

I will read up on this.


