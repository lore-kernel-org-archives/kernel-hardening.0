Return-Path: <SRS0=K4VX=7W=lists.openwall.com=kernel-hardening-return-18945-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBEAC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 20:14:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7CF372065C
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 20:14:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CF372065C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18945-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26400 invoked by uid 550); 9 Jun 2020 20:14:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26373 invoked from network); 9 Jun 2020 20:14:20 -0000
IronPort-SDR: q6R3qHGLmdQt2V7QHny7hxI+bu5NGr8tN2J40QVzXANl2hJD6Civ9BLppJYtl5uY+v0QDydOgi
 cqE4+J1TdNeQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: uPlyW+8nDixVNiEUxdlfEfyekV6D7tF/zCK1DQBiWjoZFvVDLqrUlA2S24HrpGgJM10qZS9E/t
 /u1+3pILi+tw==
X-IronPort-AV: E=Sophos;i="5.73,493,1583222400"; 
   d="scan'208";a="349628061"
Message-ID: <9fdea0bc0008eccd6dfcad496b37930cf5bd364a.camel@linux.intel.com>
Subject: Re: [PATCH v2 9/9] module: Reorder functions
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org, "H.
	Peter Anvin"
	 <hpa@zytor.com>, Jessica Yu <jeyu@kernel.org>, arjan@linux.intel.com, 
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, 
	rick.p.edgecombe@intel.com, Ard Biesheuvel <ardb@kernel.org>, Tony Luck
	 <tony.luck@intel.com>
Date: Tue, 09 Jun 2020 13:14:04 -0700
In-Reply-To: <202005211415.5A1ECC638@keescook>
References: <20200521165641.15940-1-kristen@linux.intel.com>
	 <20200521165641.15940-10-kristen@linux.intel.com>
	 <202005211415.5A1ECC638@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2020-05-21 at 14:33 -0700, Kees Cook wrote:
> Oh! And I am reminded suddenly about CONFIG_FG_KASLR needing to
> interact
> correctly with CONFIG_LD_DEAD_CODE_DATA_ELIMINATION in that we do NOT
> want the sections to be collapsed at link time:

sorry - I'm a little confused and was wondering if you could clarify
something. Does this mean you expect CONFIG_FG_KASLR=y and
CONFIG_LD_DEAD_CODE_DATA_ELIMINATION=y to be a valid config? I am not
familiar with the option, but it seems like you are saying that it
requires sections to be collapsed, in which case both of these options
as yes would not be allowed? Should I actively prevent this in the
Kconfig?

Thanks.

Kristen

> 
> #ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
> #define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
> 
> (I think I had fixed this in some earlier version?)
> 
> I think you want this (untested):
> 
> 
> diff --git a/Makefile b/Makefile
> index 04f5662ae61a..a0d9acd3b900 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -853,8 +853,11 @@ ifdef CONFIG_DEBUG_SECTION_MISMATCH
>  KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-
> once)
>  endif
>  
> +ifneq ($(CONFIG_LD_DEAD_CODE_DATA_ELIMINATION)$(CONFIG_FG_KASLR),)
> +KBUILD_CFLAGS_KERNEL += -ffunction-sections
> +endif
>  ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
> -KBUILD_CFLAGS_KERNEL += -ffunction-sections -fdata-sections
> +KBUILD_CFLAGS_KERNEL += -fdata-sections
>  LDFLAGS_vmlinux += --gc-sections
>  endif
>  
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-
> generic/vmlinux.lds.h
> index 71e387a5fe90..5f5c692751dd 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -93,20 +93,31 @@
>   * sections to be brought in with rodata.
>   */
>  #ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
> -#define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
>  #define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..LPBX*
>  #define SDATA_MAIN .sdata .sdata.[0-9a-zA-Z_]*
>  #define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]*
>  #define BSS_MAIN .bss .bss.[0-9a-zA-Z_]*
>  #define SBSS_MAIN .sbss .sbss.[0-9a-zA-Z_]*
>  #else
> -#define TEXT_MAIN .text
>  #define DATA_MAIN .data
>  #define SDATA_MAIN .sdata
>  #define RODATA_MAIN .rodata
>  #define BSS_MAIN .bss
>  #define SBSS_MAIN .sbss
>  #endif
> +/*
> + * Both LD_DEAD_CODE_DATA_ELIMINATION and CONFIG_FG_KASLR options
> enable
> + * -ffunction-sections, which produces separately named .text
> sections. In
> + * the case of CONFIG_FG_KASLR, they need to stay distinct so they
> can be
> + * separately randomized. Without CONFIG_FG_KASLR, the separate
> .text
> + * sections can be collected back into a common section, which makes
> the
> + * resulting image slightly smaller.
> + */
> +#if defined(CONFIG_LD_DEAD_CODE_DATA_ELIMINATION) &&
> !defined(CONFIG_FG_KASLR)
> +#define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
> +#else
> +#define TEXT_MAIN .text
> +#endif

