Return-Path: <SRS0=UFvI=H6=lists.openwall.com=kernel-hardening-return-20860-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E95C433E0
	for <kernel-hardening@archiver.kernel.org>; Sun, 28 Feb 2021 09:09:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E920C64E4A
	for <kernel-hardening@archiver.kernel.org>; Sun, 28 Feb 2021 09:09:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E920C64E4A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20860-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3421 invoked by uid 550); 28 Feb 2021 09:09:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1100 invoked from network); 28 Feb 2021 09:04:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y3Uu/ZsgdYlP08kLSEVkeDEOcieYxfw0pQ354JPC2Q8=;
        b=IGC6oxBgqtzKuECaslYLe0rrGIsJ4UFxxy4GL4v/Zs8RE/qpumzSmXwsvH9mKfU7Uj
         dZEnVt3oVbN5duSQthBazjmPgd4/gXFuecaEtAHNWlRMGGTNiYJOrE+A/8ut47CupCet
         Iq5JjE0rSivojPuiG6oDZ1Vscq579fbYjoIy7ez2wwlFgK/lOGW2QSaOciDeRFAIlTpq
         Miak5nST3JWg/La8t9L4iAPOGqj03qI4rPHMMw5Lq18AWI9oZHYGjmzV5M0k1M9NxO6U
         i8ZTEnHYoEBcAL9gtm/pLqabb2ilr+FtUK+dX0qUE0U66Awq7ygP9TJHpiO93Z9rdm2c
         EaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Y3Uu/ZsgdYlP08kLSEVkeDEOcieYxfw0pQ354JPC2Q8=;
        b=qZzpAXgB8u6Zf+WRLyhuOBeRQO1bb5Ap08X7EDQYS5kVTxaLzZCZR+nBWklu6IxPP8
         FjDIKiAlhh4IwN/cspBDJfvuyfdEuNKa4UhrcB0hCXFz0vyjivInP4n9qw09GyMzd7cF
         GzRA+kDVMqkurEIlof9H7BpmnIHnGrqCVEBI+5IKzBKWqieRvX2dOKLVgoGE0KJAnQHy
         YVp2/rUP+3UhGFocjW6q4hCkD87Xqv3rM4isH/BT8WNwQihDNcNHdkod8X2naRKMAkcc
         plYhV7BnfmIYm8bIHR1gdqMHhO3K1y+YCyN+St0YBwN4W8pALg94s9fjOokYm+BARs4N
         K4mA==
X-Gm-Message-State: AOAM530RF4fiw3WvYhCGoPw4IzZ0pn0lnuBMVFTSJDJbnlArJhc6IYhr
	89xLW2tUqATClc1h+XhywsA=
X-Google-Smtp-Source: ABdhPJwRbm12LrWwbcR6zUKZ9YTXpgi2ThJ1DGoXccMSMQ5SbAREgYAFsD/S4IzWXMwy+RvvMSRvTw==
X-Received: by 2002:a05:651c:1318:: with SMTP id u24mr6298895lja.426.1614503038657;
        Sun, 28 Feb 2021 01:03:58 -0800 (PST)
Subject: Re: [PATCH 19/20] usbip: usbip_host: Manual replacement of the
 deprecated strlcpy() with return values
To: Romain Perier <romain.perier@gmail.com>, Kees Cook
 <keescook@chromium.org>, kernel-hardening@lists.openwall.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Valentina Manea <valentina.manea.m@gmail.com>, Shuah Khan
 <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210222151231.22572-1-romain.perier@gmail.com>
 <20210222151231.22572-20-romain.perier@gmail.com>
From: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <045eb376-f490-9608-6e54-68d39e83c3f9@gmail.com>
Date: Sun, 28 Feb 2021 12:03:54 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210222151231.22572-20-romain.perier@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Hello!

On 22.02.2021 18:12, Romain Perier wrote:

> The strlcpy() reads the entire source buffer first, it is dangerous if
> the source buffer lenght is unbounded or possibility non NULL-terminated.

    Length. Possibly?

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
[...]

MBR, Sergei
