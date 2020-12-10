Return-Path: <SRS0=MZK1=FO=lists.openwall.com=kernel-hardening-return-20574-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846ECC4361B
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Dec 2020 17:54:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4A03823D57
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Dec 2020 17:54:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A03823D57
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20574-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24487 invoked by uid 550); 10 Dec 2020 17:54:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23630 invoked from network); 10 Dec 2020 17:51:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yr+7PimI5SX8gLaBBIeyUIA4tybpzSbAPxDoOmcjcnQ=;
        b=vrWaP2BghzgXVAXO8/4fJFu+YdAr3B+p9Y+yw0FoUavRxTv6Vgpv6B6ve24ci/I1bY
         KzbWww4N/yd8SBZg1ELjrsQywJXvvNBT8fq0UzGe6T+mQWJ2sKgqmvSY6vkjnutYBs+A
         lc26FKPJzeVoMGlpqvRxeTYq5N7i0FbV/ExJXqwutN5WherqgHNH3tm5bGlJbVd0DJ8k
         HLko3AlKteVVWqTHTvjn1I+oUmK8WFmnCXehpVMEeD43khvbDOJHW92FmfMP6HHiDo0I
         3Zw1DQAJ7sOUs6LyU7PBOBhD383A0OQ/wRZ/LJNFq3Krjz2AaA1hXC3jzKH7u1ThBaKG
         CI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=yr+7PimI5SX8gLaBBIeyUIA4tybpzSbAPxDoOmcjcnQ=;
        b=gKlC3bCQta1M64uNcBa8pJO+FO8bbRXzb9giy/LJ5eNvkER86TMc4BOAlpaCNtYcyf
         iFXhmRf+FBbkZDNoI/bETkcOVfiQk6JtcoU1BYwFthdL44xNR3bXTDMjALUNG+RZ9zig
         4C6yj6Fq5tWITC1DqdD8WD8xetVujSOwzKvdO4peGRS3YuvmkvioM6tH0KlPkTbNp1NE
         ro1TqLW2T+4PVrWWI7/RGz3d7zYn8BltzUOAGIO/kttcfnJY2wxiyr1EugJtEbUxH2ap
         G5YQXD/536RirEqVdezA8/KOCXFRabjnDHKJac/EsvT/2x6/6B4pn4UhnLw/Z+4nNWqJ
         /rOw==
X-Gm-Message-State: AOAM5338ZEknIgXDs8ySIKlMZ56LSEd4ttJaYHlU3+9eg0Bje5lpPplC
	40/o+VMxTe1GpmqfoEmBdDLNBw==
X-Google-Smtp-Source: ABdhPJy4NrwnP0SI2nGAyQth/Air8lGqX6RZ0P4Sr9jMNykIeP0a0LiI38tsRCcZ3ZP/BPqN/jn0sg==
X-Received: by 2002:a05:622a:14:: with SMTP id x20mr10611188qtw.58.1607622689364;
        Thu, 10 Dec 2020 09:51:29 -0800 (PST)
To: Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org
Cc: Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Jeremy Linton <jeremy.linton@arm.com>, Mark Brown <broonie@kernel.org>,
 Topi Miettinen <toiwoton@gmail.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
References: <cover.1606319495.git.szabolcs.nagy@arm.com>
 <8756cc1083eb4cd93d3766cd39b2f34b6623bbcb.1606319495.git.szabolcs.nagy@arm.com>
From: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Autocrypt: addr=adhemerval.zanella@linaro.org; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH v2 1/6] aarch64: Fix missing BTI protection from
 dependencies [BZ #26926]
Message-ID: <f077a6d5-082c-c3a5-ce07-71b87a70dc12@linaro.org>
Date: Thu, 10 Dec 2020 14:51:23 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8756cc1083eb4cd93d3766cd39b2f34b6623bbcb.1606319495.git.szabolcs.nagy@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit



On 27/11/2020 10:19, Szabolcs Nagy via Libc-alpha wrote:
> The _dl_open_check and _rtld_main_check hooks are not called on the
> dependencies of a loaded module, so BTI protection was missed on
> every module other than the main executable and directly dlopened
> libraries.
> 
> The fix just iterates over dependencies to enable BTI.
> 
> Fixes bug 26926.

LGTM, modulus the argument name change.

I also think it would be better to add a testcase, for both DT_NEEDED
and dlopen case.

> ---
>  sysdeps/aarch64/dl-bti.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/sysdeps/aarch64/dl-bti.c b/sysdeps/aarch64/dl-bti.c
> index 196e462520..8f4728adce 100644
> --- a/sysdeps/aarch64/dl-bti.c
> +++ b/sysdeps/aarch64/dl-bti.c
> @@ -51,11 +51,24 @@ enable_bti (struct link_map *map, const char *program)
>    return 0;
>  }
>  
> -/* Enable BTI for L if required.  */
> +/* Enable BTI for MAP and its dependencies.  */
>  
>  void
> -_dl_bti_check (struct link_map *l, const char *program)
> +_dl_bti_check (struct link_map *map, const char *program)

I don't see much gain changing the argument name.

>  {
> -  if (GLRO(dl_aarch64_cpu_features).bti && l->l_mach.bti)
> -    enable_bti (l, program);
> +  if (!GLRO(dl_aarch64_cpu_features).bti)
> +    return;
> +
> +  if (map->l_mach.bti)
> +    enable_bti (map, program);
> +
> +  unsigned int i = map->l_searchlist.r_nlist;
> +  while (i-- > 0)
> +    {
> +      struct link_map *l = map->l_initfini[i];
> +      if (l->l_init_called)
> +	continue;
> +      if (l->l_mach.bti)
> +	enable_bti (l, program);
> +    }
>  }
> 

Ok.
