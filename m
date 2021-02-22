Return-Path: <SRS0=MX7f=HY=lists.openwall.com=kernel-hardening-return-20807-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778A3C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 17:24:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AFFC864E00
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 17:24:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFFC864E00
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20807-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11765 invoked by uid 550); 22 Feb 2021 17:22:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1122 invoked from network); 22 Feb 2021 16:37:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CQtzj2ET+OspvcT7VasFUJh31XI2DgueE7K7chQefu0=;
        b=JgIAcXbmqnUtAzeQggrQMFDw+iRD7712f5b6XLlsNpGFq/2OH71ZR8eVPcYSvV8O9Z
         Q4ZFhr/HY3qIL2VVw5am2ZXMqQjcHv6oQm57icBzxpF2r/H6pUN28Ic0UVcMNAWR0oM3
         Nk4pk+06r39DoxUQo5VbU8V6VX0ewSDT/6fu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CQtzj2ET+OspvcT7VasFUJh31XI2DgueE7K7chQefu0=;
        b=GkeJHRx4QMBklbo29LuwIwA67Q4k9E8fdHn8evyWqU/nlgNE5KzFcU+p/iSL96NMy0
         RU/QYjpwEtXfpjkyru5Il3Qi75AqnqBJdR048rkERL19VDtc3XuNCGsqSw+SSB6Q97E9
         xisJPjKqLQLqOsL8J5IEKZllZbMfno2FICPMTgZYSBvWafHIGk16SMi4w6ml2zVS2QBj
         xtEdUaRZ21mdx2ZVR01ngIV8AM4z7c9qfUyNQSBh4/0qbrV6xfRgBQtdDsTt1tbLb/ko
         cWOIkZ6724F9GP+betLaOV9qoRdqDF2SJ2evsbfr7Z5iejkqKaCpGk4HXIoQXcgYKTJM
         mJXg==
X-Gm-Message-State: AOAM532+UvUJocJmLAtKRmrijQsLcYfVGN8cRv4jp14cs4hKS4X/gD5y
	I1iaw+LB+XkEEmZPRYFfyK37Sw==
X-Google-Smtp-Source: ABdhPJyA692d/UkhfnySsVsus41uILuIidqyduT1DxwFO8wUlVI27VDOIjP5WOhWxUUsjwOOYq7M6Q==
X-Received: by 2002:a05:6830:314d:: with SMTP id c13mr16134049ots.124.1614011814286;
        Mon, 22 Feb 2021 08:36:54 -0800 (PST)
Subject: Re: [PATCH 00/20] Manual replacement of all strlcpy in favor of
 strscpy
To: Romain Perier <romain.perier@gmail.com>, Kees Cook
 <keescook@chromium.org>, kernel-hardening@lists.openwall.com,
 Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jiri@nvidia.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Mimi Zohar <zohar@linux.ibm.com>, Dmitry Kasatkin
 <dmitry.kasatkin@gmail.com>, "J. Bruce Fields" <bfields@fieldses.org>,
 Chuck Lever <chuck.lever@oracle.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Jessica Yu <jeyu@kernel.org>,
 Guenter Roeck <linux@roeck-us.net>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Steffen Maier <maier@linux.ibm.com>, Benjamin Block <bblock@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
 Jiri Slaby <jirislaby@kernel.org>, Felipe Balbi <balbi@kernel.org>,
 Valentina Manea <valentina.manea.m@gmail.com>, Shuah Khan
 <shuah@kernel.org>, Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: cgroups@vger.kernel.org, linux-crypto@vger.kernel.org,
 netdev@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-integrity@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-hwmon@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 alsa-devel@alsa-project.org, linux-usb@vger.kernel.org,
 linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20210222151231.22572-1-romain.perier@gmail.com>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <936bcf5e-2006-7643-7804-9efa318b3e2b@linuxfoundation.org>
Date: Mon, 22 Feb 2021 09:36:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210222151231.22572-1-romain.perier@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2/22/21 8:12 AM, Romain Perier wrote:
> strlcpy() copy a C-String into a sized buffer, the result is always a
> valid NULL-terminated that fits in the buffer, howerver it has severals
> issues. It reads the source buffer first, which is dangerous if it is non
> NULL-terminated or if the corresponding buffer is unbounded. Its safe
> replacement is strscpy(), as suggested in the deprecated interface [1].
> 
> We plan to make this contribution in two steps:
> - Firsly all cases of strlcpy's return value are manually replaced by the
>    corresponding calls of strscpy() with the new handling of the return
>    value (as the return code is different in case of error).
> - Then all other cases are automatically replaced by using coccinelle.
> 

Cool. A quick check shows me 1031 strscpy() calls with no return
checks. All or some of these probably need to be reviewed and add
return checks. Is this something that is in the plan to address as
part of this work?

thanks,
-- Shuah
