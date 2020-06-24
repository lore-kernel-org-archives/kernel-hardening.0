Return-Path: <SRS0=c7mm=AF=lists.openwall.com=kernel-hardening-return-19147-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867C9C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:52:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D6FCD20768
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:52:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gkQ03mH+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6FCD20768
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19147-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13523 invoked by uid 550); 24 Jun 2020 21:52:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13491 invoked from network); 24 Jun 2020 21:52:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZlZyjdUHfTmn42OuhaukPgD3qQeRnM/SwkQPWmFMjno=;
        b=gkQ03mH+pPQbaY26mXH9tyFtYNKkc69RJVql3zuiAJ9HIg/y5EOgT1k1p8MPr1NS2p
         0+9hv/B8bA8y01i7lTNiIORUq/cOqzJHzcy92+dzag7XYVdUX0EM3i8tlsySkKFAcx1W
         EsBVlaYTjHyKIaqiR5f+zZkVnqGQKjJtrJF7neBM45lEg19dUfITLa6w50pvskzp+H3Q
         7+LiARiXwvKUf+3wbAxBMvD0W3zQDujuEi0Ff7RCeS/cXPDUV5GS8pCW67UEdB7YUlbF
         0gxAzEoMpBl65jky4H43Nbd4ZEdySbpIt0IKZBbG4xl5q5BlvUG77XQRz/Foyl8g2Bff
         X4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZlZyjdUHfTmn42OuhaukPgD3qQeRnM/SwkQPWmFMjno=;
        b=XWbKDEt85VffXMk2ftgyjxkYphZZAcpDbj8DD1xoXheYzuTn2RpIqMhOtBX6stOyq1
         19pms052iiHnA0YTH4H8j76oAYOBrLBrI3f0e7JKIoe6C1uYb+PNRMcPSM4n1JIKzkN5
         TpL5hGUuLEIo+3WqvDAsQo/fwXtq5BtyUeuzb0MJPoJXVKUEDhAxAgx+qTFi9yGZ8YiF
         /pHckukz0totYxV/0fFdX/RUvOAV25OYf7VBjBvV8wFQ/m+BYlhRPndK3gv92vzcBAX/
         9pvZeFHGmn1lvTJbogeDyb2MS6curGClret1xaTpCNNLDU5nsZu1pCOyjjD/KsASszNL
         KCiw==
X-Gm-Message-State: AOAM530lWe8E2aqYuE6I9TnvvUe5mGTJMYbM8V/HjskDIjcQ+5KnOrlx
	AtFgkS7fFGQvLUrDcKCNdc0YxQ==
X-Google-Smtp-Source: ABdhPJy+JpaxqpHIcJHjR6LpPq5kjrXe0+X/cVoPhow+mRdRGR18dTuC1hpKBoYOG/LhDJ7hbA1ueg==
X-Received: by 2002:a17:90a:dc16:: with SMTP id i22mr30660369pjv.84.1593035556605;
        Wed, 24 Jun 2020 14:52:36 -0700 (PDT)
Date: Wed, 24 Jun 2020 14:52:31 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 17/22] arm64: vdso: disable LTO
Message-ID: <20200624215231.GC120457@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-18-samitolvanen@google.com>
 <CAKwvOdnEbCfYZ9o=OF51oswyqDvN4iP-9syWUDhxfueq4q0xcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnEbCfYZ9o=OF51oswyqDvN4iP-9syWUDhxfueq4q0xcw@mail.gmail.com>

On Wed, Jun 24, 2020 at 01:58:57PM -0700, 'Nick Desaulniers' via Clang Built Linux wrote:
> On Wed, Jun 24, 2020 at 1:33 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > Filter out CC_FLAGS_LTO for the vDSO.
> 
> Just curious about this patch (and the following one for x86's vdso),
> do you happen to recall specifically what the issues with the vdso's
> are?

I recall the compiler optimizing away functions at some point, but as
LTO is not really needed in the vDSO, it's just easiest to disable it
there.

Sami
