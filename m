Return-Path: <SRS0=WmNr=32=lists.openwall.com=kernel-hardening-return-17696-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8998EC2D0B1
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 11:48:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D948F21741
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 11:48:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PX6L81YY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D948F21741
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17696-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3509 invoked by uid 550); 6 Feb 2020 11:48:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3486 invoked from network); 6 Feb 2020 11:48:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=tf7UfAXF0+7+R/0CR/EhvROtYInc8epHQipEfshPVGs=;
        b=PX6L81YYJdfK1dzYbHAtJvW+q7p3T/0pcVLlue5FeG4q7vAYgtvwTOkmic7TMKGuuO
         +Kv/qr++XIOZZEokHxFHqatEdlf/ZNap1h7uIHw40ejP2uWu7PRmNoRic/wvHYFAd3Zk
         wKRp8P+VQP4V4FtxKgDx6FYxSI0lZ5z57RMqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=tf7UfAXF0+7+R/0CR/EhvROtYInc8epHQipEfshPVGs=;
        b=bty4XQiNFXoV5OB1q4N4/te0Tjpf5hyxyoQKp/eGkylQPGahfD7w9dE1PRxYsYaOKj
         zi0EdPB+qYuboKS0VX63xEiQS9tOD/GL4OkcAaErSC9w7v0pRR8bqFajjG6und8sinnV
         to113xCiPz5TCgxHtLvB2Yl/mtiX1rMB8h5V3ZtR8aZjxVTZO85hyeQBSz4jwIC1FmE0
         7m9ikKQj8t+eET2Ov3j+NojfYyFGHb+8/6e3y7Oq1f57zREtWss8KEIKAaCeWUz2d772
         +K2VSU/q1ez+haQ3qjjvuE2FEvakBcu/xfOZTdXEVm15UiLTG8vWChnHx6ijfL7QF2KT
         VErw==
X-Gm-Message-State: APjAAAVbBK7cLSjn69d5zb769XTP6ZN8LSozsUtZo5ujk9K+Xk+poODY
	p0Lhhz1GipJDtykw++Zf9l8ztw==
X-Google-Smtp-Source: APXvYqwjnYccMXUVd+n93iR5zMBTFfXt5QHWYG9PKa/8tWlaPADduZNq1u0fLkVynUJQ4it71oULeg==
X-Received: by 2002:a9d:5885:: with SMTP id x5mr29462319otg.132.1580989683562;
        Thu, 06 Feb 2020 03:48:03 -0800 (PST)
Date: Thu, 6 Feb 2020 03:48:01 -0800
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 03/11] x86/boot: Allow a "silent" kaslr random byte
 fetch
Message-ID: <202002060345.FAF7517CA4@keescook>
References: <20200205223950.1212394-4-kristen@linux.intel.com>
 <B173D69E-DC6C-4658-B5CB-391D3C6A6597@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B173D69E-DC6C-4658-B5CB-391D3C6A6597@amacapital.net>

On Wed, Feb 05, 2020 at 05:08:55PM -0800, Andy Lutomirski wrote:
> 
> 
> > On Feb 5, 2020, at 2:39 PM, Kristen Carlson Accardi <kristen@linux.intel.com> wrote:
> > 
> > ﻿From: Kees Cook <keescook@chromium.org>
> > 
> > Under earlyprintk, each RNG call produces a debug report line. When
> > shuffling hundreds of functions, this is not useful information (each
> > line is identical and tells us nothing new). Instead, allow for a NULL
> > "purpose" to suppress the debug reporting.
> 
> Have you counted how many RDRAND calls this causes?  RDRAND is
> exceedingly slow on all CPUs I’ve looked at. The whole “RDRAND
> has great bandwidth” marketing BS actually means that it has decent
> bandwidth if all CPUs hammer it at the same time. The latency is abysmal.
> I have asked Intel to improve this, but the latency of that request will
> be quadrillions of cycles :)

In an earlier version of this series, it was called once per function
section (so, about 50,000 times). The (lack of) speed was quite
measurable.

> I would suggest adding a little ChaCha20 DRBG or similar to the KASLR
> environment instead. What crypto primitives are available there?

Agreed. The simple PRNG in the next patch was most just a POC initially,
but Kristen kept it due to its debugging properties (specifying an
external seed). Pulling in ChaCha20 seems like a good approach.

-- 
Kees Cook
