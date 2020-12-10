Return-Path: <SRS0=0aYw=FO=lists.openwall.com=kernel-hardening-return-20577-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18782C4361B
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Dec 2020 18:50:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D979C22AAF
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Dec 2020 18:50:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D979C22AAF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20577-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16265 invoked by uid 550); 10 Dec 2020 18:49:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16233 invoked from network); 10 Dec 2020 18:49:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=or/dEyLjRPEuDqc6EuhpMXHxKeUi7Dl8ZI9OXWI4uPU=;
        b=MDBF9Q/Kd2/ofI7dOS2EuzcxkuznfN2RzTu1Nr8fDXVqu13kMaaf3L/XilIPMldwEy
         mU6FQBQ5TJ8HUipuNnLJnGkJNSJX37FblyDEMZsJQkTTF2IFNF6VEfxbPFxEfLE/+raF
         93behg/t6QGQlgf3U/m7vWnARqhW3wFwMtVwiHmnUlEsWpShLidCdS3lyBXz7U+rbnva
         7EOBBR7807A5ilrtK0sJ/Hw4K6V5thwHvs2cC3Nma46fuTnuhc/iSr3KhwFKi10nj9qT
         Uq/isic2U8jM7vQHPEj65heZNHy8oBhHfWewUmSp9hi4slmDs9UQnmaKV5tM3JoCl+Vv
         qMTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=or/dEyLjRPEuDqc6EuhpMXHxKeUi7Dl8ZI9OXWI4uPU=;
        b=hOzRShAgJIost0GIg9bmjuFyVeSjMaQiDZYqZxHVrRC51s4DBUo+GtcGTXWCUsWySD
         dbbcdyGdPl4yL62AfD+oIuTJAvacFwTCDFTdp8uJk3n41fqpMmPDYThQV6bJyy6kKd7w
         O2NOBjPBHrLE15P//FAwZvxQrEtCNTLnNsrvmIWZhItbO118k6CGhPnyqH4WYRGcQbk0
         lVTNKTrpHCu8hH6CSPPCAE4gCyasDzvHUfRnU/bYdW88Hl/FHQZtkZB+4DLjJe2As67C
         OLdzKle0Fg5oqsPLwZIu/TRtMzD/alYJU0ubcw/6vw5J0lkIL1QMeoKM6jfDQxX2hixo
         2/bQ==
X-Gm-Message-State: AOAM533NSZX8Y3OJYW8y/1AfLO+HPLET3GzvfvIiuPJ5BLJiDzuMJxdt
	7SzxlJga2RUKTKwOaRHbt0w1lQ==
X-Google-Smtp-Source: ABdhPJwhpkr9VQxaoGbhZAEMHBgEcJ9kkDJEVIORtAqUwXjwIUvj3WFoYYZkHz+ZRb6bWlAq1tBhSg==
X-Received: by 2002:ac8:5982:: with SMTP id e2mr10506961qte.257.1607626182095;
        Thu, 10 Dec 2020 10:49:42 -0800 (PST)
To: Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org
Cc: Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Jeremy Linton <jeremy.linton@arm.com>, Mark Brown <broonie@kernel.org>,
 Topi Miettinen <toiwoton@gmail.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
References: <ebce134991eae4261bbb32572a2062d3ca56e674.1606319495.git.szabolcs.nagy@arm.com>
 <d460a4f7aa4d70cc205f08896ed50b31fcd992df.1606898457.git.szabolcs.nagy@arm.com>
From: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Autocrypt: addr=adhemerval.zanella@linaro.org; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH v3 1/2] aarch64: align address for BTI protection [BZ
 #26988]
Message-ID: <a6cb2e48-e285-07f1-cff9-b337a56e7966@linaro.org>
Date: Thu, 10 Dec 2020 15:49:37 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d460a4f7aa4d70cc205f08896ed50b31fcd992df.1606898457.git.szabolcs.nagy@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit



On 02/12/2020 05:55, Szabolcs Nagy via Libc-alpha wrote:
> Handle unaligned executable load segments (the bfd linker is not
> expected to produce such binaries, but other linkers may).
> 
> Computing the mapping bounds follows _dl_map_object_from_fd more
> closely now.
> 
> Fixes bug 26988.

LGTM, thanks.

Reviewed-by: Adhemerval Zanella  <adhemerval.zanella@linaro.org>

> ---
> v3:
> - split the last patch in two so this bug is fixed separately.
> - pushed to nsz/btifix-v3 branch.
> 
>  sysdeps/aarch64/dl-bti.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/sysdeps/aarch64/dl-bti.c b/sysdeps/aarch64/dl-bti.c
> index 8f4728adce..67d63c8a73 100644
> --- a/sysdeps/aarch64/dl-bti.c
> +++ b/sysdeps/aarch64/dl-bti.c
> @@ -20,19 +20,22 @@
>  #include <libintl.h>
>  #include <ldsodefs.h>
>  
> -static int
> +static void
>  enable_bti (struct link_map *map, const char *program)
>  {

Ok.

> +  const size_t pagesz = GLRO(dl_pagesize);
>    const ElfW(Phdr) *phdr;
> -  unsigned prot;
>  
>    for (phdr = map->l_phdr; phdr < &map->l_phdr[map->l_phnum]; ++phdr)
>      if (phdr->p_type == PT_LOAD && (phdr->p_flags & PF_X))
>        {
> -	void *start = (void *) (phdr->p_vaddr + map->l_addr);
> -	size_t len = phdr->p_memsz;
> +	size_t vstart = ALIGN_DOWN (phdr->p_vaddr, pagesz);
> +	size_t vend = ALIGN_UP (phdr->p_vaddr + phdr->p_filesz, pagesz);
> +	off_t off = ALIGN_DOWN (phdr->p_offset, pagesz);
> +	void *start = (void *) (vstart + map->l_addr);
> +	size_t len = vend - vstart;
>  
> -	prot = PROT_EXEC | PROT_BTI;
> +	unsigned prot = PROT_EXEC | PROT_BTI;
>  	if (phdr->p_flags & PF_R)
>  	  prot |= PROT_READ;
>  	if (phdr->p_flags & PF_W)
> @@ -48,7 +51,6 @@ enable_bti (struct link_map *map, const char *program)
>  				N_("mprotect failed to turn on BTI"));
>  	  }
>        }
> -  return 0;
>  }
>  
>  /* Enable BTI for MAP and its dependencies.  */
> 

Ok.
