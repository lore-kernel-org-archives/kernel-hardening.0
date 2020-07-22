Return-Path: <SRS0=tGc6=BB=lists.openwall.com=kernel-hardening-return-19414-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDD7C433E1
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 18:15:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E065A20B1F
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 18:15:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NuIYTIiK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E065A20B1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19414-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9720 invoked by uid 550); 22 Jul 2020 18:15:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9688 invoked from network); 22 Jul 2020 18:15:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+SReuFYVGjLRX5r5xj5YpIfyUC4xzq9ishSeECc8oc0=;
        b=NuIYTIiKaQc1CsD0KXBC5Yhe7GX8yMqprWzzn8wTzzFy0PzxzGczcaGqdeb4YKryxx
         gDGjWE4EW1L+rsFD2ozcBAmUlUjqvHcfmeZTjicgfj/G2zjx+4h3skQn3dcUWxhf/HGA
         34blS1DVtvnecxc1FIU189JqspE7/zPXYiT+P+DU7dpREkeZiHpbse3hobDGVMvtNzbD
         KrJtaaqMOlcqXc8kDvP2uFSCHPNCwCqMldtmcSw2My/VgU3ZZIe/FRFIcNJ7iFkbw6cy
         utbf98JYdXdwWcsEetVbf/K56+HhaYsRX5rkPaO+4MJKlgRMduJzLaAbfn7bk7LRFtsA
         Fi8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+SReuFYVGjLRX5r5xj5YpIfyUC4xzq9ishSeECc8oc0=;
        b=hfThlqIKcApB6uhQIgjbV+5UgFMw6bJ1sFlw2Yz2mvuINe7icV1f6cYCdrQXZFOt8f
         C9gcmTYEh81qeovMjpqgw8Ea8c6OI70/CXgmW4qNDpE2+j4o2jSYwk0qLZWw9PnYLwZ5
         77qJG1PSUNgahvFENnmWjShV06jLvMxgGBzM7C7Qdr8PAHFLK0BEvys9mWql2GUzgok1
         z6K/b9usk8wQF0jfWrAq0rD3yx9vtGhQbM5TpMbGHXo//e6zzmkiPZ4W01LCgyRBWsrQ
         2iTHvvEXzNjXVu2aoBL14hB9jG/zcjfxpTVLH2oCvwnsomDFwR8ciWQPCI8FXv4Zyul0
         w+Ew==
X-Gm-Message-State: AOAM5327z/QW6G1GyGzTOLc5+gojs+HQ2yqsnosRl9T4lXc5wDVI7qul
	eAh3Rbwl6Xy9t4VNlMtmDa+WBZm/w3v3/46ZoXO6Ig==
X-Google-Smtp-Source: ABdhPJxrA+hjx0Q1mNxWSy2JCrzqouCMw/jbe01R8hqj3aXOsgJE0QWv/Xu+8L2SG1RhOKQ8MRvH9R8RbRpmUUnfeh4=
X-Received: by 2002:a50:931e:: with SMTP id m30mr677030eda.341.1595441726019;
 Wed, 22 Jul 2020 11:15:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-12-samitolvanen@google.com> <20200717202620.GA768846@bjorn-Precision-5520>
In-Reply-To: <20200717202620.GA768846@bjorn-Precision-5520>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 22 Jul 2020 11:15:14 -0700
Message-ID: <CABCJKudTCwt3J19u8Em493a3Z9J2SD+imtVZTpz5cPv7Wza5iQ@mail.gmail.com>
Subject: Re: [PATCH 11/22] pci: lto: fix PREL32 relocations
To: Bjorn Helgaas <helgaas@kernel.org>
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

Hi Bjorn,

On Fri, Jul 17, 2020 at 1:26 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> OK by me, but please update the subject to match convention:
>
>   PCI: Fix PREL32 relocations for LTO
>
> and include a hint in the commit log about what LTO is.  At least
> expand the initialism once.  Googling for "LTO" isn't very useful.
>
>   With Clang's Link Time Optimization (LTO), the compiler ... ?

Sure, I'll change this in the next version. Thanks for taking a look!

Sami
