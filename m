Return-Path: <SRS0=Agil=DV=lists.openwall.com=kernel-hardening-return-20208-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BFFC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 22:49:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6C2B12223F
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 22:49:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Xiw0SX12"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C2B12223F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20208-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7388 invoked by uid 550); 14 Oct 2020 22:49:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7356 invoked from network); 14 Oct 2020 22:49:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=73JDK6v9QIywlQAL1ojHAWu8vRvKniVaMQhT9AVQkgM=;
        b=Xiw0SX12te2H7unG0PW7k/KDxUZJqZb5kGC4j352+pdUtyhY3eZe/RclVKos04VObp
         mf+x2YyvDzI5Ik3UZzDFmDrX7FcS/7sA3PxWZ6U5hpwDTt9i4/2blfvsBVY9nqQH/5rp
         HouHNDN1JpRuMXtKKKFag3SRoJuNJQv3vA0zs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=73JDK6v9QIywlQAL1ojHAWu8vRvKniVaMQhT9AVQkgM=;
        b=n1PjcjRhV2q6NlHKVJLQrp1dkNqT+P3yzwJGVWOrub/2vfdqumG6howr9TbH64FO0b
         ziS/HrVIA2GsCKzgeLyPMR1z8757rvRufn/W59rQByBnc8Icv0BLqbS+6WijeWQcgGmy
         jWG4T/g26lVe3lLScJhc0DCQnhtXNAxUyUumYHgBOyDcDAfYK5tyJnER8ZUcGmY9miK+
         Y0wZW9UiYZr9hFzBk2xiOx11gtJn6aEH1bxPAxQb7xXQEZjd8bcG1ev3vovPYETnUPmA
         ImdIcp7Symd8rIpMjCw0e48ZcQWF85/IVs8GBRtLs1Y9xiEo9MZXz64PvFQqs4sZYSUr
         RQWg==
X-Gm-Message-State: AOAM5338XEBnz3dfspYClSQQ9L0B09VujKEo18FifzELhF2IYcpa+2m9
	QteJK/t4n2IZuDiChSQSpv+f9g==
X-Google-Smtp-Source: ABdhPJxSM90nZhUVG0O6sO50Xgaa+D7fRK95gdDff9gylp7HlrlNT4+Iuxg9mylfSVrF1VzMLrV6Tg==
X-Received: by 2002:a17:90a:f685:: with SMTP id cl5mr1325486pjb.210.1602715751992;
        Wed, 14 Oct 2020 15:49:11 -0700 (PDT)
Date: Wed, 14 Oct 2020 15:49:10 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
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
Subject: Re: [PATCH v6 13/25] kbuild: lto: merge module sections
Message-ID: <202010141548.47CB1BC@keescook>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-14-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013003203.4168817-14-samitolvanen@google.com>

On Mon, Oct 12, 2020 at 05:31:51PM -0700, Sami Tolvanen wrote:
> LLD always splits sections with LTO, which increases module sizes. This
> change adds linker script rules to merge the split sections in the final
> module.
> 
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  scripts/module.lds.S | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/scripts/module.lds.S b/scripts/module.lds.S
> index 69b9b71a6a47..037120173a22 100644
> --- a/scripts/module.lds.S
> +++ b/scripts/module.lds.S
> @@ -25,5 +25,33 @@ SECTIONS {
>  	__jump_table		0 : ALIGN(8) { KEEP(*(__jump_table)) }
>  }
>  
> +#ifdef CONFIG_LTO_CLANG

In looking at this again -- is this ifdef needed? Couldn't this be done
unconditionally? (Which would make it an independent change...)

-Kees

> +/*
> + * With CONFIG_LTO_CLANG, LLD always enables -fdata-sections and
> + * -ffunction-sections, which increases the size of the final module.
> + * Merge the split sections in the final binary.
> + */
> +SECTIONS {
> +	__patchable_function_entries : { *(__patchable_function_entries) }
> +
> +	.bss : {
> +		*(.bss .bss.[0-9a-zA-Z_]*)
> +		*(.bss..L*)
> +	}
> +
> +	.data : {
> +		*(.data .data.[0-9a-zA-Z_]*)
> +		*(.data..L*)
> +	}
> +
> +	.rodata : {
> +		*(.rodata .rodata.[0-9a-zA-Z_]*)
> +		*(.rodata..L*)
> +	}
> +
> +	.text : { *(.text .text.[0-9a-zA-Z_]*) }
> +}
> +#endif
> +
>  /* bring in arch-specific sections */
>  #include <asm/module.lds.h>
> -- 
> 2.28.0.1011.ga647a8990f-goog
> 

-- 
Kees Cook
