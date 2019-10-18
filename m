Return-Path: <SRS0=82zz=YL=lists.openwall.com=kernel-hardening-return-17051-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83542CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 17:54:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D18F721835
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 17:54:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GEpdi/vg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D18F721835
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17051-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12038 invoked by uid 550); 18 Oct 2019 17:54:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21843 invoked from network); 18 Oct 2019 17:08:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=icZdr5RXUlfIVPQUZ5ag+GwSMhqiqaO3j83adcgUQWY=;
        b=GEpdi/vgYB3Dbp/h96wQEbZdgTLwWntVY74quNjgbeeg+hzsMk/zZrigXjhZJrnpFb
         1sCxD/BkPu3n7ILO/vPRn92A4D4Pr6zGfOnoOhHoLbcienF2os3HqnY38YjnZQJ6CPhG
         2cEVlEkOD94zB1mmdsNc/rgKAweeHHSgQwOR9VQJUeRc6eDJnhZALabYW62do/0UnUKN
         RPD8sUmEbIHcS6c0uuy1U053bUE0xElIjmjrspvbBm1j/HBDqlS+YM/Eb3VkslwJ1EmK
         DxiIUIGOP9sE/R5mKuzwIB5v1VMKO+wkGaN/oK/qSJiYn43BeozwBBvtWYrtPX2GM7z4
         dH4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=icZdr5RXUlfIVPQUZ5ag+GwSMhqiqaO3j83adcgUQWY=;
        b=Vvr/dIHqo4A5kt7dy3zjBBzaHppGQs3lMg5GDY0JJIW0Vo4Zmk1RKhDEG8eViibRNh
         TQGu4HWkrfoD9cQIRYoEegdxETtDsedzFaEoD1DXQ5ES4d6rh+jCONqAEG/75epspEy6
         pHYUpyT6QdJuHhXfFRYWPBmW54zhUvMDs54d2nUE5k6xw2b6lZ6arOGAV2RZbnaiFJY4
         fFBCUTZXTjeE4NFfgVPNg7gHTjZAPQ3XdirXdSMOsTcbQatlNbVmNMv4/50Vwtvb8Mmy
         MNIOYxofBq2bJ5vLE9axaWXFObozsv0qaHbK77RswPi2jkqPhE9e/3KIppZqR/6Ms19q
         EuBA==
X-Gm-Message-State: APjAAAUPyAjqFN1xDy/DyPTdviSo5B6jsYQ6wYntHzvQhZmTjBttP6rO
	s5Tj/2WBjPIDrZ5LU3wnjMRf1d8QELTbH7TdVzyShA==
X-Google-Smtp-Source: APXvYqyzzIiNyDr2Id6Kr8DVoqWVgixdTZAxPTLo1g0mx6+HWc+w18Nu6n4FjKGbHpDO9wjpt2GMM+GyVFTzkMX0z78=
X-Received: by 2002:a67:ed8b:: with SMTP id d11mr6015143vsp.104.1571418507964;
 Fri, 18 Oct 2019 10:08:27 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-10-samitolvanen@google.com> <20191018130127.23746ff2@gandalf.local.home>
In-Reply-To: <20191018130127.23746ff2@gandalf.local.home>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 18 Oct 2019 10:08:16 -0700
Message-ID: <CABCJKufdDxJ_q-8Sj3+4rPuhAB3bdo_EN=DybZF5eenwZB4v3g@mail.gmail.com>
Subject: Re: [PATCH 09/18] trace: disable function graph tracing with SCS
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 10:01 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> NAK, Put this in the arch code.

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 41a9b4257b72..d68339987604 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -149,7 +149,7 @@ config ARM64
>         select HAVE_FTRACE_MCOUNT_RECORD
>         select HAVE_FUNCTION_TRACER
>         select HAVE_FUNCTION_ERROR_INJECTION
> -       select HAVE_FUNCTION_GRAPH_TRACER
> +       select HAVE_FUNCTION_GRAPH_TRACER if ROP_PROTECTION_NONE
>         select HAVE_GCC_PLUGINS
>         select HAVE_HW_BREAKPOINT if PERF_EVENTS
>         select HAVE_IRQ_TIME_ACCOUNTING

Thanks, Steven. I'll fix this and kretprobes in v2.

Sami
