Return-Path: <SRS0=9FFx=I3=lists.openwall.com=kernel-hardening-return-21076-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE14AC433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Mar 2021 18:41:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 364FC6195D
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Mar 2021 18:41:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 364FC6195D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21076-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17577 invoked by uid 550); 29 Mar 2021 18:41:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17557 invoked from network); 29 Mar 2021 18:41:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aYL/dbQ14QTXXMSkWSQ/z+qzj6yL6Ve3lzeO159+/Vc=;
        b=ILRNFBaUrvYS27aWFLaYXO8LPj6pKTA2SBD59ksr9Fpfa7kG44gHIoQIIeiA0uW0DT
         INDEJxHCxLo9mNI1mXPwmIRMdAheSsDUl9E7dL0goqI8aLORifPfviS8NWFxCGPsRDpU
         h2HExNb2DqeqeKKnXrybXZvXygAADq2smXaJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aYL/dbQ14QTXXMSkWSQ/z+qzj6yL6Ve3lzeO159+/Vc=;
        b=TznanbPacdS+xSKYVhb9pKWOxrV/PGv/rpvYK/XevtdY9c0SyZl3jQC/n++qOKKaQq
         7o4EKvZ2aWUr5E+9plmkGNUhUFTbq4kJy4n6z+m0QKOgpxjRrh1ZULNsBhhgvPCNTo/7
         cfUdPPiTIyQmlNBM+RA2japnFYETyaYtNusccFJkT9j8NSalrYhpbSh8zBDYFQcyiSkW
         226DDxyMjwwIYlSZgrfxgK10ofJtwrwTmuOE7AZee83pT0ACFiTw0Gv6aHyvNyiXotjZ
         8X0yFio9OsKcLYnjGRQ9K5SHyXaakaZI5CcIQMMMoId9KDhWm3Q2opkkkVLx/QCZA2uf
         OrjQ==
X-Gm-Message-State: AOAM530yIRp3/gsWU/NIFYItyOdx2/s/908fkaLd0fAz4UGXjWj6xZin
	OfRzPjXxG67zFKphDVpJkoR0Jw==
X-Google-Smtp-Source: ABdhPJxjjtBRwQY4aFK1R1QLvwpTRJ9D0T4m5/43mE5p+szS6JXZVD5wBPAm/iQ4MzX4uEt8W4cEIA==
X-Received: by 2002:aa7:8a19:0:b029:1f6:6839:7211 with SMTP id m25-20020aa78a190000b02901f668397211mr25877536pfa.40.1617043281318;
        Mon, 29 Mar 2021 11:41:21 -0700 (PDT)
Date: Mon, 29 Mar 2021 11:41:18 -0700
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
Subject: Re: [PATCH v7 3/6] stack: Optionally randomize kernel stack offset
 each syscall
Message-ID: <202103291139.54AA7CDE@keescook>
References: <20210319212835.3928492-1-keescook@chromium.org>
 <20210319212835.3928492-4-keescook@chromium.org>
 <87eefzcpc4.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eefzcpc4.ffs@nanos.tec.linutronix.de>

On Sun, Mar 28, 2021 at 04:42:03PM +0200, Thomas Gleixner wrote:
> On Fri, Mar 19 2021 at 14:28, Kees Cook wrote:
> > +/*
> > + * Do not use this anywhere else in the kernel. This is used here because
> > + * it provides an arch-agnostic way to grow the stack with correct
> > + * alignment. Also, since this use is being explicitly masked to a max of
> > + * 10 bits, stack-clash style attacks are unlikely. For more details see
> > + * "VLAs" in Documentation/process/deprecated.rst
> 
> VLAs are bad, VLAs to the rescue! :)

I'm aware of the irony, but luto's idea really makes things easy. As
documented there, though, this has a hard-coded (low) upper bound, so
it's not like "regular" VLA use.

> 
> > + * The asm statement is designed to convince the compiler to keep the
> > + * allocation around even after "ptr" goes out of scope.
> > + */
> > +void *__builtin_alloca(size_t size);
> > +
> > +#define add_random_kstack_offset() do {					\
> > +	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
> > +				&randomize_kstack_offset)) {		\
> > +		u32 offset = this_cpu_read(kstack_offset);              \
> 
> Not that it matters on x86, but as this has to be called in the
> interrupt disabled region of the syscall entry, shouldn't this be a
> raw_cpu_read(). The asm-generic version has a preempt_disable/enable
> pair around the raw read for native wordsize reads, otherwise a
> irqsave/restore pair.
> 
> __this_cpu_read() is fine as well, but that has an sanity check before
> the raw read when CONFIG_DEBUG_PREEMPT is on, which is harmless but
> also pointless in this case.
> 
> Probably the same for the counterpart this_cpu_write().

Oh! Excellent point. I think this will make a big difference on arm64. I
will adjust and test.

-- 
Kees Cook
