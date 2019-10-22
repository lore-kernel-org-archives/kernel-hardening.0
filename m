Return-Path: <SRS0=e9cy=YP=lists.openwall.com=kernel-hardening-return-17084-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E7C5CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 05:54:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C7D9220B7C
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 05:54:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VeZ/77yC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7D9220B7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17084-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17816 invoked by uid 550); 22 Oct 2019 05:54:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17798 invoked from network); 22 Oct 2019 05:54:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=70+N4pxkreRk5D8qTuATktL5M/ApNQm1mVe3QKo4Ow8=;
        b=VeZ/77yCO2vkRreTdZF0BmlF3aBW7GYN63ztZ+W9IxGlyzot3aZzQG7XNVjBY7A7oD
         5ErFNuJigjHDoajFcUUKer2ZNuRvqeRRkKDFwX0d2Zr1W2J0Sitj3DU47jafk1WpqrB9
         RO+JgyMPsgCHPUuHfaLf9mhm0FhMWiroTQMq0AMJS2EyfB2q8y2Uj4BUJeCO2gXI9tCY
         6QkWiBS+nVx6fiVGxPNCg3OkhqZK5Cxo3moubEo1LbU3pI9Z3P3SLfQSm8r4r1GEdvXM
         A3I5Jr0ovB215EmWyJbd+kRIvPhHLcOf8Yw0LDZ75fNBWsAH3Ssp+sYWHP4KD/+V8/GQ
         /NvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=70+N4pxkreRk5D8qTuATktL5M/ApNQm1mVe3QKo4Ow8=;
        b=EpdySz5Qu3YgUZnjUhgvxGApR9MwmXJcmJoTnQ5RAiqLna/jHpLNQ4ei2kvhIg+8KU
         SJ5s0n6aXA6+0eq/9DJxUYQE2E3O+vPq5pGB/V64oi6UQak81y4pXXLxSxzzTXHE+Jic
         od1Bkw9VE3/6OCWeyVQ+u7A96/lTVQVj2mYcGjg/HpLE+F12UbYjxZaAJnhN0+SNZAwS
         idqVKYr3N1AwZMIxAEYiWo9t/mu7JSd5cD7ex797XlkWZXWQH+UBmHAQV+Bl6k/WSaU2
         PwM1DXJ0ZtF9tyL53+Rw56D9tdrob/dpE4Y7VnfhK4JoP/VFlke25VMZeMoZnVDkx5PV
         RtXg==
X-Gm-Message-State: APjAAAVPf4T1Eo5SLtMpD345cFTmnkO6PMyawsy/+bnJbScZZ4+0Uo9s
	jJBdH++Y+BbWGYbS9jvvmHESAAzt69wGomBFWjAe3g==
X-Google-Smtp-Source: APXvYqwrYnGYkoL34VBIT6H+JNjJm/uZwOLCkW8JDJj+1Q/w7n/LWtklQn1YWpTuz0AHRX28UXgTzenaMPN3dF2ZvS4=
X-Received: by 2002:adf:9f08:: with SMTP id l8mr1573796wrf.325.1571723652654;
 Mon, 21 Oct 2019 22:54:12 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-15-samitolvanen@google.com> <CAKv+Gu-kMzsot5KSPSo_iMsuzcv8J1R5RLT9uGjuzJsxCVUPPg@mail.gmail.com>
 <CABCJKuf-tXu2ZhBMCYTHP3BU8g1i-0GGd7+YvyTDUc1kH2iZvA@mail.gmail.com>
In-Reply-To: <CABCJKuf-tXu2ZhBMCYTHP3BU8g1i-0GGd7+YvyTDUc1kH2iZvA@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 22 Oct 2019 07:54:07 +0200
Message-ID: <CAKv+Gu_b6eCy4BbM0xFBgL2EzW+eP5rH+wTOgNCO=ai-vb-WWw@mail.gmail.com>
Subject: Re: [PATCH 14/18] arm64: efi: restore x18 if it was corrupted
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 22 Oct 2019 at 00:40, Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Sun, Oct 20, 2019 at 11:20 PM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> > You'll have to elaborate a bit here and explain that this is
> > sufficient, given that we run EFI runtime services with interrupts
> > enabled.
>
> I can add a note about this in v2. This is called with preemption
> disabled and we have a separate interrupt shadow stack, so as far as I
> can tell, this should be sufficient. Did you have concerns about this?
>

No concerns, but we should put the above clarification in the commit log.
