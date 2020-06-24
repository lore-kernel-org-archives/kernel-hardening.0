Return-Path: <SRS0=df7I=AF=lists.openwall.com=kernel-hardening-return-19102-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E628BC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 14:46:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 44E1B20702
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 14:46:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UcuWUiaL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44E1B20702
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19102-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17691 invoked by uid 550); 24 Jun 2020 14:46:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17671 invoked from network); 24 Jun 2020 14:46:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YGEb31AttHeA5YUH1Hedg3SW+2stgVlj3nYXGGbAchU=;
        b=UcuWUiaLtS6hQwB9KxUy3Z9bv7Nks62Tpl6fbvA8uqD2/B7av9kURZB/L+B445OT1t
         NvQdGODIDeocCPW6jfNCyl35CogPsG3G8IknHXCfJJW3FYZfWX6G7dhUvusVDuWMLuDl
         qZYw9sQff/knmaH1usdfgE0F1lzEuWXKIIt4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YGEb31AttHeA5YUH1Hedg3SW+2stgVlj3nYXGGbAchU=;
        b=hCtPAVUju1k+OTYq/fWWSz4uq/Tugo1TiJL3fyqfuWwijSP4LyEBP7xVNvMcf8OHe0
         QPDdY8qRMVFTtqG+TYk2Z9B+BRQe8+BZFq2wSr9J8cbdHWISh5KviEI/gPL80vF2Gsz9
         opLeSFuNbh2vFZ8ATsJhxxmA0zLjZDpTOWRGweu17fc5XXBjKtIdgh9pXSRjWSZtQPD+
         rrj74d45+TsFaJr+MeF3ZMh6kfC+lzgU1CL+Y1U5ph/iP6aGu1M4TCGAvONdlYl0FqgY
         l/Jjt+/SufnPyd1JN+ZBQ6VZrQEvLtQOWrcOS4kFFZXjvzD1rADwFJMA799w000PZakV
         +Ydw==
X-Gm-Message-State: AOAM533nz9vpLT1sd8IDpKqFRkPEkMhvDl8BCqbDncWyICByWI9iIP3C
	es1KiDa/+o5ZWjhQxOeicbKizw==
X-Google-Smtp-Source: ABdhPJyaJyusdqr7gDuMQQVuvplY9KQKo74Br6IzoxaZjoYjPgwJk8Z+WqrtZcFpgt19+bLbcQX0cg==
X-Received: by 2002:a17:902:8681:: with SMTP id g1mr27995114plo.161.1593009978891;
        Wed, 24 Jun 2020 07:46:18 -0700 (PDT)
Date: Wed, 24 Jun 2020 07:46:17 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Jann Horn <jannh@google.com>, Emese Revfy <re.emese@gmail.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Thiago Jung Bauermann <bauerman@linux.ibm.com>,
	Luis Chamberlain <mcgrof@kernel.org>, Jessica Yu <jeyu@kernel.org>,
	Sven Schnelle <svens@stackframe.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Collingbourne <pcc@google.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Alexander Monakov <amonakov@ispras.ru>,
	Mathias Krause <minipli@googlemail.com>,
	PaX Team <pageexec@freemail.hu>,
	Brad Spengler <spender@grsecurity.net>,
	Laura Abbott <labbott@redhat.com>,
	Florian Weimer <fweimer@redhat.com>,
	kernel-hardening@lists.openwall.com, linux-kbuild@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, gcc@gcc.gnu.org, notify@kernel.org
Subject: Re: [PATCH v2 3/5] arm64: vdso: Don't use gcc plugins for building
 vgettimeofday.c
Message-ID: <202006240745.19E4F8BDEA@keescook>
References: <20200624123330.83226-1-alex.popov@linux.com>
 <20200624123330.83226-4-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624123330.83226-4-alex.popov@linux.com>

On Wed, Jun 24, 2020 at 03:33:28PM +0300, Alexander Popov wrote:
> Don't use gcc plugins for building arch/arm64/kernel/vdso/vgettimeofday.c
> to avoid unneeded instrumentation.
> 
> Signed-off-by: Alexander Popov <alex.popov@linux.com>

It looks like Will has taken this already, but:

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
