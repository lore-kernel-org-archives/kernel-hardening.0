Return-Path: <SRS0=s585=4A=lists.openwall.com=kernel-hardening-return-17796-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F288CC2BA83
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 17:31:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4F29A2082F
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 17:31:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BtezE3UK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F29A2082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17796-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29904 invoked by uid 550); 12 Feb 2020 17:31:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29879 invoked from network); 12 Feb 2020 17:31:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XgpctoHh6dg1wxvj3BzSThVl8kpcEhXa3sNGXPcFbT4=;
        b=BtezE3UKOP32S7Hgi6uAZOCn9BCk1YLzZTI/31neMRdDIAastd/PkKexEg5uWIeSlq
         /hFI/msrF2GQcVhisW/RaJNrJGmFkKA4SeD0lHwdM4ey9ghkS/K+yx90I62OEmTesdwF
         xzMU/2Mq+v9/Okdl/2mUjBYKqE6P9vJw2KVomx5TFhjbaK/lu0Q6tw2rFDTRVzvD2KxL
         boPGPbPxe+RpyEehZt6ohw9y9NodMcdQmgyDLVMfAAlCQ41OBvoUAldOafMsvbSOhhvM
         Ujf9+E+XNGlSxbjxgY5T1BHWqvckIdfOYnsyRjOxsWx6G6V+xqkaOcye9xpAB/GIw4Zn
         EW+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XgpctoHh6dg1wxvj3BzSThVl8kpcEhXa3sNGXPcFbT4=;
        b=aqKrwywDhUyQ/iKY6OcxTKsPzo49Kc0aEI1x0mkJB3bJBbqR7HcsRI52dTFyxwPxVa
         pzPL7Tt5OoTDMZQjqwYXz0NxReYg1xgpMMLagl5bz++GTOkjTO2qN4U7n7YgYjSn4GCy
         /yuU8m3DPy29cJNyfX8V//ZeSz+y/2CR1hCGKPFZmc+LMeMIgcP80TCc5RK8Sv9kAMBM
         ugqxlvaNggdl+7oA8ISrqRoywYivJcWhMA3vewEwqqerkSLu8j6Zs1s+FRR9FXa3Pz2+
         huv59O6RSIlrGSDC8vX72twpSSDI3bZJ0Q+Y5d4eAVEn4rGIGH31ucNppeAttEijuUJ/
         f94g==
X-Gm-Message-State: APjAAAWfY5IY97s5qMD1yLjn25EkvZIx6JiEzXkzfeMedbJXEZ4px5lc
	DmtmiD4vdPIOWDf8NRAlxiYJn2hcWqHqdzDGwvUBvg==
X-Google-Smtp-Source: APXvYqyjKo/YFw4KoPFfCCWJOIKf5+SsU5ZWgCMmPdEkaicagM609YliueP7WkCTKw6TDAOHNRXlU3z7/h7iIoQqHFg=
X-Received: by 2002:a67:f4d2:: with SMTP id s18mr12516774vsn.15.1581528660711;
 Wed, 12 Feb 2020 09:31:00 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200128184934.77625-1-samitolvanen@google.com> <20200128184934.77625-10-samitolvanen@google.com>
 <6f62b3c0-e796-e91c-f53b-23bd80fcb065@arm.com> <20200210175214.GA23318@willie-the-truck>
 <20200210180327.GB20840@lakrids.cambridge.arm.com> <20200210180740.GA24354@willie-the-truck>
 <20200210182431.GC20840@lakrids.cambridge.arm.com> <20200211095401.GA8560@willie-the-truck>
In-Reply-To: <20200211095401.GA8560@willie-the-truck>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 12 Feb 2020 09:30:49 -0800
Message-ID: <CABCJKucpq=zu7ikf+Q-f-v+6T-cbQCEb1setiZfFvHa8iw3erg@mail.gmail.com>
Subject: Re: [PATCH v7 09/11] arm64: disable SCS for hypervisor code
To: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Feb 11, 2020 at 1:54 AM Will Deacon <will@kernel.org> wrote:
> Thanks, I missed that. It's annoying that we'll end up needing /both/
> -ffixed-x18 *and* the save/restore around guest transitions, but if we
> actually want to use SCS for the VHE code then I see that it will be
> required.
>
> Sami -- can you restore -ffixed-x18 and then try the function attribute
> as suggested by James, please?

Sure. Adding __noscs to __hyp_text and not filtering out any of the
flags in the Makefile appears to work. I'll update this in the next
version.

Sami
