Return-Path: <SRS0=JPd+=AE=lists.openwall.com=kernel-hardening-return-19049-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDE2C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 00:05:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 006FF2076E
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 00:05:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bZnR5cxj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 006FF2076E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19049-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28530 invoked by uid 550); 23 Jun 2020 00:05:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28495 invoked from network); 23 Jun 2020 00:05:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ci1H/D9yRBKgCOs8CwvIjI+cliPNnLJY+ZZdvthmHrE=;
        b=bZnR5cxj0yVhupPYbVTZrUAGY9nNkIrFLLNIPmuoAvUQ4OHK1sHDJWoL2/SJRkwpMI
         m7Prz2r4QOf6lv5YTO11dfUPOF7IdsLIzGE0bbPrwh0Jqu3SwX4PVrjDyEqr2hhiOwnd
         8ZhWv03Dhkn/QmOUGiO+wbhlnkTVoyz0ypeJQhxVs+38DxTgnv8VKRIqiXcRvjAjFL2B
         PY3M7tpF+3Cje3f8ltlW1ZoL/ABW7ca3n/B+EM/ouagHylGpp4Fnj9zLrVUfXu2HmB2c
         rMGukrOiBhktkdYYOtt74ENxCSvvGBtzzC/JD9jGDjulPVNC8e2L3Rw63kb/ditJ9R4B
         48CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ci1H/D9yRBKgCOs8CwvIjI+cliPNnLJY+ZZdvthmHrE=;
        b=Kheh7zP/PQlLVywynlVf7ixKgsWO2+X0VNo2tmBtfDPx5GjAfjJDc0UCO844icPjqP
         VGUByxewUIqir0o2wG6dM13rM706zzWiRg1TwKrj9x1MuFLtFbGlJqnBUMKhAK0CA6fO
         juePzJibv8u/j9V1F+OQ6T2SdxqA3f93r5KbcevKZ6xrkEkeyT2FuJgPdFNgl5gnmkzR
         4YcI/peEKnQLRkWrmOmTCEDUUcpUVvAgWYajspLeoKx02M81CSqIgdYvCwl/PBD8txZs
         BahC1J0AikM4/WN7XN9781ZZCVHpv2Zme/D2F/7XhgGwhWoM9HxUgU5hDAcN72OsDwZv
         z/Ag==
X-Gm-Message-State: AOAM53074amJbr1wxVpvdmFVxbM5PTS5dlLPnJbxNpfptHfnFtOLPgT0
	c2N5o12kFdDIluD8eftlVWw=
X-Google-Smtp-Source: ABdhPJxYjTLo2qfOd0wWwuZ+o+bwZ1DSHNPGSAzwRuX6m2CVu0k46bPOAgySdkGRIdv61Zccfg9lPw==
X-Received: by 2002:ac8:6602:: with SMTP id c2mr11641275qtp.243.1592870712468;
        Mon, 22 Jun 2020 17:05:12 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Mon, 22 Jun 2020 20:05:10 -0400
To: Kees Cook <keescook@chromium.org>
Cc: Arvind Sankar <nivedita@alum.mit.edu>,
	Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20200623000510.GA3542245@rani.riverdale.lan>
References: <20200622193146.2985288-1-keescook@chromium.org>
 <20200622193146.2985288-4-keescook@chromium.org>
 <20200622225615.GA3511702@rani.riverdale.lan>
 <202006221604.871B13DE3@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202006221604.871B13DE3@keescook>

On Mon, Jun 22, 2020 at 04:07:11PM -0700, Kees Cook wrote:
> On Mon, Jun 22, 2020 at 06:56:15PM -0400, Arvind Sankar wrote:
> > On Mon, Jun 22, 2020 at 12:31:44PM -0700, Kees Cook wrote:
> > > +
> > > +#define add_random_kstack_offset() do {					\
> > > +	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
> > > +				&randomize_kstack_offset)) {		\
> > > +		u32 offset = this_cpu_read(kstack_offset);		\
> > > +		u8 *ptr = __builtin_alloca(offset & 0x3FF);		\
> > > +		asm volatile("" : "=m"(*ptr));				\
> > > +	}								\
> > > +} while (0)
> > 
> > This feels a little fragile. ptr doesn't escape the block, so the
> > compiler is free to restore the stack immediately after this block. In
> > fact, given that all you've said is that the asm modifies *ptr, but
> > nothing uses that output, the compiler could eliminate the whole thing,
> > no?
> > 
> > https://godbolt.org/z/HT43F5
> > 
> > gcc restores the stack immediately, if no function calls come after it.
> > 
> > clang completely eliminates the code if no function calls come after.
> 
> nothing uses the stack in your example. And adding a barrier (which is
> what the "=m" is, doesn't change it.

Yeah, I realized that that was what's going on. And clang isn't actually
DCE'ing it, it's taking advantage of the red zone since my alloca was
small enough.

But I still don't see anything _stopping_ the compiler from optimizing
this better in the future. The "=m" is not a barrier: it just informs
the compiler that the asm produces an output value in *ptr (and no other
outputs). If nothing can consume that output, it doesn't stop the
compiler from freeing the allocation immediately after the asm instead
of at the end of the function.

I'm talking about something like
	asm volatile("" : : "r" (ptr) : "memory");
which tells the compiler that the asm may change memory arbitrarily.

Here, we don't use it really as a barrier, but to tell the compiler that
the asm may have stashed the value of ptr somewhere in memory, so it's
not free to reuse the space that it pointed to until the function
returns (unless it can prove that nothing accesses memory, not just that
nothing accesses ptr).
