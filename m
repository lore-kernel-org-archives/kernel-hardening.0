Return-Path: <SRS0=E0i4=6G=lists.openwall.com=kernel-hardening-return-18613-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4C1C55186
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 23:54:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6EF2D206ED
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 23:54:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ul4AvjVQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EF2D206ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18613-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23917 invoked by uid 550); 22 Apr 2020 23:54:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23894 invoked from network); 22 Apr 2020 23:54:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9yta31YHLGTtMTc3kimrMC0tNHi4fPt9ZpXXfvJokHE=;
        b=ul4AvjVQXbGe+67+07L6i6vBhv+ePFHnNv5wOIO5OLBqKwlga7zXiy6xS1d0X/n/tF
         6woOlNdImmOPZMJChQsUQyygz5ZseUPmnZAKczKpT7Y7lInJ6k/DDJqqloDP2VpGFDPw
         OFtrm1ALOx3/hCMPr/YQ3m1N7xm3tLJ/pl95K3DRTQoOWwlka1VKxTJhNX6t7x3uramm
         2dyep6SUwSuJ79qzMc80b3OzgAHRlzEcC+sG84d0mATYPxu/tkZ16ivMuXJA1CHS9gCY
         zZTcPJxWLKTN7QTPUPa2eVcTdjKumsRqOxjD1k+RVCHPaHKtuxR9qW1L8MlMmMCCFv+Y
         LkDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9yta31YHLGTtMTc3kimrMC0tNHi4fPt9ZpXXfvJokHE=;
        b=PxMKnFvKkIOfCVTLDeDH/+qu6A8CKKL5ebEdLrLBw8R5ayM89fi6ab92VQdd5OEbQU
         XYBRzKFvGumqL97PqZjYXu7ZF+NuHgZYpFknemck4tMv8keW9t+kffAFYkZVX4yPcAx5
         BnwD94h2MZ4o2ZAwiMomP4WKH0rWUcuorsyT4QUeaaIah5ZzT5VEgHEs+8bV0cI1Otmt
         tt2WIdbqGNg8pWKIeww5y9W1vjtXlNv7qkTQ1bfUmCddRAMnyh6BBeOdXhb4mIq/avhk
         0DrVrzY4diLtoQ66CLoi7P5pJoEFbY2bn75gV9+ppPX3311DOKb1I2oQt65GX0NC5X4K
         BiUw==
X-Gm-Message-State: AGi0PubVdXpC7OcEnGUh9ocjCKDla5S2rF0jVEB+HsnHHnQRtqQtO3jB
	YZhyuMUOXxKU1u+gKI1jmEw6fw==
X-Google-Smtp-Source: APiQypIxgD2CWLnytM507AIaoaby+Reth9qe8JpsU5Egogw5Wrog+ZS/v8kJIWI3ShghE5eGkNfP8g==
X-Received: by 2002:aa7:8118:: with SMTP id b24mr1011016pfi.321.1587599643609;
        Wed, 22 Apr 2020 16:54:03 -0700 (PDT)
Date: Wed, 22 Apr 2020 16:53:56 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 03/12] scs: add support for stack usage debugging
Message-ID: <20200422235356.GA128062@google.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200421021453.198187-1-samitolvanen@google.com>
 <20200421021453.198187-4-samitolvanen@google.com>
 <20200422174602.GB3121@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422174602.GB3121@willie-the-truck>

On Wed, Apr 22, 2020 at 06:46:02PM +0100, Will Deacon wrote:
> > +static void scs_check_usage(struct task_struct *tsk)
> > +{
> > +	static unsigned long highest;
> > +	unsigned long used = __scs_used(tsk);
> > +	unsigned long prev;
> > +	unsigned long curr = highest;
> > +
> > +	while (used > curr) {
> > +		prev = cmpxchg(&highest, curr, used);
> 
> I think this can be cmpxchg_relaxed(), since we don't care about ordering
> here afaict.

Sure, I'll change this in v13. Thanks.

Sami
