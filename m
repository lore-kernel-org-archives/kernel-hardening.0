Return-Path: <SRS0=mWLR=HY=lists.openwall.com=kernel-hardening-return-20803-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 687AAC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 17:23:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 68F7364E00
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 17:23:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68F7364E00
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20803-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3148 invoked by uid 550); 22 Feb 2021 17:21:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13910 invoked from network); 22 Feb 2021 15:56:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TPpevQFvMZZaJ5SzMpqPhoMUxM8hXrVsQM4xh4VAqE0=;
        b=m0cbFoUW3OXA+TA1/2nGv1cjum3dpvIZg31hF14CB0UgAIGlLR/MvrWzsnEXtacM8m
         Fmj3AWJa1qzDaNdSGMCjH/MKHZdMoiqmMkVfQIlJtVZ51+psoFP6Ul4B1uqexRO+v/QF
         k/mGOCJaeHd6LRUc8XYEMg3CKPwJ3pGSfw8XFE5Dd4/dKWzSMpYxGI/DSQdmjcesLU8E
         jLyBR5XrWlKISITxUZsDrQM8D+dgC3UlifK7I6KFWdQGT4RegbRwlfF5d7DVyedH2vzT
         YZDIH5Xj+8SZjjmQvElLoazJnrn6NmR2UBTvUUqYBQuZVj/BkHIzxEgPV+NNx65erk2H
         /Xvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TPpevQFvMZZaJ5SzMpqPhoMUxM8hXrVsQM4xh4VAqE0=;
        b=Yi2n8DZKrsU3YgCv+VRD1NWJvKoF80E9YVV7yExKOV9SVRvb730IqTTT2yTBbC2G2B
         vWRQfZXVeU5kD450GEPRmVkWmHb3jpW4tXO5amz6jOe4eir2/iHtgUeWapWXYfC9s6qu
         jFNVfuLE8euYbNwnfPXSHeKSs+EFzSagbthAc8j2UrsvgqEG533ItMChoyVWasuz9t7w
         5CW6YsMT2TAoycEZrzULq2uincNVJSTUjpO2jKNsF2bL2y1CEWAXHlu6EHZKtEi5duXM
         ceKxKUuwmUB+x+x8oKtBgP+Z2S+NMqSJwmawQ8FESr6QTWqOxQ4Dfkz2RXA293ubjuzg
         v2lA==
X-Gm-Message-State: AOAM530pNdaV2Si+fQzSEyv/eMmfotLasxIGlZ76MjrBUjPXqqVjPK5m
	PrRcT6VxMoDRR6xDK7x/doU=
X-Google-Smtp-Source: ABdhPJxEg0BBP7mWsE08uisVDLqWYrDPsvyCHU3uMb22kVyWIjJiTrrrK2B23MSxj0dtI55Eju57jg==
X-Received: by 2002:a05:6808:aa6:: with SMTP id r6mr4112330oij.128.1614009351635;
        Mon, 22 Feb 2021 07:55:51 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 20/20] s390/watchdog: Manual replacement of the deprecated
 strlcpy() with return values
To: Romain Perier <romain.perier@gmail.com>, Kees Cook
 <keescook@chromium.org>, kernel-hardening@lists.openwall.com,
 Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210222151231.22572-1-romain.perier@gmail.com>
 <20210222151231.22572-21-romain.perier@gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <98317dfa-d884-d4ae-9449-d84b902c0e5c@roeck-us.net>
Date: Mon, 22 Feb 2021 07:55:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210222151231.22572-21-romain.perier@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 2/22/21 7:12 AM, Romain Perier wrote:
> The strlcpy() reads the entire source buffer first, it is dangerous if
> the source buffer lenght is unbounded or possibility non NULL-terminated.

length

> It can lead to linear read overflows, crashes, etc...
> 

That won't happen here since both buffers have the same length
and the source is known to be NULL_terminated.

So this is another misleading patch. If strlcpy() is deemed so dangerous
nowadays, replace it with memcpy(). That is expensive too, but at least
it won't create the impression that a non-existing error would ever occur
On top of that, the code is handling all MAX_CMDLEN bytes twice anyway
later on, so we can for sure afford the extra cost of the memcpy().
Pus, we'll have the added benefit that the unused part of the buffer
will be cleared and no longer contain random data.

Guenter

> As recommended in the deprecated interfaces [1], it should be replaced
> by strscpy.
> 
> This commit replaces all calls to strlcpy that handle the return values
> by the corresponding strscpy calls with new handling of the return
> values (as it is quite different between the two functions).
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  drivers/watchdog/diag288_wdt.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/watchdog/diag288_wdt.c b/drivers/watchdog/diag288_wdt.c
> index aafc8d98bf9f..5703f35dd0b7 100644
> --- a/drivers/watchdog/diag288_wdt.c
> +++ b/drivers/watchdog/diag288_wdt.c
> @@ -111,7 +111,7 @@ static unsigned long wdt_status;
>  static int wdt_start(struct watchdog_device *dev)
>  {
>  	char *ebc_cmd;
> -	size_t len;
> +	ssize_t len;
>  	int ret;
>  	unsigned int func;
>  
> @@ -126,7 +126,9 @@ static int wdt_start(struct watchdog_device *dev)
>  			clear_bit(DIAG_WDOG_BUSY, &wdt_status);
>  			return -ENOMEM;
>  		}
> -		len = strlcpy(ebc_cmd, wdt_cmd, MAX_CMDLEN);
> +		len = strscpy(ebc_cmd, wdt_cmd, MAX_CMDLEN);
> +		if (len == -E2BIG)
> +			return -E2BIG;
>  		ASCEBC(ebc_cmd, MAX_CMDLEN);
>  		EBC_TOUPPER(ebc_cmd, MAX_CMDLEN);
>  
> @@ -163,7 +165,7 @@ static int wdt_stop(struct watchdog_device *dev)
>  static int wdt_ping(struct watchdog_device *dev)
>  {
>  	char *ebc_cmd;
> -	size_t len;
> +	ssize_t len;
>  	int ret;
>  	unsigned int func;
>  
> @@ -173,7 +175,9 @@ static int wdt_ping(struct watchdog_device *dev)
>  		ebc_cmd = kmalloc(MAX_CMDLEN, GFP_KERNEL);
>  		if (!ebc_cmd)
>  			return -ENOMEM;
> -		len = strlcpy(ebc_cmd, wdt_cmd, MAX_CMDLEN);
> +		len = strscpy(ebc_cmd, wdt_cmd, MAX_CMDLEN);
> +		if (len == -E2BIG)
> +			return -E2BIG;
>  		ASCEBC(ebc_cmd, MAX_CMDLEN);
>  		EBC_TOUPPER(ebc_cmd, MAX_CMDLEN);
>  
> 

