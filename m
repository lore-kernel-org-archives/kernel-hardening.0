Return-Path: <SRS0=EG6w=YL=lists.openwall.com=kernel-hardening-return-17057-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DF1CA9EA9
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 19:01:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 511FC2070B
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 19:01:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fGjlwqaP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 511FC2070B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17057-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7645 invoked by uid 550); 18 Oct 2019 19:00:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7624 invoked from network); 18 Oct 2019 19:00:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dHnooVFY2SD/hhEM3K3r0PH8N73JFv2NbOv8bRM4m2E=;
        b=fGjlwqaPn26KxRb9o+F4zrhfo5SkElhAWo4zrZYkQX9pYzl+Gat5G9cEzwzzgLT0yN
         01vXJtveJQV2qNvuL3dsYa3uHnA44CbQiyZWnm0OfAnXngfbQBE6/GoC7xkKTjBJoQ1W
         I3TlO2mOikI6Kr/w+ct+2TTOTmiNs0XrL0v8Qsjwm5i6295ZB9suC9+VQPpZngTAqbXp
         lbTN8AhrIsPleMkGbxdHNZqq0UgR8TbuoHXfoDLAHfBp5Dt4CXqh/ghNRZE/atlkwC4C
         f/z8a9w78sIenvmPm6uGln+51flj9Z7ABSXfofYGZvMWcJmJ0vLmRcx9Etw4H3lXK2ux
         qiHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dHnooVFY2SD/hhEM3K3r0PH8N73JFv2NbOv8bRM4m2E=;
        b=efe10kjcqoklrLVM9S501s+y3gl9ShAZJAmVWCuvWJ+35HdyHOam0Yd1SmoBCMJl/3
         7jdHTV72ixSvcRRlix6Y+iJVCCvAsShurcarcyAgNJ2lcldMCgMGyYDKL6BrPUmEhlmf
         henK4Ms3LwzYU4uGehmzTWKBGQYeC4aQYao0Tr7zP78FfRhlxmdQM2jaDwRj9uczzJC6
         2bN4nEqHimt7keJieuPtt//kz6n+Y8vsLiLxKTqjWR3YIr6uy4k3sRp8Zo/Dzo1qWSpB
         azrdTt6PEyrTiPf2jRk5w/GSXhqIn4998A8kxsibyV+8yvUkGayGTeBvsiwgcqhHngyh
         5U1Q==
X-Gm-Message-State: APjAAAXTUFQN9VHsPWbAAwOGldBSsuRlulO3bxoVXsRUK1kSJ2ZPObpt
	Mpg5mPju08VYPUAZfky0gA2fRdtT8Ex2h4KQEwOnXw==
X-Google-Smtp-Source: APXvYqy+QiLkN9pfvjcYpnB+QYepyp79m5l6k8r6HsNNtj0nqOOoe5lpxNRIDuav5cK0cYo+BuFsIE1uUC/SJFG20xg=
X-Received: by 2002:a1f:b202:: with SMTP id b2mr6191356vkf.59.1571425241664;
 Fri, 18 Oct 2019 12:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-6-samitolvanen@google.com> <CAKwvOd=SZ+f6hiLb3_-jytcKMPDZ77otFzNDvbwpOSsNMnifSg@mail.gmail.com>
In-Reply-To: <CAKwvOd=SZ+f6hiLb3_-jytcKMPDZ77otFzNDvbwpOSsNMnifSg@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 18 Oct 2019 12:00:30 -0700
Message-ID: <CABCJKuf1cTHqvAC2hyCWjQbNEdGjx8dtfHGWwEvrEWzv+f7vZg@mail.gmail.com>
Subject: Re: [PATCH 05/18] arm64: kbuild: reserve reg x18 from general
 allocation by the compiler
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 10:32 AM 'Nick Desaulniers' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
> > and remove the mention from
> > the LL/SC compiler flag override.
>
> was that cut/dropped from this patch?
>
> >
> > Link: https://patchwork.kernel.org/patch/9836881/
>
> ^ Looks like it. Maybe it doesn't matter, but if sending a V2, maybe
> the commit message to be updated?

True. The original patch is from 2017 and the relevant part of
arm64/lib/Makefile no longer exists. I'll update this accordingly.

> I like how this does not conditionally reserve it based on the CONFIG
> for SCS.  Hopefully later patches don't wrap it, but I haven't looked
> through all of them yet.

In a later patch x18 is only reserved with SCS. I'm fine with dropping
that patch and reserving it always, but wouldn't mind hearing thoughts
from the maintainers about this first.

Sami
