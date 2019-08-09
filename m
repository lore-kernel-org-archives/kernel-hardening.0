Return-Path: <SRS0=23A2=WF=lists.openwall.com=kernel-hardening-return-16775-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5393CC433FF
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Aug 2019 13:41:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A33B9214C6
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Aug 2019 13:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="uxcY+HoG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A33B9214C6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16775-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9751 invoked by uid 550); 9 Aug 2019 13:41:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9719 invoked from network); 9 Aug 2019 13:41:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hDbmSeAqM7CnABefrdoIV33EQwgfzsxS6CwWc2ozMxc=;
        b=uxcY+HoGpSPxU3WZM34vst9UCgKCvpWafX3qIo5agR9YilACC8L2UAmnDJsft2xWlO
         b07chohxzG7xDB3J+bqVaMoSrNljFZcSamWc9wW+uH9NiT+TA4SsQP0SWcbE28tHM18q
         mTwYKTOwdk+pUBUgpdGK/EFNza0fSDoIXyaZqjkdpT4EJZKVcnEyqtf/0ogGJ8b1WYnh
         3TrhBjACarraJTY0jKNBogI4gswvHw4aUqukhNA/+NdjDgM5YBCHb/Z0lxBjmFJOTwTK
         IvKidRrYHkitWYQfblSGRj+3MOR6AywPx/kgY9mxZa3glzSQfeGZZHHr2wvtoZ1z6Lpf
         vPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hDbmSeAqM7CnABefrdoIV33EQwgfzsxS6CwWc2ozMxc=;
        b=HUMduHlKUUADvcWM66v7+Bf5xy+uuQHBdwO3y6d0w9ttCXqf36Q81rSy+uMqWCKJTY
         5+uLkyjx6KxfBeA0uwhO7DvPx3Is2MRduQIuAJ/AY+6K4VvIEab9IbLKrPi40CaLf2yz
         7CQZBZJUfn6SqPf40mGBNQpb9vB+vYYDjNgwAbaf1wdD1CSo786Izs0B5ridnMRbX1NO
         5BmE+TUFG2XNV1XKUf/gYAUOT54YKZ3hOUNi8zQjNTmJeAfkSwfFls3D0cBhEB3AzJq9
         GG9pyTEcovrFm+Hvx0QD6Zm1vh7pYKCao/w27A4w7DAhrC+Ge14xpoxrmVh9gljhM5Q8
         Nb0A==
X-Gm-Message-State: APjAAAUWsf/G78Zshg/x5LDl8snJYXyqR/T3qWdZ/ey2SHcnUdsaqi/1
	2OVv+QpiUFLatIYwHDoUh59mhw==
X-Google-Smtp-Source: APXvYqxy1N/BNXHHumn8ArufQ0S1e3+SjdYte+WSSnMyakBpI1Ibu103uf5GY4RSvgofZXfNb2fYxQ==
X-Received: by 2002:a62:b615:: with SMTP id j21mr20995178pff.190.1565358091327;
        Fri, 09 Aug 2019 06:41:31 -0700 (PDT)
Subject: Re: [PATCH] floppy: fix usercopy direction
To: alex.popov@linux.com, Jann Horn <jannh@google.com>
Cc: Jiri Kosina <jikos@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 Mukesh Ojha <mojha@codeaurora.org>,
 "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
 Denis Efremov <efremov@linux.com>, Julia Lawall <Julia.Lawall@lip6.fr>,
 Gilles Muller <Gilles.Muller@lip6.fr>, Nicolas Palix
 <nicolas.palix@imag.fr>, Michal Marek <michal.lkml@markovi.net>,
 cocci@systeme.lip6.fr
References: <20190326220348.61172-1-jannh@google.com>
 <9ced7a06-5048-ad1a-3428-c8f943f7469c@linux.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b324719d-4cb4-89c9-ed00-2e0cd85ee375@kernel.dk>
Date: Fri, 9 Aug 2019 06:41:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9ced7a06-5048-ad1a-3428-c8f943f7469c@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 8/9/19 6:36 AM, Alexander Popov wrote:
> Hello everyone!
> 
> On 27.03.2019 1:03, Jann Horn wrote:
>> As sparse points out, these two copy_from_user() should actually be
>> copy_to_user().
> 
> I've spent some time on these bugs, but it turned out that they are already public.
> 
> I think Jann's patch is lost, it is not applied to the mainline.
> So I add a new floppy maintainer Denis Efremov to CC.

Looks like it got lost indeed, I will just apply this one directly for
5.4.

-- 
Jens Axboe

