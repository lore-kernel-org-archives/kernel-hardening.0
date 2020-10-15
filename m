Return-Path: <SRS0=SjwC=DW=lists.openwall.com=kernel-hardening-return-20213-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DAD2C433E7
	for <kernel-hardening@archiver.kernel.org>; Thu, 15 Oct 2020 00:13:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0F89921D81
	for <kernel-hardening@archiver.kernel.org>; Thu, 15 Oct 2020 00:13:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PgKjpNgr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F89921D81
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20213-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5911 invoked by uid 550); 15 Oct 2020 00:13:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5878 invoked from network); 15 Oct 2020 00:13:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LURiEnBAw2K4z9zIAiaFYTyrr5u9bQTopZRlsHwZQ30=;
        b=PgKjpNgrHeicAl8QzyJWoTs5A6rmp6R8Pmum8VjneOxNanE02C3iR0xMHPEKXRSwiA
         hgbPuEmU4Y/KvHEeIBgVzlegtYfQL/e1IYCy/LveXiVHXjGwp6JSkRsgM1KwAIfKJcKw
         xjiOyeSTmvlceona3bncz+d4u8W6hA+58+IV74pozmLNmVEOzj6zHtFH6BbvMPGb1Q1N
         SCAyW7rDspMISGiSvIfRrqTnMCItj6RGBKiMdjZQs84SXB/tH/0v/+6ZNBKtXVi4giBx
         5O+k8MWQSqRdXTBoaXJdV4Sbx9ykfhv8CIwDyMJZ5tK/7VE1ZpxXSBqDafewuTLQ+EfB
         Zbrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LURiEnBAw2K4z9zIAiaFYTyrr5u9bQTopZRlsHwZQ30=;
        b=IogZwAyQbve+uLXYQ6H9GZ9V+5Q/YW04lMgStXUge1fmrcblxf95MIfefld3VMf0p/
         dv3pUVH/1Ut69Ks1ta7C4n9O8OUHjduZ5daWmwDyhszKD6QHZ0IzWVbF0H+pLeNlrdlk
         kiI/vPmG9oT+ZyjJcwLApgCaFoktCVWQGyFNbqXLA/2ickoeUrG9c6kJNF8N13xibGO7
         DRA1vzCtzLRY3OQIHvcphcnEoo3ABSFPlNbZ1Z0qjsWhl+lTs3qWi8GDtObUzlsqNJ8B
         5SOFeuSHgMhbGDKqjYHIPO80jGnglQKP9q7wX6IGdTwqU0m2EcqHydN0rtmFBohBY7as
         eimQ==
X-Gm-Message-State: AOAM530pHeimH9PKBfAUHl5yMUyzQhRyjSYVdQji7rgKCtMg+mjOpPAY
	P6Q/QHJRD2tLlUmBpAUToZmxZDno4Nk3HXXRCFwjUQ==
X-Google-Smtp-Source: ABdhPJzXFIHFpKtLKeaohPSTTFSTn1moPmFA2URXdVrEpwDK24AygeIW08WWsjsl1A8u32KKXSdaLbgxjj+v3FNFXjU=
X-Received: by 2002:a05:6512:52f:: with SMTP id o15mr141586lfc.381.1602720794371;
 Wed, 14 Oct 2020 17:13:14 -0700 (PDT)
MIME-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com> <20201013003203.4168817-17-samitolvanen@google.com>
In-Reply-To: <20201013003203.4168817-17-samitolvanen@google.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 15 Oct 2020 02:12:47 +0200
Message-ID: <CAG48ez26uiRBKS06_DQXB_GSmNjJjRiT+YA6pgLBGYCbVi2NNg@mail.gmail.com>
Subject: Re: [PATCH v6 16/25] init: lto: fix PREL32 relocations
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-kbuild@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org, 
	"the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 13, 2020 at 2:34 AM Sami Tolvanen <samitolvanen@google.com> wrote:
> With LTO, the compiler can rename static functions to avoid global
> naming collisions. As initcall functions are typically static,
> renaming can break references to them in inline assembly. This
> change adds a global stub with a stable name for each initcall to
> fix the issue when PREL32 relocations are used.

While I understand that this may be necessary for now, are there any
plans to fix this in the compiler in the future? There was a thread
about this issue at
<http://lists.llvm.org/pipermail/llvm-dev/2016-April/thread.html#98047>,
and possible solutions were discussed there, but it looks like that
fizzled out...
