Return-Path: <SRS0=wgMU=BQ=lists.openwall.com=kernel-hardening-return-19570-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CE2C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Aug 2020 19:28:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2FC682177B
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Aug 2020 19:28:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VRbLv045"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FC682177B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19570-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12115 invoked by uid 550); 6 Aug 2020 19:28:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12087 invoked from network); 6 Aug 2020 19:28:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eXpUXCboa1iboXL0krzV2/Rr3Jeb/snQcwOxIp/4Dfc=;
        b=VRbLv045DWIuz8DLew94VGvDSVErpo6jn4nvSzw0t7K7QnTc3umT6i53NWb1LP/jF0
         VYzRuv6ew+G0jWbCr06tDw0B0AwLkTE9uV4u7R0p3VhkEcSPWnNxsCZS9qwEThWGqRYf
         BtImZHYpWLIfRfelG5j1Ui4Z6C2DXjTCalbpY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eXpUXCboa1iboXL0krzV2/Rr3Jeb/snQcwOxIp/4Dfc=;
        b=fmkminQr469tFbS+GuiTQcnQy/9QpJTYvv8Wczfq/1/3fH1ogOXSlACV6zFkc4NsfX
         ZB0kukXuUACOB9VhjzCZfQ8VKb1M2FP25uT1Kfi4U2+Ki7abvnmQ+w5Rn2ftEKm9lwwc
         /REd8UvsPrEuvH0sFZ2EfbezJOm8iMiFqwchm0eiYroR4tqP6BgZR++Z6OkI96ZQROpt
         gLy+yQfLFhDI8LNiwnesjzGq6tv17W39d/hJppLARUkwqxmcWIigKjHVDXjXH4m3L/l5
         iPo/TnWeLr5ashf6QNVCbnc3FymNTm9DMybv9bnKdpGaFLM753pjn22l2INhtIg1K87N
         iWIg==
X-Gm-Message-State: AOAM533+0CCIfCIGUwHJTO4lK3X7+M6CAjZKtHKpf/tB6qD0WkwtWD1L
	hsFgrqL/xp/ZsYwfGv9L0wdsEA==
X-Google-Smtp-Source: ABdhPJyGGpXe0mD6tJaO+rovKFGQgiUeb/vs5z8wLn89skFqmXdsz2fgHIgqZ28K2zBb/xj6F/qkZQ==
X-Received: by 2002:a17:90b:3597:: with SMTP id mm23mr9564700pjb.3.1596742072173;
        Thu, 06 Aug 2020 12:27:52 -0700 (PDT)
Date: Thu, 6 Aug 2020 12:27:50 -0700
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <202008061052.DA6F3AA2@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <20200806153258.GB2131635@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200806153258.GB2131635@gmail.com>

On Thu, Aug 06, 2020 at 05:32:58PM +0200, Ingo Molnar wrote:
> * Kristen Carlson Accardi <kristen@linux.intel.com> wrote:
> > [...]
> > Performance Impact
> > ------------------
> 
> > * Run time
> > The performance impact at run-time of function reordering varies by workload.
> > Using kcbench, a kernel compilation benchmark, the performance of a kernel
> > build with finer grained KASLR was about 1% slower than a kernel with standard
> > KASLR. Analysis with perf showed a slightly higher percentage of 
> > L1-icache-load-misses. Other workloads were examined as well, with varied
> > results. Some workloads performed significantly worse under FGKASLR, while
> > others stayed the same or were mysteriously better. In general, it will
> > depend on the code flow whether or not finer grained KASLR will impact
> > your workload, and how the underlying code was designed. Because the layout
> > changes per boot, each time a system is rebooted the performance of a workload
> > may change.
> 
> I'd guess that the biggest performance impact comes from tearing apart 
> 'groups' of functions that particular workloads are using.
> 
> In that sense it might be worthwile to add a '__kaslr_group' function 
> tag to key functions, which would keep certain performance critical 
> functions next to each other.

We kind of already do this manually for things like the scheduler, etc,
using macros like ".whatever.text", so we might be able to create a more
generalized approach for those. Right now they require a "section" macro
usage and a linker script __start* and __end* marker, etc:

#define SCHED_TEXT						\
                ALIGN_FUNCTION();				\
                __sched_text_start = .;				\
                *(.sched.text)					\
                __sched_text_end = .;

Manually collected each whatever_TEXT define and building out each
__whatever_start, etc is annoying. It'd be really cool to have linker
script have wildcard replacements for build a syntax like this, based
on the presences of matching input sections:

	.%.text : {
		__%_start = .;
		*(.%.text.hot)
		*(.%.text)
		*(.%.text.*)
		*(.%.text.unlikely)
		__%_end = .;
		}

> I'd also suggest allowing the passing in of a boot-time pseudo-random 
> generator seed number, which would allow the creation of a 
> pseudo-randomized but repeatable layout across reboots.

This was present in earlier versions of the series.

-- 
Kees Cook
