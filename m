Return-Path: <SRS0=uCk+=HY=lists.openwall.com=kernel-hardening-return-20806-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CEF6C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 17:23:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AC55564E00
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 17:23:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC55564E00
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20806-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9490 invoked by uid 550); 22 Feb 2021 17:22:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28247 invoked from network); 22 Feb 2021 16:22:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O2UdjypR4W3iDVOy5hnKP5de6BTPFEvlQ6oGQr/tzUY=;
        b=QWYr4qA6Wc1K2uzDRbRDKEFJU9VggdyiFbE9noSMExFmpSB/WSH/g2hR2wobF0KpKU
         aVmWFkaH9gj8GcMoYdDsRvYawy/kizivt/PojhfqMjCVxWyJwyMAmuZjBr0OPFcPerai
         XoppCFZUi/lHoq1JIO0Y7Bw+vx/Vb9gdiubmc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O2UdjypR4W3iDVOy5hnKP5de6BTPFEvlQ6oGQr/tzUY=;
        b=HDkoVRGn/mjD+NPMxI+fpyTOqxu5lbrsUfpEcUUT7ffxhDtPV0Ttbn19edQE1kIsye
         GZINIhAX2ogd0h3OQWxWc8aO/3SUQDDMYnc94daEy9tW/yAO9HjNG7xMsI+eBH0gaLWI
         C0LgBwwqjbYV15934NYjoFmX7a3SbquvIeVbAd75nrUbbzVmJBk9xSn+DptSD27Ov1Dm
         fDNCJVJGf/cBibFPL97evggIS4f1HcbSvFRB3ZQYBhYP1Czh+qgKfUn2VtI6J2dEJMvv
         RXnehzyoQvISZG36OXzRU2cHcsxZCFBnqcgeTaWGKsj7/iBRHLQ7UgDEJB4STXGpFffG
         zyUA==
X-Gm-Message-State: AOAM531YUy7XccZYxRpNG6oIyPWq3p5hyIcHF31tmjD0jPBtt+UwHZcw
	H0KwNMUVwYQ6Msu6iOv3n296uQ==
X-Google-Smtp-Source: ABdhPJwFg4oQJS2b8UUSE1H4Y8Chs7Kox5qlda5aF9f45HJogdaR2sWCL7VTfnIvoEcooK4vehk05A==
X-Received: by 2002:a92:1312:: with SMTP id 18mr15099286ilt.92.1614010911339;
        Mon, 22 Feb 2021 08:21:51 -0800 (PST)
Subject: Re: [PATCH 19/20] usbip: usbip_host: Manual replacement of the
 deprecated strlcpy() with return values
To: Romain Perier <romain.perier@gmail.com>, Kees Cook
 <keescook@chromium.org>, kernel-hardening@lists.openwall.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Valentina Manea <valentina.manea.m@gmail.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20210222151231.22572-1-romain.perier@gmail.com>
 <20210222151231.22572-20-romain.perier@gmail.com>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0323dcb2-726c-7ea2-8e8b-dba81090b571@linuxfoundation.org>
Date: Mon, 22 Feb 2021 09:21:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210222151231.22572-20-romain.perier@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2/22/21 8:12 AM, Romain Perier wrote:
> The strlcpy() reads the entire source buffer first, it is dangerous if
> the source buffer lenght is unbounded or possibility non NULL-terminated.
> It can lead to linear read overflows, crashes, etc...
> 
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
>   drivers/usb/usbip/stub_main.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/usbip/stub_main.c b/drivers/usb/usbip/stub_main.c
> index 77a5b3f8736a..5bc2c09c0d10 100644
> --- a/drivers/usb/usbip/stub_main.c
> +++ b/drivers/usb/usbip/stub_main.c
> @@ -167,15 +167,15 @@ static ssize_t match_busid_show(struct device_driver *drv, char *buf)
>   static ssize_t match_busid_store(struct device_driver *dev, const char *buf,
>   				 size_t count)
>   {
> -	int len;
> +	ssize_t len;
>   	char busid[BUSID_SIZE];
>   
>   	if (count < 5)
>   		return -EINVAL;
>   
>   	/* busid needs to include \0 termination */
> -	len = strlcpy(busid, buf + 4, BUSID_SIZE);
> -	if (sizeof(busid) <= len)
> +	len = strscpy(busid, buf + 4, BUSID_SIZE);
> +	if (len == -E2BIG)
>   		return -EINVAL;
>   
>   	if (!strncmp(buf, "add ", 4)) {
> 


Looks good to me. Thank you.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
