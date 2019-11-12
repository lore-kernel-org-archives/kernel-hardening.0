Return-Path: <SRS0=3dgu=ZE=lists.openwall.com=kernel-hardening-return-17345-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219D3C43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 Nov 2019 23:45:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 68355206A3
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 Nov 2019 23:45:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="V8X9HHxH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68355206A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17345-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24299 invoked by uid 550); 12 Nov 2019 23:44:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24277 invoked from network); 12 Nov 2019 23:44:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EcHuuFp0uXLbkkRAA858XYtBunr2zA+LeQirH7UYVa4=;
        b=V8X9HHxHiG0Is+chnq9hKdAdntFAww1rSfsLxVyiP7E6i67FTXBjLe2zS+ZMOC8b1k
         Dx0K/KLvXeHKck7H32Glr39l0lktqFgwNo89bALI4mv0oKnxAMk8fH/ycmz15f5xUEiI
         MHSQl1bOX0rd1bQotssKgZXS0uaqqO2dwUxpU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EcHuuFp0uXLbkkRAA858XYtBunr2zA+LeQirH7UYVa4=;
        b=d6PCdUD12eposYyula0ueUFU6mabr8pQz+HHDqbDrkYXMk+Sbd8NWonweg4UGeIfHz
         8LuXCzoz5w7lzaJkvEc+Lv8daYqLfqE2GzIe9RM2oyTMvAxwObH1CtMGoo8fuNeey1qa
         SWuJmRVD3uyINLSJco226H6FkG9enj8YVURZJObSGr501Z9dtQZsPyXwHJgmsol2nyL3
         8Yer+O2HfQFeC9bU3y4TsMwnthJkSqf5QwfMmkpIYmmM7UYVIAL2I5HhBalPhRAF2FWw
         uaaXkPjhjbs5JnUBGx4oIpfJ25DY1WCRNbqecaM85JNYD5XeaC5m3ik3eSGiQm2s8FjC
         qKTg==
X-Gm-Message-State: APjAAAXO1/Mq/PNGHcmAV7xEM2YwyYW/w8VakfvMqhJe8+Ywc8/wjUlE
	79Xnt61o1zB8W0RWDBk8s4atXQ==
X-Google-Smtp-Source: APXvYqy2qGlhbJhYD2XTlLrDucG7ETmNR5WevbQ8m/DZKdYkJBrkAiHNHZ0RU582wg1P7ojJiuH82g==
X-Received: by 2002:a65:6149:: with SMTP id o9mr186489pgv.228.1573602284496;
        Tue, 12 Nov 2019 15:44:44 -0800 (PST)
Date: Tue, 12 Nov 2019 15:44:42 -0800
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/14] add support for Clang's Shadow Call Stack
Message-ID: <201911121530.FA3D7321F@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191105235608.107702-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105235608.107702-1-samitolvanen@google.com>

On Tue, Nov 05, 2019 at 03:55:54PM -0800, Sami Tolvanen wrote:
> This patch series adds support for Clang's Shadow Call Stack
> (SCS) mitigation, which uses a separately allocated shadow stack
> to protect against return address overwrites. More information

Will, Catalin, Mark,

What's the next step here? I *think* all the comments have been
addressed. Is it possible to land this via the arm tree for v5.5?

Thanks!

-- 
Kees Cook
