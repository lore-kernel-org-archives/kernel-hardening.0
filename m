Return-Path: <SRS0=A7zl=EL=lists.openwall.com=kernel-hardening-return-20366-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D8CEC388F7
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Nov 2020 19:38:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5688E20704
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Nov 2020 19:38:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5688E20704
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20366-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27790 invoked by uid 550); 5 Nov 2020 19:38:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27770 invoked from network); 5 Nov 2020 19:38:14 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=U+a+gNIbJITYFSm1fPB5NcpyqxVoTmbEhGD5seomukY=;
        b=TBNvKFLqGOdy6o2Is1tIzQOMpXV6f0dfOANqFfoKgisYQI81W+ylqXiT1wyJeD3Cu+
         imZUORXC0a8k1dDhXOBABptxIZvTvCKSPAm5r3TIwzsaWNPupfcK4oRFHVCsZGei8UOz
         DpJWscO5MdAtL0oeIOQs8Tutt+6WkwC4ZWtGzeglnxRWcND4u73EtjzoggKkImV85hRQ
         sDaiG24p76e8WhFQXdOUP5GhRfG3BfWHLZlJ3iN1l5IUUEDTmRbmseTo13R7J/6Pw8Z4
         ynMREAGq78yR6Yo4lOfRpkG0s2D3/UfNjEPgVGlSKNTI1l3UrzvM9XHUapUsJntubuln
         NGrg==
X-Gm-Message-State: AOAM5325RWgFWxkcq/D9OUGXsOeSvC7joy7w6oiVo8pJln92mU+UssQn
	o5WHQuoB7IKPUNb4IunjzluaouFWPmcG2uXz9RNyUJZn5KguBIL3lkqme2grnePDiXsbQpWc3AE
	2H/ZUy99EeCAT+BQP2IfyANDiaCKrTvWX+3CjyTXSCBuUa3hJY0o=
X-Received: by 2002:ac8:540e:: with SMTP id b14mr3630709qtq.136.1604605081490;
        Thu, 05 Nov 2020 11:38:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwogUYq8CCKM+u/T4cSYijlorWkNQQUKBHl8kr1d+TVLfKeqZioURlPJbfLkAGZuLSMkNW7mg==
X-Received: by 2002:ac8:540e:: with SMTP id b14mr3630680qtq.136.1604605081219;
        Thu, 05 Nov 2020 11:38:01 -0800 (PST)
Subject: Re: [PATCH] mm, hugetlb: Avoid double clearing for hugetlb pages
To: linux-mm@kvack.org
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org,
 linux-security-module@vger.kernel.org, kernel@gpiccoli.net,
 cascardo@canonical.com, Alexander Potapenko <glider@google.com>,
 James Morris <jamorris@linux.microsoft.com>,
 Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@suse.cz>,
 Mike Kravetz <mike.kravetz@oracle.com>, david@redhat.com
References: <20201019182853.7467-1-gpiccoli@canonical.com>
From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Autocrypt: addr=gpiccoli@canonical.com; prefer-encrypt=mutual; keydata=
 xsBNBFpVBxcBCADPNKmu2iNKLepiv8+Ssx7+fVR8lrL7cvakMNFPXsXk+f0Bgq9NazNKWJIn
 Qxpa1iEWTZcLS8ikjatHMECJJqWlt2YcjU5MGbH1mZh+bT3RxrJRhxONz5e5YILyNp7jX+Vh
 30rhj3J0vdrlIhPS8/bAt5tvTb3ceWEic9mWZMsosPavsKVcLIO6iZFlzXVu2WJ9cov8eQM/
 irIgzvmFEcRyiQ4K+XUhuA0ccGwgvoJv4/GWVPJFHfMX9+dat0Ev8HQEbN/mko/bUS4Wprdv
 7HR5tP9efSLucnsVzay0O6niZ61e5c97oUa9bdqHyApkCnGgKCpg7OZqLMM9Y3EcdMIJABEB
 AAHNLUd1aWxoZXJtZSBHLiBQaWNjb2xpIDxncGljY29saUBjYW5vbmljYWwuY29tPsLAdwQT
 AQgAIQUCWmClvQIbAwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAKCRDOR5EF9K/7Gza3B/9d
 5yczvEwvlh6ksYq+juyuElLvNwMFuyMPsvMfP38UslU8S3lf+ETukN1S8XVdeq9yscwtsRW/
 4YoUwHinJGRovqy8gFlm3SAtjfdqysgJqUJwBmOtcsHkmvFXJmPPGVoH9rMCUr9s6VDPox8f
 q2W5M7XE9YpsfchS/0fMn+DenhQpV3W6pbLtuDvH/81GKrhxO8whSEkByZbbc+mqRhUSTdN3
 iMpRL0sULKPVYbVMbQEAnfJJ1LDkPqlTikAgt3peP7AaSpGs1e3pFzSEEW1VD2jIUmmDku0D
 LmTHRl4t9KpbU/H2/OPZkrm7809QovJGRAxjLLPcYOAP7DUeltvezsBNBFpVBxcBCADbxD6J
 aNw/KgiSsbx5Sv8nNqO1ObTjhDR1wJw+02Bar9DGuFvx5/qs3ArSZkl8qX0X9Vhptk8rYnkn
 pfcrtPBYLoux8zmrGPA5vRgK2ItvSc0WN31YR/6nqnMfeC4CumFa/yLl26uzHJa5RYYQ47jg
 kZPehpc7IqEQ5IKy6cCKjgAkuvM1rDP1kWQ9noVhTUFr2SYVTT/WBHqUWorjhu57/OREo+Tl
 nxI1KrnmW0DbF52tYoHLt85dK10HQrV35OEFXuz0QPSNrYJT0CZHpUprkUxrupDgkM+2F5LI
 bIcaIQ4uDMWRyHpDbczQtmTke0x41AeIND3GUc+PQ4hWGp9XABEBAAHCwF8EGAEIAAkFAlpV
 BxcCGwwACgkQzkeRBfSv+xv1wwgAj39/45O3eHN5pK0XMyiRF4ihH9p1+8JVfBoSQw7AJ6oU
 1Hoa+sZnlag/l2GTjC8dfEGNoZd3aRxqfkTrpu2TcfT6jIAsxGjnu+fUCoRNZzmjvRziw3T8
 egSPz+GbNXrTXB8g/nc9mqHPPprOiVHDSK8aGoBqkQAPZDjUtRwVx112wtaQwArT2+bDbb/Y
 Yh6gTrYoRYHo6FuQl5YsHop/fmTahpTx11IMjuh6IJQ+lvdpdfYJ6hmAZ9kiVszDF6pGFVkY
 kHWtnE2Aa5qkxnA2HoFpqFifNWn5TyvJFpyqwVhVI8XYtXyVHub/WbXLWQwSJA4OHmqU8gDl
 X18zwLgdiQ==
Message-ID: <6c17f146-3d1e-8b9f-835c-1dc33d95aa0c@canonical.com>
Date: Thu, 5 Nov 2020 16:37:55 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019182853.7467-1-gpiccoli@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Thanks all for the valuable opinions and feedback!
Closing the loop here: so, the proposal wasn't accepted, but an
interesting idea to optimize later hugeTLB allocations was discussed in
the thread - it doesn't help much our case, but it is a performance
optimization.

Cheers,


Guilherme
