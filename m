Return-Path: <SRS0=DDl7=YP=lists.openwall.com=kernel-hardening-return-17088-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395C6CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 16:28:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8272921783
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 16:28:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Akp0RE/L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8272921783
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17088-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30276 invoked by uid 550); 22 Oct 2019 16:27:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30226 invoked from network); 22 Oct 2019 16:27:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yCqef9gQT6nmyTqqGL+wlHZ1CGtJs3cHNc9rYV1fhGQ=;
        b=Akp0RE/L/DluE7lJNU+chwNolLm4k9jsXnFTp9tcKG5xdcIVWiC2r0h9i0cwWyG7m7
         1M0XchljXyxrcF5F3z8kYQRl4stUEGdCXI7OA+TvymmMfiDz9QjnwWIItRChIyof8pgy
         LqJ1hg3+WyGv6FMYaKq9RKP9Q3ZF+joMQTEmY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yCqef9gQT6nmyTqqGL+wlHZ1CGtJs3cHNc9rYV1fhGQ=;
        b=dLY0+aUCjtGWOHXpqq/Tacf0yE7+IaDSAWJAXKATiqT8QFkpyq5qlOXAqeqDL1DLkL
         ZZTz4XVeKSoCZpFXfsq8Kg/QQHYjMx743vfELeR/eMalp35TP3OGywLjmEdfp08qnY83
         +iX58gjNs1RK73ywI/o+t3h+80AFuXrwUGx13SN0QaYthuurma1FhiUfrx3hZkTPlMqa
         BWUWv0JKIFoyCDW6Hk0Egp41eusves9lCV0zBi+hvRGRKa11dClJRf592W5JKthV3uHj
         M+COdyscUhWmpEaw42WsxSEKnS9fj1yogUvij3tJw2x86ulrXqbd40ioLUJ5+RPeSWNb
         BXDw==
X-Gm-Message-State: APjAAAUH1ZgmRb0iosGWBdlPI2zBY9m0wxrX/QDl+Jwy/epkBALkliRG
	SPxgRuGv9r1XS4+4NfwCmuQndQ==
X-Google-Smtp-Source: APXvYqy0V08cVd3k9DTb6b5fAVT9pV7tar1OJtZIZQ+pxwtsG2Lik9okZfxhxg4bRHHBWocLCOzgYQ==
X-Received: by 2002:a63:68c8:: with SMTP id d191mr4555216pgc.197.1571761662807;
        Tue, 22 Oct 2019 09:27:42 -0700 (PDT)
Date: Tue, 22 Oct 2019 09:27:40 -0700
From: Kees Cook <keescook@chromium.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/18] arm64: reserve x18 only with Shadow Call Stack
Message-ID: <201910220926.B78C4D88@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-13-samitolvanen@google.com>
 <CAKwvOd=rU2cC7C3a=8D2WBEmS49YgR7=aCriE31JQx7ExfQZrg@mail.gmail.com>
 <20191022160010.GB699@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022160010.GB699@lakrids.cambridge.arm.com>

On Tue, Oct 22, 2019 at 05:00:10PM +0100, Mark Rutland wrote:
> If we wanted to, we could periodically grep for x18 to find any illicit
> usage.

Now we need objtool for arm64! :) (It seems CONFIG_HAVE_STACK_VALIDATION
is rather a narrow description for what objtool does now...)

-- 
Kees Cook
