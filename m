Return-Path: <SRS0=+e0+=YZ=lists.openwall.com=kernel-hardening-return-17224-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E208CA9EC9
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 04:02:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A9BFE2085B
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 04:02:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="d20dfeMU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9BFE2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17224-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7896 invoked by uid 550); 1 Nov 2019 04:02:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7876 invoked from network); 1 Nov 2019 04:02:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BAe1ln5Hx2gY8GJiVnbrjacBTRiF8zYUc3i9OMgoBV4=;
        b=d20dfeMUMO7iAV+Fn0SFBoJceIxy/S9eCh9MpKcU+8Svi9/nIYjbdD5L/UkHZhnzix
         JkU7VA7dyGF/sNbCwHD80C0s1IhuF/GjsyEtDZet5D5R19m1YB1nTHn4RH8s+keb8EXh
         TN5h9u8K3SVZV7Ba8Rr1S3a6ZJ8AbVBGmjB00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BAe1ln5Hx2gY8GJiVnbrjacBTRiF8zYUc3i9OMgoBV4=;
        b=ceFJ5IeMfCgQniGWvZ/UCNxnLllPQTIrsciORbNxGE/nopBWurZMzvn/hdUrrC5UjS
         m3lTXW6JF22tvroy4h36Qh+WheBvAEbN6SjAetwV0n/TWBvIMpGwUz4DyiN3h4lCde+K
         tfXZy1+s6wc/KlAlHMVQN3xkTUdRgSBMyWMdw7mJtkpQ0kWVcZIr+e4BXCM+BE4JccjS
         4JQmALbWAe/MO9XLJJa+JC1MOW0KKoTmfeTsQTgm/beiPeGMFCQny0KkEJCQKUMp0dp4
         xjQBeiOQAGd9y+ngwydmvfDeMY46nK3BuIB51zWqjAIvA0qSnmmN8luBQemOpKVrHFA5
         R/nQ==
X-Gm-Message-State: APjAAAUmlLxJw9TX/5mmctTB0h0SPwas5nsQDb9VrriVg3Wr/eHhUT2c
	4pH8hiJLyYepjT3X4x7dRpguWw==
X-Google-Smtp-Source: APXvYqyPHiOd3taHNtWSlPaVTh8guZzdREmzdQBPCQtoOfjQY9wgtCAJXeLozcbxVyvdbHL+RNqt5g==
X-Received: by 2002:a62:b616:: with SMTP id j22mr10383274pff.201.1572580936603;
        Thu, 31 Oct 2019 21:02:16 -0700 (PDT)
Date: Thu, 31 Oct 2019 21:02:14 -0700
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
Subject: Re: [PATCH v3 16/17] arm64: disable SCS for hypervisor code
Message-ID: <201910312101.2A014A8F@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com>
 <20191031164637.48901-17-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031164637.48901-17-samitolvanen@google.com>

On Thu, Oct 31, 2019 at 09:46:36AM -0700, samitolvanen@google.com wrote:
> Filter out CC_FLAGS_SCS for code that runs at a different exception
> level.
> 
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

(Does it make any sense to merge all of these "disable under SCS"
patches? I guess not, since they're each different areas...)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/arm64/kvm/hyp/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index ea710f674cb6..17ea3da325e9 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -28,3 +28,6 @@ GCOV_PROFILE	:= n
>  KASAN_SANITIZE	:= n
>  UBSAN_SANITIZE	:= n
>  KCOV_INSTRUMENT	:= n
> +
> +# remove the SCS flags from all objects in this directory
> +KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 

-- 
Kees Cook
