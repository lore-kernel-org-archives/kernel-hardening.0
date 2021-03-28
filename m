Return-Path: <SRS0=pG5h=I2=lists.openwall.com=kernel-hardening-return-21073-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD52CC433C1
	for <kernel-hardening@archiver.kernel.org>; Sun, 28 Mar 2021 14:42:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E97D66196E
	for <kernel-hardening@archiver.kernel.org>; Sun, 28 Mar 2021 14:42:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E97D66196E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21073-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7802 invoked by uid 550); 28 Mar 2021 14:42:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7782 invoked from network); 28 Mar 2021 14:42:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1616942523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D54Z2PmLCo200yXOSvaj2hVPC2HaVunYq4YcYHV7CLI=;
	b=nOSANqfo4EtIMAP5mGifyuzW2Af52m5HsKAtyMqUUKMzc0XR6FoAXid/2jQwT1JZL0bk7z
	XPx6W8UmnTT3Jx8MOw6POYFwlaSRgC40XHyAM5M5FsbPbyOmckgM3CeZ6439glilf+vtSq
	sV/a3k181wHYDoGE2YkUj9wK8HnMhNzpeJaVEDbXe5/Xjgk8QNWJBHO+6uqjcNoR+FXFCZ
	yESHY04k4zxypQtFZ8DrCTzA11YAhm/q9JYc/rH+HEA/Aq5HxI9j53+8VORvF9pvloSBK+
	YRfZClUyO8fKSqfnrPgq+eK5DxXnt0UkMYLx1a/LsXp/dt707mjcotvIBxFSaA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1616942523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D54Z2PmLCo200yXOSvaj2hVPC2HaVunYq4YcYHV7CLI=;
	b=2/R47s1sLunWDFbaoDjixBAOVW6iJ5IR9uZH6pLWwX8sxIDwqn63g4zVRcfcZhQBqAGFeV
	mga+yqnJjOZqMqCQ==
To: Kees Cook <keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander Potapenko <glider@google.com>, Alexander Popov <alex.popov@linux.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/6] stack: Optionally randomize kernel stack offset each syscall
In-Reply-To: <20210319212835.3928492-4-keescook@chromium.org>
References: <20210319212835.3928492-1-keescook@chromium.org> <20210319212835.3928492-4-keescook@chromium.org>
Date: Sun, 28 Mar 2021 16:42:03 +0200
Message-ID: <87eefzcpc4.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain

Kees,

On Fri, Mar 19 2021 at 14:28, Kees Cook wrote:
> +/*
> + * Do not use this anywhere else in the kernel. This is used here because
> + * it provides an arch-agnostic way to grow the stack with correct
> + * alignment. Also, since this use is being explicitly masked to a max of
> + * 10 bits, stack-clash style attacks are unlikely. For more details see
> + * "VLAs" in Documentation/process/deprecated.rst

VLAs are bad, VLAs to the rescue! :)

> + * The asm statement is designed to convince the compiler to keep the
> + * allocation around even after "ptr" goes out of scope.
> + */
> +void *__builtin_alloca(size_t size);
> +
> +#define add_random_kstack_offset() do {					\
> +	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
> +				&randomize_kstack_offset)) {		\
> +		u32 offset = this_cpu_read(kstack_offset);              \

Not that it matters on x86, but as this has to be called in the
interrupt disabled region of the syscall entry, shouldn't this be a
raw_cpu_read(). The asm-generic version has a preempt_disable/enable
pair around the raw read for native wordsize reads, otherwise a
irqsave/restore pair.

__this_cpu_read() is fine as well, but that has an sanity check before
the raw read when CONFIG_DEBUG_PREEMPT is on, which is harmless but
also pointless in this case.

Probably the same for the counterpart this_cpu_write().

Thanks,

        tglx
