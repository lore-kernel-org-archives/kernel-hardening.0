Return-Path: <SRS0=bSp2=YZ=lists.openwall.com=kernel-hardening-return-17217-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B1CFCA9EC9
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 03:56:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B3D09208CB
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 03:56:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CCX57PXe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3D09208CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17217-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29994 invoked by uid 550); 1 Nov 2019 03:56:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29974 invoked from network); 1 Nov 2019 03:56:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z+nYmbiX+N1St4EAeF06ZLBIc22exSOWn82chVWgQ58=;
        b=CCX57PXeSP8raTIa7stPdOtMkXfDOMY7T1F5hUmVdwgHt3jJlYyT6pDYvyD+nZPnjd
         RDynOfkryq8ctGOLHdv/HhV7WAh/aJmiBALoqt5gki6zK0lyCCvj+8TBwx4BlVd4ZsYn
         QlzmEfXTcWlJFOzLS3MwRZqKvvLzEB2qTfEAY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z+nYmbiX+N1St4EAeF06ZLBIc22exSOWn82chVWgQ58=;
        b=V81FXWWqICLafDtv1E5PQK4Q054N1EoElmM4yp63TsAuMhl7JeqlkiAR8+sagUQ6W5
         QsyMpW6CN1Jup3cqxF9Bb+UXOiabELOTkCdOvYiVWYBEdVDizF0LW7nxE6V9fLwUrCVH
         yqiKskOMYW3Hnx3vtefUjvRk5FuA6TgqxLdq/OnPwzmZSLB2uGymAfSN7U/9UxFnECgN
         PN+CmhsTIy93Tlu79o98YbdsBqyyIvgFTdRF2nCEEDfXo+rC1oh/kYEV/aK7GEz/2vGF
         /qC0q1CHCjdX46/414MlSReKABmAgHQ+1ag3pwxyWya1utH+MSNvN6hIZ37udZDdA87N
         /9fg==
X-Gm-Message-State: APjAAAUT2C6tpOgRpHoBXrYqG6rBpbTX/1L0cEejWtj60a6BdF2T6zp9
	mzAryTwjNT2VZH8sXpPRTCLI7PaZWYs=
X-Google-Smtp-Source: APXvYqzjbJ7PTCwR8dbLX9yGoruNQd+AcfmNqc/IOeBXJ7CEpc7/rFxnCKUJlN4CgjbHYqxLA44oZA==
X-Received: by 2002:a17:902:988d:: with SMTP id s13mr10329146plp.335.1572580573736;
        Thu, 31 Oct 2019 20:56:13 -0700 (PDT)
Date: Thu, 31 Oct 2019 20:56:11 -0700
From: Kees Cook <keescook@chromium.org>
To: samitolvanen@google.com
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/17] arm64: kprobes: fix kprobes without
 CONFIG_KRETPROBES
Message-ID: <201910312055.BD31A966DB@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com>
 <20191031164637.48901-10-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031164637.48901-10-samitolvanen@google.com>

On Thu, Oct 31, 2019 at 09:46:29AM -0700, samitolvanen@google.com wrote:
> This allows CONFIG_KRETPROBES to be disabled without disabling
> kprobes entirely.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Is this worth folding this into the prior kprobes patch? Regardless:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/arm64/kernel/probes/kprobes.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
> index c4452827419b..98230ae979ca 100644
> --- a/arch/arm64/kernel/probes/kprobes.c
> +++ b/arch/arm64/kernel/probes/kprobes.c
> @@ -551,6 +551,7 @@ void __kprobes __used *trampoline_probe_handler(struct pt_regs *regs)
>  	return (void *)orig_ret_address;
>  }
>  
> +#ifdef CONFIG_KRETPROBES
>  void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
>  				      struct pt_regs *regs)
>  {
> @@ -564,6 +565,7 @@ int __kprobes arch_trampoline_kprobe(struct kprobe *p)
>  {
>  	return 0;
>  }
> +#endif
>  
>  int __init arch_init_kprobes(void)
>  {
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 

-- 
Kees Cook
