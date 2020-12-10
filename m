Return-Path: <SRS0=TnQU=FO=lists.openwall.com=kernel-hardening-return-20575-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB09C4361B
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Dec 2020 18:35:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7501323E1E
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Dec 2020 18:35:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7501323E1E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20575-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9228 invoked by uid 550); 10 Dec 2020 18:35:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5420 invoked from network); 10 Dec 2020 18:25:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uluB0mD/174B1JmgSMgZuinmmEBxrt4PIkK2KNEJKOo=;
        b=tOSj+o+rtLHr0mYnk2x0/AptMtOoigAm7gugCwxIsv6z5PruF3gIGNzLQkTclvyxu+
         tzzt9elwfPh/fydidEQ9Sk/0KDXVkJq2YzIrINmta1HzTS0f7DN90YQ7EVbGx2u+F5Gy
         QFfSAgTWgHQXjC28gQzETma55aB54KfSbc/v8XSTON+5jtkkFk8UQR/KC6JIRUxSuWbo
         1+0fOohfIACX2KFZkI3ThD6bmvskDs9CEQqGojqRXDPpI0ASIPUA0O4tzZvRm/ExPjHy
         BqevTbUKSKy+cP8+ucu2KiXzxfK1OvzxNeJKTCyV89cjB3G6XVLC8vR7cFihsH4bT+G0
         YU+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uluB0mD/174B1JmgSMgZuinmmEBxrt4PIkK2KNEJKOo=;
        b=nRkn1qP0i6Sml8M9wHh5xzBTDDJy9BxyLTdxA4CF0LCbJD+2HZIdGVggGZnS7mgD7V
         oq5L5X3Iuc83PSrUoX40pwwIshVu8ZAZ4kXyXHxYFlyrcEdpwH+BClnTDtMvuC7n3gCp
         w8BDvCzUN9PAr71Txg+I3eUTkFA7OyfxGeWUQfGIVC48c2a604C5zbdXEpQCnib6QBSM
         N7BoKkI/kLEisn7SxyA6PMhrevSpIKw31qoNoWCfAjydrYb6bpqkcwvzSCT0636T5Zk8
         7Wlp17P1zsfDkPK3X3RvxqSW4nxs7ZBrxSauiqP0BWD1uOEBdt7m8HSfvNzxof1gxj6e
         G+Mg==
X-Gm-Message-State: AOAM531ago2AwNuj4svdfvIxl457Mi7Hzcsh6bXL1nm/LB0hshuHKYTH
	D6jRZkfmG4wjfuMSmwzquRFg9w==
X-Google-Smtp-Source: ABdhPJx/Do5bA91lE6f8apE3WArvcwbgH/dVUZItW3VPJqbV0nihvwAd9PJeh1M6rqlwzTkyl7gprw==
X-Received: by 2002:aed:2f67:: with SMTP id l94mr6124949qtd.201.1607624717743;
        Thu, 10 Dec 2020 10:25:17 -0800 (PST)
Subject: Re: [PATCH v2 3/6] elf: Fix failure handling in
 _dl_map_object_from_fd
To: Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org
Cc: Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Jeremy Linton <jeremy.linton@arm.com>, Mark Brown <broonie@kernel.org>,
 Topi Miettinen <toiwoton@gmail.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
References: <cover.1606319495.git.szabolcs.nagy@arm.com>
 <8ebf571196dd499c61983dbf53c94c68ebd458cc.1606319495.git.szabolcs.nagy@arm.com>
From: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Autocrypt: addr=adhemerval.zanella@linaro.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <1525639f-560f-2677-b1cb-f904b3552c71@linaro.org>
Date: Thu, 10 Dec 2020 15:25:12 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8ebf571196dd499c61983dbf53c94c68ebd458cc.1606319495.git.szabolcs.nagy@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit



On 27/11/2020 10:20, Szabolcs Nagy via Libc-alpha wrote:
> There are many failure paths that call lose to do local cleanups
> in _dl_map_object_from_fd, but it did not clean everything.
> 
> Handle l_phdr, l_libname and mapped segments in the common failure
> handling code.
> 
> There are various bits that may not be cleaned properly on failure
> (e.g. executable stack, tlsid, incomplete dl_map_segments).
> ---
>  elf/dl-load.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/elf/dl-load.c b/elf/dl-load.c
> index 21e55deb19..9c71b7562c 100644
> --- a/elf/dl-load.c
> +++ b/elf/dl-load.c
> @@ -914,8 +914,15 @@ lose (int code, int fd, const char *name, char *realname, struct link_map *l,
>    /* The file might already be closed.  */
>    if (fd != -1)
>      (void) __close_nocancel (fd);
> +  if (l != NULL && l->l_map_start != 0)
> +    _dl_unmap_segments (l);
>    if (l != NULL && l->l_origin != (char *) -1l)
>      free ((char *) l->l_origin);
> +  if (l != NULL && !l->l_libname->dont_free)
> +    free (l->l_libname);
> +  if (l != NULL && l->l_phdr_allocated)
> +    free ((void *) l->l_phdr);
> +
>    free (l);
>    free (realname);
>  
> @@ -1256,7 +1263,11 @@ _dl_map_object_from_fd (const char *name, const char *origname, int fd,
>      errstring = _dl_map_segments (l, fd, header, type, loadcmds, nloadcmds,
>  				  maplength, has_holes, loader);
>      if (__glibc_unlikely (errstring != NULL))
> -      goto call_lose;
> +      {
> +	/* Mappings can be in an inconsistent state: avoid unmap.  */
> +	l->l_map_start = l->l_map_end = 0;
> +	goto call_lose;
> +      }
>  
>      /* Process program headers again after load segments are mapped in
>         case processing requires accessing those segments.  Scan program

In this case I am failing to see who would be responsible to unmap 
l_map_start int the type == ET_DYN where first mmap succeeds but
with a later mmap failure in any load command.

> @@ -1294,14 +1305,6 @@ _dl_map_object_from_fd (const char *name, const char *origname, int fd,
>        || (__glibc_unlikely (l->l_flags_1 & DF_1_PIE)
>  	  && __glibc_unlikely ((mode & __RTLD_OPENEXEC) == 0)))
>      {
> -      /* We are not supposed to load this object.  Free all resources.  */
> -      _dl_unmap_segments (l);
> -
> -      if (!l->l_libname->dont_free)
> -	free (l->l_libname);
> -
> -      if (l->l_phdr_allocated)
> -	free ((void *) l->l_phdr);
>  
>        if (l->l_flags_1 & DF_1_PIE)
>  	errstring
> @@ -1392,6 +1395,9 @@ cannot enable executable stack as shared object requires");
>    /* Signal that we closed the file.  */
>    fd = -1;
>  
> +  /* Failures before this point are handled locally via lose.
> +     No more failures are allowed in this function until return.  */
> +
>    /* If this is ET_EXEC, we should have loaded it as lt_executable.  */
>    assert (type != ET_EXEC || l->l_type == lt_executable);
>  
> 

Ok.
