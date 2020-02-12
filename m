Return-Path: <SRS0=udGG=4A=lists.openwall.com=kernel-hardening-return-17797-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B3EC2BA83
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 17:36:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B36DA2073C
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 17:36:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WTUFnbqw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B36DA2073C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17797-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1231 invoked by uid 550); 12 Feb 2020 17:36:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1209 invoked from network); 12 Feb 2020 17:36:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oXC2J3nEK5SwOdFoK4ULqW0570rBTdySIYo3+gIlo9M=;
        b=WTUFnbqwYf+rL57s/FGxM1+vxE9Jz5IK7E+OqB1D8Yag+QT+LdUeuoco6oTC4zgy7L
         TKipBuXtB2O8hn6XUjmdUpdrUfke0F8SCdmbLI53UNP2BplyGiw6vXFuWmFYFzZtLQeN
         5wpar/5ILukP9S05BShLrDSCKEPCKcsSH/oAGyElM1PsKMhn2zidyE008XJx5PD7dUMg
         n4j6E1083epW+BkViMtDeuVftqlXVyhEyjY2m1kZGGBAfrXmhWXYSRy7y6cbm8taKOCJ
         y3l8mKYES7s2h2SOYn+hKiFfdkCBn2+SUUTjhfBmJGbvU+drkZVcb4Ou3zqNKzp4BpKd
         nG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oXC2J3nEK5SwOdFoK4ULqW0570rBTdySIYo3+gIlo9M=;
        b=lIzdDJzSqZTqmAQ7Z5bbEJXbEfYgsS+C8y9NMFFvqHahvprYQkL7FqaccjZ2/GwAKS
         h1yKV6JVsfQncGCEoQnpU5J0UuSKhVrSQyXpCqUX8hfSRgfESDCC1fRpmSAW1V4zvbe4
         Nj0MChOhtxu38MHUBEmK7Wq8F8NFCm6DQOqQczFrRn9MEJ9YenIHLMgqxuMv2i9eyptU
         C2FM2bTethp9YEWoziLHSKID4CFQfPbhc3iGpd++Y27d5aGcYW8gUHTOam1UR1I4NGpr
         XKRIrF1Qabhfb+jjEjLUAw/K+udO5D+KPjEdF4AUsT7jn1PNNlOLANxH63MIL5+muGmy
         ZISw==
X-Gm-Message-State: APjAAAV0L2hF8NHqhTAEjfNE5pZ5vflglg+sB8QqqprbZHz2C10A3ztB
	VmhrS2OKMnAn5r/3a2qQ1mW13Jr51/fUeeWnrTdsjw==
X-Google-Smtp-Source: APXvYqySnCPpjBgnelV684/U07lYpWTQs3A+aOrC5t4BnyXhAn03wUz7JH8o/EDUYvzcfRllMDnDJ3B306fqXtaeZDQ=
X-Received: by 2002:ab0:422:: with SMTP id 31mr5283734uav.98.1581528994562;
 Wed, 12 Feb 2020 09:36:34 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200128184934.77625-1-samitolvanen@google.com> <63517cff-4bd6-bb6c-9a54-23de4f5fbb4a@arm.com>
In-Reply-To: <63517cff-4bd6-bb6c-9a54-23de4f5fbb4a@arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 12 Feb 2020 09:36:23 -0800
Message-ID: <CABCJKuff08oGqg-2WO-J=SkGHcX+2KCrqhmgVnQT7ujKGUcvag@mail.gmail.com>
Subject: Re: [PATCH v7 00/11] add support for Clang's Shadow Call Stack
To: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Feb 11, 2020 at 5:57 AM James Morse <james.morse@arm.com> wrote:
> I found I had to add:
> | KBUILD_CFLAGS := $(filter-out -ffixed-x18 $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
>
> to drivers/firmware/efi/libstub/Makefile, to get this going.

Ah, good catch!

> I don't think there is much point supporting SCS for the EFIstub, its already isolated
> from the rest of the kernel's C code by the __efistub symbol prefix machinery, and trying
> to use it would expose us to buggy firmware at a point we can't handle it!

Yes, fully agreed.

> I can send a patch if its easier for you,

It's not a problem, I will include a patch for this in v8.

Sami
