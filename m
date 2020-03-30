Return-Path: <SRS0=ViId=5Q=lists.openwall.com=kernel-hardening-return-18337-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786A8C43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 14:15:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C740D207FF
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 14:15:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="X+fgDi3M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C740D207FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18337-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9995 invoked by uid 550); 31 Mar 2020 14:15:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9960 invoked from network); 31 Mar 2020 14:15:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zTyZUZyP+zXDM17uOl5EO7jnuzHUmLuralf0hD1C7uQ=;
        b=X+fgDi3MlKSPCh2sgIYL+gkLlsZfyMGWwuidp67Y/1xJSJpN6GiCrcKj4vscCntt5X
         AsoSD/y4zBkHXejpqSRnno4P4EIdp8HhS1WuvfQUKvsUfsyvyJIqVP5BNhp1WI9YXqSe
         Z6QL0bcqJwst77oznDjNOVFNBeNpNp6rUlFeQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zTyZUZyP+zXDM17uOl5EO7jnuzHUmLuralf0hD1C7uQ=;
        b=soWUEF3iSn6gwm+2yFmcn+x0EGYKVGS+TYppXTe3dlPvACOL4Y4PgWkISTsRzO84E7
         F20W6UyzlphMSNf3d1owMQvTWL6csfmz/9JSskk32lHoVwv+GGqs36LKUNYDianyNQIG
         Obv82dGzhc18PRcQw31oENIS0ED/YatGvXBoc0z12efdPvuYTWYS5WM3JR6+xNHL4ZKw
         j78Vb+t0Z3+Ja7SBOVrOf6v/FIqG4yfZNjYyasH2/+jXyai1nwjheD+AAmcqLrpsRP/S
         EFov6QxAI2ECzld9DFR5Uv2QBXUMQ3TScAB7kqO5Y1BiBn5bVmvxONvfVSUSvaEaDGjB
         QAHw==
X-Gm-Message-State: AGi0PubVWZTFyKvaFC5ds0jcsu3tLQu8k7QYoTzimL/msBXZ8AocteXJ
	nsbvoZEYBxOV4jNU4R80J0A4dw==
X-Google-Smtp-Source: APiQypIT3n7KLf8ko7LebvhJ17T7gGW5sDePBsyltHCF4aEdKZNxQ/m3qhCvFd7PBcLmqZTusgipUw==
X-Received: by 2002:a17:90a:202f:: with SMTP id n44mr4330392pjc.150.1585664122467;
        Tue, 31 Mar 2020 07:15:22 -0700 (PDT)
Date: Mon, 30 Mar 2020 11:18:40 -0700
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
Message-ID: <202003301116.081DB02@keescook>
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

Hah, yes, it is. And this produces identical asm, so I've replaced it
with OPTIMIZER_HIDE_VAR() now. Now if I could figure out how to hide it
from stack protector. :(

-- 
Kees Cook
