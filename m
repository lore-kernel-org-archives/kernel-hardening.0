Return-Path: <SRS0=Bccb=YO=lists.openwall.com=kernel-hardening-return-17082-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0905CA9EAF
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 22:40:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 03CDD20700
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 22:40:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O/CXUAVG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03CDD20700
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17082-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19537 invoked by uid 550); 21 Oct 2019 22:40:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19517 invoked from network); 21 Oct 2019 22:40:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+ZsNsXP4OTYt0YNh6qKFB6AFECQX69mBiPpRVt9SfH0=;
        b=O/CXUAVGNYcy3a5ZMEhvYVIsdUWMdntI32aa1fCXHK7oi6GQtdX8twOyCLRtqHcLw6
         am1b9fbswrT9o98uh5aDlhm1tPvl0Av/XEHc7jFDFc/FekuKFDvkdmrzLXsS+cBmnejP
         w+a/gseGa6WnbCp/yH1KdCdxNLv/Q43LbeRO19wQ0C6JCREDYSId7agxszZ/KRyBe4dS
         rBqaj2BEFPuwjg8K2IaN+ZdQ2/V18uW5p+D3bRRAW5ncrEsKECvCEFR63WSYX3IplWb4
         GYGuiM7vUIXmh+zLMMdnpEno7Jg6V7tjnP6+5fo5a94md98f+1ELrfUwmGcSvu34YKiS
         XHeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+ZsNsXP4OTYt0YNh6qKFB6AFECQX69mBiPpRVt9SfH0=;
        b=bCglgDFGD0m9T+mHdsta4A/RQNB52tm5hASUVRaSvKO+tRugJm6CQ4K+IR4W4JNDEP
         JEeuzguNjmZf0QNNuIaCVekxwe+JiKjqyqwoMOQ8YKjQkZDBiNxQEXXMEITm9fZIL7I7
         6C5RfP9W9E2iXFgWL4QZQKQpl0JqF7OjawBZOTviY3ElrCzoCkiQBWTRvPmP2+jBgEdK
         fnWPp8ME56hab7L8BhzoLgiiPbmCH6EkXVKNNbAXA1Erl0Ldrf1rFhMU9ACNO41XhIvt
         0+nbt8gw71iB3d20I730xyHeJQrxKVIQvjySKORMwFU4KDoI83oroTQSImqtNbylIRok
         M6KQ==
X-Gm-Message-State: APjAAAXi7BVVW6yE2cGtDR/iv8vpkwCcNTbE9nKYud5FgWBhjqbg0ZlJ
	f1d9b5ZRka3pTGrzpWxcn26ZeTjjgifv0evMEOoNDw==
X-Google-Smtp-Source: APXvYqy582En+heI5MQp3ZrQQ6f6MZJsAwNRRmtRSRpMZCKNBzLSU+/wxNeKwJ1tJAW4E2Y1xYNHr6jWiAAsx2LVJZQ=
X-Received: by 2002:a67:ed8b:: with SMTP id d11mr100849vsp.104.1571697602070;
 Mon, 21 Oct 2019 15:40:02 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-15-samitolvanen@google.com> <CAKv+Gu-kMzsot5KSPSo_iMsuzcv8J1R5RLT9uGjuzJsxCVUPPg@mail.gmail.com>
In-Reply-To: <CAKv+Gu-kMzsot5KSPSo_iMsuzcv8J1R5RLT9uGjuzJsxCVUPPg@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 21 Oct 2019 15:39:50 -0700
Message-ID: <CABCJKuf-tXu2ZhBMCYTHP3BU8g1i-0GGd7+YvyTDUc1kH2iZvA@mail.gmail.com>
Subject: Re: [PATCH 14/18] arm64: efi: restore x18 if it was corrupted
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, Oct 20, 2019 at 11:20 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> You'll have to elaborate a bit here and explain that this is
> sufficient, given that we run EFI runtime services with interrupts
> enabled.

I can add a note about this in v2. This is called with preemption
disabled and we have a separate interrupt shadow stack, so as far as I
can tell, this should be sufficient. Did you have concerns about this?

Sami
