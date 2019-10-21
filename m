Return-Path: <SRS0=5BIF=YO=lists.openwall.com=kernel-hardening-return-17081-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC17CA9EAF
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 20:43:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C69BC214AE
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 20:43:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KSDqpUym"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C69BC214AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17081-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11998 invoked by uid 550); 21 Oct 2019 20:43:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11979 invoked from network); 21 Oct 2019 20:43:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/J47pHWT2X7Av3FRgY9sGp9A1Q4EsZtxdv8QeJCfN3I=;
        b=KSDqpUymn0gcUp8dFXPeZ/HiSZgbKxXfCtrzL6BZnLONWdSEVg6/Ke0KbCXr4Am7Ft
         PQ7LNFK0xrC/Rzs1NmPkslJtnnvIL1/aotOz8artc1tXedz3v4PQs1sCHzV7cj0E+0g8
         lBFOzuOMbrJ2UVV/FyJ/HXSxexJ2AOV1mW43p1ysYnPcCPjtOCz+n59DOMk3Y+RZbbmR
         ZVsEOEEmGtG+pvfHspdeVdID46tqH/wz/BTkQZiZIwOy4d1tPZAHvm89PAZtpWJzYBzt
         y+pBeWqeVU+tUEqfAuYYA2dOE2vlX3md/TnWCt9fr7Tobunt15FALPHuUxRBRVwCBo/H
         zfrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/J47pHWT2X7Av3FRgY9sGp9A1Q4EsZtxdv8QeJCfN3I=;
        b=pGBpjp+Rce+o3lqt5A6uJUS6TnZssCctKuVKOLciaf0SNEYFHm8UVQJLK0lSFUE4Gr
         LgkAe4IUE4PzCcYcFiPuHoIOjsTqACFusboQ150a7Al6Asc/gR+utPJl+tFTbuUJC9+D
         cI+Q6rX33InTdOTrJVuBG5QtDrdhS8NtFsSeCdBFddlcALJc9NhJAB2EsDOyN10VgWWl
         D65MiDl4CkEYfTtmMNMafn2BpU8pQ7tBEt3VAisJle0PdCk9GcHIZGB0ZLsfwccDbfgC
         vkFdXfuiXtNAFu2PuXSpWRURDpmVmjunOlLVhUbq4OwRUJL/fBO6mCWjAjHCdLy9JtFB
         Wtrw==
X-Gm-Message-State: APjAAAUZ1kHXe1qb7H9mK1oYf7SpwEnmsaNjDT59AoLMYJK+vlk/w0pw
	oNUGZwpYWXr1Dy6I0zDGEIGGNB2gQmWRDxJN6kMEQA==
X-Google-Smtp-Source: APXvYqz4ZEHugfx1iLTVr5oh8wcvQsZnhgiG/2ZE182Aies/iiC08Q8WJN0chuD/KhyaBz5bbSu/RP+GuEhOKFYCX9U=
X-Received: by 2002:ab0:5981:: with SMTP id g1mr64566uad.98.1571690602892;
 Mon, 21 Oct 2019 13:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-6-samitolvanen@google.com> <CAKwvOd=SZ+f6hiLb3_-jytcKMPDZ77otFzNDvbwpOSsNMnifSg@mail.gmail.com>
 <CABCJKuf1cTHqvAC2hyCWjQbNEdGjx8dtfHGWwEvrEWzv+f7vZg@mail.gmail.com> <CAKv+Gu92eR81+W1iXOXZHWgub-fNPcKaa+NCpGS_Yy4K4=7t+Q@mail.gmail.com>
In-Reply-To: <CAKv+Gu92eR81+W1iXOXZHWgub-fNPcKaa+NCpGS_Yy4K4=7t+Q@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 21 Oct 2019 13:43:11 -0700
Message-ID: <CABCJKufZX7McCUoeH8=VR90gdQPCjUSNaPgjPRzo6-vV-y6oHw@mail.gmail.com>
Subject: Re: [PATCH 05/18] arm64: kbuild: reserve reg x18 from general
 allocation by the compiler
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, Oct 20, 2019 at 11:12 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> Also, please combine this patch with the one that reserves it
> conditionally, no point in having both in the same series.

Sure, I'll just drop this patch from v2 then and only reserve it with SCS.

Sami
