Return-Path: <SRS0=zBg2=YO=lists.openwall.com=kernel-hardening-return-17072-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D681CA9EB5
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 06:22:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B6404206C2
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 06:22:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GjbUSEjv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6404206C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17072-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 2024 invoked by uid 550); 21 Oct 2019 06:22:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 2006 invoked from network); 21 Oct 2019 06:22:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uyhVv4N2UiJ3EJxpaNQCWc5NdrhC/9AoAL7jZ85/7b8=;
        b=GjbUSEjvkAF47IsFWgAUnfSwZ9jZeOmpmmzg8L/6guVX38gCMZuouTdMO5Iji6ewM0
         ZcqaKKfluXkc0GCek0xGcyop4JHYb97Q/n3Eqc7ah2EKKHr0N7BGDs851PPpZHuHqzCj
         Az8WGOd2xhVAFxxTDg1R2UqIdUdRXgD25JY9oY8pXU6I6vVvsfZ0aFENdmAVqf4UnUr8
         lcQmqiLBmmkWCuTPfA0TxotJre4XtMv52V1BrM2hzvGfc4Miftl70l+50k9K9NVhoe2J
         xX9Fh2F8N7Dj2Pl0njY0mgUTPdAzdCBXsCb1ksBM0pvjzMtLDB5366phzKtAZjRMiTXL
         ANmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uyhVv4N2UiJ3EJxpaNQCWc5NdrhC/9AoAL7jZ85/7b8=;
        b=Tad8Rqi4jgovplpYSgL2b9j8kvUetY1lBOoLMOXVfcB4hQW5WV8u5FNlpwUWAx95hJ
         453C1mfD4Xs8QRP0qd7qisJHG9/daRInF6kv9K/+ff0AXOA9obQKdRShBO6k2CujqI8m
         KdMaIf48yzkWu8oprVmspEuDvoKxrRoOG2Xdpi0Y3wd3mYqHyKbOULp5eTWCO8uP9TwD
         h1+bqqgFbPMKqXPztTqFHz9KcFnkBa35T2tSnIxcU/EzJvjxe8bfAObp32uB3pCFGLqD
         YhFkvcMtwwGoWyYyv5HNtHmx1D0sdRe1c9KR7y3rPIvrTYfsjNSobcA1g7zepjuUkt9U
         z0ug==
X-Gm-Message-State: APjAAAWUs5ciAeV6nALSyJn4qtNMiuJk+egZRboecd+yCv24GPrFbnra
	F3o77eL4suuNX+zbfFuOFvkj5u5R9GkPPNiI1dKnYw==
X-Google-Smtp-Source: APXvYqx9wfbsml6zIZvtLXulYaMSgitt7ok8Qfrnv+GkD+c5R91Idi9S9ZV+WgZk06tMxv4wXfJaROot0zqVv9/hG5E=
X-Received: by 2002:a7b:c925:: with SMTP id h5mr1847720wml.61.1571638919306;
 Sun, 20 Oct 2019 23:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191018161033.261971-17-samitolvanen@google.com>
In-Reply-To: <20191018161033.261971-17-samitolvanen@google.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 21 Oct 2019 08:21:48 +0200
Message-ID: <CAKv+Gu-88USO+fbjBgj35B4fUQ7A_t9nHO_swyN=T1q1G2wViA@mail.gmail.com>
Subject: Re: [PATCH 16/18] arm64: kprobes: fix kprobes without CONFIG_KRETPROBES
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
> This allows CONFIG_KRETPROBES to be disabled without disabling
> kprobes entirely.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Can we make kretprobes work with the shadow call stack instead?

> ---
>  arch/arm64/kernel/probes/kprobes.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
> index c4452827419b..98230ae979ca 100644
> --- a/arch/arm64/kernel/probes/kprobes.c
> +++ b/arch/arm64/kernel/probes/kprobes.c
> @@ -551,6 +551,7 @@ void __kprobes __used *trampoline_probe_handler(struct pt_regs *regs)
>         return (void *)orig_ret_address;
>  }
>
> +#ifdef CONFIG_KRETPROBES
>  void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
>                                       struct pt_regs *regs)
>  {
> @@ -564,6 +565,7 @@ int __kprobes arch_trampoline_kprobe(struct kprobe *p)
>  {
>         return 0;
>  }
> +#endif
>
>  int __init arch_init_kprobes(void)
>  {
> --
> 2.23.0.866.gb869b98d4c-goog
>
