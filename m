Return-Path: <SRS0=yvzL=AD=lists.openwall.com=kernel-hardening-return-19047-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124EBC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 22:56:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 62B042075A
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 22:56:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TlW8G6Xn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62B042075A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19047-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5558 invoked by uid 550); 22 Jun 2020 22:56:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5518 invoked from network); 22 Jun 2020 22:56:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J4t/1UJvzfHD1sfeMp1vjjaj+f6i6rz7qh/A+MZJ/fk=;
        b=TlW8G6XnBweeMXO77mxR2aTGOdh/2ICx7gObCjvLq2UNfL3/HDbW+smIfJOMVG2gcL
         lsY37DUopQMvf8Aca+IyTniz/bSKymGHBgUBT8nPFFE5LfOKsAb6xRKdQ7saIovM7jrz
         Gcc7IZlLGgRdweoPdYugiSt13kCP7q8v92Q1ZSA7kXWZCK09UI3aXlgORpVu1BOgkZDq
         KDwTv2gMH5q3ZqUHxF0USrzHhMhxWfDoPXI6D1xlqh2UyyT5+bslyfezaLU9LBmlRGsx
         GS3T0H++0asrVBHeSwjH4ZsuIs3LUcr8V5bHV9uV19oqodtzFYLrhzNFidLkn9FNGOCd
         RV5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=J4t/1UJvzfHD1sfeMp1vjjaj+f6i6rz7qh/A+MZJ/fk=;
        b=D5yIpNND41g9CkuN78OYAYh+fPszUKwEAMEwbfgpZRPzVnXkwDtTJw3bSe/767Mhfl
         sL6U3bdrYn/kGRF0/almhbl8iHAGbXS+a4qpYpc1ZGTYE+4MaNqpOxyFpK4fPWZ3519r
         QMuTL1S5GSSiOcOnFhMfb+Qjz1Q5ikgy/RbuS7KF0JILLHzLtjEFYaS5ITObjbTgngE5
         f0Vrll79KFxKzoM+p3TrPFxMm5b2QiNujOl49s58nHcIARQ1XyA4kjJLGpYbokaayDqq
         bDhS16nCqGB7f//27zu/sP4IJ5VnDIzdfNL58o7IN5qGbKB0eq71Jq4bxxGwPwkelMmo
         2uvA==
X-Gm-Message-State: AOAM532x8ZzfAzwRUhySBXEyzNjDhSiBiAiSIHUf+sIp0b2Ts00XZH0X
	DXjKWKrNztGdvldJyqPIGqM=
X-Google-Smtp-Source: ABdhPJx6ViX3VUi9U5rO1UC8eBAxyutLutchUmhepd+t1xhXYQPr9V9FJEHmR0NJcQTmGq+2dhFMVQ==
X-Received: by 2002:ac8:72d2:: with SMTP id o18mr6306890qtp.208.1592866577875;
        Mon, 22 Jun 2020 15:56:17 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Mon, 22 Jun 2020 18:56:15 -0400
To: Kees Cook <keescook@chromium.org>
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
Message-ID: <20200622225615.GA3511702@rani.riverdale.lan>
References: <20200622193146.2985288-1-keescook@chromium.org>
 <20200622193146.2985288-4-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200622193146.2985288-4-keescook@chromium.org>

On Mon, Jun 22, 2020 at 12:31:44PM -0700, Kees Cook wrote:
> +
> +#define add_random_kstack_offset() do {					\
> +	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
> +				&randomize_kstack_offset)) {		\
> +		u32 offset = this_cpu_read(kstack_offset);		\
> +		u8 *ptr = __builtin_alloca(offset & 0x3FF);		\
> +		asm volatile("" : "=m"(*ptr));				\
> +	}								\
> +} while (0)

This feels a little fragile. ptr doesn't escape the block, so the
compiler is free to restore the stack immediately after this block. In
fact, given that all you've said is that the asm modifies *ptr, but
nothing uses that output, the compiler could eliminate the whole thing,
no?

https://godbolt.org/z/HT43F5

gcc restores the stack immediately, if no function calls come after it.

clang completely eliminates the code if no function calls come after.

I'm not sure why function calls should affect it, though, given that
those functions can't possibly access ptr or the memory it points to.

A full memory barrier (like barrier_data) should be better -- it gives
the compiler a reason to believe that ptr might escape and be accessed
by any code following the block?
