Return-Path: <SRS0=xe9V=DV=lists.openwall.com=kernel-hardening-return-20210-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78BA7C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 22:54:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7E0002078A
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 22:54:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QpUrFNEH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E0002078A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20210-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11946 invoked by uid 550); 14 Oct 2020 22:54:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11914 invoked from network); 14 Oct 2020 22:54:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q8SxKFJ37keEA3fcjeZ0MUjIlmAhyy2Ds4RMjo12YH0=;
        b=QpUrFNEHB+eD+KCRl2HFxnlSp1vyTwWjRHJ5V7CaCjVOqpSlZIknEXyWQPVpbQ+cM1
         3i42ZiG9dAhIxqD8odiXtSLMX3J6wsygKL5cMccgJlHcYjee0k8wg7sSqGzv5GnU6ZI3
         skUQeZ1p5r7C9RZcDY+bIpWwe/Uz2In5VWAfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q8SxKFJ37keEA3fcjeZ0MUjIlmAhyy2Ds4RMjo12YH0=;
        b=j7Nvn89hYqeodd9fc2RrCrI0+0a7xEz+WsjP08Q7tXV0lRuRY3qnmq2gBOqMmC4/pT
         Hgt0ql9QBh4NDkfI3tpGAqjEt5HhuDfg8hra39EBDVmfv3ykKn7c3whiQ90WRy0QidG6
         2jhZrwYj9Jpa/78E8qx+EwtWb2SjO77/RkTFgzFvbtktbTymAVkvBm/B7YuvBYl2g5WY
         kVZALxedZuvBNINyseXDpTrjzrb5w010y1XmAPxDXu2/6SU5U+NO/QoM+gBgjYu8p5GV
         04BQHb2NSiK0vhuY9KrMadf9mlRK39/qRMEZTwikn80igqV+Kk87dy/oIIEcs65gu7Dk
         kvOQ==
X-Gm-Message-State: AOAM533ytyT4IDYiMwvxGldN+7208O9ODM1DidvE5fNZ6+Yf7wfDMHTq
	YdYOsuQ9XPq59hvmNd8hSiU4Iw==
X-Google-Smtp-Source: ABdhPJwJ4ghnrKefm3Ds7OP+vaaqBOqNCgcbWcY/kWoZDzqVnqAP2a2SLXiCE9xOBsgOh/pHszIHUg==
X-Received: by 2002:a17:90a:cb91:: with SMTP id a17mr1300337pju.220.1602716041061;
        Wed, 14 Oct 2020 15:54:01 -0700 (PDT)
Date: Wed, 14 Oct 2020 15:53:59 -0700
From: Kees Cook <keescook@chromium.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v6 16/25] init: lto: fix PREL32 relocations
Message-ID: <202010141552.9172003F6A@keescook>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-17-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013003203.4168817-17-samitolvanen@google.com>

On Mon, Oct 12, 2020 at 05:31:54PM -0700, Sami Tolvanen wrote:
> With LTO, the compiler can rename static functions to avoid global
> naming collisions. As initcall functions are typically static,
> renaming can break references to them in inline assembly. This
> change adds a global stub with a stable name for each initcall to
> fix the issue when PREL32 relocations are used.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>

This is another independent improvement... this could land before the
other portions of the series.

-Kees

> ---
>  include/linux/init.h | 31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/init.h b/include/linux/init.h
> index af638cd6dd52..cea63f7e7705 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -209,26 +209,49 @@ extern bool initcall_debug;
>   */
>  #define __initcall_section(__sec, __iid)			\
>  	#__sec ".init.." #__iid
> +
> +/*
> + * With LTO, the compiler can rename static functions to avoid
> + * global naming collisions. We use a global stub function for
> + * initcalls to create a stable symbol name whose address can be
> + * taken in inline assembly when PREL32 relocations are used.
> + */
> +#define __initcall_stub(fn, __iid, id)				\
> +	__initcall_name(initstub, __iid, id)
> +
> +#define __define_initcall_stub(__stub, fn)			\
> +	int __init __stub(void);				\
> +	int __init __stub(void)					\
> +	{ 							\
> +		return fn();					\
> +	}							\
> +	__ADDRESSABLE(__stub)
>  #else
>  #define __initcall_section(__sec, __iid)			\
>  	#__sec ".init"
> +
> +#define __initcall_stub(fn, __iid, id)	fn
> +
> +#define __define_initcall_stub(__stub, fn)			\
> +	__ADDRESSABLE(fn)
>  #endif
>  
>  #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
> -#define ____define_initcall(fn, __name, __sec)			\
> -	__ADDRESSABLE(fn)					\
> +#define ____define_initcall(fn, __stub, __name, __sec)		\
> +	__define_initcall_stub(__stub, fn)			\
>  	asm(".section	\"" __sec "\", \"a\"		\n"	\
>  	    __stringify(__name) ":			\n"	\
> -	    ".long	" #fn " - .			\n"	\
> +	    ".long	" __stringify(__stub) " - .	\n"	\
>  	    ".previous					\n");
>  #else
> -#define ____define_initcall(fn, __name, __sec)			\
> +#define ____define_initcall(fn, __unused, __name, __sec)	\
>  	static initcall_t __name __used 			\
>  		__attribute__((__section__(__sec))) = fn;
>  #endif
>  
>  #define __unique_initcall(fn, id, __sec, __iid)			\
>  	____define_initcall(fn,					\
> +		__initcall_stub(fn, __iid, id),			\
>  		__initcall_name(initcall, __iid, id),		\
>  		__initcall_section(__sec, __iid))
>  
> -- 
> 2.28.0.1011.ga647a8990f-goog
> 

-- 
Kees Cook
