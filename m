Return-Path: <SRS0=kXB+=I5=lists.openwall.com=kernel-hardening-return-21107-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94033C43460
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Mar 2021 22:38:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8A0F161008
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Mar 2021 22:38:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A0F161008
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21107-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24359 invoked by uid 550); 31 Mar 2021 22:38:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24339 invoked from network); 31 Mar 2021 22:38:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1617230311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MTAca8jamyiv4OQC/0ehNmkUzrYgK82+B2gnABlfuE4=;
	b=wLJuSNRlSVF/PkDm3fuzha7lpECmwuVqtA03/nXyQDXDAWvBirH+/fYTNYqrnlItwtLK39
	ueabTGEjWfDwJRWajmljjDlBBRKb1e4iWShFRNEaFV/o2ysNaExtYxnlKlAmRe3XZMJnKG
	bNQvUoKtTg4fdrC48N52k6UMO9iR3DD92508uibjdl9Mmhw/WkzMQdF6Rjwqo7Q7jvmbj+
	WxukKQ1OuTjvMmPRlRVQVfC0Htd3LczE5FTUIDbv/T8HXjwy0JEUrOjh1ErBC+f7z6rUNc
	jP8Y+MbOuHb2pyR7nVtU21KL+1pc2hsRU+1ZQlaM5d6XOuJe6UKGsmHaYhzSQA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1617230311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MTAca8jamyiv4OQC/0ehNmkUzrYgK82+B2gnABlfuE4=;
	b=yTpBUljzXJtrMhJ2lcQnuH9tBbKROS0ovJE/lzzYE7vrNqhZtLuA5E4XjbMAeCAsuBkJfi
	LNLwWc3mHTWDTwBw==
To: Kees Cook <keescook@chromium.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander Potapenko <glider@google.com>, Alexander Popov <alex.popov@linux.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/6] stack: Optionally randomize kernel stack offset each syscall
In-Reply-To: <202103311453.A840B7FC5@keescook>
References: <20210330205750.428816-1-keescook@chromium.org> <20210330205750.428816-4-keescook@chromium.org> <87im5769op.ffs@nanos.tec.linutronix.de> <202103311453.A840B7FC5@keescook>
Date: Thu, 01 Apr 2021 00:38:31 +0200
Message-ID: <87v9973q54.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Mar 31 2021 at 14:54, Kees Cook wrote:
> On Wed, Mar 31, 2021 at 09:53:26AM +0200, Thomas Gleixner wrote:
>> On Tue, Mar 30 2021 at 13:57, Kees Cook wrote:
>> > +/*
>> > + * Do not use this anywhere else in the kernel. This is used here because
>> > + * it provides an arch-agnostic way to grow the stack with correct
>> > + * alignment. Also, since this use is being explicitly masked to a max of
>> > + * 10 bits, stack-clash style attacks are unlikely. For more details see
>> > + * "VLAs" in Documentation/process/deprecated.rst
>> > + * The asm statement is designed to convince the compiler to keep the
>> > + * allocation around even after "ptr" goes out of scope.
>> 
>> Nit. That explanation of "ptr" might be better placed right at the
>> add_random...() macro.
>
> Ah, yes! Fixed in v9.

Hmm, looking at V9 the "ptr" thing got lost ....

> +/*
> + * Do not use this anywhere else in the kernel. This is used here because
> + * it provides an arch-agnostic way to grow the stack with correct
> + * alignment. Also, since this use is being explicitly masked to a max of
> + * 10 bits, stack-clash style attacks are unlikely. For more details see
> + * "VLAs" in Documentation/process/deprecated.rst
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

> Do you want to take this via -tip (and leave off the arm64 patch until
> it is acked), or would you rather it go via arm64? (I've sent v9 now...)

Either way is fine.

Thanks,

        tglx
