Return-Path: <SRS0=Br8J=YZ=lists.openwall.com=kernel-hardening-return-17215-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 808FBCA9EC9
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 03:55:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CBFAE2083E
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 03:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gdpHWq36"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBFAE2083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17215-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26441 invoked by uid 550); 1 Nov 2019 03:55:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26421 invoked from network); 1 Nov 2019 03:55:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zSoUcnGkSf7yfDdI4UPFWole6s3LI6NqVWKcqfKw3S8=;
        b=gdpHWq36NRa5kgf+gRe/MKxYGjAw3bBoglJCiCxqDG/Z5bLWefay/odv1qRX70dC6u
         xEQoc/cnbPdiJcOxSIkOgyhVuljqbWzwmQF4cqReWLlUHB1iREij3Bw5hMnU19ZGaFou
         2x2RfVCm1NB8MMDbP9OX8d28IFnaJuv0SjjDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zSoUcnGkSf7yfDdI4UPFWole6s3LI6NqVWKcqfKw3S8=;
        b=oqVcaBIL5YLP8AQ2ns9pK3Q25jCKNt1UatUg4+5u0F3EcnYKm6fEw/gNB3TFm4wqg+
         Z7a3Om1HAhIRBajFzfNPA0vN9BmEh2mUvtubjxoYegk8v38ybD6BqPfsgUjzDrmkfRHG
         Nvgi3RlTF667wOFeXigumHFZs+K+77INdrJFCbFFzB0SVb75XiXuRUfmOzs3RzFmGAgp
         Zu7JH7zrBT2bruxm0nmS0rfZFKzCo8oIdfJtopEYbaCjJpvSHVEAS5iZPI0mQ2blZ2iN
         KAHTAlBS4W40148m/RTrPpvCbNePeMPnRqd3DJXtoAS3/+5Tc7MAeS3NosqZ/w7zUpaD
         gcpQ==
X-Gm-Message-State: APjAAAWHpi4TKjnYXNNqDXUWvHxyjyy8exmWlfJ8Mo8vhKxfbbXVUoDS
	RewGyFEKmiJQTs/1D+JiClMlZw==
X-Google-Smtp-Source: APXvYqx5k7aF99T5w9h4PpSwUM81mxoH0R6qDLQkK0BR3TP2j37wYiYVIHIkontT/DEGLXmTTHNH0A==
X-Received: by 2002:a17:90a:bb0b:: with SMTP id u11mr12349099pjr.94.1572580505585;
        Thu, 31 Oct 2019 20:55:05 -0700 (PDT)
Date: Thu, 31 Oct 2019 20:55:03 -0700
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
Subject: Re: [PATCH v3 07/17] scs: add support for stack usage debugging
Message-ID: <201910312054.3064999E@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com>
 <20191031164637.48901-8-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031164637.48901-8-samitolvanen@google.com>

On Thu, Oct 31, 2019 at 09:46:27AM -0700, samitolvanen@google.com wrote:
> Implements CONFIG_DEBUG_STACK_USAGE for shadow stacks.

Did I miss it, or is there no Kconfig section for this? I just realized
I can't find it. I was going to say "this commit log should explain
why/when this option is used", but then figured it might be explained in
the Kconfig ... but I couldn't find it. ;)

-Kees

> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  kernel/scs.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/kernel/scs.c b/kernel/scs.c
> index 7780fc4e29ac..67c43af627d1 100644
> --- a/kernel/scs.c
> +++ b/kernel/scs.c
> @@ -167,6 +167,44 @@ int scs_prepare(struct task_struct *tsk, int node)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_DEBUG_STACK_USAGE
> +static inline unsigned long scs_used(struct task_struct *tsk)
> +{
> +	unsigned long *p = __scs_base(tsk);
> +	unsigned long *end = scs_magic(tsk);
> +	uintptr_t s = (uintptr_t)p;
> +
> +	while (p < end && *p)
> +		p++;
> +
> +	return (uintptr_t)p - s;
> +}
> +
> +static void scs_check_usage(struct task_struct *tsk)
> +{
> +	static DEFINE_SPINLOCK(lock);
> +	static unsigned long highest;
> +	unsigned long used = scs_used(tsk);
> +
> +	if (used <= highest)
> +		return;
> +
> +	spin_lock(&lock);
> +
> +	if (used > highest) {
> +		pr_info("%s: highest shadow stack usage %lu bytes\n",
> +			__func__, used);
> +		highest = used;
> +	}
> +
> +	spin_unlock(&lock);
> +}
> +#else
> +static inline void scs_check_usage(struct task_struct *tsk)
> +{
> +}
> +#endif
> +
>  bool scs_corrupted(struct task_struct *tsk)
>  {
>  	return *scs_magic(tsk) != SCS_END_MAGIC;
> @@ -181,6 +219,7 @@ void scs_release(struct task_struct *tsk)
>  		return;
>  
>  	WARN_ON(scs_corrupted(tsk));
> +	scs_check_usage(tsk);
>  
>  	scs_account(tsk, -1);
>  	task_set_scs(tsk, NULL);
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 

-- 
Kees Cook
