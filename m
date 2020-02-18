Return-Path: <SRS0=1O/P=4G=lists.openwall.com=kernel-hardening-return-17824-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCEDC34026
	for <kernel-hardening@archiver.kernel.org>; Tue, 18 Feb 2020 11:08:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D6E292173E
	for <kernel-hardening@archiver.kernel.org>; Tue, 18 Feb 2020 11:08:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kc96tCEW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6E292173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17824-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22500 invoked by uid 550); 18 Feb 2020 11:08:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32712 invoked from network); 18 Feb 2020 02:22:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z/jehiOXQCJ99Rc+Y+qxYc0pnP1x2sTTgrg9bNsXRtI=;
        b=kc96tCEWf5sZc8m6jBxuKeJ0RbrhRpb/uJmmmNgzeCPT1J7fJaSBCULyzFIXfAX4ha
         o8sVrNlBN1ajv3cF0cJ55NFKaRRHew5fbNf2A7KwuzT/YNXLSMhzGIS3i3k+DE6qGjV/
         Ohe2Q5nOWWmjv0Al/h60tXXYADCvA52uL4hdNy2N2KfDG4z3QuzVETPK377Qxs8xiFPp
         uIPns5NmKRkeYkGkqQuL6fqYWWXU96+MzOVnxLqf9qKrhUeNwdreYjxX5HV5IhJDaExv
         32dTByueHQHz41yLZuQDUa2Ui21IPyffDSXetVRQ8bXV3D++QGoUqzEw4F5ckI7LY3zN
         hW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=z/jehiOXQCJ99Rc+Y+qxYc0pnP1x2sTTgrg9bNsXRtI=;
        b=erXnG74TPjfiLPXX/MVObqYUCDO1CwWQ4WDKu2lofo4MHTDC7HnxdZIdZIktNO34RV
         gle5S+t5gITh4Slm0xMCmcsd09fAaTPKbMgv2FPKalsjvsf8Sw+oZiuLmJ5T8gICvzvS
         ZDQscxwDf7iFi/EZ8bhHg8DHGijBIjMlwAxaFGO5fi1oBttAwHA/oryf7hrXfGh4TyCw
         unXEe/PVOtgDibRM2Eso059NPUMfHeGfYaPW0Ymk93tFGa5ynaytHAsoea++l4DiT6xA
         rDgoQn8svTovc6nDW419F3DqsWkaen/KLC79HoKoUJOKaMl6x4iqLgVs6zTFSl35jx+V
         xx1w==
X-Gm-Message-State: APjAAAVRqH9vriekOl5ge6FdVfFcSn0cfG1vULOsgEALKA3Vz6I5be2M
	OZ3812jK1QZXAdihIVNiDnM=
X-Google-Smtp-Source: APXvYqxQXZr3jpQRyTuIlWQlekoV6fdLy63TfxHYB/Sd7qektCWGyzfMRDtUNkxofg0+k6DG2Gufyg==
X-Received: by 2002:a17:90b:3c9:: with SMTP id go9mr2332215pjb.7.1581992521250;
        Mon, 17 Feb 2020 18:22:01 -0800 (PST)
Subject: Re: Maybe inappropriate use BUG_ON() in CONFIG_SLAB_FREELIST_HARDENED
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Popov <alex.popov@linux.com>,
 Andrey Konovalov <andreyknvl@google.com>,
 kernel-hardening@lists.openwall.com, Shawn <citypw@hardenedlinux.org>,
 spender@grsecurity.net
References: <e535d698-5268-e5fc-a238-0649c509cc4f@gmail.com>
 <CAAeHK+y-FdpH20Z7HsB0U+mgD9CK0gECCqShXFtFWpFp01jAmA@mail.gmail.com>
 <202002171019.A7B4679@keescook>
From: zerons <zeronsaxm@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=zeronsaxm@gmail.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <dc337497-8084-915c-be64-059ef7cc1538@gmail.com>
Date: Tue, 18 Feb 2020 10:21:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <202002171019.A7B4679@keescook>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit


> 
>>> In my opinion, this patch can somehow help attacker exploit this kind of bugs
>>> more reliable.
> 
> Why do you think this makes races easier to win?
> 

Sorry, not to make the races easier, but to make the exploitations
more reliable.

>> +Alexander Popov, who is the author of the double free check in
>> SLAB_FREELIST_HARDENED.
>>
>> Ah, so as long as the double free happens in a user process context,
>> you can retry triggering it until you succeed in winning the race to
>> reallocate the object (without causing slab freelist corruption, as it
>> would have had happened before SLAB_FREELIST_HARDENED). Nice idea!
> 
> Do you see improvements that could be made here?
> 

Could we use BUG_ON() only when panic_on_oops is set?
