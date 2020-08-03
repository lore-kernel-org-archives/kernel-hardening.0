Return-Path: <SRS0=itMo=BN=lists.openwall.com=kernel-hardening-return-19546-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB128C433DF
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 20:11:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1B58E2075A
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 20:11:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HeAvcOEz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B58E2075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19546-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24274 invoked by uid 550); 3 Aug 2020 20:11:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24253 invoked from network); 3 Aug 2020 20:11:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TfiyLaiiytHrMlT6oh4IsfhQ9YFyy5wx3zu6IU7BZNY=;
        b=HeAvcOEzYgF+GPngOCTfUbepzuEHkx+8qRmbejrCRY0MMmgn7UeyBWYdJzytoGD/Ta
         qJv07CPlJcF29ETgPuWONUktPZBp3nwXCAW6eRZRISbnRUQRb/KL+l6+49U1G00uxaJ2
         G8Xq9iIuiiHpWvLKYqRaN87kEr5QcIdg7wdbc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TfiyLaiiytHrMlT6oh4IsfhQ9YFyy5wx3zu6IU7BZNY=;
        b=mhaNwP/95vaIF9yqxFB78lFpIxwPqZC/Z1SXC664eXNVEjajd9RGn1t+VOdSYqYta4
         2hMOf+WC4Ne5WuIGm2VXZrym57Fc3Sk/wH8z8Sr+EsOBoth3LlzlwoHfEu6YoNDtHVYo
         VswHp5uXoOt2qXBllcK0ybh2+xjrEkCHTJ6sgW8tRbu2u6+pA3Jdz/UADYU9FY+n5j/0
         Z+b63AxvcNVxMMvYYC9dC5h3WNRlkHMTPU11Kr9HnawllNUpmRv07+0Y58awuDFGgkCP
         /pLvZj1cq8pxBJMzYWp1SMIofoI11+7yaJP8AtifYtWEvlFaHwoY+cVmcKXhkWz+whZ5
         PHUA==
X-Gm-Message-State: AOAM532pXSlBvi9/h29JCyCyFEWYaDdwvdKMguUWz7xTeq1eoNueaMFE
	Wr/1wI9FoB9L/BV1k1zkPUUDpA==
X-Google-Smtp-Source: ABdhPJx5soepBCB5jCgc7HTF/4STC+NuKiuSvs2LauZE/NK7WGz7+MhS+gn47Q/oX5PA+CVBiIyxZw==
X-Received: by 2002:a17:90a:7f02:: with SMTP id k2mr942128pjl.196.1596485489540;
        Mon, 03 Aug 2020 13:11:29 -0700 (PDT)
Date: Mon, 3 Aug 2020 13:11:27 -0700
From: Kees Cook <keescook@chromium.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
	Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <202008031310.4F8DAA20@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
 <202008031043.FE182E9@keescook>
 <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
 <20200803193837.GB30810@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803193837.GB30810@redhat.com>

On Mon, Aug 03, 2020 at 03:38:37PM -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> > > While this does seem to be the right solution for the extant problem, I
> > > do want to take a moment and ask if the function sections need to be
> > > exposed at all? What tools use this information, and do they just want
> > > to see the bounds of the code region? (i.e. the start/end of all the
> > > .text* sections) Perhaps .text.* could be excluded from the sysfs
> > > section list?
> 
> > [[cc += FChE, see [0] for Evgenii's full mail ]]
> 
> Thanks!
> 
> > It looks like debugging tools like systemtap [1], gdb [2] and its
> > add-symbol-file cmd, etc. peek at the /sys/module/<MOD>/section/ info.
> > But yeah, it would be preferable if we didn't export a long sysfs
> > representation if nobody actually needs it.
> 
> Systemtap needs to know base addresses of loaded text & data sections,
> in order to perform relocation of probe point PCs and context data
> addresses.  It uses /sys/module/...., kind of under protest, because
> there seems to exist no MODULE_EXPORT'd API to get at that information
> some other way.

Wouldn't /proc/kallsysms entries cover this? I must be missing
something...

-- 
Kees Cook
