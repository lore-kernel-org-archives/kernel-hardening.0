Return-Path: <SRS0=d4ev=I6=lists.openwall.com=kernel-hardening-return-21134-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B482AC433B4
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 22:42:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AF48D610F9
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 22:42:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF48D610F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21134-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9798 invoked by uid 550); 1 Apr 2021 22:42:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9774 invoked from network); 1 Apr 2021 22:42:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XHU/CSlbR0tXIQ7skc+D9M4sQ8Nf+DFxpytkWh85RTc=;
        b=Cdeb4TJryjuUvq0PZ22+p9aZ80XrqpLOQqZBbyxQf2b3KNvemF9hZdYHkWk2rvgvr9
         +SpPIdq+JMo2g9UMPmRHYMNVYDXvm5KREo94cbMizN1C/uol3pIjbIlmE2pjHUirEook
         l3tfPMZVPC0JP0fRuhcSZ92o1n77ukI4HC3SY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XHU/CSlbR0tXIQ7skc+D9M4sQ8Nf+DFxpytkWh85RTc=;
        b=bsjrnH78Zac6tUetmxzKn5C9ir8djDXZRxDoKZ27N4uFVPvDnmOLeJD7UGpZlLDs1e
         Q/CVw6/tbWSUJpLk+PMfPS0bfqybVhzgantgdx/orl3Memxzujx/RCl7Nj88WNiXGf0s
         ZBBgByUaW/G8e9rj8VLTjem8No7ai0Lkn0zu3KMCEcpmyzBFT2fETb9HUQ63GGPC5S7b
         O1cAVU9VSzJH0RhqI2aXgvoIHCT18j0qjmsaY3zI+9jmh4M0ofhcHmY8beXFbSZ2Brx4
         928JgBKI0qK+oqe0a5oz94UvU8RClyR0ENHel0f5IkM1Lp8N1gXYg4uGhl4lOWdiaDiJ
         RZhg==
X-Gm-Message-State: AOAM5321qW9k9yFjshsNmoK/pWSp4dnmMJLTAtc19dnCkdWtT91s+QLO
	eQTxnDgF2VEL0msTwAQgBCJUCg==
X-Google-Smtp-Source: ABdhPJy5OYaYtgibg+iSJ6TbNgMEMp0Li4wFRje6LCbJMZHyUSADLtOfsJcpWv8pBVkoh3+T2eGIQA==
X-Received: by 2002:a65:56cc:: with SMTP id w12mr9470880pgs.354.1617316931239;
        Thu, 01 Apr 2021 15:42:11 -0700 (PDT)
Date: Thu, 1 Apr 2021 15:42:08 -0700
From: Kees Cook <keescook@chromium.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Will Deacon' <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 3/6] stack: Optionally randomize kernel stack offset
 each syscall
Message-ID: <202104011447.2E7F543@keescook>
References: <20210330205750.428816-1-keescook@chromium.org>
 <20210330205750.428816-4-keescook@chromium.org>
 <20210401083034.GA8554@willie-the-truck>
 <61ae9398a03d4fe7868b68c9026d5998@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61ae9398a03d4fe7868b68c9026d5998@AcuMS.aculab.com>

On Thu, Apr 01, 2021 at 11:15:43AM +0000, David Laight wrote:
> From: Will Deacon
> > Sent: 01 April 2021 09:31
> ...
> > > +/*
> > > + * These macros must be used during syscall entry when interrupts and
> > > + * preempt are disabled, and after user registers have been stored to
> > > + * the stack.
> > > + */
> > > +#define add_random_kstack_offset() do {					\
> > > +	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
> > > +				&randomize_kstack_offset)) {		\
> > > +		u32 offset = __this_cpu_read(kstack_offset);		\
> > > +		u8 *ptr = __builtin_alloca(KSTACK_OFFSET_MAX(offset));	\
> > > +		asm volatile("" : "=m"(*ptr) :: "memory");		\
> > 
> > Using the "m" constraint here is dangerous if you don't actually evaluate it
> > inside the asm. For example, if the compiler decides to generate an
> > addressing mode relative to the stack but with writeback (autodecrement), then
> > the stack pointer will be off by 8 bytes. Can you use "o" instead?

I see other examples of empty asm, but it's true, none are using "=m" read
constraints. But, yes, using "o" appears to work happily.

> Is it allowed to use such a mode?
> It would have to know that the "m" was substituted exactly once.
> I think there are quite a few examples with 'strange' uses of memory
> asm arguments.
> 
> However, in this case, isn't it enough to ensure the address is 'saved'?
> So:
> 	asm volatile("" : "=r"(ptr) );
> should be enough.

It isn't, it seems.

Here's a comparison:

https://godbolt.org/z/xYGn9GfGY

So, I'll resend with "o", and with raw_cpu_*().

Thanks!

-- 
Kees Cook
