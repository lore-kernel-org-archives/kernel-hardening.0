Return-Path: <SRS0=9gp1=YO=lists.openwall.com=kernel-hardening-return-17069-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDCECA9EB5
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 06:15:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 63D2D206C2
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 06:15:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NLXY6TdH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63D2D206C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17069-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27986 invoked by uid 550); 21 Oct 2019 06:15:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27968 invoked from network); 21 Oct 2019 06:15:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wyeF1rMaUaHqm01fq+szlG0Q/Q/37dlLkcs/fhKj+JU=;
        b=NLXY6TdHG8Tz04qn7XKMcvdLN/OzoqTYvrB+JSqGhbSGr3rCzaBbRYQdR4no1EY5NL
         Nh9rCiOB9Og08f19wRWClJFDu0/sS1HKtgYeD23z9WavaGd4NE1QQCGW8pgaYugjj5k8
         2ETtuu2xsV6k3V2UW5rEbo/g5/Ro5F6Dfiu6pP5pMD+QaVJORHRrHwe8sIvzyRQ7nyDP
         jeq1vxJ7pypdSO3Ec2jWIw0zBRJyOT5DrUa7sOW2tzW0AmKLRJNb5sdKiVl76Mfb6VFf
         1fntrhgs76bfmwfvZZGpT+tBafmH1AcMK2MVAeBXgJj+RUvSklAClZI5m15AK4a0NKmO
         Z0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wyeF1rMaUaHqm01fq+szlG0Q/Q/37dlLkcs/fhKj+JU=;
        b=b5x7rr9+TA1R6HfoLXyLEDNgBgjvBPcRqOrHbuCvIqVHBZ20yg+JFC6P3WuxvmSHR3
         n0M4Bsm3BksjuM/pX3RASV5OcHYGMe9wHMi/iqb3JzBc6jnijX7Y8KzMIlvv48siWT+/
         yjrVi7yfnHDi8d/WTN5IC9eoReLNyHSEQegturqKzcuhkisfe1kiA7o4xXh8Wozsr1rQ
         OGl7iLIBbqQV8M7V+BKArZhTWDi93wC3S45RxZZt2xx7/h4oTg4FSKPnyXtxiFuGEdRT
         gSno+vIIVmPU1BbgW7dptjbHJSxZE5Og/+KxyMyIhjPHS6nCIMaqL9WJnHreCbAe8lpJ
         ER8Q==
X-Gm-Message-State: APjAAAU7qJXTlXxWcIg8cTo56PKpliqGC8NZ8KQwmn17XZ8cEVUBTjwP
	DeGeXxS8NP8XWHEbB7AF/zTgz1+42LFRM2co5hqNbA==
X-Google-Smtp-Source: APXvYqwy6S1XLT1tP+FIkDZSJy0h8vZRZeJmoRt5dOcKFryQnLOFQp/4bIpH+FqX5564F137wX49Gmx6/y/bSuaFgAQ=
X-Received: by 2002:a7b:c925:: with SMTP id h5mr1828158wml.61.1571638529717;
 Sun, 20 Oct 2019 23:15:29 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191018161033.261971-10-samitolvanen@google.com>
In-Reply-To: <20191018161033.261971-10-samitolvanen@google.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 21 Oct 2019 08:15:18 +0200
Message-ID: <CAKv+Gu_bYk8oudqfxmN5GUYSrTNeCPmz19BNnBn_TqATFPK11g@mail.gmail.com>
Subject: Re: [PATCH 09/18] trace: disable function graph tracing with SCS
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

On Fri, 18 Oct 2019 at 18:11, Sami Tolvanen <samitolvanen@google.com> wrote:
>
> With CONFIG_FUNCTION_GRAPH_TRACER, function return addresses are
> modified in ftrace_graph_caller and prepare_ftrace_return to redirect
> control flow to ftrace_return_to_handler. This is incompatible with
> return address protection.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

How difficult would it be to update the return address on the shadow
call stack along with the normal one? Not having to disable
infrastructure that is widely used by the distros would make this a
lot more palatable in the general case (even if it is Clang only at
the moment)


> ---
>  kernel/trace/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index e08527f50d2a..b7e5e3bfa0f4 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -161,6 +161,7 @@ config FUNCTION_GRAPH_TRACER
>         depends on HAVE_FUNCTION_GRAPH_TRACER
>         depends on FUNCTION_TRACER
>         depends on !X86_32 || !CC_OPTIMIZE_FOR_SIZE
> +       depends on ROP_PROTECTION_NONE
>         default y
>         help
>           Enable the kernel to trace a function at both its return
> --
> 2.23.0.866.gb869b98d4c-goog
>
