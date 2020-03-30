Return-Path: <SRS0=ZJDb=5Q=lists.openwall.com=kernel-hardening-return-18338-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A911C2D0F2
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 14:25:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 702E7207FF
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 14:25:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kui63y9F"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 702E7207FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18338-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15556 invoked by uid 550); 31 Mar 2020 14:25:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15510 invoked from network); 31 Mar 2020 14:25:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zFezxGPsyLpYhR0ox7KaSCSsmOf9Nv4P7a8TQy3AEWA=;
        b=kui63y9FrsIxlmLnNNmwJXRNc4d5KtuCI1cHY11sSFYq2KfwtdcIa936YyorHFthi2
         u51IRjzHkfjRWkdg1nOlfPmBiFRpfWsRggkVi8wPGm7uCexv7iA+C+qluXeiGIDUXryq
         k1YhMeoXHScS5YyYxvg51WLdW+V/wYDY0fkl4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zFezxGPsyLpYhR0ox7KaSCSsmOf9Nv4P7a8TQy3AEWA=;
        b=KC3yWVbKf5SaVVRw+Y8nFbQejQh4H4MYsIZK8R5NjSA6TxkiXE8+rTumGTX0hU67wH
         6O+if4vnf8NF7h5KrvDaGR2V3d8nl66bqexUTkT7F6WIMbV3mAm0KFQQOcy/Qad5kIxQ
         11G0tXc7FaLWG4RQCOxyzDMrZDN6kxbP2nW4KRIgUD4VPi5fzeH5Mf9L2BTZfjGixRz1
         2B0mzO4QUllRvZeGMWq0sFAQ+n70EwVwHi+xHCBbf6YrlBKy9h1Wl4+oAEPIW2u/zUPX
         7rGXknjOmScTqETASxfoXQ+o2o/mcfeod5z4d1IPuA9Pz7o9LLHdqwlu7CCLUr4YQqCf
         jI2A==
X-Gm-Message-State: ANhLgQ0UhB/ULxeT+CjMkMjJEkpILi6fqlmtP7kdp+VtngXXuHyYrQ8X
	Z86YfRkJwpga/RZcPhKeLIDiOA==
X-Google-Smtp-Source: ADFU+vtkTDKkSRJvhWJLA7hYxbwYlTJ0X4a7SDipA3reIPvc6zMuV2c0VM5b15ltd1k0YTjdeBT8eQ==
X-Received: by 2002:a62:8f0c:: with SMTP id n12mr18284422pfd.226.1585664721989;
        Tue, 31 Mar 2020 07:25:21 -0700 (PDT)
Date: Mon, 30 Mar 2020 11:27:19 -0700
From: Kees Cook <keescook@chromium.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	"Perla, Enrico" <enrico.perla@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] stack: Optionally randomize kernel stack offset
 each syscall
Message-ID: <202003301122.354B722@keescook>
References: <20200324203231.64324-1-keescook@chromium.org>
 <20200324203231.64324-4-keescook@chromium.org>
 <20200330112536.GD1309@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330112536.GD1309@C02TD0UTHF1T.local>

On Mon, Mar 30, 2020 at 12:25:36PM +0100, Mark Rutland wrote:
> On Tue, Mar 24, 2020 at 01:32:29PM -0700, Kees Cook wrote:
> > +/*
> > + * Do not use this anywhere else in the kernel. This is used here because
> > + * it provides an arch-agnostic way to grow the stack with correct
> > + * alignment. Also, since this use is being explicitly masked to a max of
> > + * 10 bits, stack-clash style attacks are unlikely. For more details see
> > + * "VLAs" in Documentation/process/deprecated.rst
> > + */
> > +void *__builtin_alloca(size_t size);
> > +
> > +#define add_random_kstack_offset() do {					\
> > +	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
> > +				&randomize_kstack_offset)) {		\
> > +		u32 offset = this_cpu_read(kstack_offset);		\
> > +		char *ptr = __builtin_alloca(offset & 0x3FF);		\
> > +		asm volatile("" : "=m"(*ptr));				\
> 
> Is this asm() a homebrew OPTIMIZER_HIDE_VAR(*ptr)? If the asm
> constraints generate metter code, could we add those as alternative
> constraints in OPTIMIZER_HIDE_VAR() ?

Er, no, sorry, not the same. I disassembled the wrong binary. :)

With     asm volatile("" : "=m"(*ptr))

ffffffff810038bc:       48 8d 44 24 0f          lea    0xf(%rsp),%rax
ffffffff810038c1:       48 83 e0 f0             and    $0xfffffffffffffff0,%rax


With   __asm__ ("" : "=r" (var) : "0" (var))

ffffffff810038bc:       48 8d 54 24 0f          lea    0xf(%rsp),%rdx
ffffffff810038c1:       48 83 e2 f0             and    $0xfffffffffffffff0,%rdx
ffffffff810038c5:       0f b6 02                movzbl (%rdx),%eax
ffffffff810038c8:       88 02                   mov    %al,(%rdx)


It looks like OPTIMIZER_HIDE_VAR() is basically just:

	var = var;

In the former case, we avoid the write and retain the allocation. So I
think don't think OPTIMIZER_HIDE_VAR() should be used here, nor should
OPTIMIZER_HIDE_VAR() be changed to remove the "0" (var) bit.

-- 
Kees Cook
