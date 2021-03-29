Return-Path: <SRS0=xp78=I3=lists.openwall.com=kernel-hardening-return-21077-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7541C433C1
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Mar 2021 18:43:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D1D1961981
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Mar 2021 18:43:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1D1961981
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21077-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19685 invoked by uid 550); 29 Mar 2021 18:43:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19664 invoked from network); 29 Mar 2021 18:43:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LlNrP/9Ut5sXN3pkzKNi+WSrlgUBYs/IFekoNMyL2Jw=;
        b=T+DpvsxQed12BAoexlkki+09jZcOH2cjiPTOOafDyn6acCeGPxIcFenrtcJ3zGGa8+
         mSk7Iu22+Txx0wacKigEu3+FnKaFEgH82nuqdasm4GN0gQoF+hpT3m52TrAsh9p0Gnkv
         ME2leGRxC72wu2uxStmg0L9ey3ygUFNqHk0V4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LlNrP/9Ut5sXN3pkzKNi+WSrlgUBYs/IFekoNMyL2Jw=;
        b=sUbc2rWDdD8Z/zavP4n+85zCQyOSKCpvic2VyBIAgGZ0QgUIdHt0jYpCMANBlYPMXH
         1hmQHSwpCFGzDR/H7k4wBjI0LWKTTIoXRi0y3v+cqD/rUd7UI2H+oQAhvEhXpI4uQ9Wd
         XKyVMGQ91b+WI4yxUtS6FcR2CzedJyXNGCOhJxmD/VkzFChNM7zkbQfacDklhvMpQYwT
         r30f9XsCmiq5cmSVfue89D7BvZAGQcLz4KVbfe3lxcoGWlLAwD2Dlj4sUAShqKEiN53q
         RuU6y3q4EM22FvLvIIgnJPkv0ABSwClaCibKo40tERBs+FA9qhMbCbvBWD8R1w5fFzI/
         POBA==
X-Gm-Message-State: AOAM531Q+6gbiK/chKJGUu+eLre1KqL9dlC8vb3F1GGvSOpg4higUCM6
	lbqSoxA6IHdbrSbRiN9hbT1bHg==
X-Google-Smtp-Source: ABdhPJxToxGXO0GwIsEriJuM+yDUQVqjN+yq+LJpGrMhEoXh9Okut5BCawWoS9xITNbBK4nDieDGBg==
X-Received: by 2002:a17:90a:bd09:: with SMTP id y9mr458540pjr.179.1617043404655;
        Mon, 29 Mar 2021 11:43:24 -0700 (PDT)
Date: Mon, 29 Mar 2021 11:43:23 -0700
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
Subject: Re: [PATCH v7 4/6] x86/entry: Enable random_kstack_offset support
Message-ID: <202103291141.EC2A77731@keescook>
References: <20210319212835.3928492-1-keescook@chromium.org>
 <20210319212835.3928492-5-keescook@chromium.org>
 <87h7kvcqen.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7kvcqen.ffs@nanos.tec.linutronix.de>

On Sun, Mar 28, 2021 at 04:18:56PM +0200, Thomas Gleixner wrote:
> On Fri, Mar 19 2021 at 14:28, Kees Cook wrote:
> > +
> > +	/*
> > +	 * x86_64 stack alignment means 3 bits are ignored, so keep
> > +	 * the top 5 bits. x86_32 needs only 2 bits of alignment, so
> > +	 * the top 6 bits will be used.
> > +	 */
> > +	choose_random_kstack_offset(rdtsc() & 0xFF);
> 
> Comment mumbles about 5/6 bits and the TSC value is masked with 0xFF and
> then the applied offset is itself limited with 0x3FF.
> 
> Too many moving parts for someone who does not have the details of all
> this memorized.

Each piece is intentional -- I will improve the comments to explain
each level of masking happening (implicit compiler stack alignment mask,
explicit per-arch mask, and the VLA upper-bound protection mask).

-- 
Kees Cook
