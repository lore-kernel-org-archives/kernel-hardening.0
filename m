Return-Path: <SRS0=mpyb=I5=lists.openwall.com=kernel-hardening-return-21096-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62854C433C1
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Mar 2021 07:53:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 82B7261582
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Mar 2021 07:53:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82B7261582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21096-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27729 invoked by uid 550); 31 Mar 2021 07:53:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27709 invoked from network); 31 Mar 2021 07:53:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1617177206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+ZtZF2/xRNH8fh4hE5BwT2wTWTeqB0uXB55wapYkngo=;
	b=GWyURJemE04fXbv/dNXDF/0LWRaQ4tGALC9OOaZZX1jX909PJnJqQNLmRHU5bdnoOe2BPx
	0l8tqzO1C4X81JC4UF9EgqK+rv+MMuq4vKZKBmgS5xgoh8kHJoK3yGMc2JwD7K7KVPN5Zq
	RLphVVO5mdZn4sd3F2SxpVYjMeGrFZSuYdnsdxeQ9UVJIKrFKj+c/KkC8NhGXn4uFrQQUq
	9QLF3bKV+Mu5u9aWn5wv2Q3URdLLaeajI6nGfeAAJVefUJq5RO+JEKMZN24tbHnVEBUmEF
	FOZzekWqIHRsr935F3eIGzBuCrVBchBs81pOqz2+wQGf9LvkUKRzkPamj+H42g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1617177206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+ZtZF2/xRNH8fh4hE5BwT2wTWTeqB0uXB55wapYkngo=;
	b=FVaJ/rkH5MysXsEMr6SCeJ7tpYOEQWBQj1HtTudrC96F3XUvn+lMIWByyEe5qL5WKknhun
	e3t0jDC5LkQ4NZCQ==
To: Kees Cook <keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander Potapenko <glider@google.com>, Alexander Popov <alex.popov@linux.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/6] stack: Optionally randomize kernel stack offset each syscall
In-Reply-To: <20210330205750.428816-4-keescook@chromium.org>
References: <20210330205750.428816-1-keescook@chromium.org> <20210330205750.428816-4-keescook@chromium.org>
Date: Wed, 31 Mar 2021 09:53:26 +0200
Message-ID: <87im5769op.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Mar 30 2021 at 13:57, Kees Cook wrote:
> +/*
> + * Do not use this anywhere else in the kernel. This is used here because
> + * it provides an arch-agnostic way to grow the stack with correct
> + * alignment. Also, since this use is being explicitly masked to a max of
> + * 10 bits, stack-clash style attacks are unlikely. For more details see
> + * "VLAs" in Documentation/process/deprecated.rst
> + * The asm statement is designed to convince the compiler to keep the
> + * allocation around even after "ptr" goes out of scope.

Nit. That explanation of "ptr" might be better placed right at the
add_random...() macro.

> + */
> +void *__builtin_alloca(size_t size);
> +/*
> + * Use, at most, 10 bits of entropy. We explicitly cap this to keep the
> + * "VLA" from being unbounded (see above). 10 bits leaves enough room for
> + * per-arch offset masks to reduce entropy (by removing higher bits, since
> + * high entropy may overly constrain usable stack space), and for
> + * compiler/arch-specific stack alignment to remove the lower bits.
> + */
> +#define KSTACK_OFFSET_MAX(x)	((x) & 0x3FF)
> +
> +/*
> + * These macros must be used during syscall entry when interrupts and
> + * preempt are disabled, and after user registers have been stored to
> + * the stack.
> + */
> +#define add_random_kstack_offset() do {					\
> +	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
> +				&randomize_kstack_offset)) {		\
> +		u32 offset = __this_cpu_read(kstack_offset);		\
> +		u8 *ptr = __builtin_alloca(KSTACK_OFFSET_MAX(offset));	\
> +		asm volatile("" : "=m"(*ptr) :: "memory");		\
> +	}								\
> +} while (0)

Other than that.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
