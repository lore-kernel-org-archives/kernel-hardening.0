Return-Path: <SRS0=rdQj=I6=lists.openwall.com=kernel-hardening-return-21114-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5491BC433B4
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 13:33:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 51CA961220
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 13:33:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51CA961220
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21114-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30659 invoked by uid 550); 1 Apr 2021 13:33:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30637 invoked from network); 1 Apr 2021 13:33:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1617283982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HZjvyKpt+QXry8euYSSyT/r99M7FJN1MQXh9qXC4Ovc=;
	b=OH/CF4HibPXVGkUdfGd2pL1pUjUIF436O4FRK6nP0rQgDA27/0DbpRpklUSnYW6qo7N47Z
	bwGU896e+og2wjEMgi8YAD/XxNXlGeeySxLnCVqTq2swbV/WvxqlCDTQsnAFsIEuqKFjzE
	WcINh7uptDUpKxjulazD79npSLL2TFYdlt9Pdqf8pKMSwHfWPX/H1e0RdOnL4nH93SurQI
	nDy8RSI+Ffr8J1Jx0Cx2jYbd9ysbf4324yA1V8OKnDMRrn/NoZspWKlGuh2P+n/jco5yYQ
	OpJS6Bcofv4VluIdc8RKCDyT/Gu+YI3XTIRRnOKANzysJq+uW1E8m+Q7qGsd2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1617283982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HZjvyKpt+QXry8euYSSyT/r99M7FJN1MQXh9qXC4Ovc=;
	b=yG7k2QB1PDjKcVufvbc8qoQOxN5QwFy6nxDd8786TOEt1taaumoojXztjePOcCOmuF4672
	o8XO9neOntE3BqBw==
To: Will Deacon <will@kernel.org>, Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Alexander Potapenko <glider@google.com>, Alexander Popov <alex.popov@linux.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 0/6] Optionally randomize kernel stack offset each syscall
In-Reply-To: <20210401083758.GA8745@willie-the-truck>
References: <20210331205458.1871746-1-keescook@chromium.org> <20210401083758.GA8745@willie-the-truck>
Date: Thu, 01 Apr 2021 15:33:02 +0200
Message-ID: <87sg4a3zap.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Apr 01 2021 at 09:37, Will Deacon wrote:
> On Wed, Mar 31, 2021 at 01:54:52PM -0700, Kees Cook wrote:
>> Hi Will (and Mark and Catalin),
>> 
>> Can you take this via the arm64 tree for v5.13 please? Thomas has added
>> his Reviewed-by, so it only leaves arm64's. :)
>
> Sorry, these got mixed up in my inbox so I just replied to v7 and v8 and
> then noticed v9. Argh!
>
> However, I think the comments still apply: namely that the dummy "=m" looks
> dangerous to me

> https://lore.kernel.org/r/20210401083034.GA8554@willie-the-truck

Hrmpf, didn't think about that.

> and I think you're accessing pcpu variables with preemption enabled
> for the arm64 part:

That's my fault. On x86 this is invoked right after coming up into C
code and _before_ enabling interrupts, which I why I suggested not to
use the wrapped one. raw_cpu_read() should be fine everywhere.

Thanks,

        tglx
