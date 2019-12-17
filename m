Return-Path: <SRS0=qPnV=2H=lists.openwall.com=kernel-hardening-return-17505-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02731C43603
	for <kernel-hardening@archiver.kernel.org>; Tue, 17 Dec 2019 23:57:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5149720729
	for <kernel-hardening@archiver.kernel.org>; Tue, 17 Dec 2019 23:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PGch8hly"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5149720729
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17505-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15594 invoked by uid 550); 17 Dec 2019 23:57:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15560 invoked from network); 17 Dec 2019 23:57:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=98nQRWslLAdLJGWLqVhnniGfUUsPCo+VqaOoUSaSUns=;
        b=PGch8hlyMzS3H+pj7vsa+6bP67QROcjbgUjWjaiomnK918y2/7P+cQB1j6ACFDOLFj
         wNbtp61480FQ7nbl2qR39dcoMTxq+SEHu9B7vXPmoZ1IfJNKL4AIrwBCeCkvI4AWc0tV
         xfJSmgOcLHPXwvOXwxPWyaho6pWx92dPSHWYk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=98nQRWslLAdLJGWLqVhnniGfUUsPCo+VqaOoUSaSUns=;
        b=ruAfFpvDKTAYYDSQ9cIIfIe6+gn0nP/5pyieFPuP93B7l0A8ZuT5JE50BXK02PXEHF
         TCgq1pvDAtHGmnhNbSQi33NDMCHpvmvWtY1pKdUNdazm88m/0SB8zQdmvLGFp7jVFy8r
         7NlG5HeLUF/MU3zZQ3Kz/lu1XvudIlQsko5ttXfOTAlbA736i6PyEAp0Uoz8jmkvxeKN
         tpg1qPSmAorxxb3qTtmPTb37Gj6w14oHd7zhJXYrMklwFe9T9jqHQ7gu5Egtd9IJMNFd
         IMMr4ouUASAe63+vcw2JJ9t8hTXTeiWIqEK+v7flO6qf+8N+R938SUiyS7B0hCCLNZB0
         7HWw==
X-Gm-Message-State: APjAAAWXOkzk/jO6r1uv5jDLzlYN29MqBIlHX7aoGBkd4nxX1aW75rBt
	4pNhZPYeVSNQ6MWlvxP4Bqfs5A==
X-Google-Smtp-Source: APXvYqwtElBq8KfVRNF9PP7xPPEpVIg/BmDDCfZjjfZ0McuBDEedfKzOjWDThbCPUdUTzVobikP7tg==
X-Received: by 2002:a17:90a:8a8f:: with SMTP id x15mr114462pjn.87.1576627031671;
        Tue, 17 Dec 2019 15:57:11 -0800 (PST)
Date: Tue, 17 Dec 2019 15:57:09 -0800
From: Kees Cook <keescook@chromium.org>
To: Tianlin Li <tli@digitalocean.com>
Cc: kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/misc: have the callers of set_memory_*() check
 the return value
Message-ID: <201912171557.507D9D2@keescook>
References: <20191217194528.16461-1-tli@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217194528.16461-1-tli@digitalocean.com>

On Tue, Dec 17, 2019 at 01:45:28PM -0600, Tianlin Li wrote:
> Right now several architectures allow their set_memory_*() family of  
> functions to fail, but callers may not be checking the return values.
> If set_memory_*() returns with an error, call-site assumptions may be
> infact wrong to assume that it would either succeed or not succeed at  
> all. Ideally, the failure of set_memory_*() should be passed up the 
> call stack, and callers should examine the failure and deal with it. 
> 
> Need to fix the callers and add the __must_check attribute. They also 
> may not provide any level of atomicity, in the sense that the memory 
> protections may be left incomplete on failure. This issue likely has a 
> few steps on effects architectures:
> 1)Have all callers of set_memory_*() helpers check the return value.
> 2)Add __must_check to all set_memory_*() helpers so that new uses do 
> not ignore the return value.
> 3)Add atomicity to the calls so that the memory protections aren't left 
> in a partial state.
> 
> This series is part of step 1. Make sram driver check the return value of  
> set_memory_*().
> 
> Signed-off-by: Tianlin Li <tli@digitalocean.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/misc/sram-exec.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/misc/sram-exec.c b/drivers/misc/sram-exec.c
> index d054e2842a5f..cb57ac6ab4c3 100644
> --- a/drivers/misc/sram-exec.c
> +++ b/drivers/misc/sram-exec.c
> @@ -85,6 +85,7 @@ void *sram_exec_copy(struct gen_pool *pool, void *dst, void *src,
>  	unsigned long base;
>  	int pages;
>  	void *dst_cpy;
> +	int ret;
>  
>  	mutex_lock(&exec_pool_list_mutex);
>  	list_for_each_entry(p, &exec_pool_list, list) {
> @@ -104,16 +105,28 @@ void *sram_exec_copy(struct gen_pool *pool, void *dst, void *src,
>  
>  	mutex_lock(&part->lock);
>  
> -	set_memory_nx((unsigned long)base, pages);
> -	set_memory_rw((unsigned long)base, pages);
> +	ret = set_memory_nx((unsigned long)base, pages);
> +	if (ret)
> +		goto error_out;
> +	ret = set_memory_rw((unsigned long)base, pages);
> +	if (ret)
> +		goto error_out;
>  
>  	dst_cpy = fncpy(dst, src, size);
>  
> -	set_memory_ro((unsigned long)base, pages);
> -	set_memory_x((unsigned long)base, pages);
> +	ret = set_memory_ro((unsigned long)base, pages);
> +	if (ret)
> +		goto error_out;
> +	ret = set_memory_x((unsigned long)base, pages);
> +	if (ret)
> +		goto error_out;
>  
>  	mutex_unlock(&part->lock);
>  
>  	return dst_cpy;
> +
> +error_out:
> +	mutex_unlock(&part->lock);
> +	return NULL;
>  }
>  EXPORT_SYMBOL_GPL(sram_exec_copy);
> -- 
> 2.17.1
> 

-- 
Kees Cook
