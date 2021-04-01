Return-Path: <SRS0=Mxao=I6=lists.openwall.com=kernel-hardening-return-21109-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A40C433B4
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 06:32:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 58300600EF
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 06:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58300600EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21109-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26270 invoked by uid 550); 1 Apr 2021 06:31:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26247 invoked from network); 1 Apr 2021 06:31:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hfTiBhDabA7pBPLjBpIi4iWvrEHL2e3DeE4vbI5tAiE=;
        b=INuoEL/r01BHe5/0yKi04SaL6KiDFwaY3kVglmh8y1egtrKhBcEeVSMQq834wTyuHZ
         qDvvBOvmZArmoVNPOp/MXHjJ9+bCFSVaPsePM0Sw+bRDQEqjhousEsLqTQ9dRxVkOvYx
         HBppUlDY7Djx+X/wpLnFxgFe7TiS6kNvMLqwc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hfTiBhDabA7pBPLjBpIi4iWvrEHL2e3DeE4vbI5tAiE=;
        b=tXuFU7njQGz6hmSIvK99PTFe5J8a3dgumdKYy6v3AMv/OAh2utHSFwptOHZ0ZxkgBu
         H9DNY5TWCVHFiegTYVSDLQOoQE9VKJeyVxZA1AQ6c7hiI6Dbd+x/y662VmOFWUPt/pf+
         7Sza6PxjpJVUT8kANvRPoEWvhe86mAs2hP94mfJvP03xxaxJDfW/4F0lYqBqyNiPA1Ou
         UvJaTvl+pp3/hWDtYAKAx+MyqSxsZxUrujQeNwA5bFdSKtXEXzNNIbWvxullx2Ui2zue
         7quojuC2x4bwTdrOYfLid5k8SL8baiJsVsAtBzmDaQcAMwR8fsyS1SLqNzTMtmzfqUIz
         AT3A==
X-Gm-Message-State: AOAM533QmUKZMroJ3TQuKXmuQ13JEO2pAXu+FtOcOfx8Cyvru9GYujAQ
	d+FOnQa9KywEhqzOqPoFYFgtew==
X-Google-Smtp-Source: ABdhPJybf6kMo+xaigSfWlgtmn9ANKW+eH5leA3QXT6lgzLQyGzKLYlDgQSa+C8d5xDIMNkOgP5Eag==
X-Received: by 2002:a17:902:6b43:b029:e6:3d73:e9fb with SMTP id g3-20020a1709026b43b02900e63d73e9fbmr6546739plt.37.1617258701439;
        Wed, 31 Mar 2021 23:31:41 -0700 (PDT)
Date: Wed, 31 Mar 2021 23:31:39 -0700
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/6] stack: Optionally randomize kernel stack offset
 each syscall
Message-ID: <202103312329.394CCA13CF@keescook>
References: <20210330205750.428816-1-keescook@chromium.org>
 <20210330205750.428816-4-keescook@chromium.org>
 <87im5769op.ffs@nanos.tec.linutronix.de>
 <202103311453.A840B7FC5@keescook>
 <87v9973q54.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9973q54.ffs@nanos.tec.linutronix.de>

On Thu, Apr 01, 2021 at 12:38:31AM +0200, Thomas Gleixner wrote:
> On Wed, Mar 31 2021 at 14:54, Kees Cook wrote:
> > On Wed, Mar 31, 2021 at 09:53:26AM +0200, Thomas Gleixner wrote:
> >> On Tue, Mar 30 2021 at 13:57, Kees Cook wrote:
> >> > +/*
> >> > + * Do not use this anywhere else in the kernel. This is used here because
> >> > + * it provides an arch-agnostic way to grow the stack with correct
> >> > + * alignment. Also, since this use is being explicitly masked to a max of
> >> > + * 10 bits, stack-clash style attacks are unlikely. For more details see
> >> > + * "VLAs" in Documentation/process/deprecated.rst
> >> > + * The asm statement is designed to convince the compiler to keep the
> >> > + * allocation around even after "ptr" goes out of scope.
> >> 
> >> Nit. That explanation of "ptr" might be better placed right at the
> >> add_random...() macro.
> >
> > Ah, yes! Fixed in v9.
> 
> Hmm, looking at V9 the "ptr" thing got lost ....

I put the comment inline in the macro directly above the asm().

> > Do you want to take this via -tip (and leave off the arm64 patch until
> > it is acked), or would you rather it go via arm64? (I've sent v9 now...)
> 
> Either way is fine.

Since the arm64 folks have been a bit busy, can you just put this in
-tip and leave off the arm64 patch for now?

Thanks!

-- 
Kees Cook
