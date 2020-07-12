Return-Path: <SRS0=Jsc5=AX=lists.openwall.com=kernel-hardening-return-19290-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D15FC433E3
	for <kernel-hardening@archiver.kernel.org>; Sun, 12 Jul 2020 23:35:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ACC6920674
	for <kernel-hardening@archiver.kernel.org>; Sun, 12 Jul 2020 23:35:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pBpXJX53"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACC6920674
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19290-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1152 invoked by uid 550); 12 Jul 2020 23:35:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1119 invoked from network); 12 Jul 2020 23:35:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LVOtLwv/Cvl11tUYp50SksGWhQhY11SC0NIkGuc8zKg=;
        b=pBpXJX539broCTWH17WgpJDxoLP0paWSlvb8A7h3fxHZadJbhqRCNtCFP25mX7XEJ4
         /kwaDuWKopj4I8eO8SAvDGZq6F9j25nSGRAO0y6X2NGnu7izoh9SZwvHn6KFIILHenua
         VZeZFZ0bZYIFUV+EEZeOEkkM7qjxY5RJIoRAIP4Ic1GB+xDjTjYg3z0lEPuNawED7EbA
         MonmBQTmlvtQCqFgEnrnwFndAHCUOPLKAGIG3XWpeW0/Qr4qA0bZxFzdTlAkI2KH7b0F
         rBajQRa/6JbzOq5B4AwXzh5PM1ZTZhssUaqSkDgJ7Yz0lPtz7xwa3hLHTGAXQMnzERV6
         /O1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LVOtLwv/Cvl11tUYp50SksGWhQhY11SC0NIkGuc8zKg=;
        b=SnRI3z93dLQ0IRmGL12H0UrEM+Ez9p+d0BADS/6LMNf1aDU11+uBXYAtepf7qv4SKn
         gmT04gIeXahfnAawmmQfnRbqBNpKtGVH1sY79B/kQoGmWd1J2+tHRai8nNBMxb4YQFYS
         gkRxt4sBACI3U3Bk3qx92udvFg0npXS27gsu1BeZT1uv5EcVwv4UPyO9MmOC+2vYVqjv
         5GEUHkrShLpsvsLtPJmgP8eWcUGTN5Vlok7omCwnFXDHYBqhoQ5eIcHIKxEfLXDwi/XG
         KnIQeLmzSE31INdjmwvzmiylzmEiHhPTOnkZ8iUEnR4DxzQ9G1/elO28vhgk1hLzTVKA
         5xWA==
X-Gm-Message-State: AOAM5301C2yJKNRuAyPGkWrsk+XRqcsmOT5Wa2cnPASQkAxnRAglgIwb
	F1FU7XPFOcpAzYguDiMCvSbM7ybghqwr6vU2C0XU4A==
X-Google-Smtp-Source: ABdhPJytFy6lsxbxptEBJHanuAZiQiJRjagWMLPmEYrRnXLJYMLE9doc2W4BiVdJO1Ek3tqEEHDclPE0n0pEuhpOHu8=
X-Received: by 2002:a17:906:94c4:: with SMTP id d4mr69283452ejy.232.1594596890894;
 Sun, 12 Jul 2020 16:34:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <671d8923-ed43-4600-2628-33ae7cb82ccb@molgen.mpg.de>
In-Reply-To: <671d8923-ed43-4600-2628-33ae7cb82ccb@molgen.mpg.de>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Sun, 12 Jul 2020 16:34:39 -0700
Message-ID: <CABCJKuedpxAqndgL=jHT22KtjnLkb1dsYaM6hQYyhqrWjkEe6A@mail.gmail.com>
Subject: Re: [PATCH 00/22] add support for Clang LTO
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, Jul 11, 2020 at 9:32 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> Thank you very much for sending these changes.
>
> Do you have a branch, where your current work can be pulled from? Your
> branch on GitHub [1] seems 15 months old.

The clang-lto branch is rebased regularly on top of Linus' tree.
GitHub just looks at the commit date of the last commit in the tree,
which isn't all that informative.

> Out of curiosity, I applied the changes, allowed the selection for i386
> (x86), and with Clang 1:11~++20200701093119+ffee8040534-1~exp1 from
> Debian experimental, it failed with `Invalid absolute R_386_32
> relocation: KERNEL_PAGES`:

I haven't looked at getting this to work on i386, which is why we only
select ARCH_SUPPORTS_LTO for x86_64. I would expect there to be a few
issues to address.

> >   arch/x86/tools/relocs vmlinux > arch/x86/boot/compressed/vmlinux.relocs;arch/x86/tools/relocs --abs-relocs vmlinux
> > Invalid absolute R_386_32 relocation: KERNEL_PAGES

KERNEL_PAGES looks like a constant, so it's probably safe to ignore
the absolute relocation in tools/relocs.c.

Sami
