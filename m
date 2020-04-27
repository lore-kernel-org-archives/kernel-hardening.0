Return-Path: <SRS0=4BB8=6L=lists.openwall.com=kernel-hardening-return-18649-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60C7C54FD0
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 16:49:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F179D2078E
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 16:49:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GRK7TdGO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F179D2078E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18649-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18007 invoked by uid 550); 27 Apr 2020 16:49:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17979 invoked from network); 27 Apr 2020 16:49:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DggTYojfEhSzNZzSt4p++E5JdlZHCZXJc0ROh9SzVlM=;
        b=GRK7TdGOAvGylag4wlIODdJrhvjeHh+CNCtIcuSjrjRzmjvA/4gHODiRDIqS3Ni+Ul
         xbrVAAQCFm0TrYX2gS2hmjsvmryyRHakKtro88oW5d8as36di5wAZi4QB0mVNrt3VYKC
         +mpM0biKQt1OtPZuP6KA+c31n0Icc3RDkS0F9D8RbdChUBCSxHizssgw5UMLXNS+Ozdv
         GhMLcbyKMjipz7hWcnUogsA5mxtEQ9HhUWk5UBJ4M7FpLiEWL82tfvSHuemxUMjA3T9k
         HQEcjwjSO8dW822QXi8v5ESAjxm5SgtUzR6RIF8ybNX7oWNscelNzVp5wj+yo9QkGQtH
         XR7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DggTYojfEhSzNZzSt4p++E5JdlZHCZXJc0ROh9SzVlM=;
        b=Uh6XKB3XYmuIBtRmxBS9CTMKZvsYpVUfT570zdPkNSVDCs94kv5I0cwb0h3e7bT0IM
         CdmLm94iEkBtCXsgh1UvNWR18Fu6ZcfQmbANBzuAQTwoKKbgx0FohvlH+oZK147HwyT+
         mFfd5J4H9HXELX5Sp4ZL0OVZmA/TP9i4ChIV2ua9mNLQqvO0mKGD2t/OGNfLqSAmNw03
         gN/pRcNeiHVdaPQ0DFQ2UyIKaVtuXUxw7WnIRngvzWBT1Swli4rzbXh1CtStbN+0QZ2N
         8S0LoxYZlIMkkrOhY7t7vbCEQkuc/LemVAERyn1dppqX3gjYJYOd43EtL1J3hmHlWGd/
         HaQA==
X-Gm-Message-State: AGi0PuavTAkoXL0SA5KEu1nN2uTZELHeK0D8QQCK5HjjVndVdVvtaGHY
	/e0JChRIppIkHLMSGnKSC4qckcBo0lpVXWIksVM=
X-Google-Smtp-Source: APiQypKOZlel+ggVdbFyIPtgHGZpVrDz6ne1COTeLPmgW0WeAhG5IdM5qWoDEvfl/ilzflIttY+StL0Az1RFGIsqSuw=
X-Received: by 2002:a2e:7613:: with SMTP id r19mr4909107ljc.29.1588006140845;
 Mon, 27 Apr 2020 09:49:00 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200427160018.243569-1-samitolvanen@google.com> <20200427160018.243569-2-samitolvanen@google.com>
In-Reply-To: <20200427160018.243569-2-samitolvanen@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 27 Apr 2020 18:48:49 +0200
Message-ID: <CANiq72=vvRcjWCON7zbaCTxLA2wP_-5zrnLyymR4g9b1gwc5kg@mail.gmail.com>
Subject: Re: [PATCH v13 01/12] add support for Clang's Shadow Call Stack (SCS)
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jann Horn <jannh@google.com>, clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Apr 27, 2020 at 6:00 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
> index 333a6695a918..18fc4d29ef27 100644
> --- a/include/linux/compiler-clang.h
> +++ b/include/linux/compiler-clang.h
> @@ -42,3 +42,9 @@
>   * compilers, like ICC.
>   */
>  #define barrier() __asm__ __volatile__("" : : : "memory")
> +
> +#if __has_feature(shadow_call_stack)
> +# define __noscs       __attribute__((__no_sanitize__("shadow-call-stack")))
> +#else
> +# define __noscs
> +#endif

Can we remove the `#else` branch? compiler_types.h [*] has to care
anyway about that case for other compilers anyway, no?

> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> index e970f97a7fcb..97b62f47a80d 100644
> --- a/include/linux/compiler_types.h
> +++ b/include/linux/compiler_types.h
> @@ -193,6 +193,10 @@ struct ftrace_likely_data {
>  # define randomized_struct_fields_end
>  #endif
>
> +#ifndef __noscs
> +# define __noscs
> +#endif

[*] Here

Cheers,
Miguel
