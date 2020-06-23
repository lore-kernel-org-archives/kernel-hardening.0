Return-Path: <SRS0=LbuN=AE=lists.openwall.com=kernel-hardening-return-19050-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDBEC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 00:56:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6EAEB2070E
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 00:56:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nAdHPfYX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EAEB2070E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19050-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25606 invoked by uid 550); 23 Jun 2020 00:56:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24504 invoked from network); 23 Jun 2020 00:56:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ddZISy/nnQaDTw5hRGQzjmZlz/IMEisCTFQ7iFu0Th0=;
        b=nAdHPfYXVzWTBCeDEMmkeKJ+hHfd7oErRWwLQb9dB7/Ol4YD/npR6fC0vwGRXy/c29
         GGQ0oMgXVfEfwUNLWB5Mq3C346cIetMwNMMUd76j9Ztr+rPIR33dCIUpM2i+4VJOQ8xU
         A1KmHa9YIl4kewOB9Lmi3GBsCMQ5u7F38OPjo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ddZISy/nnQaDTw5hRGQzjmZlz/IMEisCTFQ7iFu0Th0=;
        b=C+zVqay/0LZ6oOPyYXtcLDneWo2GHjB2i4Ds/T3U+Vgs8EgGLDNUm7h4ctHMegDxRD
         sBobYgtCV8maC/JuMMM6IxPWCuLkgcVHndP+HhkpMS+Ws/NFKG/z4JwV5cWTQ9AU7NIQ
         5C8bFx6eF/slh6GftMFYCmnFtyzjkmgrNzOeKJLKPZgjSRneSrqWt2FJECDAOaNeyzxn
         tldinr8xFfzzBbl5q6/U/kgEfFoqI4xXV7ZQIa3Aj2AHEUfXnEScKXpNHoaSHQlBcZaf
         XoQ/NLw/FZS4FV1IRC1ovi1qJnDoDTtTuFKP18+STKi5/sBEg7S+BKhbWoftwey9zUAP
         8ZLQ==
X-Gm-Message-State: AOAM532oWhR1QXzOMFfLXJtTceNqBHxCuHtFP7pCKvNX0MkwGyxC/NAa
	8PhBZ7lcRWJVmLadBtXxYIoNlg==
X-Google-Smtp-Source: ABdhPJzcouPDWEUYGfs6mnKQxNW21WTL2h/cvt4aWHu1LneMG7v+1KMi+E4KPxR8Q7oPaJp1wkS5WA==
X-Received: by 2002:a63:35cc:: with SMTP id c195mr14777269pga.180.1592873783576;
        Mon, 22 Jun 2020 17:56:23 -0700 (PDT)
Date: Mon, 22 Jun 2020 17:56:21 -0700
From: Kees Cook <keescook@chromium.org>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>, kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/5] stack: Optionally randomize kernel stack offset
 each syscall
Message-ID: <202006221748.DA27A7FFC@keescook>
References: <20200622193146.2985288-1-keescook@chromium.org>
 <20200622193146.2985288-4-keescook@chromium.org>
 <20200622225615.GA3511702@rani.riverdale.lan>
 <202006221604.871B13DE3@keescook>
 <20200623000510.GA3542245@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623000510.GA3542245@rani.riverdale.lan>

On Mon, Jun 22, 2020 at 08:05:10PM -0400, Arvind Sankar wrote:
> But I still don't see anything _stopping_ the compiler from optimizing
> this better in the future. The "=m" is not a barrier: it just informs
> the compiler that the asm produces an output value in *ptr (and no other
> outputs). If nothing can consume that output, it doesn't stop the
> compiler from freeing the allocation immediately after the asm instead
> of at the end of the function.

Ah, yeah, I get what you mean.

> I'm talking about something like
> 	asm volatile("" : : "r" (ptr) : "memory");
> which tells the compiler that the asm may change memory arbitrarily.

Yeah, I will adjust it.

> Here, we don't use it really as a barrier, but to tell the compiler that
> the asm may have stashed the value of ptr somewhere in memory, so it's
> not free to reuse the space that it pointed to until the function
> returns (unless it can prove that nothing accesses memory, not just that
> nothing accesses ptr).

-- 
Kees Cook
