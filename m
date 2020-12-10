Return-Path: <SRS0=5MvO=FO=lists.openwall.com=kernel-hardening-return-20576-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81094C433FE
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Dec 2020 18:36:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 31E7B23DE3
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Dec 2020 18:36:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31E7B23DE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20576-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10019 invoked by uid 550); 10 Dec 2020 18:36:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8116 invoked from network); 10 Dec 2020 18:35:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5PiNXGPvjp1H9H98zDqeQBFeXQnqdDfXRHVZjyB+efE=;
        b=qRoQLn2GUkkHS6tPTSnxlu1nNMXmHESP+Una9cbIwi93bCDk0TJxcP1pJhFY/c6Vk5
         cI+PWb4Fz3282Y4VGM8+SaFGY57uYFiaCyKJ2ZJ3DSX9tKlPsY+CCtZTKHB2snleezve
         9Dr5aToy7Yb2fE3ekY27E0DR3MBhoU5d1bIv7//4MBUJdBFXBYC6ampIDPlP8lGTc2am
         yUqd1eGH4nHyWgVm91x8el6CwqQW5IQmBfWiHy3aLtww5WzDdpB8Dd/w5ohMkZRljfSo
         hzIlu4eQoH7i8gPLLEN7YdGsiMbzC9y7N0eJEr3QZNcATKhGPq1Gc5tiMQW/xpLS7RC9
         kkUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5PiNXGPvjp1H9H98zDqeQBFeXQnqdDfXRHVZjyB+efE=;
        b=CGBGdsz1kU1RYaZY4jhBWTaOGsZ/+/6yxY3MKt1a/HbGK4pI/nRxhEjQdIZ1MHvRxl
         wIrzfxAYAC+wDyjaeU4V9HXQviSkgjYlc5w8pT06Qhrz/p7EOjuViWCoq8btlJrKLUn2
         sDnx+62MEtQTrN+Vh4xTB6jkOzAdJu5QNzTHpjfkaKQzgsjK9/ws64Vv+1eN9/XvPEFQ
         v9Xcy6zQh68c3soFiK+jsN8nVI3BA7nYNs+VjFYAWUq1qvonKakdRl3UxS7SDTnXolSz
         ZU4RrLF15Bwq2hlHoLmUnwjg3NB3bcelMR+eeFJ3ttf8F3/clbYLeVWlphElYMUpY+Wm
         iTIQ==
X-Gm-Message-State: AOAM532iQjEdFm5a/t8KlGIwz7us6MqhJ3euLUJhTyX59NP2bEsQEM1u
	VPmuiwg8FjEHlfo/DGAugpoXYw==
X-Google-Smtp-Source: ABdhPJyl91FWeoYV4M61IhQNfdeXj8gDsykP2dx+DeHBAm29ujKRDIjxprZyNlmYiFcPvo1zbpXeZQ==
X-Received: by 2002:a37:8943:: with SMTP id l64mr10272404qkd.212.1607625315915;
        Thu, 10 Dec 2020 10:35:15 -0800 (PST)
Subject: Re: [PATCH v2 5/6] elf: Pass the fd to note processing
To: Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org
Cc: Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Jeremy Linton <jeremy.linton@arm.com>, Mark Brown <broonie@kernel.org>,
 Topi Miettinen <toiwoton@gmail.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
References: <cover.1606319495.git.szabolcs.nagy@arm.com>
 <a23246987ec0a8b307a9a171193464b74a7cb416.1606319495.git.szabolcs.nagy@arm.com>
From: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Autocrypt: addr=adhemerval.zanella@linaro.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f181ee98-152a-7555-f883-b179e88aeadd@linaro.org>
Date: Thu, 10 Dec 2020 15:35:10 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a23246987ec0a8b307a9a171193464b74a7cb416.1606319495.git.szabolcs.nagy@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit



On 27/11/2020 10:21, Szabolcs Nagy via Libc-alpha wrote:
> To handle GNU property notes on aarch64 some segments need to
> be mmaped again, so the fd of the loaded ELF module is needed.
> 
> When the fd is not available (kernel loaded modules), then -1
> is passed.
> 
> The fd is passed to both _dl_process_pt_gnu_property and
> _dl_process_pt_note for consistency. Target specific note
> processing functions are updated accordingly.

LGTM, thanks.

Reviewed-by: Adhemerval Zanella  <adhemerval.zanella@linaro.org>

> ---
>  elf/dl-load.c              | 12 +++++++-----
>  elf/rtld.c                 |  4 ++--
>  sysdeps/aarch64/dl-prop.h  |  6 +++---
>  sysdeps/generic/dl-prop.h  |  6 +++---
>  sysdeps/generic/ldsodefs.h |  5 +++--
>  sysdeps/x86/dl-prop.h      |  6 +++---
>  6 files changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/elf/dl-load.c b/elf/dl-load.c
> index b0d65f32cc..74039f22a6 100644
> --- a/elf/dl-load.c
> +++ b/elf/dl-load.c
> @@ -837,10 +837,12 @@ _dl_init_paths (const char *llp, const char *source)
>  
>  /* Process PT_GNU_PROPERTY program header PH in module L after
>     PT_LOAD segments are mapped.  Only one NT_GNU_PROPERTY_TYPE_0
> -   note is handled which contains processor specific properties.  */
> +   note is handled which contains processor specific properties.
> +   FD is -1 for the kernel mapped main executable otherwise it is
> +   the fd used for loading module L.  */
>  
>  void
> -_dl_process_pt_gnu_property (struct link_map *l, const ElfW(Phdr) *ph)
> +_dl_process_pt_gnu_property (struct link_map *l, int fd, const ElfW(Phdr) *ph)
>  {
>    const ElfW(Nhdr) *note = (const void *) (ph->p_vaddr + l->l_addr);
>    const ElfW(Addr) size = ph->p_memsz;

Ok.

> @@ -887,7 +889,7 @@ _dl_process_pt_gnu_property (struct link_map *l, const ElfW(Phdr) *ph)
>  	      last_type = type;
>  
>  	      /* Target specific property processing.  */
> -	      if (_dl_process_gnu_property (l, type, datasz, ptr) == 0)
> +	      if (_dl_process_gnu_property (l, fd, type, datasz, ptr) == 0)
>  		return;
>  
>  	      /* Check the next property item.  */

Ok.

> @@ -1379,10 +1381,10 @@ cannot enable executable stack as shared object requires");
>      switch (ph[-1].p_type)
>        {
>        case PT_NOTE:
> -	_dl_process_pt_note (l, &ph[-1]);
> +	_dl_process_pt_note (l, fd, &ph[-1]);
>  	break;
>        case PT_GNU_PROPERTY:
> -	_dl_process_pt_gnu_property (l, &ph[-1]);
> +	_dl_process_pt_gnu_property (l, fd, &ph[-1]);
>  	break;
>        }
>  

Ok.

> diff --git a/elf/rtld.c b/elf/rtld.c
> index c4ffc8d4b7..ec62567580 100644
> --- a/elf/rtld.c
> +++ b/elf/rtld.c
> @@ -1540,10 +1540,10 @@ dl_main (const ElfW(Phdr) *phdr,
>      switch (ph[-1].p_type)
>        {
>        case PT_NOTE:
> -	_dl_process_pt_note (main_map, &ph[-1]);
> +	_dl_process_pt_note (main_map, -1, &ph[-1]);
>  	break;
>        case PT_GNU_PROPERTY:
> -	_dl_process_pt_gnu_property (main_map, &ph[-1]);
> +	_dl_process_pt_gnu_property (main_map, -1, &ph[-1]);
>  	break;
>        }
>  

Ok.

> diff --git a/sysdeps/aarch64/dl-prop.h b/sysdeps/aarch64/dl-prop.h
> index b0785bda83..2016d1472e 100644
> --- a/sysdeps/aarch64/dl-prop.h
> +++ b/sysdeps/aarch64/dl-prop.h
> @@ -35,13 +35,13 @@ _dl_open_check (struct link_map *m)
>  }
>  
>  static inline void __attribute__ ((always_inline))
> -_dl_process_pt_note (struct link_map *l, const ElfW(Phdr) *ph)
> +_dl_process_pt_note (struct link_map *l, int fd, const ElfW(Phdr) *ph)
>  {
>  }
>  
>  static inline int
> -_dl_process_gnu_property (struct link_map *l, uint32_t type, uint32_t datasz,
> -			  void *data)
> +_dl_process_gnu_property (struct link_map *l, int fd, uint32_t type,
> +			  uint32_t datasz, void *data)
>  {
>    if (type == GNU_PROPERTY_AARCH64_FEATURE_1_AND)
>      {

Ok.

> diff --git a/sysdeps/generic/dl-prop.h b/sysdeps/generic/dl-prop.h
> index f1cf576fe3..df27ff8e6a 100644
> --- a/sysdeps/generic/dl-prop.h
> +++ b/sysdeps/generic/dl-prop.h
> @@ -37,15 +37,15 @@ _dl_open_check (struct link_map *m)
>  }
>  
>  static inline void __attribute__ ((always_inline))
> -_dl_process_pt_note (struct link_map *l, const ElfW(Phdr) *ph)
> +_dl_process_pt_note (struct link_map *l, int fd, const ElfW(Phdr) *ph)
>  {
>  }
>  
>  /* Called for each property in the NT_GNU_PROPERTY_TYPE_0 note of L,
>     processing of the properties continues until this returns 0.  */
>  static inline int __attribute__ ((always_inline))
> -_dl_process_gnu_property (struct link_map *l, uint32_t type, uint32_t datasz,
> -			  void *data)
> +_dl_process_gnu_property (struct link_map *l, int fd, uint32_t type,
> +			  uint32_t datasz, void *data)
>  {
>    return 0;
>  }

Ok.

> diff --git a/sysdeps/generic/ldsodefs.h b/sysdeps/generic/ldsodefs.h
> index b1da03cafe..89eab4719d 100644
> --- a/sysdeps/generic/ldsodefs.h
> +++ b/sysdeps/generic/ldsodefs.h
> @@ -933,8 +933,9 @@ extern void _dl_rtld_di_serinfo (struct link_map *loader,
>  				 Dl_serinfo *si, bool counting);
>  
>  /* Process PT_GNU_PROPERTY program header PH in module L after
> -   PT_LOAD segments are mapped.  */
> -void _dl_process_pt_gnu_property (struct link_map *l, const ElfW(Phdr) *ph);
> +   PT_LOAD segments are mapped from file FD.  */
> +void _dl_process_pt_gnu_property (struct link_map *l, int fd,
> +				  const ElfW(Phdr) *ph);
>  
>  
>  /* Search loaded objects' symbol tables for a definition of the symbol

Ok.

> diff --git a/sysdeps/x86/dl-prop.h b/sysdeps/x86/dl-prop.h
> index 89911e19e2..4eb3b85a7b 100644
> --- a/sysdeps/x86/dl-prop.h
> +++ b/sysdeps/x86/dl-prop.h
> @@ -145,15 +145,15 @@ _dl_process_cet_property_note (struct link_map *l,
>  }
>  
>  static inline void __attribute__ ((unused))
> -_dl_process_pt_note (struct link_map *l, const ElfW(Phdr) *ph)
> +_dl_process_pt_note (struct link_map *l, int fd, const ElfW(Phdr) *ph)
>  {
>    const ElfW(Nhdr) *note = (const void *) (ph->p_vaddr + l->l_addr);
>    _dl_process_cet_property_note (l, note, ph->p_memsz, ph->p_align);
>  }
>  
>  static inline int __attribute__ ((always_inline))
> -_dl_process_gnu_property (struct link_map *l, uint32_t type, uint32_t datasz,
> -			  void *data)
> +_dl_process_gnu_property (struct link_map *l, int fd, uint32_t type,
> +			  uint32_t datasz, void *data)
>  {
>    return 0;
>  }
> 

Ok.
