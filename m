Return-Path: <SRS0=Ca5b=H4=lists.openwall.com=kernel-hardening-return-20846-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054C0C433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Feb 2021 09:49:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C234064E38
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Feb 2021 09:49:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C234064E38
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20846-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16186 invoked by uid 550); 26 Feb 2021 09:49:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16151 invoked from network); 26 Feb 2021 09:49:15 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qz7iF8KIepOE4aCxzuQPw/BTEyuyc4LjaMrR27h9584=;
        b=ky/WdLfXbsFYxB/OAReDqdiJ5j9yqCYobJD+NmKm7yKyHw938jvD+P8DOuh8pd/6Fp
         gufu2JaUXFx/T5cM804kQLr4LsBnVGNSaCmj1gIRgKEF9ZXHo2w80j+clUALfVpNgXxv
         E/qqalWzaiiS8Fmt7dBXcCzV8oJ6clUgzD+XQItTNdq18w325UK13Fcdj74pnN6fX0hf
         Bjh3MOxED/MKL4kh+CY5dWKTMq6GLNiQpZ3Hg566pm6vkdMx/xvvPpoullf4TzTnFmTJ
         nKAV/j+6vhZgj04EmKaPCLkWf2G3nQnn/okDFqrbbMTn8YDfbTAORItVLT5tEoqQ1euT
         lLlA==
X-Gm-Message-State: AOAM532w8TLeKCDN/3Z6CXd4SrVJCwaUlGo9F/xKgVabJUt/yhC8z3Ca
	xTB1mc6R8coNdfPWE4B2p2w=
X-Google-Smtp-Source: ABdhPJxa+ePfa8Re0o7FPIUeXTV3zNbjJ6/8zuXMfuHUQc76/Zay34GMNYowsatoX+YD24AqPO+Hiw==
X-Received: by 2002:a17:906:1b0e:: with SMTP id o14mr2419608ejg.541.1614332943754;
        Fri, 26 Feb 2021 01:49:03 -0800 (PST)
Subject: Re: [PATCH 17/20] vt: Manual replacement of the deprecated strlcpy()
 with return values
To: Romain Perier <romain.perier@gmail.com>, Kees Cook
 <keescook@chromium.org>, kernel-hardening@lists.openwall.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
References: <20210222151231.22572-1-romain.perier@gmail.com>
 <20210222151231.22572-18-romain.perier@gmail.com>
From: Jiri Slaby <jirislaby@kernel.org>
Message-ID: <a9f26339-c366-40c4-1cd6-c7ae1838e2b6@kernel.org>
Date: Fri, 26 Feb 2021 10:49:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210222151231.22572-18-romain.perier@gmail.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 22. 02. 21, 16:12, Romain Perier wrote:
> The strlcpy() reads the entire source buffer first, it is dangerous if
> the source buffer lenght is unbounded or possibility non NULL-terminated.

"length" and it's NUL, not NULL in this case.

> It can lead to linear read overflows, crashes, etc...
> 
> As recommended in the deprecated interfaces [1], it should be replaced
> by strscpy.
> 
> This commit replaces all calls to strlcpy that handle the return values

s/that/which/ ?
"handles"
"value"

> by the corresponding strscpy calls with new handling of the return
> values (as it is quite different between the two functions).

Sorry, I have hard times understand the whole sentence. Could you 
rephrase a bit?

> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>   drivers/tty/vt/keyboard.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
> index 77638629c562..5e20c6c307e0 100644
> --- a/drivers/tty/vt/keyboard.c
> +++ b/drivers/tty/vt/keyboard.c
> @@ -2067,9 +2067,12 @@ int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm)
>   			return -ENOMEM;
>   
>   		spin_lock_irqsave(&func_buf_lock, flags);
> -		len = strlcpy(kbs, func_table[kb_func] ? : "", len);
> +		len = strscpy(kbs, func_table[kb_func] ? : "", len);

func_table[kb_func] is NUL-terminated and kbs is of length len anyway, 
so this is only cosmetical.

>   		spin_unlock_irqrestore(&func_buf_lock, flags);
>   
> +		if (len == -E2BIG)
> +			return -E2BIG;
> +

This can never happen, right?

>   		ret = copy_to_user(user_kdgkb->kb_string, kbs, len + 1) ?
>   			-EFAULT : 0;
>   
> 

thanks,
-- 
js
