Return-Path: <SRS0=eN2f=I5=lists.openwall.com=kernel-hardening-return-21106-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7979C433B4
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Mar 2021 21:55:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D6E5761003
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Mar 2021 21:55:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6E5761003
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21106-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26356 invoked by uid 550); 31 Mar 2021 21:55:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26333 invoked from network); 31 Mar 2021 21:55:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rtsfbkg65ln578BueP2qKUJ2W4TVYylDnpFNvn0AmZY=;
        b=lFIjHUpJ6J2bChkAW6VFomn72sxkplIQywWFLHMael4kNCA63jvDhP8bxintcnt5bw
         KQBjDW0tdgan1Mw+ew9YOivDWjvq1y/RLhovgps8HPve8vSaz1UqvITEKhuq5UCgL/Wz
         NM80b1+1PpQm7Vs1o0Fx6Yx2NIh0Uno3lLAkY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rtsfbkg65ln578BueP2qKUJ2W4TVYylDnpFNvn0AmZY=;
        b=TV1EUGPQGuccZzynpuvAz64IezqC4kUG7xW00gLGtBbVyQLDbVhKkVpsOUCRcRr7ie
         dkDVoVX7tOW1Kfr+AyBF+abalvBb5Qc++8NjKXrWoqlWvHKmxJcz/ATqcnD68eNar6x8
         PB+jRDzQJvL+CyFcTE2jmZcDmgvzUrW7nO//DvLFz2YXYWNS1CLoX9Sp5UE3npQ4jJz3
         wbM/b3D/QDDgLhtB17vLkiwNAdxDZxn0J0PnN/FCQJUBMMawO3fsW5xvKrvxDyhYzByh
         JMXeAQPkhBon1IOtV/cT2rzxmL/ret6J91U0T0cD9ZFWCiZSZEdskNyDxUMh5pWmLRdG
         f6nw==
X-Gm-Message-State: AOAM533WkhdCtQC2UVL+SJfACSMMOaAVQQoG8KxfS3cjc5F9ScLxumOc
	T2KRM59vK7dnCZCBHebuH1cTFA==
X-Google-Smtp-Source: ABdhPJy+ITLzRDWVQZ4QLokxo3xwGBU2j8b+z7YKdSsnEN/k5kQuDOdpvQny/ml71yhjeB4NsIqJiQ==
X-Received: by 2002:a05:6a00:22c6:b029:201:1166:fdad with SMTP id f6-20020a056a0022c6b02902011166fdadmr4839743pfj.58.1617227698663;
        Wed, 31 Mar 2021 14:54:58 -0700 (PDT)
Date: Wed, 31 Mar 2021 14:54:57 -0700
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
Subject: Re: [PATCH v8 3/6] stack: Optionally randomize kernel stack offset
 each syscall
Message-ID: <202103311453.A840B7FC5@keescook>
References: <20210330205750.428816-1-keescook@chromium.org>
 <20210330205750.428816-4-keescook@chromium.org>
 <87im5769op.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87im5769op.ffs@nanos.tec.linutronix.de>

On Wed, Mar 31, 2021 at 09:53:26AM +0200, Thomas Gleixner wrote:
> On Tue, Mar 30 2021 at 13:57, Kees Cook wrote:
> > +/*
> > + * Do not use this anywhere else in the kernel. This is used here because
> > + * it provides an arch-agnostic way to grow the stack with correct
> > + * alignment. Also, since this use is being explicitly masked to a max of
> > + * 10 bits, stack-clash style attacks are unlikely. For more details see
> > + * "VLAs" in Documentation/process/deprecated.rst
> > + * The asm statement is designed to convince the compiler to keep the
> > + * allocation around even after "ptr" goes out of scope.
> 
> Nit. That explanation of "ptr" might be better placed right at the
> add_random...() macro.

Ah, yes! Fixed in v9.

> Other than that.
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Thank you for the reviews!

Do you want to take this via -tip (and leave off the arm64 patch until
it is acked), or would you rather it go via arm64? (I've sent v9 now...)

-- 
Kees Cook
